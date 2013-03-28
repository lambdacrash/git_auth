git_auth
========

Apache module allowing HTTP authentication over multiple GIT repositories managed by `git-http-backend`. 

Overview
--------
This module allows you to:
* Use HTTP authentication instead of SSH
* Use Apache for checking the credentials
* Manage multiple users
* Manage multiple repositories
* Control the access per user, per repository
* Centralize the configuration in one file
* Use `git-web` for repository browsing

How to compile it?
------------------
In order to compile the module, you need to get the Apache dev distribution installed on your system and then just type :
```bash
sudo apxs2 -c -i mod_git_auth.c
````
After the compilation, your new fresh module is deployed in your Apache server.

How to configure the rules?
---------------------------
The module needs a configuration file containing the credentials and the description of roles like this
```
## Users
# Generated using htpasswd
test1:$apr1$uMDe/sTo$714wfmKUlQbs61BkCr83U/
test2:$apr1$uMDe/sTo$714wfmKUlQbs61BkCr83U/

## Repositories
#git:repository_name
git:repo1
#list of authorized users
user:test1
user:test2

#git:repository_name
git:repo2
#list of authorized users
user:test2
```

How to configure your Apache?
-----------------------------
Just add these following lines in your `httpd.conf` or `apache2.conf`:
```
<Location /git>
   AuthType basic
   AuthuserFile /the/path/to/your/conf_file
   AuthName "Private GIT"
   AuthBasicProvider git_auth
   Require valid-user
</Location>
```
I assume here that all your repositories are in a `git` folder.

Add the module to `/etc/apache2/mods-available/`
------------------------------------------------
File `git_auth.conf`:
```
<IfModule mod_git_auth.c>

</IfModule>
```
File `git_auth.load`:
```
LoadModule git_auth_module /usr/lib/apache2/modules/mod_git_auth.so
```

Building the module for ARM target
----------------------------------
First of all, you have to install **Qemu** and install **Debian Squeeze** 
for **Arm** platform. The smartest way is to download `qcow2` image from <http://people.debian.org/~aurel32/qemu/armel/>

So, if you run under some kind of linux distrib, just type
```
sudo apt-get install qemu-kvm qemu-kvm-extras
mkdir arm
wget http://people.debian.org/~aurel32/qemu/armel/vmlinuz-2.6.32-5-versatile
wget http://people.debian.org/~aurel32/qemu/armel/initrd.img-2.6.32-5-versatile
wget http://people.debian.org/~aurel32/qemu/armel/debian_squeeze_armel_standard.qcow2
qemu-system-arm -M versatilepb -kernel vmlinuz-2.6.32-5-versatile -initrd initrd.img-2.6.32-5-versatile -hda debian_squeeze_armel_standard.qcow2 -append "root=/dev/sda1"
```

Then, enter username and password (`root root`) and type:
```
apt-get install apache2-prefork-dev
cd /tmp
git clone git://github.com/lambdacrash/git_auth.git
cd git_auth
apxs2 -c -i mod_git_auth.c
```
Your `.so` is located in something like `/usr/lib/apache2/modules/mod_git_auth.so`.

Example of deploying this module on *Synology 411j*
---------------------------------------------------
Just copy your `.so` in `/usr/syno/apache/modules` and follow the instructions written at the top of this document.
Restart `apache` with `/usr/syno/etc/rc.d/S97apache-user.sh restart` and it is done!! 

*********************
* More informations about `git-http-backend` <https://www.kernel.org/pub/software/scm/git/docs/git-http-backend.html>
* More informations about `qemu` <http://wiki.qemu.org/Main_Page>
* More informations about `arm` emulation with `qemu` <http://people.debian.org/~aurel32/qemu/armel/>


Special thanks to Sancho, Arnaud and Arnaud !!
