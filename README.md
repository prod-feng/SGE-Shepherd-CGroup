# SGE-Shepherd-CGroup
Bash Script for Shepherd  Dameon to set CGroup rule to control job's RAM and CPU usage

CentOS 7. Sun Grid Engine 2011.1101.

Change the global SGE configuration to set the "shepherd_cmd" parameter:

>$ qconf -sconf

...

shepherd_cmd                 /scratch/apps/sge/util/shepherd.sh

...

For the parallel jobs like MPI,if you use ssh as the rsh, rlogin, the ststemd-logind service will move the spawned child process on the remote node to a user session CGroup, out of the shepherd scope, which void the cgoup rule applied from the shepher command.

To avoid this, you can comment the following line in /etc/pam.d/password-auth, on all the compute nodes.

#-session     optional      pam_systemd.so

