--Add Data to Tables

insert into sensors.address (id, country, city, street)
values (default, 'Russia', 'Moscow', 'Unknown Street 27');

insert into sensors.house (id, place_name, address_id)
values (default, 'My Home', (select id
                             from sensors.address as adr
                             where adr.country = 'Russia'
                               and adr.city = 'Moscow'
                               and adr.street = 'Unknown Street 27'));

insert into sensors."user" (id, name, house_id)
values (default, 'Me', (select id from sensors.house as h where h.place_name = 'My Home'));
insert into sensors.zone (id, house_id, title, description)
values (default, (select h.id
                  from sensors."user" u
                           join sensors.house h on h.id = u.house_id
                  where u.name like 'M_'), 'My Room', 'Bedroom');
insert into sensors.zone (id, house_id, title, description)
values (default, (select h.id
                  from sensors."user" u
                           join sensors.house h on h.id = u.house_id
                  where u.name like 'M_'), 'NOT MY Room', 'Kitchen');

insert into sensors.device_type (id, title, description)
values (default, 'TEMPERATURE_SENSOR', 'temperature and air humidity'),
       (default, 'LIGHT_SENSOR', 'light flow');

insert into sensors.event_type (id, type, description)
values (default, 'INFO', 'Information events, no need to alert'),
       (default, 'CRITICAL', 'Important events, need to alert to user')
returning id; -- запрос с выводом сгенерированных id


insert into sensors.device (id, zone_id, type_id, title)
values (default,
        (select z.id from sensors.zone as z limit 1),
        (select dt.id from sensors.device_type as dt where dt.title = 'LIGHT_SENSOR'),
        'RANDOM DEVICE');



select *
from sensors.address;
select *
from sensors.house;

select *
from sensors.zone;


insert into sensors.event (id, event_type_id, zone_id, device_id, msg, created_at)
values (default,
        1,
        (select z.id from sensors.zone as z limit 1),
        (select d.id from sensors.device as d limit 1),
        '{
          "light flow": 30
        }',
        now());


--with regex
select adr.street
from sensors.address as adr
where street ~ '.* Street \d{2}';
-- все двухзначные дома улиц


-- delete with using
delete
from sensors.event as e using sensors.device as d
where d.id = 1
  and e.created_at <= now()
returning e.id;
-- все события конкретного девайся с датой меньше текущей


-- with update from
-- Подписать всем девайсам тайтл зоны в которых они находятся
-- пример device.title было 'Random Device' стало 'Random Device in zone My Zone'
update sensors.device
set title = d.title || ' in zone ' || z.title
from sensors.device as d
         inner join sensors.zone as z on d.zone_id = z.id;



-- with join
-- показать все доступные зоны и девайсы, которые привязаны к зонам
select * from sensors.device right join sensors.zone on device.zone_id = zone.id;

-- показать только девайсы, которые привязаны к своим зонам
select * from sensors.device left join sensors.zone on device.zone_id = zone.id;