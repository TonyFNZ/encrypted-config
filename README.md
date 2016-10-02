# encrypted-config
*Scripts for managing encrypted configuration for web applications*

Often when dealing with application configuration, there is a need to store configuration values
(eg. database username and password) in an encrypted form so that they cannot be accessed outside
of the target machine(s).

A simple and practical solution to this problem is to encrypt configuration values using the
private key of the user account that the application runs under.  These scripts simplify this process.

## Basic Usage

1. Your devops/infrastructure person who rightfully has access to the target machine should access the
target machine (as the user which will run the application) and use `enc.sh` to encrypt the required
configuration.

2. The encrypted values should be inserted into the application configuration file prefixed with `ENC:`. E.g.

       db_pass="ENC:854dlXz5a3pn/wyMxJMZ5ay1PAo="

3. When the application is being deployed to the target machine, `dec-file.sh` should be run on the file
to decrypt the encrypted configuration. E.g.

       ./dec-file.sh app.properties >app.properties

---
Note: If using AWS Elastic Beanstalk to host your application, the key pair specified when creating the environment will be assigned to the root user on the machines which is the user the application runs under.
This means the pem file downloaded when creating the key-pair can be used to encrypt config without needing
to ssh to one of the instances.

## Detailed Usage

### enc.sh
Encrypt a string.  Current user's private key is used for decryption by default
if `-k` option is not specified.

Usage: `./enc.sh [-k <pem key file>] <string>`

### dec.sh
Decrypt an encrypted string. Current user's private key is used for decryption by default
if `-k` option is not specified.

Usage: `./dec.sh [-k <pem key file>] <string>`

### dec-file.sh
Output the contents of a file and decrypt any encrypted strings found.
Encrypted strings must be prefixed with `ENC:` and must not have two on a single line.

Current user's private key is used for decryption by default.

Usage: `dec-file.sh [-k <pem key file>] <file>`

Example:
```bash
$ cat app.properties
db_user=app-user
db_pass=ENC:854dlXz5a3pn/wyMxJMZ5ay1PAo=
db_host=127.0.0.1

$ ./dec-file.sh app.properties
db_user=app-user
db_pass=app-password
db_host=127.0.0.1
```
