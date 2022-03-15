# SGE-Shepherd-CGroup
Bash Script for Shepherd  Dameon to set CGroup rule to control job's RAM and CPU usage

Change the global SGE configuration to set the "shepherd_cmd" parameter:

>$ qconf -sconf

...

shepherd_cmd                 /scratch/apps/sge/util/shepherd.sh

...
