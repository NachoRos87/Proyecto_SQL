# Proyecto_SQL
Este es un repositorio que incluye la primera entrega del máster en Data Science de The Power, referido a SQL.

Descripción del proyecto:
Este proyecto consiste en el análisis de una base de datos relacional proporcionada como parte del curso del master de Data Science.
El objetivo es practicar y demostrar habilidades en consultas SQL, manejo de relaciones entre tablas, uso de funciones agregadas, subconsultas, vistas y creación de tablas temporales.
El dataset simula un sistema de alquiler de películas, con tablas como film, actor, rental, customer, inventory, category, entre otras.

Pasos seguidos durante el proyecto:
1.	Creación de la base de datos
  o	Se creó una base de datos en PostgreSQL desde DBeaver con el nombre bbdd_proyecto.
  o	Se importó el script BBDD_Proyecto.sql que contiene la estructura y datos iniciales.
2.	Exploración inicial
  o	Se analizó la estructura y las relaciones entre tablas mediante el diagrama ER (o Entidad-Relación).
  o	Se revisó la información básica de las tablas (film, actor, rental, customer, category, etc.) para entender su propósito y las claves primarias/foráneas.
3.	Ejecución de consultas
  o	Se elaboraron 63 consultas que abarcan:
    	Selecciones básicas (SELECT, WHERE, ORDER BY, LIMIT)
    	Agregaciones (COUNT, AVG, SUM, MAX, MIN)
    	Agrupamientos (GROUP BY, HAVING)
    	Combinaciones de tablas (INNER JOIN, LEFT JOIN, RIGHT JOIN, CROSS JOIN)
    	Subconsultas y creación de vistas y tablas temporales.
  o	Cada consulta fue analizada para comprobar que el resultado tuviera sentido.
4.	Buenas prácticas
  o	Todas las consultas se documentaron con comentarios que incluyen su número y enunciado.
  o	Se cuidó la legibilidad del código (indentación, alias claros, comentarios explicativos).

 Estructura del repositorio:
📁 Proyecto_SQL
 	📄 README.md
 	📄 BBDD_Proyecto.sql
 	📄 queries.sql
 	🖼️ ER_diagram.png

  •	README.md → Explicación del proyecto y pasos seguidos.
  •	BBDD_Proyecto.sql → Script de la base de datos original.
  •	queries.sql → Todas las consultas realizadas con comentarios.
  •	ER_diagram.png → Diagrama o esquema de la base de datos (exportado desde DBeaver).

Análisis y conclusiones
•	Se comprobó la correcta comprensión de las relaciones entre entidades (clientes, películas, actores, alquileres).
•	Las consultas complejas (subconsultas, joins múltiples, y creación de vistas) ayudaron a reforzar la lógica SQL.
•	El uso de funciones como DATE_TRUNC, EXTRACT, AGE, o INTERVAL permitió resolver ejercicios temporales con mayor precisión.
•	En general, la base de datos muestra una estructura bien normalizada y adecuada para ejercicios de análisis y práctica SQL.

Tecnologías utilizadas:
•	PostgreSQL
•	DBeaver 25.2.1
•	GitHub (para control de versiones y entrega del proyecto)




Proyecto realizado por José Ignacio Ros
nachoros87@gmail.com
Máster en Data Science — The Power

