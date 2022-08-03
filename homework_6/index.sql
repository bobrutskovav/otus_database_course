create index idx_house_id
    on sensors.house("id");

create index idx_zone_id
    on sensors.zone("id");

create index idx_device_id
    on sensors.device("id");


create index idx_event_id_device_id
    on sensors.event("id","device_id");


create index idx_event_created_at
    on sensors.event("created_at");


--explain index only
explain
select e.id from sensors.device as d join sensors.event as e on d.id = e.device_id where device_id = 1;


--Nested Loop  (cost=0.14..30.34 rows=5 width=4)
--->  Index Only Scan using device_id_index on device d  (cost=0.14..8.16 rows=1 width=4)
--Index Cond: (id = 1)
--->  Seq Scan on event e  (cost=0.00..22.12 rows=5 width=8)
--Filter: (device_id = 1)

-- explain without index
explain
select * from sensors.device as d join sensors.event as e on d.id = e.device_id where title like 'RANDOM DEVICE%';
--select ticket_no, passenger_name, to_tsvector(passenger_name)@@to_tsquery('olga' )

explain
select e.id,e.msg, to_tsvector(e.msg)@@to_tsquery('light') from sensors.event as e;



--Полнотекстовой поиск с индексом
--Добавим много девайсов для полнотекстового поиска
insert into sensors.device (zone_id, type_id, title)
select 1,2,('another device ' || i::text)
from generate_series(10, 150) as t(i);

--добавим много эвенитов
insert into sensors.event(event_type_id,zone_id, device_id,msg,created_at)
select 1,1,3,('{"light flow": ' || i::text || '}') ::jsonb, now()
from generate_series(10, 150) as t(i);


explain(analyse)
select d.id,d.title,to_tsvector(d.title)@@to_tsquery('10 | 100' ) from sensors.device as d;

--Seq Scan on device d  (cost=0.00..74.77 rows=142 width=23) (actual time=0.041..0.754 rows=142 loops=1)
--Planning Time: 0.037 ms
--Execution Time: 0.790 ms



create index title_search_idx on sensors.device using gin (to_tsvector('english', title));
analyse sensors.device;

explain(analyse)
select d.id,d.title,to_tsvector(d.title)@@to_tsquery('10 | 100' ) from sensors.device as d;

--Seq Scan on device d  (cost=0.00..74.77 rows=142 width=23) (actual time=0.039..0.762 rows=142 loops=1)
--Planning Time: 0.041 ms
--Execution Time: 0.781 ms

--Похоже индекс не применяется(((



--индекс с функцией
explain(analyse)
select d.id,d.title  from sensors.device as d where upper(d.title) = 'ANOTHER DEVICE 22';


--Seq Scan on device d  (cost=0.00..4.13 rows=1 width=22) (actual time=0.062..0.110 rows=1 loops=1)
--Filter: (upper((title)::text) = 'ANOTHER DEVICE 22'::text)
--Rows Removed by Filter: 141
--Planning Time: 0.045 ms
--Execution Time: 0.121 ms

CREATE INDEX upper_title_idx on sensors.device(upper(title));


explain(analyse)
select d.id,d.title  from sensors.device as d where upper(d.title) = 'ANOTHER DEVICE 22';


--Seq Scan on device d  (cost=0.00..4.13 rows=1 width=36) (actual time=0.026..0.074 rows=1 loops=1)
--Filter: (upper((title)::text) = 'ANOTHER DEVICE 22'::text)
--Rows Removed by Filter: 141
--Planning Time: 0.177 ms
--Execution Time: 0.088 ms

--индекс тоже не применился((



