--=============== МОДУЛЬ 4. УГЛУБЛЕНИЕ В SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--База данных: если подключение к облачной базе, то создаёте новую схему с префиксом в --виде фамилии, название должно быть 
--на латинице в нижнем регистре и таблицы создаете --в этой новой схеме, если подключение к локальному серверу, 
--то создаёте новую схему и --в ней создаёте таблицы.

--Спроектируйте базу данных, содержащую три справочника:
--· язык (английский, французский и т. п.);
--· народность (славяне, англосаксы и т. п.);
--· страны (Россия, Германия и т. п.).
--Две таблицы со связями: язык-народность и народность-страна, отношения многие ко многим. Пример таблицы со связями — film_actor.
--Требования к таблицам-справочникам:
--· наличие ограничений первичных ключей.
--· идентификатору сущности должен присваиваться автоинкрементом;
--· наименования сущностей не должны содержать null-значения, не должны допускаться --дубликаты в названиях сущностей.
--Требования к таблицам со связями:
--· наличие ограничений первичных и внешних ключей.

--В качестве ответа на задание пришлите запросы создания таблиц и запросы по --добавлению в каждую таблицу по 5 строк с данными.
CREATE SCHEMA mypublic AUTHORIZATION postgres;

SET search_path TO mypublic

 --СОЗДАНИЕ ТАБЛИЦЫ ЯЗЫКИ
create table language(
language_id serial unique not null,
language varchar(20) unique not null,
primary key(language_id)
);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ ЯЗЫКИ
insert into language(language) values('русский')

insert into language(language) values('английский') 

insert into language(language) values('французский')

insert into language(language) values('немецкий')

insert into language(language) values('итальянский')

--СОЗДАНИЕ ТАБЛИЦЫ НАРОДНОСТИ
create table nationality(
nationality_id serial unique not null,
nationality varchar(20) unique not null,
primary key (nationality_id)
);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ НАРОДНОСТИ
insert into nationality(nationality) values('русский')

insert into nationality(nationality) values('англичанин')

insert into nationality(nationality) values('француз')

insert into nationality(nationality) values('немец')

insert into nationality(nationality) values('итальянец')

--СОЗДАНИЕ ТАБЛИЦЫ СТРАНЫ
create table country(
country_id serial unique not null,
country varchar(20) unique not null,
primary key (country_id)
);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СТРАНЫ
insert into country(country) values('Россия')

insert into country(country) values('Англия')

insert into country(country) values('Германия')

insert into country(country) values('Франция')

insert into country(country) values('Италия')

--СОЗДАНИЕ ПЕРВОЙ ТАБЛИЦЫ СО СВЯЗЯМИ
CREATE TABLE language_to_nationality(
            id serial primary key,
            nationality_id integer not null,
            language_id integer not null,
        foreign key (nationality_id) references nationality(nationality_id),
        foreign key (language_id) references language(language_id)
    );

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ
insert into language_to_nationality(language_id, nationality_id) values('1','1')

insert into language_to_nationality(language_id, nationality_id) values('1','2')

insert into language_to_nationality(language_id, nationality_id) values('1','3')

insert into language_to_nationality(language_id, nationality_id) values('1','4')

insert into language_to_nationality(language_id, nationality_id) values('1','5')

insert into language_to_nationality(language_id, nationality_id) values('2','2')

insert into language_to_nationality(language_id, nationality_id) values('2','3')

insert into language_to_nationality(language_id, nationality_id) values('2','4')

insert into language_to_nationality(language_id, nationality_id) values('3','3')

insert into language_to_nationality(language_id, nationality_id) values('3','4')

--СОЗДАНИЕ ВТОРОЙ ТАБЛИЦЫ СО СВЯЗЯМИ
CREATE TABLE country_to_nationality(
            id serial primary key,
            nationality_id integer not null,
            country_id integer not null,
        foreign key (nationality_id) references nationality(nationality_id),
        foreign key (country_id) references country(country_id)
    );


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ
insert into country_to_nationality(country_id, nationality_id) values('1','1')

