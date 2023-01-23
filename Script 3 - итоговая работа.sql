-- Задание 1. - Какие самолеты имеют более 50 посадочных мест?

select seats.aircraft_code as "тип самолета", count(seats.seat_no) as "количество мест" from seats
group by seats.aircraft_code
having count(seats.seat_no)>50
order by count(seats.seat_no) desc

-- Задание 2. - В каких аэропортах есть рейсы, в рамках которых можно добраться бизнес - классом дешевле, чем эконом - классом?

with tab_bis as (
select fare_conditions, amount, airport_name from ticket_flights
join flights 
on ticket_flights.flight_id = flights.flight_id 
join airports 
on airports.airport_code = flights.departure_airport
where fare_conditions = 'Business'
group by airport_name, fare_conditions, amount
),
	tab_eco as (
select fare_conditions, amount, airport_name from ticket_flights
join flights 
on ticket_flights.flight_id = flights.flight_id 
join airports 
on airports.airport_code = flights.departure_airport
where fare_conditions = 'Economy'
group by  airport_name, fare_conditions, amount
)
	select tab_bis.fare_conditions, tab_bis.amount, tab_bis.airport_name, 
tab_eco.fare_conditions, tab_eco.amount, tab_eco.airport_name from tab_bis
join tab_eco 
on tab_eco.amount > tab_bis.amount

-- Задание 3. - Есть ли самолеты, не имеющие бизнес - класса?

with bis as (
select s.fare_conditions, unnest(array_agg(distinct model)) as model from seats s 
join aircrafts a 
on a.aircraft_code = s.aircraft_code 
group by s.fare_conditions 
having s.fare_conditions = 'Business'),
 no_bis as (
select s.fare_conditions, unnest(array_agg(distinct model)) as model from seats s 
join aircrafts a 
on a.aircraft_code = s.aircraft_code 
group by s.fare_conditions 
having s.fare_conditions != 'Business') 
 select n.fare_conditions, n.model from no_bis n
 full outer join bis b
 on n.model = b.model
where b.model is null

-- Задание 4. - Найдите количество занятых мест для каждого рейса, процентное отношение количества занятых мест 
-- к общему количеству мест в самолете, добавьте накопительный итог вывезенных пассажиров по каждому аэропорту на каждый день.

-- seats
-- flights
-- boarding_passes
 with 
seats as (
select a.aircraft_code as aircraft_code, 
count(s.seat_no) as seats from seats s 
join aircrafts a 
on a.aircraft_code = s.aircraft_code 
group by a.aircraft_code
),
passes as (
select f.flight_id as flight_id,  
--f.flight_id, - дублируется
f.aircraft_code as aircraft_code, 
count(bp.boarding_no) as passes, 
--count(bp.boarding_no) as bp_count - дублируется
f.departure_airport as departure_airport,  -- добавил столбцы для накопительного итога 
f.actual_departure as actual_departure  -- добавил столбцы для накопительного итога
from flights f  
join boarding_passes bp  
on bp.flight_id  = f.flight_id  
group by f.flight_id 
)
select p.passes, s.seats, round(cast(p.passes as numeric)/s.seats * 100) as "процент загрузки", 
p.departure_airport, -- добавил в запрос 
p.actual_departure, -- добавил в запрос
sum(p.passes) over (partition by p.departure_airport, cast (p.actual_departure as date) order by p.actual_departure) as "итог" -- добавил в запрос
from passes p
join seats s
on s.aircraft_code = p.aircraft_code


-- Задание 5. - Найдите процентное соотношение перелетов по маршрутам от общего количества перелетов. 
-- Выведите в результат названия аэропортов и процентное отношение.


select a.airport_name, round(cast(count(actual_departure) as numeric)/(select count(flight_id) from flights),4)*100 as "%"
from flights f
join airports a 
on f.departure_airport = a.airport_code
group by a.airport_name

-- более наглядный вариант запроса 
select a.airport_name, count(actual_departure) as "реальные перелеты", (select count(flight_id) from flights) as "все перелёты",
round(cast(count(actual_departure) as numeric)/(select count(flight_id) from flights),4)*100 as "%"
from flights f
join airports a on f.departure_airport = a.airport_code
group by a.airport_name
order by count(actual_departure) desc


