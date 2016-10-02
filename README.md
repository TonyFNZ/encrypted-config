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

2. The encrypted values should be inserted into the application configuration file prefixed with `ENC:`

   e.g. `db_pass="ENC:854dlXz5a3pn/wyMxJMZ5ay1PAo="`

3. When the application is being deployed to the target machine, `dec-file.sh` should be run on the file
to decrypt the encrypted configuration

   e.g. `./dec-file.sh app.properties >app.properties`

---
