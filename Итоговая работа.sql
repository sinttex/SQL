-- Задание 1.

select seats.aircraft_code as "тип самолета", count(seats.seat_no) as "количество мест" from seats
group by seats.aircraft_code
having count(seats.seat_no)>50
order by count(seats.seat_no) desc

-- Задание 2.

with tab_bis as (
select fare_conditions, amount, airport_name from ticket_flights
join flights 
on ticket_flights.flight_id = flights.flight_id 
join airports 
on airports.airport_code = flights.departure_airport
where fare_conditions = 'Business'
order by amount desc),
tab_eco as (
select fare_conditions, amount, airport_name from ticket_flights
join flights 
on ticket_flights.flight_id = flights.flight_id 
join airports 
on airports.airport_code = flights.departure_airport
where fare_conditions = 'Economy'
order by amount desc)
select tab_bis.fare_conditions, tab_bis.amount, tab_bis.airport_name, 
tab_eco.fare_conditions, tab_eco.amount, tab_eco.airport_name from tab_bis, tab_eco 
where tab_eco.amount > tab_bis.amount 
limit 50

-- Задание 3.

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
 full outer join bis b on n.model = b.model
where b.model is null

-- Задание 4.
seats
flights
boarding_passes
-- 3 таблицы 
-- первый запрос - занято в рейсе
-- второй запрос - отношение
-- оконная функция - накопительный итог
-- сколько посадочных талонов на рейсе - сколько мест в самолете на этом рейсе

-- select flight_id, count(bp.boarding_no), count(bp.seat_no) from boarding_passes bp 
-- group by flight_id 
-- having count(bp.boarding_no) != count(bp.seat_no) 
-- -- нет расхождений 

-- select f.flight_id, f.aircraft_code, count(bp.boarding_no), count(s.seat_no) from seats s
-- join flights f
-- on f.aircraft_code = s.aircraft_code 
-- join boarding_passes bp
-- on bp.flight_id = f.flight_id 
-- group by f.aircraft_code, f.flight_id  
-- having (count(s.seat_no)/count(bp.boarding_no)) != 1
-- -- нет расхождений

 with seats as (
select a.aircraft_code as aircraft_code, 
count(s.seat_no) as seats from seats s 
join aircrafts a 
on a.aircraft_code = s.aircraft_code 
group by a.aircraft_code
),
passes as (
select f.flight_id as flight_id, f.aircraft_code as aircraft_code, 
count(bp.boarding_no) as passes from flights f  
join boarding_passes bp  
on bp.flight_id  = f.flight_id  
group by f.flight_id 
)
select p.flight_id, p.aircraft_code, p.passes, s.seats, round(cast(p.passes as numeric)/s.seats * 100) as "процент загрузки" 
from passes p
join seats s
on s.aircraft_code = p.aircraft_code
 
-- третий вариант 
with bp_count as (
select f.flight_id, departure_airport, scheduled_departure, count(bp.boarding_no) as bp_count from flights f
join boarding_passes bp
on bp.flight_id = f.flight_id 
group by f.flight_id
order by f.departure_airport, f.scheduled_departure
)
select *, 
sum(bp_count.bp_count) over (partition by bp_count.departure_airport order by bp_count.scheduled_departure) as "итог" 
from bp_count


-- Задание 5. 

select distinct (f.departure_airport), count(f.actual_departure) over (partition by f.departure_airport) as actual, 
count(f.flight_id) over (partition by f.departure_airport) as all, 
round(cast(count(f.actual_departure) over (partition by f.departure_airport) as numeric)/count(f.flight_id) over (partition by f.departure_airport),2)*100 as "%"
from flights f
group by f.departure_airport, f.actual_departure, f.flight_id 
order by f.departure_airport 

--select * from flights f
--where f.departure_airport = 'AAQ'
--order by f.status 

-- Задание 7.
-- аэропорты и перелёты 
-- 
select f.flight_no, a.city from airports a 
join flights f on a.airport_code != f.departure_airport 
 

