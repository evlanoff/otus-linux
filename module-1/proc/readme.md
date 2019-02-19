**Реализация ps ax на python**

Скрипт работает на python 2.7.5

Устанавливаем пакет для управления библиотеками python

```console
sudo yum install pip
```

Установка доп. библиотек для оперирования с /proc/

```console
pip install proc procfs psutil
````

Скрипт в цикле выводит информацию похожую на вывод команды ps ax. Вызов скрипта

```console
sudo myps.py
```
