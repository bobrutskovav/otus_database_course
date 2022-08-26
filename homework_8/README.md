### Домашнее задание 8

#### Репликация
##### Физическая репликация
*поднимаем compose, нужные конфиги уже прокинуты в контейнеры*
*подключаемся контейнеру postgres-master, создаем пользователя для репликации, создаем базу и таблицу с данными*
<details>
  <summary>postgres-master</summary><p>

```
# su postgres
postgres@bbf973c9811e:/$ psql
Password for user postgres:
psql (14.4 (Debian 14.4-1.pgdg110+1))
Type "help" for help.

postgres=# CREATE DATABASE replica;
CREATE DATABASE
postgres=# \c replica;
You are now connected to database "replica" as user "postgres".
replica=# CREATE TABLE test(i int);
CREATE TABLE
replica=# INSERT INTO test values(10);
INSERT 0 1
replica=# SELECT pg_create_physical_replication_slot('main');
pg_create_physical_replication_slot
-------------------------------------
(main,)
(1 row)

replica=# SELECT pg_reload_conf();
pg_reload_conf
----------------
t
(1 row)

replica=# CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'pass';
CREATE ROLE
replica=# INSERT INTO test values(10);
INSERT 0 1
replica=#
```
</p></details>


*заходим в реплику, создаем кластер, стираем данные, запускаем репликацию, проверяем состояние*

<details>
  <summary>postgres-replica</summary><p>


```
# pg_createcluster -d /var/lib/postgresql/14/main2 14 main2
Creating new PostgreSQL cluster 14/main2 ...
/usr/lib/postgresql/14/bin/initdb -D /var/lib/postgresql/14/main2 --auth-local peer --auth-host scram-sha-256 --no-instructions
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

The database cluster will be initialized with locale "en_US.utf8".
The default database encoding has accordingly been set to "UTF8".
The default text search configuration will be set to "english".

Data page checksums are disabled.

fixing permissions on existing directory /var/lib/postgresql/14/main2 ... ok
creating subdirectories ... ok
selecting dynamic shared memory implementation ... posix
selecting default max_connections ... 100
selecting default shared_buffers ... 128MB
selecting default time zone ... Etc/UTC
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok
Ver Cluster Port Status Owner    Data directory               Log file
14  main2   5432 down   postgres /var/lib/postgresql/14/main2 /var/log/postgresql/postgresql-14-main2.log

#
# su postgres
postgres@93a477bd8ad0:/$ rm -rf /var/lib/postgresql/14/main2/*
postgres@93a477bd8ad0:/$ pg_basebackup -h 172.21.0.2 -p 5432 -U replicator -D /var/lib/postgresql/14/main2
Password:
postgres@93a477bd8ad0:/$ pg_lsclusters
Ver Cluster Port Status Owner    Data directory               Log file
14  main2   5432 down   postgres /var/lib/postgresql/14/main2 /var/log/postgresql/postgresql-14-main2.log
postgres@93a477bd8ad0:/$ pg_ctlcluster 14 main2 start
postgres@93a477bd8ad0:/$ pg_lsclusters
Ver Cluster Port Status Owner    Data directory               Log file
14  main2   5432 online postgres /var/lib/postgresql/14/main2 /var/log/postgresql/postgresql-14-main2.log
postgres@93a477bd8ad0:/$ psql
psql (14.4 (Debian 14.4-1.pgdg110+1))
Type "help" for help.

postgres=# \l
List of databases
Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
replica   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
|          |          |            |            | postgres=CTc/postgres
template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
|          |          |            |            | postgres=CTc/postgres
(4 rows)

postgres=# \c replica
You are now connected to database "replica" as user "postgres".
replica=# select pg_is_in_recovery();
pg_is_in_recovery
-------------------
t
(1 row)
replica=# select * from test;
i
----
10
(1 row)
replica=#
```
</p></details>


##### Логическая репликация

*мастер получил нужные настройки с конфигом(wal_level = logical), создаем пользователя, данные и публикацию*

<details>
    <summary>postgres-master</summary><p>

```
psql
postgres=# CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'pass';
postgres=# CREATE TABLE my_pub_table(i int);
postgres=# INSERT INTO my_pub_table values(1);
postgres=# CREATE PUBLICATION my_pub FOR TABLE my_pub_table;
```

</p></details>


*реплика получила нужный конфиг (wal_level = logical), создаем таблицу, подписку и делаем запрос на подключение к публикации*
<details>
    <summary>postgres-replica</summary><p>

```
psql


postgres=# CREATE TABLE my_pub_table(i int);
postgres=# CREATE SUBSCRIPTION my_pub
postgres=# CONNECTION 'host=172.20.0.5 port=5432 user=postgres password=pass dbname=postgres' 
PUBLICATION my_pub;


postgres=# SELECT * FROM my_pub_table;
i
----
 1
 (1 row)
```

</p></details>