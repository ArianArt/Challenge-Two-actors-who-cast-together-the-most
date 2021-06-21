WITH CTE AS
(
  SELECT 
    COUNT(FA1.film_id), FA1.actor_id FA1, FA2.actor_id FA2 
  FROM 
    film_actor AS FA1 INNER JOIN film_actor AS FA2 ON FA1.film_id = FA2.film_id
  WHERE 
    FA1.actor_id <> FA2.actor_id
  GROUP BY FA1.actor_id, FA2.actor_id
), CTE2 AS
(
  SELECT * FROM CTE ORDER BY COUNT DESC LIMIT 1
), CTE3 AS
(
 SELECT 
  FA.Film_id, 
  FA1,
  FA2
  FROM 
    film_actor FA INNER JOIN CTE2 ON (FA.actor_id = FA1 OR FA.actor_id = FA2)
    INNER JOIN film A ON FA.film_id = A.film_id
), CTE4 AS
(
 SELECT C1.* FROM CTE3 C1 INNER JOIN CTE3 C2 ON C1.film_id = C2.film_id
), CTE5 AS
(
SELECT film_id, COUNT(film_id) AS C, fa1, fa2 FROM CTE4  GROUP BY film_id, fa1, fa2
)
 
SELECT 
  (SELECT CONCAT(first_name,' ', last_name) FROM actor WHERE actor_id = fa1) first_actor,
  (SELECT CONCAT(first_name,' ', last_name) FROM actor WHERE actor_id = fa2) second_actor,
  f.title 
FROM 
  CTE5 C INNER JOIN film f ON f.film_id = C.film_id  
WHERE 
  C > 1 
ORDER BY title ASC
