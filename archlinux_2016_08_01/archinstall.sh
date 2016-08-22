#!/bin/bash
# from live rescue, single user mode...

# Partition the disk
echo -e 'o\nn\np\n1\n\n+10G\nn\np\n2\n\n+512M\nt\n2\n82\nn\np\n3\n\n\nw' | fdisk -u /dev/xvda
yes | mkfs.ext4 /dev/xvda1
mkswap /dev/xvda2
yes | mkfs.ext4 /dev/xvda3
mount /dev/xvda1 /mnt

# Download and Extract tar
mkdir -p /mnt/opt/install
pushd /mnt/opt/install
wget https://mirrors.kernel.org/archlinux/iso/2016.08.01/archlinux-bootstrap-2016.08.01-x86_64.tar.gz --output-document=arch-2016.08.01-64.tar.gz
echo "Extracting bootstrap"
tar -zxf arch-2016.08.01-64.tar.gz

# Copy scripts into place
popd
cp archinstall_archboot /mnt/opt/install/root.x86_64/opt/
cp archinstall_finalize /mnt/opt/install
cp prgmr-on-init-launch.s* /mnt/opt/install

# chroot into arch environment
cp /etc/resolv.conf /mnt/opt/install/root.x86_64/etc
for i in {proc,sys,dev,run}; do
  mount --rbind /$i /mnt/opt/install/root.x86_64/$i
done
chroot /mnt/opt/install/root.x86_64/ /opt/archinstall_archboot

for i in {proc,sys,dev,run}; do
  mount --rbind /$i /mnt/$i
done
chroot /mnt/ /opt/install/archinstall_finalize

echo "~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~"
echo "finished"
echo "********"

#rm -r /mnt/opt/install
