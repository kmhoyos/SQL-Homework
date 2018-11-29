USE sakila;

-- Question 1
SELECT first_name, last_name FROM actor;

SELECT CONCAT(first_name, " ", last_name) AS "Actor Name" FROM actor;

-- Question 2
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = "Joe";

SELECT actor_id, first_name, last_name FROM actor
WHERE last_name LIKE "%gen%";

SELECT actor_id, first_name, last_name FROM actor
WHERE last_name LIKE "%li%"
ORDER BY last_name, first_name ASC;

SELECT country_id, country FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- Question 3
ALTER TABLE actor
ADD COLUMN description BLOB AFTER last_update;

ALTER TABLE actor
DROP COLUMN description;

-- Question 4
SELECT last_name, COUNT(last_name) FROM actor
GROUP BY last_name;

SELECT last_name, COUNT(last_name) FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;

UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO";

UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

-- Question 5
SHOW CREATE TABLE address;

-- Question 6
SELECT staff.first_name, staff.last_name, address.address
FROM staff INNER JOIN address ON staff.address_id = address.address_id;

SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff INNER JOIN payment ON staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE "2005-08%"
GROUP BY staff_id;

SELECT film.film_id, film.title, COUNT(film_actor.actor_id)
FROM film INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film_id;

SELECT film.film_id, film.title, COUNT(inventory.film_id)
FROM film INNER JOIN inventory ON film.film_id = inventory.film_id
GROUP BY film_id
HAVING film.title = "Hunchback Impossible";

SELECT customer.customer_id, customer.last_name, customer.first_name, SUM(payment.amount)
FROM customer INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer_id
ORDER BY customer.last_name ASC;

-- Question 7
SELECT film.title FROM film
WHERE title LIKE "K%" OR title LIKE "Q%"
AND
(
 SELECT language_id FROM language
 WHERE language.name = "English"
 );
 
SELECT first_name, last_name FROM actor
WHERE actor_id IN
(
 SELECT actor_id FROM film_actor
 WHERE film_id IN
 (
  SELECT film_id FROM film
  WHERE title = "Alone Trip"
  )
 );
 
SELECT customer.first_name, customer.last_name, customer.email, country.country
FROM customer
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
WHERE country = "Canada";

SELECT film.title, category.name
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE name = "Family";

SELECT film.title, COUNT(rental.rental_id)
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY COUNT(rental.rental_id) DESC;

SELECT store.store_id, SUM(payment.amount)
FROM payment
INNER JOIN rental ON payment.rental_id = rental.rental_id
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN store ON inventory.store_id = store.store_id
GROUP BY store_id;

SELECT store.store_id, city.city, country.country
FROM country
INNER JOIN city ON country.country_id = city.country_id
INNER JOIN address ON city.city_id = address.city_id
INNER JOIN store ON address.address_id = store.address_id;

SELECT category.name, SUM(payment.amount)
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON film_category.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC;

-- Question 8
CREATE VIEW gross_sales AS
(
 SELECT category.name, SUM(payment.amount)
 FROM category
 INNER JOIN film_category ON category.category_id = film_category.category_id
 INNER JOIN inventory ON film_category.film_id = inventory.film_id
 INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
 INNER JOIN payment ON rental.rental_id = payment.rental_id
 GROUP BY category.name
 ORDER BY SUM(payment.amount) DESC
 );

SELECT * FROM gross_sales;

DROP VIEW gross_sales;