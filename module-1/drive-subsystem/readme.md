*Перенос рэйда*

Создаём 2 виртуальные машины. Через vboxmanage создаём 2 диска вне директорий с Vagrantfile. Файлы VM1.vagrantfile и VM2.vagrantfile с описанием двух разных машин. VM1 имеет 192.168.11.101, VM2 192.168.11.102.

На VM1.vagrantfile собираем массив, генерируем mdadm.conf

```console
echo \"DEVICE partitions\" > /etc/mdadm/mdadm.conf"
mdadm --detail --scan | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
```

В VM2.vagrantfile добавляем 2 диска. Грузимся в систему, через lsblk проверяем, что диски имеются.
Через scp копируем mdadm.conf с VM1 на VM2. На VM2 ставим mdadm. Выполняем

```console
mdadm --assemble --scan.
```

Смотрим

```console
watch cat /proc/mdstat и lsblk
```

Ребутаем VM2 и проверяем, что массив на месте.

Через vagrant provision как-то так...

```console
 box.vm.provision "shell", inline: <<-SHELL
              mkdir -p ~root/.ssh
              cp ~vagrant/.ssh/auth* ~root/.ssh
              yum install mdadm scp
              mkdir -p /etc/mdadm
              scp root@<ip>:/etc/mdadm/mdadm.conf /etc/mdadm/mdadm.conf
              mdadm --assemble --scan
          SHELL
```

Как вариант через box.vm.provision "shell", path: "bootstrap_attach_raid.sh" добавить опции для монтирования дисков и автоматизации сборки рэйда.
