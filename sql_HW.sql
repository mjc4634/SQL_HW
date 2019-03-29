USE sakila;

SELECT 
    first_name, last_name
FROM
    actor;

SELECT 
    CONCAT(first_name, ' ', last_name) AS 'Actor Name'
FROM
    actor;

SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name = 'Joe';

SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%GEN%';

SELECT 
    *
FROM
    actor
WHERE
    last_name LIKE '%LI%'
ORDER BY last_name , first_name;

SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');

ALTER TABLE actor 
ADD COLUMN description BLOB;

ALTER TABLE actor 
DROP COLUMN description;

SELECT DISTINCT
    last_name, COUNT(last_name)
FROM
    actor
GROUP BY last_name;

SELECT DISTINCT
    last_name, COUNT(last_name)
FROM
    actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';

UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO';

SELECT 
    *
FROM
    actor
WHERE
    first_name = 'GROUCHO';

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
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

SELECT staff.first_name, staff.last_name, address.address, city.city, country.country
FROM staff
INNER JOIN
    address ON staff.address_id = address.address_id 
INNER JOIN
	city ON address.city_id = city.city_id
INNER JOIN
	country ON city.country_id = country.country_id;

SELECT staff.first_name, staff.last_name, SUM(payment.amount) AS "Total Sold"
FROM staff
INNER JOIN
    payment ON staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE "2005-08%"
GROUP BY payment.staff_id;
    
SELECT title, COUNT(actor_id)
FROM film
INNER JOIN
	film_actor ON film.film_id = film_actor.film_id
GROUP BY title;

SELECT title, COUNT(inventory_id)
FROM film
INNER JOIN
	inventory ON film.film_id = inventory.film_id
WHERE title = "Hunchback Impossible";

SELECT first_name, last_name, SUM(amount)
FROM customer
INNER JOIN
	payment ON customer.customer_id = payment.customer_id
GROUP BY last_name;

SELECT title
FROM film
WHERE language_id LIKE
	(SELECT language_id
	FROM language
	WHERE name = "English")
AND (title LIKE "K%") 
OR (title LIKE "Q%");

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(SELECT actor_id
	FROM film_actor
	WHERE film_id LIKE
		(SELECT film_id 
		FROM film
		WHERE title = "Alone Trip"));


SELECT cu.last_name, cu.first_name, cu.email, co.country
FROM customer cu
JOIN address a
ON cu.address_id = a.address_id
JOIN city ci
ON a.city_id = ci.city_id
JOIN country co
ON ci.country_id = co.country_id
WHERE co.country = "Canada";

SELECT f.title, c.name
FROM film f, category c
WHERE c.name = "Family";

SELECT f.title, COUNT(*)
FROM film f, rental r, inventory i
WHERE f.film_id = i.film_id AND r.inventory_id = i.inventory_id
GROUP BY i.film_id
ORDER BY COUNT(*) DESC;

SELECT store.store_id, SUM(amount)
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN payment ON payment.staff_id = staff.staff_id
GROUP BY store.store_id;

SELECT s.store_id, SUM(amount)
FROM store s
JOIN staff ON s.store_id = staff.store_id
JOIN payment ON payment.staff_id = staff.staff_id
GROUP BY s.store_id;

SELECT *
FROM store s
JOIN address a
ON s.address_id = a.address_id
JOIN city ci
ON a.city_id = ci.city_id
JOIN country co
ON ci.country_id = co.country_id;

SELECT name, SUM(p.amount)
FROM category c
JOIN film_category fc 
ON fc.category_id = c.category_id
JOIN inventory i
ON i.film_id = fc.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
JOIN payment p 
ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

CREATE VIEW top_five_genres AS
SELECT name, SUM(p.amount)
FROM category c
JOIN film_category fc 
ON fc.category_id = c.category_id
JOIN inventory i
ON i.film_id = fc.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
JOIN payment p 
ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

SELECT * FROM top_five_genres;

DROP VIEW top_five_genres;