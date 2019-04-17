#!/usr/bin/env bash

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


# Set Defaults #

# This will set a default policy for the input chain.
sudo iptables -P INPUT DROP

# This will set a default policy for the forward chain.
sudo iptables -P FORWARD DROP

# This will set a default policy for the output chain.
sudo iptables -P OUTPUT DROP