**Уменьшение / до 8GB**

```console
su -
vagrant

pvcreate /dev/sdb
vgcreate vg_root /dev/sdb
lvcreate -n lv_root -l +100%FREE /dev/vg_root

mkfs.xfs /dev/vg_root/lv_root
mount /dev/vg_root/lv_root /mnt
xfsdump -J - /dev/VolGroup00/LogVol00 | xfsrestore -J - /mnt

for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
chroot /mnt/
grub2-mkconfig -o /boot/grub2/grub.cfg

cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done

sed -i 's|rd.lvm.lv=VolGroup00/LogVol00|rd.lvm.lv=vg_root/lv_root|g' /boot/grub2/grub.cfg

exit

reboot

script -a resize_root.log

lvremove /dev/VolGroup00/LogVol00
lvcreate -n VolGroup00/LogVol00 -L 8G /dev/VolGroup00
mkfs.xfs /dev/VolGroup00/LogVol00
mount /dev/VolGroup00/LogVol00 /mnt
xfsdump -J - /dev/vg_root/lv_root | xfsrestore -J - /mnt

for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done
chroot /mnt/
grub2-mkconfig -o /boot/grub2/grub.cfg
cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done

exit
```

**VAR MIRRORING**

```console
su -
vagrant

script var_mirroring.log

pvcreate /dev/sdc /dev/sdd
vgcreate vg_var /dev/sdc /dev/sdd
lvcreate -L 950M -m1 -n lv_var vg_var

mkfs.ext4 /dev/vg_var/lv_var
mount /dev/vg_var/lv_var /mnt
cp -aR /var/* /mnt/
rm -rf /var/*
umount /mnt
mount /dev/vg_var/lv_var /var
echo "`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" >> /etc/fstab

exit

reboot

script -a var_mirroring.log

lvremove /dev/vg_root/lv_root
vgremove /dev/vg_root
pvremove /dev/sdb

exit
```

**Манипуляции с /home**

```console
lvcreate -n LogVol_Home -L 2G /dev/VolGroup00
mkfs.xfs /dev/VolGroup00/LogVol_Home
mount /dev/VolGroup00/LogVol_Home /mnt/
cp -aR /home/* /mnt/
rm -rf /home/*
umount /mnt
mount /dev/VolGroup00/LogVol_Home /home/
echo "`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab
```

**/HOME SNAPSHOTS**

```console
touch /home/file{1..10}
lvcreate -L 100MB -s -n home_snap /dev/VolGroup00/LogVol_Home
rm -f /home/file{6..10}

umount /home
lvconvert --merge /dev/VolGroup00/home_snap
mount /home
```

**Задание со звездой**

Добавляем репозиторий

```console
yum install http://download.zfsonlinux.org/epel/zfs-release.el7_5.noarch.rpm
```

Настраиваем модуль ZFS таким образом, чтобы последующие обновления ядра linux не вынуждали заниматься перекомпеляцией модуля zfs.

```console
vi /etc/yum.repos.d/zfs.repo

[zfs]
enabled=0

[zfs-kmod]
enabled=1
```

Устаналиваем ядро

```console
yum install zfs

reboot
```

Првоеряем и подключаем модуль
```console
lsmod | grep zfs - нет модуля
modprobe zfs - подгружаем
lsmod | grep zfs - есть модуль
```

Собираем пул из свободных дисков.
```console
zpool create otus-test /dev/sd[c-d]
```

Добавляем кеширующий диск
```console
zpool add otus-test cache /dev/sde
````

Проверям добавился ли диск в кэш
```console
zpool status otus-test
```

Помещаем файлы для проверки работоспособности snapshots
```console
dd if=/dev/zero of=/otus-test/file1.test count=1024 bs=1024
dd if=/dev/zero of=/otus-test/file2.test count=256 bs=256
```

Создаём snapshot
```console
zfs snapshot otus-test@today
```

Проверяем, что он создался
```console
zfs list -t snapshot
```

Дальше развлекаемся как душе угодно. Например,
```console
mount -t zfs otus-test@today /mnt
```

**Перенос /opt на zfs**

Переносим с /opt в /mnt

Например, cp -aR /opt /mnt

Создаём zfs пул opt с точкой монтирования /opt либо для имеющейся, но ненужной точки устанавливаем значение точки монтирования.

```console
zfs set mountpoint=/opt otus-test
```

Переносим всё с /mnt на /opt и перезагружаемся. Проверяем, что в /opt всё лежит.