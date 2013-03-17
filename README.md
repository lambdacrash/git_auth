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


More informations about `git-http-backend` [here][https://www.kernel.org/pub/software/scm/git/docs/git-http-backend.html]
