#!/bin/bash
# from live rescue, single user mode...

# Partition the disk
echo -e 'o\nn\np\n1\n\n\nw' | fdisk -u /dev/xvda
mkfs.ext4 /dev/xvda1
mount /dev/xvda1 /mnt

# Download and Extract tar
mkdir -p /mnt/opt/install
pushd /mnt/opt/install
wget https://mirrors.kernel.org/archlinux/iso/2016.05.01/archlinux-bootstrap-2016.05.01-x86_64.tar.gz --output-document=arch-2016.05.01-64.tar.gz
tar -zxf arch-2016.05.01-64.tar.gz

# Copy scripts into place
popd
cp archinstall_archboot /mnt/opt/install/root.x86_64/opt/
cp archinstall_finalize /mnt/opt/install
cp prgmr-on-init-launch.s* /mnt/opt/install

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