insert into country_to_nationality(country_id, nationality_id) values('2','2')

insert into country_to_nationality(country_id, nationality_id) values('2','3')

insert into country_to_nationality(country_id, nationality_id) values('2','4')

insert into country_to_nationality(country_id, nationality_id) values('3','3')

insert into country_to_nationality(country_id, nationality_id) values('3','4')

insert into country_to_nationality(country_id, nationality_id) values('4','4')

insert into country_to_nationality(country_id, nationality_id) values('4','3')

insert into country_to_nationality(country_id, nationality_id) values('4','2')

insert into country_to_nationality(country_id, nationality_id) values('4','1')

insert into country_to_nationality(country_id, nationality_id) values('5','2')

insert into country_to_nationality(country_id, nationality_id) values('5','3')


--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============


--ЗАДАНИЕ №1 
--Создайте новую таблицу film_new со следующими полями:
--·   	film_name - название фильма - тип данных varchar(255) и ограничение not null
--·   	film_year - год выпуска фильма - тип данных integer, условие, что значение должно быть больше 0
--·   	film_rental_rate - стоимость аренды фильма - тип данных numeric(4,2), значение по умолчанию 0.99
--·   	film_duration - длительность фильма в минутах - тип данных integer, ограничение not null и условие, что значение должно быть больше 0
--Если работаете в облачной базе, то перед названием таблицы задайте наименование вашей схемы.

CREATE table film_new(
			id serial primary key unique not null,
			film_name varchar(255) [] not null,
			film_year integer [] check ("film_year" > '{0}'),
			film_rental_rate numeric(4,2) [] default '{0.99}',
			film_duration integer [] check ("film_duration" > '{0}')
);


--ЗАДАНИЕ №2 
--Заполните таблицу film_new данными с помощью SQL-запроса, где колонкам соответствуют массивы данных:
--·       film_name - array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']
--·       film_year - array[1994, 1999, 1985, 1994, 1993]
--·       film_rental_rate - array[2.99, 0.99, 1.99, 2.99, 3.99]
--·   	  film_duration - array[142, 189, 116, 142, 195]
insert into film_new 
values (1,
array ['The Shawshank Redemption','The Green Mile','Back to the Future','Forrest Gump','Schindlers List'],
array [1994, 1999, 1985, 1994, 1993],
array [2.99, 0.99, 1.99, 2.99, 3.99],
array [142, 189, 116, 142, 195]
);


--ЗАДАНИЕ №3
--Обновите стоимость аренды фильмов в таблице film_new с учетом информации, 
--что стоимость аренды всех фильмов поднялась на 1.41

update film_new set film_rental_rate = array(select temp_table.temp_column + 1.41 from unnest(film_new.film_rental_rate) as temp_table(temp_column));

--ЗАДАНИЕ №4
--Фильм с названием "Back to the Future" был снят с аренды, 
--удалите строку с этим фильмом из таблицы film_new

update film_new set film_name = array_remove(film_name,'Back to the Future')

--ЗАДАНИЕ №5
--Добавьте в таблицу film_new запись о любом другом новом фильме

update film_new set film_name = array_append(film_name,'Брат')

--ЗАДАНИЕ №6
--Напишите SQL-запрос, который выведет все колонки из таблицы film_new, 
--а также новую вычисляемую колонку "длительность фильма в часах", округлённую до десятых

select 
unnest(array[film_name]) as "название фильма", 
unnest(array[film_year]) as "год выхода", 
unnest(array[film_rental_rate]) as "арендная плата",
round((cast(unnest(array[film_duration])as numeric)/60), 1) as "длительность фильма в часах" from film_new

--ЗАДАНИЕ №7 
--Удалите таблицу film_new
drop table film_new