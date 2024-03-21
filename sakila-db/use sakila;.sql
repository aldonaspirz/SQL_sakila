use sakila;
select first_name,last_name from actor;

-- 1b. Display the first and last name of each actor in a single
--  column in upper case letters. Name the column Actor Name.
use sakila;
select upper(Concat(first_name,' ', last_name)) AS 'Actor_name' from actor Limit 10;

use sakila;
select actor_id, first_name, last_name from actor
where first_name = "Joe";

use sakila;
select * from actor
where last_name like '%GEN%';

use sakila;
select * from actor
where last_name like '%LI%'
order by last_name

use sakila;
select country, country_id from country where 
country In('Afghanistan', 'Bangladesh','China');

use sakila;
alter table actor
add middle_name_3 VARCHAR(255) AFTER first_name;

use sakila;
alter table actor
modify middle_name_2 BLOB;

use sakila;
alter table actor
drop column middle_name_3;

-- SELECT *
-- FROM article
-- WHERE article_title IN (SELECT *
--                         FROM (SELECT article_title
--                               FROM article
--                               GROUP BY article_title
--                               HAVING COUNT(article_title) > 1)
--                         AS a);
use sakila;
select count(first_name),first_name from actor
group by first_name
HAVING count(first_name)>1;

use sakila;
select count(last_name), last_name from actor
group by last_name
HAVING count(last_name)>1;

use sakila;
update actor
set first_name = 'HARPO'
where last_name = 'WILLIAMS' and first_name = 'GROUCHO';

use sakila;
select * from actor
where first_name = 'HARPO';

use sakila;
update actor
set first_name =
    case 
        when first_name = 'HARPO' then 'GROUCHO'
        else 'GRU'

    end
where actor_id = '172';
-- else
-- first_name ='Mucho frucho'
-- where actor_id = '172';


use sakila;
select s.first_name, s.last_name, a.address from staff s 
inner join address a on
a.address_id = s.address_id;


use sakila;
select s.first_name, s.last_name, s.staff_id
from payment p inner join staff s on
s.staff_id = p.staff_id
group by s.staff_id
;

use sakila;
select payment_date from payment;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
use sakila;
SELECT FORMAT(payment_date, 'MM/dd/yyyy') AS formatted_date
FROM payment;

use sakila;
SELECT SUM(payment.amount) AS 'Total Payments After 2005' FROM payment
WHERE payment_date > * Aug 01 2005 *;

select s.staff_id, s.first_name, s.last_name,  coalesce(concat('$', format(sum(p.amount), 2)), '$0') as amount 
from
staff  as s
join
payment as p
on
s.staff_id = p.staff_id
where
p.payment_date >= '2005-08-01 00:00:00'
and
p.payment_date <   '2005-08-02 00:00:00'
group by s.staff_id;

use sakila;
select f.film_id,  count(fa.actor_id) as "number of actors" 
from film f inner join film_actor fa on
f.film_id= fa.film_id
group by f.film_id;

use sakila;
select f.title, count(i.inventory_id) as "number of copies"
from 
film f inner join inventory i on
f.film_id=i.film_id
where f.title = 'Hunchback Impossible';

use sakila;
select c.last_name, count(p.amount) as "amount per customer"
from customer c inner join payment p on
c.customer_id =p.customer_id
group by c.last_name
order by c.last_name asc;

use sakila;
select f.title, l.name
from film f inner join language l on
f.language_id=l.language_id
where 
(f.title like 'Q%' or f.title like 'K%' ) and l.name = 'English';

use sakila;
select a.first_name, a.last_name 
from actor as a
where
a.actor_id in
(select fa.actor_id from film_actor fa
 where fa.film_id = 
 (select f.film_id from film f where title = 'Alone Trip'));

use sakila;
select * from customer;

use sakila;
select c.first_name, c.last_name, c.email, co.country
from customer c 
inner join address a on
c.address_id =a.address_id
inner join 
city ci on
a.city_id=ci.city_id 
inner join
country co on
ci.country_id = co.country_id
where 
co.country = "Canada";

use sakila;
select f.title
from film f
inner join
film_category as fc
on
f.film_id = fc.film_id
inner join
category as c
on
fc.category_id = c.category_id
where
c.name = 'Family';

use sakila;
select f.title, c.name
from film f 
inner join
film_category fc on
f.film_id=fc.film_id 
inner join
category c on
fc.category_id = c.category_id
where 
c.name = "Family";


use sakila;
select f.title, count(r.rental_id) as "Rental"
from film f 
inner join 
inventory i on
f.film_id= i.film_id
inner join 
rental r on 
i.inventory_id = r.inventory_id
group by f.title 
order by count(r.rental_id) desc;

use sakila;
select s.store_id, ci.city, co.country
from store s inner join 
address a on
s.address_id = a.address_id 
inner join 
city ci on
a.city_id = ci.city_id
inner join 
country co 
on 
ci.country_id = co.country_id;

use sakila;
select c.name, sum(p.amount) as "Top 5 Genres" 
from category c inner join 
film_category fc on
c.category_id=fc.category_id 
inner join
inventory i on
fc.film_id=i.film_id
inner join
rental r on
i.inventory_id = r.inventory_id
inner join
payment p on
r.rental_id = p.rental_id
group by c.name
order by sum(p.amount) desc
limit 5;

use sakila;
select catg.name
          ,coalesce(concat('$', format(sum(p.amount), 2)), '$0') as 'Gross Revenue'
from
category catg
inner join
film_category fc
on catg.category_id = fc.category_id
inner join
inventory i
on fc.film_id = i.film_id
inner join
rental r
on i.inventory_id = r.inventory_id
inner join 
payment p
on r.rental_id = p.rental_id
group by catg.name
order by coalesce(concat('$', format(sum(p.amount), 2)), '$0') desc
limit 5;

use sakila;
create view top_five_genres as
select c.name, sum(p.amount) as "Top Genres" 
from category c inner join 
film_category fc on
c.category_id=fc.category_id 
inner join
inventory i on
fc.film_id=i.film_id
inner join
rental r on
i.inventory_id = r.inventory_id
inner join
payment p on
r.rental_id = p.rental_id
group by c.name
order by sum(p.amount) desc
limit 5;

use sakila;
select * From top_five_genres;

use sakila;
drop view top_five_genres;