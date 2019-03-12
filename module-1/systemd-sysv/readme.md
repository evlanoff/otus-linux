# Создание юнита

myunit.service - основной сервис

myownunit.timer - таймер для сервиса

myownlog - файл с переменными

logger.sh - скрипт, который запускает сервис


**Запуск сервиса и таймера**

```console
sudo systemctl enable myunit.service myownunit.timer
sudo systemctl start myunit.service myownunit.timer
```

Просмотр работы скрипта

```console
sudo tail -f /var/log/messages
```

