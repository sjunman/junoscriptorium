Script Details:
--------------
  
Problem statement : RPD not coming up on a backup RE, because backup RE version
                    lower than master RE version.(Due to factory defaults)

Solution : An event-script approach to install the proper image on the back up
           RE, when backup RE version is lower than master RE version.
                    
Algorithm via Event-script:

1. Event-script expects two mandatory arguments $ftp-url and $options

$ftp-url ->  Full path of the JUNOS installation file with ftp syntax.
Example: 
ftp://abc:wxyz@ftpserver///home/version/jinstall-12.1-20130602.0-domestic-signed.tgz

$options -> Installation options (Space separated)
Example:
"no-copy reboot"

2. Script checks for master RE version details and backup RE version 
details when backup RE comes up.

3. If backup RE version lower than master RE version and if the backup RE 
uptime is less than 180 sec, then script try to use  <file-copy> RPC and 
fetch the file specified from $ftp-url 

4. After successful copy,  file will be available from "/var/tmp" location 
of master RE.

5. Newly copied image in "/var/tmp" location of the master RE will be installed
on the backup RE using "request system software add ..." Operational command.

6. During installation process, messages will be dumped to the user terminal.

7. Please refer "upgrade_event.slax" is the actual event-script to be 
configured on master RE 

8. After successful installation , backup RE will be up with proper image.


Limitations:

1. Connectivity should be proper between master and backup RE.

2. FTP service needs to be enabled on master RE and FTP server 
(Where image available).

3. Master RE "/var/tmp" location should have sufficient space to accommodate
JUNOS image file.

4. [edit chassis redundancy] needs to be deactivated before running this 
event-script.  Because "chassis daemon" will not allow installation if 
"graceful-swithcover" enabled.
We will see following error if its not deactivated.
Validating against /config/juniper.conf.gz
Chassis control process: [edit chassis redundancy]
Chassis control process:   'graceful-switchover'
Chassis control process:     Graceful switchover configured!
mgd: error: configuration check-out failed
Validation failed
WARNING: Current configuration not compatible with
/var/tmp/jinstall-12.1-20130602.0-domestic-signed.tgz

5. After deactivating the configuration, once the backup RE boots up, user 
needs to activate the [edit chassis redundancy graceful-switchover] knob.

6. The scipt compares only the Major Version while comparing the version on 
backup RE with Master RE

Note:  
     1. User should be careful in choosing the compatible JUNOS image.
     2. User needs to run this script from master RE only.

