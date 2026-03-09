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
-- Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT first_name AS Nombre, last_name AS Apellido


		FROM actor
        WHERE last_name = "Gibson";
