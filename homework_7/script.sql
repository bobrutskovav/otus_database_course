create table statistic(
                          player_name varchar(100) not null,
                          player_id int not null,
                          year_game smallint not null check (year_game > 0),
                          points decimal(12,2) check (points >= 0),
                          primary key (player_name,year_game)
);


insert into
    statistic(player_name, player_id, year_game, points)
values
    ('mike',1,2018,18),
    ('jack',2,2018,14),
    ('jackie',3,2018,30),
    ('jet',4,2018,30),
    ('luke',1,2019,16),
    ('mike',2,2019,14),
    ('jack',3,2019,15),
    ('jackie',4,2019,28),
    ('jet',5,2019,25),
    ('luke',1,2020,19),
    ('mike',2,2020,17),
    ('jack',3,2020,18),
    ('jackie',4,2020,29),
    ('jet',5,2020,27);



--написать запрос суммы очков с группировкой и сортировкой по годам
select sum(s.points),year_game from statistic as s
group by s.year_game
order by s.year_game;

--написать cte показывающее тоже самое
with points_per_year as(
    select sum(s.points) as points_sum,year_game
    from statistic as s
    group by s.year_game
    order by s.year_game
)
select p.points_sum,p.year_game from points_per_year as p;


--используя функцию LAG вывести кол-во очков по всем игрокам за текущий код и за предыдущий.
select lag(sum(points)) over (order by year_game) as prev_year,sum(points) as current,year_game
from statistic
GROUP BY  statistic.year_game;