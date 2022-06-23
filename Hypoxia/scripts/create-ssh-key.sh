cd ~/.ssh
pwd
/Users/gepolianochaves/.ssh
ls
known_hosts

ssh-keygen -o -t rsa -C "gchaves@uchicago.edu"
# Generating public/private rsa key pair.
# Enter file in which to save the key (/Users/gepolianochaves/.ssh/id_rsa):
# Enter passphrase (empty for no passphrase):
# Enter same passphrase again:

Then the output is:

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

ls
id_rsa		id_rsa.pub	known_hosts

cat id_rsa.pub

Copy this content

Go to Settings on GitHub
Go to SSH and GPG Keys
Go to Add New SSH Key
Add the content copied
Click the Add SSH Key button 

###########################################################
###########################################################
################################################### 
###########################################################
###########################################################

The command below works from the Terminal directly and from in the Script open in RStudio.

cd ~/Desktop/Gepoliano/Git/gdschaves/Projects
git add ./
git commit -m "Include Shell Script Modifications"
git push