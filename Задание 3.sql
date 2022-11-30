select initcap(customer.first_name) as "Имя покупателя", 
initcap(customer.last_name) as "Фамилия покупателя", 
address.address as "Адрес", 
city.city as "Город",
country.country as "Страна"
from customer 
join address
on customer.address_id = address.address_id
join city
on address.city_id = city.city_id
join country
on city.country_id = country.country_id 

//

select store.store_id as "номер магазина", 
city.city as "город",
address.address as "адрес магазина",
initcap(staff.first_name||' '||' '||staff.last_name) as "имя продавца",
count(store.store_id) as "количество покупателей" 
from store 
join customer
on store.store_id = customer.store_id
join address
on store.address_id = address.address_id
join city
on city.city_id = address.city_id
join staff
on staff.staff_id = store.manager_staff_id
group by city.city, address.address, store.store_id, staff.staff_id  
having count(store.store_id) > 300

//

select initcap(customer.first_name||' '||' '||customer.last_name) as "Имя покупателя",
count(rental.rental_id) as "кол-во фильмов"
from customer
join rental
on rental.customer_id = customer.customer_id
group by customer.customer_id, rental.customer_id  
order by (count(rental.rental_id)) desc limit 5

//

select initcap(customer.first_name||' '||' '||customer.last_name) as "Имя покупателя", 
payment.customer_id, 
round(sum(amount)), 
min(amount), 
max(amount), 
count(amount) as "кол-во фильмов" 
from payment
join customer
on customer.customer_id = payment.customer_id 
group by payment.customer_id, customer.customer_id  
order by (count(amount))

//  sum	    min	    max	  count
// 52.88	0.99	9.99   12

select * from city c, city c1 where c.city_id != c1.city_id

//

select r.customer_id,
initcap(c.first_name||' '||' '||c.last_name) as "Имя покупателя",
count(r.rental_id) as "взято фильмов", 
sum(r.return_date - r.rental_date) as "дней в аренде",
(sum(r.return_date - r.rental_date))/count(r.rental_id) as "среднее кол-во дней в аренда"
from rental r
join customer c 
on c.customer_id = r.customer_id 
group by r.customer_id, c.first_name,c.last_name
order by r.customer_id 

//

select f.title, f.film_id, count(r.rental_id), i.store_id, i.inventory_id from inventory i 
join rental r 
on i.inventory_id = r.inventory_id
join film f 
on f.film_id = i.film_id 
group by f.film_id, f.title, i.store_id, i.inventory_id
order by film_id

//

select i.*, f.title from inventory i 
left join rental r  
on r.inventory_id = i.inventory_id
join film f 
on f.film_id = i.film_id 
where r.inventory_id is null  

//

select s.staff_id, 
initcap(s.first_name||' '||' '||s.last_name) as "Имя продавца",
count(p.payment_id) as "кол-во продаж",
case 
	when count(p.payment_id) > 7200 then 'премия - да'
	when count(p.payment_id) < 7200 then 'премия - нет'
end as "премия" 
from staff s
join payment p  
on s.staff_id = p.staff_id  
group by s.staff_id

select r.* from rental r 
left join payment p 
on r.rental_id = p.rental_id 
where p.payment_id is null 

select count(r.rental_id), count(p.payment_id) from rental r
join payment p 
on p.rental_id = r.rental_id 


                                                            // РАЗДЕЛ 2 // - доработка

// Задание 6
select (lower(first_name)) as first_name, (lower(last_name)) as last_name from customer
where (first_name = 'KELLY' or first_name = 'WILLIE') and active != 0


// Задание 4
select replace (upper (left (split_part(email, '@', 1),1)) || lower (SUBSTRING (split_part(email, '@', 1), 2)),'.',' ') as "Префикс эл.почты", 
upper (left (split_part(email, '@', 2), 1)) || lower (SUBSTRING (split_part(email, '@', 2), 2)) as "Постфикс эл.почты" from customer

                                                            // РАЗДЕЛ 3 //  - доработка
// Задание 4 //

select count(rental.rental_id), customer.first_name, customer.customer_id from rental
join customer
on rental.customer_id = customer.customer_id 
group by customer.customer_id
order by count(rental.rental_id)
count  name   id
12	  BRIAN	  318

select initcap(customer.first_name||' '||' '||customer.last_name) as "Имя покупателя", 
customer.customer_id, 
round(sum(amount)), 
min(amount), 
max(amount), 
count(rental.rental_id) as "кол-во фильмов" 
from payment
join customer
on customer.customer_id = payment.customer_id
join rental
on payment.rental_id = rental.rental_id  
group by customer.customer_id 
order by (count(rental.rental_id))

// Задание 5 //

select * from city c, city c1 where c.city != c1.city and c.city_id != c1.city_id

// доп. задание 3 //

select * from sales_by_store

