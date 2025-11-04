-- 2. Muestra los nombres de todas las películas con clasificación 'R':
SELECT title, rating
FROM film
WHERE rating = 'R';

-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40:
SELECT first_name, last_name, actor_id 
FROM actor
WHERE actor_id BETWEEN 30 AND 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original:
SELECT title, language_id, original_language_id
FROM film
WHERE language_id = original_language_id;

-- 5. Ordena las películas por duración de forma ascendente:
SELECT title, length
FROM film
ORDER BY length ASC;

-- 6. Encuentra el nombre y apellido de los actores que tengan 'Allen' en su apellido:
SELECT first_name, last_name
FROM actor
WHERE last_name ILIKE '%allen%';

-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento:
SELECT rating, COUNT(*) AS numero_peliculas
FROM film
GROUP BY rating;

--8. Encuentra el título de todas las películas que son ‘PG13ʼ o tienen una duración mayor a 3 horas en la tabla film:
SELECT title, rating, length
FROM film
WHERE rating = 'PG-13' OR length > 180;

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas:
SELECT STDDEV_SAMP(replacement_cost) AS variabilidad_costo_reemplazo
FROM film;

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD:
SELECT
    MAX(length) AS duracion_maxima,
    MIN(length) AS duracion_minima
FROM
    film;

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día:
SELECT amount, payment_date
FROM payment
ORDER BY payment_date DESC -- Ordenamos los resultados de manera descendente, esto es, los primeros son los últimos pagos
LIMIT 1 OFFSET 2; -- Limitamos a 1 resultado, saltando los 2 primeros, devolviendo así el 3er o antepe

-- 12. Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación:
SELECT title, rating
FROM film
WHERE rating <> 'NC-17' AND rating <> 'G';

-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración:
SELECT
    rating,
    AVG(length) AS promedio_duracion
FROM
    film
GROUP BY
    rating   
ORDER BY promedio_duracion DESC; -- Para dejarlo más estético, se ha optado por ordenar cada clasificación de mayor a menor cantidad de minutos

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos:
SELECT 
	title, length
FROM 
	film
WHERE 
	length > 180;

-- 15. ¿Cuánto dinero ha generado en total la empresa?
SELECT 
	SUM(amount) AS ingresos_totales
FROM
	payment;

-- 16. Muestra los 10 clientes con mayor valor de id:
SELECT
	customer_id, first_name, last_name
FROM
	customer
ORDER BY customer_id DESC
LIMIT 10;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
SELECT first_name, last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE film.title ILIKE 'Egg Igby';

-- 18. Selecciona todos los nombres de las películas únicos
SELECT DISTINCT title
FROM film;

-- 19. Encuentra el título de las películas que son comedias y tienen duración > 180 minutos
SELECT title, length
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Comedy'
  AND film.length > 180;

-- 20. Categorías con promedio de duración > 110 minutos
SELECT category.name AS categoria, 
       AVG(film.length) AS duracion_promedio
FROM film 
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
HAVING AVG(film.length) > 110
ORDER BY duracion_promedio DESC;

-- 21. Media de duración del alquiler de las películas:
SELECT (AVG(return_date - rental_date)) AS promedio_rental_duration
FROM rental
WHERE return_date IS NOT NULL; -- Si hay algún alquiler que no ha sido devuelto, lo obvia

-- 22. Crea una columna con el nombre y apellidos de todos los actores:
SELECT actor_id,
       CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM actor;

-- 23. Número de alquileres por día, ordenados por cantidad de alquiler de forma descendente:
SELECT CAST(rental_date AS DATE) AS rental_day, -- Convertimos la fecha de alquiler de formato TIMESTAMP, que incluye la hora, a DATE, que sólo tiene el día 
       COUNT(*) AS num_alquileres
FROM rental
GROUP BY rental_day 
ORDER BY num_alquileres DESC;

-- 24. Encuentra las películas con una duración superior al promedio
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film)
ORDER BY length DESC;

-- 25. Número de alquileres por mes
SELECT TO_CHAR(rental_date,'Month') AS rental_month, -- Extraemos de una fecha el nombre del mes en cuestión
       COUNT(*) AS num_rentals
FROM rental
GROUP BY rental_month
ORDER BY num_rentals; -- Ordenamos los alquileres mensuales por su número

--26. Encuentra el promedio, la desviación estándar y varianza del total pagado:
SELECT
    AVG(amount) AS promedio_pago,
    STDDEV_SAMP(amount) AS desviacion_estandar_pago,
    VAR_SAMP(amount) AS varianza_pago
FROM
    payment;

