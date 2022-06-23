# Go to the ssh directory
cd ~/.ssh
pwd
/Users/gepolianochaves/.ssh
# Check what exists inside of the directory
ls
known_hosts
# Create ssh key using the email used in the Github account. 
# In the case below, I was interested in creating a key for my uchicago e-mail, 
# which I was using for my github account.
ssh-keygen -o -t rsa -C "gchaves@uchicago.edu"
### After the command is ran, its ooutputs are as follows:
# Generating public/private rsa key pair.
# Enter file in which to save the key (/Users/gepolianochaves/.ssh/id_rsa):
# Enter passphrase (empty for no passphrase):
# Enter same passphrase again:
### After a passphrase is set, the output is as follows:
# Your identification has been saved in /Users/gepolianochaves/.ssh/id_rsa.
# Your public key has been saved in /Users/gepolianochaves/.ssh/id_rsa.pub.
# The key fingerprint is:
# SHA256:Q5txG2PMV9A5AK2eAVNVC/ZlAuGdOEt+v7QJla5JQPA gchaves@uchicago.edu
# The key's randomart image is:
# +---[RSA 3072]----+
# |         oo+OB+.o|
# |        oooo.*+* |
# |        ooBE* =. |
# |       . *+B o  .|
# |        S..+o .o |
# |         .o ..o. |
# |             o o.|
# |            . = +|
# |             o + |
# +----[SHA256]-----+
### After the ssh key is generated, and we list the directory, we see the following:
ls
id_rsa		id_rsa.pub	known_hosts
### the contente of the key can be accessed as follows:
cat id_rsa.pub
# Copy this content
### Then we paste the key in out github repository code:
Go to Settings on GitHub
Go to SSH and GPG Keys
Go to Add New SSH Key
Add the content copied
Click the Add SSH Key button 

###########################################################
###########################################################
############## Save the current script to the script folder
############## in the our repository, for documentation
###########################################################
###########################################################

The command below works from the Terminal directly and from in the Script open in RStudio.

cd ~/Desktop/Gepoliano/Git/gdschaves/Projects
git add ./
git commit -m "Include Shell Script Modifications"
git push