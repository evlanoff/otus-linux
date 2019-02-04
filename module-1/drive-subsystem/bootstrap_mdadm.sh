#!/bin/bash

#build raid 10

build_raid() {
  yes "" | mdadm --create --verbose /dev/md0 --level=10 --raid-devices=4 /dev/sd{b,c,d,e}
}

break_raid() {
  bash -c "mdadm --manage --set-faulty /dev/md0 /dev/sdb"
  bash -c "mdadm --manage /dev/md0 --remove /dev/sdb"
}

repair_raid() {
  bash -c "mdadm --manage /dev/md0 --add /dev/sdf"
}


#make conf

save_raid_conf() {
  bash -c "mkdir -p /etc/mdadm"
  bash -c "touch /etc/mdadm/mdadm.conf"
  bash -c "echo \"DEVICE partitions\" > /etc/mdadm/mdadm.conf"
  bash -c "mdadm --detail --scan | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf"
}

make_gpt() {
  parted -s /dev/md0 mklabel gpt
}

make_partitions() {
  bash -c "parted /dev/md0 mkpart primary ext4 0% 20%"
  bash -c "parted /dev/md0 mkpart primary ext4 20% 40%"
  bash -c "parted /dev/md0 mkpart primary ext4 40% 50%"
  bash -c "parted /dev/md0 mkpart primary ext4 50% 70%"
  bash -c "parted /dev/md0 mkpart primary ext4 70% 100%"
}



main() {
  build_raid
  break_raid
  repair_raid
  save_raid_conf
  make_gpt
  make_partitions
}

[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