-- 27. ¿Qué películas se alquilan por encima del precio medio?
SELECT title, rental_rate
FROM film
WHERE rental_rate > (-- Creamos una subconsulta para conseguir el promedio del precio de alquiler
    SELECT AVG(rental_rate)
    FROM film
)
ORDER BY rental_rate ASC;

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas:
SELECT T1.actor_id, COUNT(T2.film_id) AS num_peliculas
FROM actor AS T1
JOIN film_actor AS T2
    ON T1.actor_id = T2.actor_id
GROUP BY T1.actor_id
HAVING COUNT(T2.film_id) > 40;

-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible:
SELECT
    T1.title,
    COUNT(T2.inventory_id) AS cantidad_disponible
FROM
    film AS T1
LEFT JOIN
    inventory AS T2 ON T1.film_id = T2.film_id
    /* LEFT JOIN garantiza que se mantengan todas las filas de la tabla de la izquierda (film),
     * y se les unan las filas de la tabla de la derecha (inventory) si hay una coincidencia.
     * Si no hay coincidencia (es decir, una película no está en el inventario), las columnas
     * de la tabla inventory serán NULL.
     */
GROUP BY
    T1.film_id, T1.title
ORDER BY
    T1.title;

-- 30. Obtener los actores y el número de películas en las que ha actuado:
SELECT first_name, last_name, count(t2.film_id) AS num_peliculas
FROM actor AS t1
JOIN film_actor AS t2 ON t1.actor_id = t2.actor_id
GROUP BY t1.actor_id;

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores
asociados:
SELECT
T1.title,
T3.first_name,
T3.last_name
FROM
	film AS T1
LEFT JOIN
	film_actor AS T2 ON T1.film_id = T2.film_id
LEFT JOIN
	actor AS T3 ON T2.actor_id = T3.actor_id
ORDER BY
	T1.title;


-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
SELECT
	T1.first_name,
	T1.last_name,
	T3.title
FROM
	actor AS T1
LEFT JOIN
	film_actor AS T2 ON T1.actor_id = T2.actor_id
LEFT JOIN
	film AS T3 ON T2.film_id = T3.film_id
ORDER BY
	T1.first_name, T1.last_name;

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler:
SELECT
    T1.title,
    T3.rental_id
FROM
    film AS T1
FULL OUTER JOIN
    inventory AS T2 ON T1.film_id = T2.film_id
FULL OUTER JOIN
    rental AS T3 ON T2.inventory_id = T3.inventory_id
ORDER BY
    T1.title, T3.rental_id;

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros:
SELECT
    T1.first_name,
    T1.last_name,
    SUM(T2.amount) AS total_gastado
FROM
    customer AS T1
JOIN
    payment AS T2 ON T1.customer_id = T2.customer_id
GROUP BY
    T1.customer_id,
    T1.first_name,
    T1.last_name
ORDER BY
    total_gastado DESC
LIMIT 5;

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny:
SELECT first_name, last_name
FROM actor
WHERE actor.first_name ILIKE 'Johnny';

-- 36. Renombra la columna "first_name" como Nombre y "last_name" como Apellido:
SELECT
    first_name AS Nombre,
    last_name AS Apellido
FROM
    actor;

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor:
SELECT
    MIN(actor_id) AS ID_mas_bajo,
    MAX(actor_id) AS ID_mas_alto
FROM
    actor;

-- 38. Cuenta cuántos actores hay en la tabla "actor":
SELECT 
	COUNT(*) AS total_actores
FROM
	actor;

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente:
SELECT first_name, last_name
FROM actor
ORDER BY last_name ASC;

-- 40. Selecciona las primeras 5 películas de la tabla "film":
SELECT title
FROM film
LIMIT 5;

-- 41. Agrupa los actores por su nombre, y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?:
SELECT
    first_name,
    COUNT(*) AS veces_repetido
FROM
    actor
GROUP BY
    first_name
ORDER BY
    veces_repetido DESC
LIMIT 1;

--42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron:
SELECT
    T1.rental_id,
    T2.first_name,
    T2.last_name
FROM
    rental AS T1
JOIN
    customer AS T2 ON T1.customer_id = T2.customer_id
ORDER BY
    T1.rental_id; 

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres:
SELECT
    T1.customer_id,
    T1.first_name,
    T1.last_name,
    T2.rental_id
FROM
    customer AS T1
LEFT JOIN
    rental AS T2 ON T1.customer_id = T2.customer_id
ORDER BY
    T1.customer_id, T2.rental_id;

-- 44. Realiza un CROSS JOIN entre las tablas film y category:
-- ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación

SELECT
    T1.title,
    T2.name AS category_name
FROM
    film AS T1
CROSS JOIN
    category AS T2;

