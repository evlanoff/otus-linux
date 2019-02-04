#build raid 10

build_raid() {
yes "" | mdadm --create --verbose /dev/md0 --level=10 --raid-devices=/dev/sd{b,c,d,e}
}

#make conf

save_raid_conf() {
bash -c "echo \"DEVICE partitions\" > /etc/mdadm/mdadm.conf"
bash -c "mdadm --detail --scan | awk '/ARRAY/ {print}' >> /etc/mdadm.conf"
}