## Простая защита от DDOS

Написать конфигурацию nginx, которая даёт доступ клиенту только с определенной cookie.

Если у клиента её нет, нужно выполнить редирект на location, в котором кука будет добавлена, после чего клиент будет обратно отправлен (редирект) на запрашиваемый ресурс.

### Устанавливаем nginx
```sh
yum install epel-release -y
yum install nginx -y
```
### Примитивный конфиг

```sh
events {
}

http {
    charset utf-8;
        include /etc/nginx/mime.types;
            default_type application/octet-stream;
                
                    server {
                            listen 80;
                                    root /var/www/;
                                            server_name otus.local;
                                                        location /otus {
                                                                        if ($cookie_otus = 1) {
                                                                                            return 200 'Hello, OTUS!';
                                                                                                            }
                                                                                                                        }
                                                                                                                            }
                                                                                                                                
                                                                                                                                }
                                                                                                                                ```
                                                                                                                                ### Запуск веб-сервера
                                                                                                                                ```sh
                                                                                                                                nginx -c /vagrant/nginx.conf
                                                                                                                                ```
                                                                                                                                Посылаем cookie на сервер, в ответ видем приветствие
                                                                                                                                ```sh
                                                                                                                                curl -v --cookie "otus=1" http://192.168.11.100/otus
                                                                                                                                ```
