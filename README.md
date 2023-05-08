# Пример работы с PostgreSQL

## Список SQL скриптов
Предлагается 3 SQL-скрипта, находящихся в папке ./sql:
* `Label_init.sql` - скрипт создания базы данных;
* `Label_insert.sql` - скрипт вставки в базу тестовых данных;
* `Label_queries.sql` - примеры запросов.

## Развертывание базы данных

Используется система из двух контейнеров: postgresql и pgadmin.
См. файл docker-compose.yml. Для запуска необходимо ввести команду (считаем, что docker и docker compose 
установлены):

```
docker compose up -d

```
![Alt text](/pics/docker_compose_up.png?raw=true "Запускаем docker compose в терминале")
## Доступ к базе данных
* `Порт` 5432
* `Пользователь` postgres
* `Пароль` postgres
* `Название базы данных` label
## Доступ к pgAdmin
* `URL` http://localhost:5050/browser
* `Пользователь` admin@admin.org
* `Пароль` admin

![Alt text](/pics/pgadmin_screen.png?raw=true "Открытая в браузере страница pgAdmin")

## Подключение к БД через pgAdmin
Сначала необходимо узнать IP-адрес сервера postgreSQL. Чтобы узнать его, необходимо сначала узнать CONTAINER_ID:
```
docker ps
```
Затем найти адрес в выводе команды:
```
docker inspect <CONTAINER_ID>
```
После этого необходимо на веб-странице pgAdmin зарегистрировать свой сервер:
![Alt text](/pics/pgadmin_register.png?raw=true "Регистрация в pgAdmin")

Во вкладке General ввести произвольное название сервера (например, test):
![Alt text](/pics/pgadmin_general.png?raw=true "Вкладка General")

Во вкладке Connection ввести полученный ранее IP-адрес, порт, название БД, пользователя, пароль и нажать save:
![Alt text](/pics/pgadmin_conn.png?raw=true "Вкладка Connection")

Мы подключились!
![Alt text](/pics/pgadmin_done.png?raw=true "Вкладка Connection")

## Добавление пользователя через PostgreSQL
* Зайти внутрь контейнера и запустить shell:
```
docker exec -it postgres_container sh
```
* Подключиться к PostgreSQL:
```
psql -U postgres -d label
```
* Добавить пользователя:
```
CREATE USER mike WITH PASSWORD '123';
```
* Список пользователей можно посмотреть командой:
```
\du
```
* Выйти из PostgreSQL:
```
exit
```
* Выйти из контейнера:
```
exit
```

## Инициализация базы данных

Скрипты sql/Label_init.sql и sql/Label_insert.sql запускаются автоматически при первом запуске контейнеров и инициализируют базу данных.

**Внимание** Если при запуске docker compose up в логе появляется ошибка:
```
/usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/init.sql
/docker-entrypoint-initdb.d/init.sql: Permission denied
```

необходимо поставить права на Label_init.sql на хосте:
```
chmod 777 ./sql/Label_init.sql
```

Также в качестве примера приведен ряд запросов в файле sql/Label_queries.sql.

