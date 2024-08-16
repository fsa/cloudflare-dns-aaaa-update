# Скрипт обновления AAAA записи в DNS Cloudflare

Данные скрипты позволяют обновлять записи типа AAAA через API DNS сервера Cloudflare. Устройство может анонсировать в DNS как свой адрес, так и любой другой адрес внутри своего префикса.

## Первоначальная настройка

Перед использованием скрипта необходимо создать файл переменных окружения `.env`. Пример этого файла есть в `.env.example`. Также можно пройти дальнейшие шаги по порядку и создать свой файл вручную.

## Шаг нулевой, первоначальная настройка

Первое, что необходимо сделать, указать имя интерфейса, откуда буду получены адреса:

```ini
INTERFACE=eth0
```

Далее укажите домен, который вы будете использовать на Cloudflare (DOMAIN), запись на этом домене (RECORD), а также адрес интерфейса, который будет необходимо добавить к полученному префиксу сети `/64`. Адрес интерфейса представляет из себя правую часть адреса IPv6.

```ini
DOMAIN=example.org
RECORD=my_router.example.org
RECORD_VALUE=1
```

Для получения доступа на первом шаге необходимо получить токен доступа для Cloudflare и указать его в `.env`.

```ini
API_TOKEN=CLOUDFLARE_API_TOKEN
```

## Шаг первый, получение ZONE_ID

После этого можно запустить скрипт `1_get_zone_id.sh`. Из ответа извлекаем id зоны, которая расположена в самом начале ответа:

```json
{"result":[{"id":"ZONE_ID",....
```

Копируем значение и добавляем в `.env`:

```ini
ZONE_ID=ZONE_ID_STEP1
```

## Шаг второй, получение RECORD_ID

После того, как вы указали `ZONE_ID`, выполняем получение значения RECORD_ID. Для этого запускаем скрипт `2_get_record_id.sh`. Из ответа извлекаем id записи, которая расположена в самом начале ответа:

```json
{"result":[{"id":"RECORD_ID",...
```

Копируем значение и добавляем в `.env`:

```ini
RECORD_ID=RECORD_ID_STEP2
```

## Шаг третий, обновление записи

Третий шаг является финальным. Теперь для обновления записи просто запустите скрипт `3_update_aaaa.sh`. Запуск скрипта можно выполнять каждый раз, когда необходимо обновить запись.
