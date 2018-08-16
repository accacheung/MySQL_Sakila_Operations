USE sakila;

DESCRIBE actor;

#1a. 
SELECT first_name, last_name FROM actor;

#1b.
SELECT CONCAT (actor.first_name, " ", actor.last_name) AS `Actor Name` FROM actor;

#2a.
SELECT actor.actor_id, actor.first_name, actor.last_name FROM actor WHERE actor.first_name="Joe";

#2b.
SELECT CONCAT (actor.first_name, " ", actor.last_name) AS `Actor Name` FROM actor
WHERE actor.last_name LIKE '%GEN%';

#2c.
SELECT actor.last_name, actor.first_name FROM actor
WHERE actor.last_name LIKE '%LI%';

#2d.
SELECT country.country_id, country.country FROM country WHERE country.country IN ("Afghanistan", "Bangladesh", "China");

#3a.
ALTER TABLE actor
ADD COLUMN description BLOB;
# To Check 
DESCRIBE actor;

#3b.
ALTER TABLE actor
DROP COLUMN description;
# To Check 
DESCRIBE actor;

#4a.
SELECT last_name, COUNT(last_name) AS Count FROM `Last Name` GROUP BY last_name;

#4b.
SELECT last_name, COUNT(last_name) AS Count FROM `Last Name` GROUP BY last_name
HAVING COUNT(last_name) >1;

#4c.
# Look up for GROUCHO WILLIAMS and make sure there's no dupe
SELECT * FROM actor WHERE first_name="GROUCHO" AND last_name="WILLIAMS";
# Update by using actor_id
UPDATE actor SET first_name="HARPO" WHERE actor_id=172;
# To Check 
SELECT * FROM actor WHERE actor_id=172;

#4d.
UPDATE actor SET first_name="GROUCHO" WHERE actor_id=172;
# To Check
SELECT * FROM actor WHERE actor_id=172;

#5a.
SHOW CREATE TABLE address;

CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8

#6a.
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON staff.address_id=address.address_id;

#6b.
SELECT staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff
INNER JOIN payment ON staff.staff_id=payment.staff_id 
WHERE payment.payment_date LIKE '2005-08%'
GROUP BY staff.staff_id;

#6c.
SELECT film.title, COUNT(film_actor.actor_id)
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.title;

#6d.
SELECT film.title, COUNT(inventory.inventory_id) 
FROM film
INNER JOIN inventory ON film.film_id=inventory.film_id
WHERE film.title="Hunchback Impossible";

#6e.
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS `Total Paid`
FROM customer
INNER JOIN payment ON customer.customer_id=payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name ASC;

#7a.
SELECT film.title 
FROM film
WHERE film.language_id IN (SELECT language_id FROM language WHERE name = "English")
AND film.title LIKE 'K%' OR film.title LIKE 'Q%';

#7b. 
SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id IN (SELECT film_actor.actor_id FROM film_actor WHERE film_actor.film_id IN 
(SELECT film.film_id FROM film WHERE title="Alone Trip"));

#7c.
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
WHERE customer.address_id IN (SELECT  address.address_id FROM address WHERE address.city_id IN
(SELECT city.city_id FROM city INNER JOIN country WHERE city.country_id=country.country_id AND 
country.country="Canada"));

#7d.
# Using Views film_list
DESCRIBE film_list;
SELECT film_list.title, film_list.category
FROM film_list
WHERE category = "Family";

#7e.
SELECT inventory.film_id, film_text.title, COUNT(rental.inventory_id)
FROM inventory
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN film_text ON inventory.film_id = film_text.film_id
GROUP BY rental.inventory_id
ORDER BY COUNT(rental.inventory_id) DESC;

#7f.
SELECT store.store_id, SUM(payment.amount)
FROM store
INNER JOIN staff ON store.store_id = staff.store_id
INNER JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY store.store_id;

#7g.
SELECT store.store_id, city.city, country.country
FROM store 
INNER JOIN address ON store.address_id = address.address_id 
INNER JOIN city ON address.city_id = city.city_id 
INNER JOIN country ON city.country_id = country.country_id;

#7h
SELECT category.name, SUM(payment.amount) 
FROM category 
INNER JOIN film_category ON film_category.category_id = category.category_id 
INNER JOIN inventory ON inventory.film_id = film_category.film_id 
INNER JOIN rental ON rental.inventory_id = inventory.inventory_id 
INNER JOIN payment ON payment.rental_id = rental.rental_id 
GROUP BY category.name 
ORDER BY SUM(payment.amount) DESC LIMIT 5;

#8a
CREATE VIEW top_five_genres AS
SELECT category.name, SUM(payment.amount) 
FROM category 
INNER JOIN film_category ON film_category.category_id = category.category_id 
INNER JOIN inventory ON inventory.film_id = film_category.film_id 
INNER JOIN rental ON rental.inventory_id = inventory.inventory_id 
INNER JOIN payment ON payment.rental_id = rental.rental_id 
GROUP BY category.name 
ORDER BY SUM(payment.amount) DESC LIMIT 5;

#8b.
SELECT * FROM top_five_genres;

#8c.
DROP VIEW top_five_genres;