/* Generalmente, NO aporta valor para propósitos de análisis y lógica de negocio.
El CROSS JOIN crea combinaciones que son lógicamente incorrectas en el contexto de
la base de datos. Por ejemplo, la película "ACE GOLDFINGER" se combinará con la 
categoría "Action", lo cual puede ser correcto, pero también se combinará con "Sports",
"Music" o "Horror", incluso si la película no pertenece a esas categorías.*/

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action':
SELECT DISTINCT
    T1.first_name,
    T1.last_name
FROM
    actor AS T1
JOIN
    film_actor AS T2 ON T1.actor_id = T2.actor_id
JOIN
    film_category AS T3 ON T2.film_id = T3.film_id
JOIN
    category AS T4 ON T3.category_id = T4.category_id
WHERE
    T4.name = 'Action'
ORDER BY
    T1.last_name;

-- 46. Encuentra todos los actores que no han participado en películas:
SELECT
    T1.first_name,
    T1.last_name
FROM
    actor AS T1
LEFT JOIN
    film_actor AS T2 ON T1.actor_id = T2.actor_id
WHERE
    T2.film_id IS NULL;

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado:
SELECT
    T1.first_name,
    T1.last_name,
    COUNT(T2.film_id) AS numero_peliculas
FROM
    actor AS T1
JOIN
    film_actor AS T2 ON T1.actor_id = T2.actor_id
GROUP BY
    T1.actor_id,
    T1.first_name,
    T1.last_name
ORDER BY
    T1.last_name;

-- 48. Crea una vista llamada "actor_num_peliculas" que muestre los nombres de los actores y 
-- el número de películas en las que han participado:
CREATE VIEW actor_num_peliculas AS
SELECT
    T1.first_name,
    T1.last_name,
    COUNT(T2.film_id) AS numero_peliculas
FROM
    actor AS T1
JOIN
    film_actor AS T2 ON T1.actor_id = T2.actor_id
GROUP BY
    T1.actor_id,
    T1.first_name,
    T1.last_name;

-- 49. Calcula el número total de alquileres realizados por cada cliente:
SELECT
    T1.first_name,
    T1.last_name,
    COUNT(T2.rental_id) AS total_alquileres
FROM
    customer AS T1
JOIN
    rental AS T2 ON T1.customer_id = T2.customer_id
GROUP BY
    T1.customer_id,
    T1.first_name,
    T1.last_name
ORDER BY
    total_alquileres DESC;

-- 50. Calcula la duración total de las películas en la categoría 'Action':
SELECT
    SUM(T1.length) AS duracion_total_action
FROM
    film AS T1
JOIN
    film_category AS T2 ON T1.film_id = T2.film_id
JOIN
    category AS T3 ON T2.category_id = T3.category_id
WHERE
    T3.name = 'Action';

-- 51. Crea una tabla temporal llamada "cliente_rentas_temporal" para almacenar el total de alquileres por cliente:
CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT
    customer_id,
    COUNT(rental_id) AS total_alquileres
FROM
    rental
GROUP BY
    customer_id;

-- 52. Crea una tabla temporal llamada "peliculas_alquiladas" que almacene las películas que han sido alquiladas al menos 10 veces.
CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT
    T1.film_id,
    T1.title,
    COUNT(T3.rental_id) AS veces_alquilada
FROM
    film AS T1
JOIN
    inventory AS T2 ON T1.film_id = T2.film_id
JOIN
    rental AS T3 ON T2.inventory_id = T3.inventory_id
GROUP BY
    T1.film_id, T1.title
HAVING
    COUNT(T3.rental_id) >= 10;

-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre 'Tammy Sanders' 
-- y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
SELECT
    T4.title
FROM
    customer AS T1
JOIN
    rental AS T2 ON T1.customer_id = T2.customer_id
JOIN
    inventory AS T3 ON T2.inventory_id = T3.inventory_id
JOIN
    film AS T4 ON T3.film_id = T4.film_id
WHERE
    T1.first_name = 'TAMMY'
    AND T1.last_name = 'SANDERS'
    AND T2.return_date IS NULL
ORDER BY
    T4.title ASC;

-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría 'Sci-Fi'. 
-- Ordena los resultados alfabéticamente por apellido:
SELECT DISTINCT
    T1.first_name,
    T1.last_name
FROM
    actor AS T1
JOIN
    film_actor AS T2 ON T1.actor_id = T2.actor_id
JOIN
    film_category AS T3 ON T2.film_id = T3.film_id
JOIN
    category AS T4 ON T3.category_id = T4.category_id
WHERE
    T4.name = 'Sci-Fi'
ORDER BY
    T1.last_name ASC;