-- Задание 7. - Между какими городами не существует перелетов?

select * from (
select distinct a.city as dep, a1.city as ar from airports a, airports a1 where a.city != a1.city
) as city_all except select * from (
select distinct a.city as dep, b.city as ar from flights f
join airports a on a.airport_code = f.departure_airport 
join airports b on b.airport_code = f.arrival_airport
) as city_on_route

-- Задание 6.- Выведите количество пассажиров по каждому коду сотового оператора, если учесть, что код оператора - это три символа после +7

select substring (t.contact_data->>'phone' from 3 for 3) as "код", count(t.contact_data->>'phone') as "кол-во"from tickets t 
group by substring (t.contact_data->>'phone' from 3 for 3)

-- Задание 8. - Классифицируйте финансовые обороты (сумма стоимости билетов) по маршрутам:
-- До 50 млн - low
-- От 50 млн включительно до 150 млн - middle
-- От 150 млн включительно - high
-- Выведите в результат количество маршрутов в каждом классе.

with 
high as( 
			select a.city as dep, b.city as ar, sum(tf.amount) as sum,
			case when sum(tf.amount)>150000000 then 'high' end,
			count(case when sum(tf.amount)>150000000 then 'high' end) 
			over (partition by case when sum(tf.amount)>150000000 then 'high' end)
		from flights f
		join airports a on a.airport_code = f.departure_airport 
		join airports b on b.airport_code = f.arrival_airport
		join ticket_flights tf on f.flight_id = tf.flight_id
	group by a.city, b.city
	order by sum(tf.amount) desc),
mid as (
			select a.city as dep, b.city as ar, sum(tf.amount) as sum,
			case when sum(tf.amount)>50000000 and sum(tf.amount)<150000000 then 'mid' end,
			count(case when sum(tf.amount)>50000000 and sum(tf.amount)<150000000 then 'mid' end) 
			over (partition by case when sum(tf.amount)>50000000 and sum(tf.amount)<150000000 then 'mid' end)
		from flights f
		join airports a on a.airport_code = f.departure_airport 
		join airports b on b.airport_code = f.arrival_airport
		join ticket_flights tf on f.flight_id = tf.flight_id
	group by a.city, b.city
	order by sum(tf.amount) desc),
low as (
			select a.city as dep, b.city as ar, sum(tf.amount) as sum, 
			case when sum(tf.amount)<50000000 then 'low' end,
			count(case when sum(tf.amount)<50000000 then 'low' end) 
			over (partition by case when sum(tf.amount)<50000000 then 'low' end)
		from flights f
		join airports a on a.airport_code = f.departure_airport 
		join airports b on b.airport_code = f.arrival_airport
		join ticket_flights tf on f.flight_id = tf.flight_id
	group by a.city, b.city
	order by sum(tf.amount) desc)
select * from high h
where h.case is not null
	union all
select * from mid m
where m.case is not null
	union all
select * from low l	
where l.case is not null

-- Задание 9. - Выведите пары городов между которыми расстояние более 5000 км

-- для маршрутов
with tab as(
select a.city as departure_airport, b.city as arrival_airport,  
round(acos(sind(a.latitude)*sind(b.latitude) + cosd(a.latitude)*cosd(b.latitude)*cosd(a.longitude - b.longitude))*6371) as "расстояние км."
from flights f
		join airports a on a.airport_code = f.departure_airport 
		join airports b on b.airport_code = f.arrival_airport
group by a.city, b.city, a.longitude, a.latitude, b.latitude, b.longitude
order by "расстояние км." desc)
select * from tab t
where t."расстояние км." > 5000

-- для пар городов 
with tab as(
select a.city as a, b.city as b, 
round(acos(sind(a.latitude)*sind(b.latitude) + cosd(a.latitude)*cosd(b.latitude)*cosd(a.longitude - b.longitude))*6371) as "расстояние км."
from airports a 
		join airports b on a.airport_code != b.airport_code 
group by a.city, b.city, a.latitude, b.latitude, a.longitude, b.longitude
order by "расстояние км." desc)
select * from tab t
where t."расстояние км." > 5000