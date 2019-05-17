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

В ответ ищем строку

```console
 master: * About to connect() to 192.168.11.100 port 80 (#0)
    master: *   Trying 192.168.11.100...
    master:   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    master:                                  Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0* Connected to 192.168.11.100 (192.168.11.100) port 80 (#0)
    master: > GET /otus HTTP/1.1
    master: > User-Agent: curl/7.29.0
    master: > Host: 192.168.11.100
    master: > Accept: */*
    master: > Cookie: otus=1
    master: >
    master: Hello, OTUS!	<<<<-----------------------------------
    master: < HTTP/1.1 200 OK
    master: < Server: nginx/1.12.2
    master: < Date: Fri, 17 May 2019 18:41:57 GMT
    master: < Content-Type: application/octet-stream
    master: < Content-Length: 12
    master: < Connection: keep-alive
    master: <
    master: { [data not shown]
100    12  100    12    0     0  13303      0 --:--:-- --:--:-- --:--:-- 12000
    master: * Connection #0 to host 192.168.11.100 left intact
```                                                                                                                               ```
