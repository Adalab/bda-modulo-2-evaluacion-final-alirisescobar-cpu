# bda-modulo-2-evaluacion-final-alirisescobar-cpu
bda-modulo-2-evaluacion-final-alirisescobar-cpu created by GitHub Classroom

Análisis de Base de Datos Sakila - SQL Adalab 🚀
Este repositorio contiene la resolución de una serie de retos prácticos sobre la base de datos Sakila, enfocados en consultas complejas, optimización de Joins y análisis de datos relacionales.

Descripción del Proyecto
El objetivo de esta actividad es practicar habilidades avanzadas de SQL utilizando el modelo relacional de una tienda de alquiler de películas (Sakila). Se abordan problemas que van desde agrupamientos básicos hasta Self-Joins y Subconsultas.

1. Relaciones Multitabla (Joins)
Conexión de hasta 5 tablas simultáneas para cruzar información desde los actores hasta las categorías de las películas, aplicando filtros de exclusión (ej. excluir géneros específicos como 'Horror').

```python
SELECT a.first_name, a.last_name, c.name 
    FROM actor AS a
    INNER JOIN film_actor as fa
		ON a.actor_id = fa.actor_id
    INNER JOIN film as f
		ON fa.film_id =f.film_id
	INNER JOIN film_category as fc
		ON f.film_id = fc.film_id
	INNER JOIN category as c
		ON c.category_id = fc.category_id
        WHERE c.name != 'Horror' ``` 

2. Lógica de Fechas
Uso de funciones como DATEDIFF() para calcular periodos de alquiler y detectar retrasos superiores a los 5 días.

```python 
SELECT f.title, r.rental_id, DATEDIFF(return_date, rental_date) AS num_dias
	FROM film AS f
	INNER JOIN inventory AS i
		ON f.film_id = i.film_id
	INNER JOIN rental AS r 
		ON i.inventory_id = r.inventory_id
		WHERE DATEDIFF(r.return_date, r.rental_date) > 5;```


3. Parejas de Actores (Self-Joins) 🎭
Uno de los mayores retos fue identificar qué actores han trabajado juntos en la misma película, evitando duplicados y registros espejo mediante el uso de operadores de desigualdad (<).

``` python
SELECT a1.first_name, a1.last_name, -- Datos Actor 1
	a2.first_name, a2.last_name, 		-- Datos Actor 2
	COUNT(f1.film_id) AS Total_Pelis 
    FROM film_actor AS f1
    INNER JOIN film_actor AS f2
   		ON f1.film_id = f2.film_id
        AND f1.actor_id < f2.actor_id -- 
	INNER JOIN actor AS a1 
		ON f1.actor_id = a1.actor_id
	INNER JOIN actor AS a2
        ON f2.actor_id = a2.actor_id
	GROUP BY a1.actor_id, a2.actor_id;```

🛠️ Herramientas Utilizadas
Lenguaje: SQL (MySQL Dialect)
Base de Datos: Sakila DB
Entorno: MySQL Workbench

Estructura del Repositorio
Promo_65_Evaluacion_Final_Mod_2_Aliris_Escobar.sql/: Contiene los scripts .sql con las soluciones enumeradas.

README.md: Este archivo.

✍️ Autora
Aliris Escobar Reyes- [alirisescobar-cpu / https://www.linkedin.com/in/alirisescobarreyes/]
Estudiante en Adalab Data Analytics "Promo 65"