-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que 
-- la película 'Spartacus Cheaper' se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido:
SELECT DISTINCT
    T1.first_name,
    T1.last_name
FROM
    actor AS T1
JOIN
    film_actor AS T2 ON T1.actor_id = T2.actor_id
JOIN
    inventory AS T3 ON T2.film_id = T3.film_id
JOIN
    rental AS T4 ON T3.inventory_id = T4.inventory_id
WHERE
    T4.rental_date > (
        SELECT
            MIN(T3_sub.rental_date)
        FROM
            film AS T1_sub
        JOIN
            inventory AS T2_sub ON T1_sub.film_id = T2_sub.film_id
        JOIN
            rental AS T3_sub ON T2_sub.inventory_id = T3_sub.inventory_id
        WHERE
            T1_sub.title = 'SPARTACUS CHEAPER'
    )
ORDER BY
    T1.last_name ASC;

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría 'Music':
SELECT
    first_name,
    last_name
FROM
    actor
WHERE
    actor_id NOT IN (
        SELECT
            T1.actor_id
        FROM
            film_actor AS T1
        JOIN
            film_category AS T2 ON T1.film_id = T2.film_id
        JOIN
            category AS T3 ON T2.category_id = T3.category_id
        WHERE
            T3.name = 'Music'
    );

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
SELECT DISTINCT
    T1.title
FROM
    film AS T1
JOIN
    inventory AS T2 ON T1.film_id = T2.film_id
JOIN
    rental AS T3 ON T2.inventory_id = T3.inventory_id
WHERE
    T3.return_date IS NOT NULL -- Se obvian aquellas peliculas que no han sido devueltas
    AND (T3.return_date - T3.rental_date) > INTERVAL '8 days' -- y que tengan más de 8 días entre la fecha de alquiler y de devolución
ORDER BY T1.title;

-- 58. Encuentra el título de todas las películas que son de la misma categoría que 'Animation'.
SELECT
    T1.title
FROM
    film AS T1
JOIN
    film_category AS T2 ON T1.film_id = T2.film_id
JOIN
    category AS T3 ON T2.category_id = T3.category_id
WHERE
    T3.name = 'Animation';

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título 'Dancing Fever'.
-- Ordena los resultados alfabéticamente por título de película.
SELECT
    title
FROM
    film
WHERE
    length = (
        SELECT
            length
        FROM
            film
        WHERE
            title = 'DANCING FEVER'
    )
ORDER BY
    title ASC;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas.
-- Ordena los resultados alfabéticamente por apellido:
SELECT
    T1.first_name,
    T1.last_name
FROM
    customer AS T1
JOIN
    rental AS T2 ON T1.customer_id = T2.customer_id
JOIN
    inventory AS T3 ON T2.inventory_id = T3.inventory_id
GROUP BY
    T1.customer_id, T1.first_name, T1.last_name
HAVING
    COUNT(DISTINCT T3.film_id) >= 7 -- Contamos el número de iDs de películas diferentes que sean mayor que 7
ORDER BY
    T1.last_name ASC;

-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto 
-- con el recuento de alquileres:
SELECT
    T1.name AS nombre_categoria,
    COUNT(T4.rental_id) AS total_alquileres
FROM
    category AS T1
JOIN
    film_category AS T2 ON T1.category_id = T2.category_id
JOIN
    inventory AS T3 ON T2.film_id = T3.film_id
JOIN
    rental AS T4 ON T3.inventory_id = T4.inventory_id
GROUP BY
    T1.name
ORDER BY
    total_alquileres DESC;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
SELECT
    T1.name AS nombre_categoria,
    COUNT(T3.film_id) AS num_peliculas_2006
FROM
    category AS T1
JOIN
    film_category AS T2 ON T1.category_id = T2.category_id
JOIN
    film AS T3 ON T2.film_id = T3.film_id
WHERE
    T3.release_year = 2006
GROUP BY
    T1.name
ORDER BY
    num_peliculas_2006 DESC;

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos:
SELECT
    T1.first_name AS nombre_empleado,
    T1.last_name AS apellido_empleado,
    T2.store_id AS id_tienda
FROM
    staff AS T1
CROSS JOIN
    store AS T2;

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente,
-- su nombre y apellido junto con la cantidad de películas alquiladas:
SELECT
    T1.customer_id AS ID_Cliente,
    T1.first_name AS Nombre,
    T1.last_name AS Apellido,
    COUNT(T2.rental_id) AS cantidad_alquileres
FROM
    customer AS T1
LEFT JOIN
    rental AS T2 ON T1.customer_id = T2.customer_id
GROUP BY
    T1.customer_id, T1.first_name, T1.last_name
ORDER BY
    cantidad_alquileres DESC;