#  Building Bundles

This directory contains scripts for building bundles (installation files) on Windows, Linux and OSX (Mac) computer platforms. 
`run_bundlebot.sh` is used to build Linux and OSX bundles and `run_bundlebot.bat` is used to build a Windows 
bundle. These scripts use applications (FDS, Smokeview and Smokeview utilities) built by firebot, manuals 
( FDS and Smokeview User, Verification/Validation and Technical guides) built by firebot and smokebot and 
other files found in the bot, fds and smv repos.
Applications for Linux/osx bundles are built by `firebot.sh`. 
Applications for a windows bundle are built by `make_apps.bat`
Manuals are built by firebot and smokebot run on a Linux system.

Building a bundle then consists of four steps: 1. run firebot to generate FDS manuals, 2. run smokebot to generate
Smokeview manuals, 3. build applications and finally 4. build the bundle from the various parts generated in the first three steps.
These steps are outlined in more detail below.

### Bundling Steps

1. Run firebot on a Linux system to generate FDS publications. If firebot is successful, documents are copied to the
directory $HOME/.firebot/pubs . FDS and Smokeview applications are copied to $HOME/.firebot/apps
where $HOME is the home directory of the user running firebot. At NIST this occurs nightly.
2. Run smokebot on a Linux system to generate Smokeview publications. Similarly if smokebot is successful, documents are copied
to $HOME/.smokebot/pubs.  Note, firebot generates both FDS and Smokeview applications.
At NIST this occurs whenever FDS and/or Smokeview source changes or at least once a day if the smokeview source has not changed.
3. Run firebot with the -B option (build only) on the system where you are generating  the buhdle (OSX or Linux) to generate the applications. 
4. Generate a bundle using the `run_bundlebot.sh` or `run_bundlebot.bat`script located in the `bot/Bundlebot` directory.  