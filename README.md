NOTE: This will erase the instance disk and install ONLY Archlinux

1) Log in to the mangement console for the system you want to set up
2) Start or Reboot the instance
3) Enter the OOB console before the system boots
4) Select boot option: Debian GNU/Linux, kernel ????????-amd64 (single-user mode) Live Rescue
5) press enter
6) run the following commands:

cd /tmp
wget https://github.com/prgmrcom/archinstall-scripts/archive/master.zip
unzip master.zip
cd archinstall-scripts-master/archlinux_2016_05_09
./archinstall.sh

7) You should see a 'Finished' message
8) Press 'ctrl + ]' to return to main menu
9) Make sure your bootloader is set to 'grub2' and reboot