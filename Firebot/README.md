# Firebot: A Continuous Integration Tool for FDS

Firebot is a verification test script that can be run at regular intervals as part of a continuous integration program. At NIST, the script is run by a pseudo-user named `firebot` on a linux cluster each night. The pseudo-user `firebot` updates the various repositories in the GitHub project named `firemodels`, compiles FDS and Smokeview, runs the verification cases, checks the results for accuracy, and compiles all of the manuals. The entire process takes a few hours to complete.

## Set-Up

The following steps need only be done once. The exact phrasing of the commands are for the NIST linux cluster named blaze. You might need to modify the path and module names.

1. Clone the repositories that are included in the GitHub organization called `firemodels`: `fds`, `smv`, `bot`, `out`, `exp`, and `fig`. A simple way to do this is to first clone `bot`.  Then cd into `bot/Scripts` and type `./setup_repos.sh -a` . This will clone all the other repos needed by firebot (or you can clone each repo in the same way as you cloned `bot`, with the exception of `exp` which requires the `--recursive` option because it has submodules).


2. Ensure that the following software packages are installed on the system:

    * Intel Fortran and C compilers, Intel MPI, Intel Inspector
    * Gnu Fortran compiler (Optional)
    * LaTeX (TeX Live distribution), be sure to make this the default LaTeX in the system-wide PATH
    * Matlab (test the command `matlab`)

3. Firebot uses email notifications for build status updates. Ensure that outbound emails can be sent using the `mail` command.

4. Install libraries for Smokeview. On CentOS, you can use the following command:
   ```
   yum install mesa-libGL-devel mesa-libGLU-devel libXmu-devel libXi-devel xorg-x11-server-Xvfb
   ```

5. Add the following lines to your `~/.bashrc` file:
    ```
    . /usr/local/Modules/3.2.10/init/bash
    module load null modules torque-maui
    module load intel/18
    ulimit -s unlimited
    ```
    Note that these modules load the Intel Fortran compiler and other necessary Intel libraries. If you want to do a debug compile with the Gnu fortran compiler, add
    ```
    module load gfortran492
    module load openmpi/300gnu_64ib
    export OPENMPI_GNU=openmpi/300gnu_64ib
    ```
    Both the Intel and Gnu compilers are used to check FDS for syntax errors and consisistency with the Fortran 2008 standard.
    
6. Setup passwordless SSH for the your account. Generate SSH keys and ensure that the head node can SSH into all of the compute nodes. Also, make sure that your account information is propagated across all compute nodes.

7. Ensure that a queue named `firebot` is created, enabled, and started in the torque queueing system and that nodes are defined for this queue. Test the `qstat` command.  If you use some other queue say batch then use `-q batch` when running firebot.

8. By default, firebot sends email to the email address configured for your bot repo (output of command `git config user.email` ) .  If you wish email to go to different email addresses, create a file named $HOME/.firebot/firebot_email_list.sh for some `user1` and `user2` (or more) that looks like:

   ```
   #!/bin/bash
   mailToFDS="user1@host1.com, user2@host2.com"
   ```

## Running firebot

The script `firebot.sh` is run using the wrapper script `run_firebot.sh`. This script uses a locking file that ensures multiple instances of firebot do not run at the same time, which would cause file conflicts. To see the various options associated with running firebot, type
```
./run_firebot.sh -H
```

A typical way to run firebot is to cd into the directory containing firbot.sh and type: 

```nohup ./run_firebot.sh -c -u -J -m user@gmail.com &```

The `-c` and `-u` options clean and update the repos respectively. The `-J` option directs Firebot to use the Intel suite. The email addressee shall receive notice when Firebot is done. The `nohup` at the start and `&` at the end of the command run `firebot.sh` in the background and redirect screen output to the file called `nohup.out`.

To kill firebot, cd to the directory containing firebot.sh and type:

```./run_firebot.sh -k```

Important things to consider: do you want to test your own local changes, or update your repositories from the central repository? Do you want to use Intel MPI or Open MPI? Do you want to skip certain stages of the process?

You can run firebot regularly using a `crontab` file by adding an entry like the following using the `crontab -e` command:
```
PATH=/bin:/usr/bin:/usr/local/bin:/home/<username>/firemodels/bot/Firebot:$PATH
MAILTO=""
# Run firebot at 9:56 PM every night
56 21 * * * cd ~/<username>/firemodels/bot/Firebot ; bash -lc "./run_firebot.sh <options>"
```

The output from firebot is written into the directory called `output` which is in the same directory as the `firebot.sh` script itself. When firebot completes, email should be sent to the specified list of addresses. The fds/Manuals directory in the fds repo containing manuals and figures is copied to the directdory $HOME/.firebot/Manuals .
