USE sakila;

-- 1.  Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT COUNT(title)
	FROM film; -- Antes de filtrar hay 1000 titulos

SELECT DISTINCT title
	FROM film;

SELECT COUNT(DISTINCT title)
FROM film; -- aparentemente no hay duplicados

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT film_id, title, rating -- coloco otra informacion que puede ser relevante para buscarlo
	FROM film
	WHERE rating = "PG-13";

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT title, description
	FROM film
	WHERE description LIKE  "%amazing%";

-- 4. . Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT title, length -- son 457 peliculas
	FROM film
	WHERE length > 120;
    
    -- 5. Recupera los nombres de todos los actores. La instruccion dice 'nombres' solamente asi que seria
    
SELECT first_name
	FROM actor;
    
    -- Adicionalmente, como me parece mas completo, busco nombre y apellido: 
SELECT first_name AS Nombre, last_name AS Apellido
	FROM actor;
-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT first_name AS Nombre, last_name AS Apellido
	FROM actor
	WHERE last_name = "Gibson";

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT actor_id, first_name -- Buscamos sólo los nombres en la tabla de actor
FROM actor
WHERE actor_id > 9 AND actor_id < 21;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT title, rating -- Hacemos lo opuesto al ejercicio 2
	FROM film
	WHERE rating NOT IN ("PG-13", "R");

-- otra forma de hacerlo
SELECT title, rating 
	FROM film
	WHERE rating <> "PG-13" AND rating <> "R";
    
-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT COUNT(film_id), rating -- Hacemos un count de la PK y agrupamos por rating 
	FROM film
    GROUP BY rating;
    
-- 10.  Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
-- comienzo por lo pequeno, la tabla customer. En el diagrama veo que hay que conectar con rental, hago un join con la customer_id. Veo que se repiten los clientes por cada rental, asi que lo que tengo que hacer es un count.

SELECT c.customer_id, c.first_name, c.last_name
	FROM customer as c
	INNER JOIN rental as r
		ON c.customer_id = r.customer_id;

