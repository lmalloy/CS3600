#!/usr/bin/env bash

# @author: Luke Malloy
# @description: Bash script that will set iptables firewall rules and make them persistent accross a reboot.

# Flush old rules (one by one)
sudo iptables -F 

# Flush mangle table built in chains
sudo iptables -F -t mangle

# Flush nat table built in chains
sudo iptables -F -t nat

# This deletes every non built in chain in the tables
sudo iptables -X 

# This deletes all built in chains in the mangle table
sudo iptables -X -t mangle

# This deletes all built in chains in the nat table
sudo iptables -X -t nat


# Set Secure Defaults #

# This will set a default policy for the input chain.
sudo iptables -P INPUT DROP

# This will set a default policy for the forward chain.
sudo iptables -P FORWARD DROP

# This will set a default policy for the output chain.
sudo iptables -P OUTPUT DROP

# DROP by default #

# Whitelist policies:

# Set Web Server Policies #

# Input Chain #

# This creates a rule to accept local traffic.
sudo iptables -A INPUT -i lo -j ACCEPT

# This will allow established and related incoming traffic.
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# This will allow incoming ssh connections, but are limited to one static IP address: 10.0.2.15.
sudo iptables -A INPUT -p tcp -s 10.0.2.15 --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# This will allow all incoming http(port 80) and https(port 443) using the multiport module. This module is used 
#   to create a rule for these ports. Connection tracking is stateful in both directions.
sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# This allows udp incoming traffic in addition to tcp as above.
sudo iptables -A INPUT -p udp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# This will drop packets that are marked as invalid.
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

# Forward Chain #

# This will allow the internal eth1 network to access the eth0 external network.
sudo iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

# Output Chain #

# This will allow the outgoing traffic generated from new and established ssh connections.
sudo iptables -A OUTPUT -p tcp -s 10.0.2.15 --sport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# This will allow all outgoing traffic generated from established connections
sudo iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT

# This is necessary as the ouput policy is set to drop, must accept all outgoing traffic from established http/https connections.
sudo iptables -A OUTPUT -p tcp -m multiport --sports 80,443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# This allows udp outgoing traffic in addition to tcp as above.
sudo iptables -A OUTPUT -p udp -m multiport --sports 80,443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# This will allow outgoing traffic from the dns port 53.
sudo iptables -A OUTPUT -p udp --dport domain -j ACCEPT

# Saving the State #

# If a folder named iptables exists, then
if [ -d /etc/iptables/ ]; then

    # remove all files and the folder.
    sudo rm -rf /etc/iptables/

    # and create a new directory to store rules.
    sudo mkdir /etc/iptables/

else 
# This creates a new directory to store rules.
    sudo mkdir /etc/iptables/
fi

# If a file with this name exists, then
if [ -f /etc/iptables/iptables.rules ]; then

    # delete it,
    sudo rm -f /etc/iptables/iptables.rules

    # make a new one,
    sudo touch /etc/iptables/iptables.rules

    # and export the rules to iptables.rules.
    sudo iptables-save | sudo tee /etc/iptables/iptables.rules > /dev/null
else
    # Else, make one,
    sudo touch /etc/iptables/iptables.rules 
    # and export the rules.
    sudo iptables-save | sudo tee /etc/iptables/iptables.rules > /dev/null
fi

if [ -f /etc/network/if-pre-up.d/iptables ]; then

    # Force removal of the file.
    sudo rm -f /etc/network/if-pre-up.d/iptables

    # Create a new file in the if-pre-up.d directory to load before network start.
    sudo touch /etc/network/if-pre-up.d/iptables

    # Make the newly created file executable.
    sudo chmod 777 /etc/network/if-pre-up.d/iptables
else
    # Else, create the new file.
    sudo touch /etc/network/if-pre-up.d/iptables

    # Make the newly created file executable.
    sudo chmod 777 /etc/network/if-pre-up.d/iptables
fi

# Now editing the file to load before taking up the network.
#   These commands will load the saved rules before the network is started
echo "#!/bin/bash" | sudo tee /etc/network/if-pre-up.d/iptables > /dev/null

#   Exported rules located in directory created above are directed to iptables restore in the command inside of this file created. 
echo "sudo bash -c \"/sbin/iptables-restore < /etc/iptables/iptables.rules\"" | sudo tee -a /etc/network/if-pre-up.d/iptables > /dev/null

