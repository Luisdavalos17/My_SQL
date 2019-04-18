-- 1a Display the first and last names of all actors from the table actor.
use sakila;
select first_name, last_name
From actor;
-- 1b . Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select UPPER(CONCAT(first_name,' ', last_name)) AS 'Actor Name'
from actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name
from actor
where first_name = 'joe';
-- 2b. Find all actors whose last name contain the letters GEN:
select * from actor where last_name like '%GEN%';
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select * from actor where last_name like '%LI%' order by last_name, first_name;
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country where country in 
('Afghanistan,' 'Bangladesh','China') ;
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter table actor
add column description varchar(50) after first_name;
alter table actor
modify column description BLOB;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the description column.
alter table actor drop column description;
-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) from actor 
group by last_name;
-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
select last_name, count(*) from actor
group by last_name having count(*) >2;
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.
update actor
set first_name= 'Harpo'
where first_name= 'GROUCHO'and last_name= 'WILLIAMS';
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- it turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor
set first_name= 'GROUCHO'
where first_name= 'Harpo';
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table actor; 
create table actor_table as (select * from actor); 
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member.
-- Use the tables staff and address:
select s.first_name, s.last_name, a.address
from staff s left join address a on s.address_id = a.address_id
;
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select s.first_name, s.last_name, sum(p.amount) as'total'
from staff s inner join payment p on s.staff_id = p.staff_id
group by s.first_name, s.last_name;
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select f.title, count(a.actor_id) as 'total'
from film f left join film_actor a on f.film_id = a.film_id 
group by f.title; 
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system? answer is 2
select f.title, count(inventory_id) as num_copies from inventory i
inner join film f 
on f.film_id = i.film_id and f.title = 'Hunchback Impossible'
group by f.title;
-- 6d. number of copies exist in the inventory system
-- 6e. Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. List the customers alphabetically by last name:
select c.first_name, c.last_name, sum(amount) as total_payment
from customer c inner join payment p on c.customer_id = p.customer_id
group by c.first_name, c.last_name 
order by c.last_name;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title
from film 
where (title like 'K%' 
or title like 'Q%')
and language_id in (select language_id from language 
where name = 'ENGLISH'); 
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name from actor a
where actor_id in (
select film_id from film where title = 'Alone Trip')
;
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
select first_name, last_name, email from customer c
inner join address a on (cu.address_id = a.address_id)
join city ct on (a.city_id=cit.city_id)
join country cou on (cit.country_id=cntry.country_id);
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
select f.title
from film f inner join film_category fct
on fct.film_id = f.film_id inner join category  c
on fct.category_id = c.category_id
and c.name = 'Family'
-- 7e. Display the most frequently rented movies in descending order.

-- 7f. Write a query to display how much business, in dollars, each store brought in.