-- Cuento por customer id (cuantas veces se ha registrado ese customer en sistema, que parece que es el indicador de rentals
SELECT c.customer_id, c.first_name, c.last_name, COUNT(c.customer_id) AS "Peliculas Alquiladas"
	FROM customer as c
	INNER JOIN rental as r
		ON c.customer_id = r.customer_id
	GROUP BY c.customer_id;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT f.category_id, c.name, i.film_id -- comenzamos a ver las relaciones entre las tablas category y film category
	FROM film_category AS f
	INNER JOIN category AS c
		ON f.category_id = c.category_id
	INNER JOIN inventory as i
		ON f.film_id = i.film_id;

-- Parece el mismo caso de la pregunta diez Cuento categoria en el inner join con rental (cuantas veces se ha registrado ese rental id en sistema, que parece que es el indicador de rentals

SELECT c.name AS Categoria, COUNT(r.rental_id) AS Total_Alquileres
	FROM film_category AS f
	INNER JOIN category AS c
		ON f.category_id = c.category_id
	INNER JOIN inventory as i
		ON f.film_id = i.film_id
	INNER JOIN rental as r
		ON i.inventory_id = r.inventory_id
	GROUP BY c.name;

 -- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT rating AS clasificación, AVG (length) AS promedio
	FROM film
	GROUP BY rating
	ORDER BY rating;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love"
-- Para conectar actor con film, hay que pasar por la tabla film actor 

SELECT a.actor_id, a.first_name, a.last_name, f.title 
	FROM actor AS a
	INNER JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
	INNER JOIN film AS f
		ON fa.film_id = f.film_id AND title = "Indian Love";

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title, description
	FROM film
	WHERE description LIKE "%dog%" 
   OR description LIKE "%cat%";
   
-- 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.
-- La teoria dice que NO, porque las PK de film actor son la mezcla de actor_id y film_id, ambas no nulas, pero vamos a probar. 

SELECT fa.actor_id, fa.film_id, f.title, a.actor_id
	FROM film_actor as fa
	LEFT JOIN film as f
		ON f.film_id = fa.film_id
	LEFT JOIN actor as a
		ON fa.actor_id = a.actor_id
	WHERE fa.film_id IS NULL; -- Aparentemente no arrojan datos
    
   -- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010
   
SELECT title, release_year
   FROM film
   WHERE release_year > 2004 AND release_year < 2011 
   ORDER BY release_year;
   
-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family"

SELECT c.name, f.title
	FROM category AS c
	INNER JOIN film_category AS fc
		ON fc.category_id = c.category_id
	INNER JOIN film AS f
		ON f.film_id = fc.film_id
	WHERE c.name = "Family";
    
    -- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
    
	SELECT a.actor_id, a.first_name, a.last_name, f.title -- primero buscamos la ruta
    FROM actor AS a
    INNER JOIN film_actor as fa
    ON a.actor_id = fa.actor_id
    INNER JOIN film as f
    ON fa.film_id =f.film_id;
    


    -- Query final, hacemos un count 
SELECT a.first_name, a.last_name, COUNT(f.title) AS Total_Pelis
    FROM actor AS a
    LEFT JOIN film_actor as fa
			ON a.actor_id = fa.actor_id
    INNER JOIN film as f
			ON fa.film_id =f.film_id
        GROUP BY a.first_name, a.last_name
        HAVING COUNT(f.title) > 10;
        
-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
	
SELECT title, length, rating
	FROM film
	WHERE rating = "R" AND length < 120; -- Convertimos horas a minutos
    
-- 20.  Encuentra las categorías que tienen un promedio superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

	SELECT c.name, AVG(length) -- Misma ruta de la 17 pero con AVG
	FROM category AS c
	INNER JOIN film_category AS fc
		ON fc.category_id = c.category_id
	INNER JOIN film AS f
		ON f.film_id = fc.film_id
	GROUP BY c.name
    HAVING AVG(f.length) > 120;

-- 21. actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT a.first_name, COUNT(f.title) AS Total_Pelis -- Similar a la 18, solo nos piden nombre
    FROM actor AS a
    LEFT JOIN film_actor as fa
			ON a.actor_id = fa.actor_id
    INNER JOIN film as f
			ON fa.film_id =f.film_id
        GROUP BY a.first_name, a.last_name
        HAVING COUNT(f.title) > 4;
        
-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
-- Primero resuelvo la sub consulta, veo que el formato de fecha en rental es date time, pruebo a hacer  DATEDIFF

SELECT r.rental_id, DATEDIFF(return_date, rental_date) AS num_dias
FROM rental AS r
WHERE DATEDIFF(return_date, rental_date) > 5;

-- A mi me parece mas bonito asi, sin subconsulta, pero con 2 inner joins porque puedo ver todos los datos 

SELECT f.title, r.rental_id, DATEDIFF(return_date, rental_date) AS num_dias
	FROM film AS f
	INNER JOIN inventory AS i
		ON f.film_id = i.film_id
	INNER JOIN rental AS r 
		ON i.inventory_id = r.inventory_id
		WHERE DATEDIFF(r.return_date, r.rental_date) > 5;
        
-- Query final con subconsulta
SELECT f.title
FROM film AS f
INNER JOIN inventory AS i 
	ON f.film_id = i.film_id
WHERE i.inventory_id IN (
    SELECT r.inventory_id
    FROM rental AS r
    WHERE DATEDIFF(r.return_date, r.rental_date) > 5);
    
    
-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT a.first_name, a.last_name, c.name -- Hare un innerjoin para toda la ruta de modo que pueda tener todos los datos 
    FROM actor AS a
    LEFT JOIN film_actor as fa
		ON a.actor_id = fa.actor_id
    INNER JOIN film as f
		ON fa.film_id =f.film_id
	INNER JOIN film_category as fc
		ON f.film_id = fc.film_id
	INNER JOIN category as c
		ON c.category_id = fc.category_id;
        
-- Ahora la subconsulta
SELECT name FROM category
	WHERE name != 'Horror';

     -- query final con todo
SELECT a.first_name, a.last_name, fc.category_id
FROM actor AS a
INNER JOIN film_actor AS fa 
ON a.actor_id = fa.actor_id
INNER JOIN film AS f 
ON fa.film_id = f.film_id
INNER JOIN film_category AS fc 
ON f.film_id = fc.film_id
WHERE fc.category_id NOT IN 
(SELECT category_id FROM category
	WHERE name = 'Horror');

-- Hecha la subconsulta, me gusta mas la solucion con joins
  
SELECT a.first_name, a.last_name, c.name -- Hare un innerjoin para toda la ruta de modo que pueda tener todos los datos 
    FROM actor AS a
    INNER JOIN film_actor as fa
		ON a.actor_id = fa.actor_id
    INNER JOIN film as f
		ON fa.film_id =f.film_id
	INNER JOIN film_category as fc
		ON f.film_id = fc.film_id
	INNER JOIN category as c
		ON c.category_id = fc.category_id
        WHERE c.name != 'Horror';
        
-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

	SELECT f.title, c.name, f.length
    FROM film AS f
	INNER JOIN film_category as fc
		ON f.film_id = fc.film_id
	INNER JOIN category as c
		ON c.category_id = fc.category_id
	WHERE c.name  = "Comedy" AND f.length > 180;
    
    -- 25.Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.	


