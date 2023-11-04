-- 1.Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system

SELECT COUNT(*) AS num_copies
FROM sakila.inventory
WHERE film_id = (
    SELECT film_id FROM sakila.film
    WHERE title = 'Hunchback Impossible'
    );


-- 2.List all films whose length is longer than the average length of all the films in the Sakila database

SELECT * FROM sakila.film
WHERE length > (
    SELECT AVG(length)
    FROM sakila.film
);

-- 3.Use a subquery to display all actors who appear in the film "Alone Trip"

SELECT *
FROM sakila.actor
WHERE actor.actor_id IN (
    SELECT film_actor.actor_id
    FROM sakila.film_actor
    JOIN sakila.film ON film_actor.film_id = film.film_id
    WHERE film.title = 'Alone Trip'
);


-- 4.Sales have been lagging among young families, and you want to target family movies for a promotion.
--   Identify all movies categorized as family films.

SELECT * FROM sakila.film
WHERE film.film_id IN (
    SELECT film_category.film_id
    FROM sakila.film_category
    JOIN sakila.category ON film_category.category_id = category.category_id
    WHERE category.name = 'Family'
);

-- 5.Retrieve the name and email of customers from Canada using both subqueries and joins.
--   To use joins, you will need to identify the relevant tables and their primary and foreign keys.

SELECT first_name, last_name, email
FROM sakila.customer
WHERE address_id IN (
    SELECT address_id
    FROM sakila.address
    WHERE city_id IN (
        SELECT city_id
        FROM sakila.city
        WHERE country_id IN (
            SELECT country_id
            FROM sakila.country
            WHERE country = 'Canada'
        )
    )
);

-- 6.Determine which films were starred by the most prolific actor in the Sakila database.
--   A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

SELECT actor.actor_id, actor.first_name, actor.last_name
FROM sakila.film_actor
JOIN sakila.actor ON film_actor.actor_id = actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT film.title FROM sakila.film
JOIN sakila.film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = (
    SELECT actor_id
    FROM sakila.film_actor
    GROUP BY actor_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);


-- 7.Find the films rented by the most profitable customer in the Sakila database. 
--   You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

SELECT customer_id FROM sakila.payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1;

SELECT film.title FROM sakila.film
JOIN sakila.inventory ON film.film_id = inventory.film_id
JOIN sakila.rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.customer_id = (
    SELECT customer_id
    FROM sakila.payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);

-- 8.Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
--   You can use subqueries to accomplish this.

SELECT customer_id, SUM(amount) as total_amount_spent
FROM sakila.payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_amount)
    FROM (
        SELECT customer_id, SUM(amount) as total_amount
        FROM sakila.payment
        GROUP BY customer_id
    ) AS client_totals
);


