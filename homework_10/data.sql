#Add Data to Tables

insert into sensors.address (country, city, street)
values ('Russia', 'Moscow', 'Unknown Street 27');

insert into sensors.house (place_name, address_id)
values ('My Home', (select id
                             from sensors.address as adr
                             where adr.country = 'Russia'
                               and adr.city = 'Moscow'
                               and adr.street = 'Unknown Street 27'));

insert into sensors.user (name, house_id)
values ('Me', (select id from sensors.house as h where h.place_name = 'My Home'));
insert into sensors.zone (house_id, title, description)
values ((select h.id
                  from sensors.user u
                           join sensors.house h on h.id = u.house_id
                  where u.name like 'M_'), 'My Room', 'Bedroom');
insert into sensors.zone (house_id, title, description)
values ((select h.id
                  from sensors.user u
                           join sensors.house h on h.id = u.house_id
                  where u.name like 'M_'), 'NOT MY Room', 'Kitchen');

insert into sensors.device_type (title, description)
values ('TEMPERATURE_SENSOR', 'temperature and air humidity'),
       ('LIGHT_SENSOR', 'light flow');

insert into sensors.event_type (type, description)
values ('INFO', 'Information events, no need to alert'),
       ('CRITICAL', 'Important events, need to alert to user');



insert into sensors.device (zone_id, type_id, title)
values ((select z.id from sensors.zone as z limit 1),
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
          "light_flow": 21
        }',
        now()),
       (default,
        1,
        (select z.id from sensors.zone as z limit 1),
        (select d.id from sensors.device as d limit 1),
        '{
          "light_flow": 22
        }',
        now()),
       (default,
        1,
        (select z.id from sensors.zone as z limit 1),
        (select d.id from sensors.device as d limit 1),
        '{
          "light_flow": 23
        }',
        now()),
       (default,
        2,
        (select z.id from sensors.zone as z limit 1),
        (select d.id from sensors.device as d limit 1),
        '{
          "light_flow": 45
        }',
        now());

#выбор всех событий где температура находится в заданном диапазоне
select * from sensors.event e where e.msg -> '$.light_flow' between 21 and 23;


#выбор всех событий где тип события отмечен как критический

select * from sensors.event e join sensors.event_type et on e.event_type_id = et.id where et.id = 2;


# Подписать всем девайсам тайтл зоны в которых они находятся
# пример device.title было 'Random Device' стало 'Random Device in zone My Zone'
update sensors.device d
inner join sensors.zone as z on d.zone_id = z.id
set d.title = concat(d.title,' in zone ', z.title);




# with join
# показать все доступные зоны и девайсы, которые привязаны к зонам
select * from sensors.zone left join sensors.device  on device.zone_id = zone.id;

-- показать только девайсы, которые привязаны к своим зонам
select * from sensors.device left join sensors.zone on device.zone_id = zone.id;