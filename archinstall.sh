#!/bin/bash
# from live rescue, single user mode...

echo "Preparing to install Archlinux"
echo "WARNING: This operation erases the disk."
echo "WARNING: Must be run in [Debian GNU/Linux ... (single-user mode) Live Rescue]"
read -p "Continue with install? [Y/n] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo "Cancelling install."
	echo "Please restart the system and boot single-user rescue mode to continue."
    exit 1
fi


# Partition the disk
echo -e 'o\nn\np\n1\n\n+10G\nn\np\n2\n\n+512M\nt\n2\n82\nn\np\n3\n\n+10G\nn\np\n\n\nw' | fdisk -u /dev/xvda
yes | mkfs.ext4 /dev/xvda1
mkswap /dev/xvda2
yes | mkfs.ext4 /dev/xvda3
yes | mkfs.ext4 /dev/xvda4
mount /dev/xvda1 /mnt

# Copy scripts into place
mkdir -p /mnt/opt/install/root.x86_64/opt/
cp archinstall_archboot /mnt/opt/install/root.x86_64/opt/
cp archinstall_finalize /mnt/opt/install
cp prgmr-on-init-launch.s* /mnt/opt/install

# Find latest version of Archlinux
wget --tries=3 --output-document='latest.html' 'https://mirrors.kernel.org/archlinux/iso/latest'
if [ ! -e "latest.html" ]
then
	echo 'ERROR: failed to retrieve from https://mirrors.kernel.org/archlinux/iso/latest'
	exit 1
fi
latestversion=$(awk '/archlinux-bootstrap-.*-x86_64\.tar\.gz</ {print}' latest.html | sed 's#<.*>\(.*\)<.*>.*#\1#g')
echo "latest version is $latestversion"

# Download and Extract latest version of Archlinux
echo "Attempting to change directory to /mnt/opt/install  ..."
cd /mnt/opt/install || exit 1
wget --tries=3 "https://mirrors.kernel.org/archlinux/iso/latest/${latestversion}"
if [ "$(find archlinux-bootstrap-*-x86_64.tar.gz | wc -w)" -eq 0 ]
then
	echo 'ERROR: failed to download https://mirrors.kernel.org/archlinux/iso/latest/archlinux-bootstrap-*-x86_64.tar.gz'
	exit 1
fi
if [ ! "$(find archlinux-bootstrap-*-x86_64.tar.gz | wc -w)" -eq 1 ]
then
	echo 'ERROR: multiple archlinux-bootstrap-*-x86_64.tar.gz were found after download'
	exit 1
fi
tar -zxf archlinux-bootstrap-*-x86_64.tar.gz

# chroot into arch environment
cp /etc/resolv.conf /mnt/opt/install/root.x86_64/etc
mount --rbind /proc /mnt/opt/install/root.x86_64/proc
mount --rbind /sys /mnt/opt/install/root.x86_64/sys
mount --rbind /dev /mnt/opt/install/root.x86_64/dev
mount --rbind /run /mnt/opt/install/root.x86_64/run
chroot /mnt/opt/install/root.x86_64/ /opt/archinstall_archboot

mount --rbind /proc /mnt/proc
mount --rbind /sys /mnt/sys
mount --rbind /dev /mnt/dev
mount --rbind /run /mnt/run

chroot /mnt/ /opt/install/archinstall_finalize

echo "~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~"
echo "finished"
echo "********"

#rm -r /mnt/opt/install
