# SGE-Shepherd-CGroup
Bash Script for Shepherd  Dameon to set CGroup rule to control job's RAM and CPU usage

CentOS 7. Sun Grid Engine 2011.11p1.

Change the global SGE configuration to set the "shepherd_cmd" parameter:

>$ qconf -sconf

...

shepherd_cmd                 /scratch/apps/sge/util/shepherd.sh

...

For the parallel jobs like MPI,if you use ssh as the rsh, rlogin daemon/command, the ststemd-logind service will move the spawned child process on the remote nodes to a user session slice, out of the defined shepherd scope, which then void the cgoup rule applied from the shepher command.

Like this:

├─user.slice

│ ├─user-1008.slice

│ │ └─session-1265189.scope

│ │   ├─ 8240 systemd-cgls

│ │   ├─ 8241 less

│ │   ├─25803 sshd: feng [priv]

To avoid this, you can comment the following line in /etc/pam.d/password-auth, on all the compute nodes.

#-session     optional      pam_systemd.so

and then restart the sshd service.

The CGroup structure defined by the shepherd command looks like:

├─1 /usr/lib/systemd/systemd --system
├─sge.slice
│ └─sge-shepherd.slice
│   ├─sge-shepherd-396548.slice
│   │ └─sge-shepherd-396548-0.slice
│   │   └─sge-shepherd-396548-0.scope
│   │     ├─11775 /cm/shared/apps/sge/current/bin/linux-x64/sge_shepherd
│   │     ├─11798 -bash /cm/local/apps/sge/var/spool/node057/job_scripts/396548
│   │     ├─11881 mpirun -np 4 ....


