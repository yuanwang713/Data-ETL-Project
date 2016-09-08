
/* Sample queries about T-SQL analytic function */

1
SELECT calendar_month_number_in_year, SUM(product_price-product_cost) AS profit,
   ROUND(AVG(SUM(product_price-product_cost)) 
    OVER (ORDER BY calendar_month_number_in_year),2) AS moving_profit
   FROM product_dimension AS p
   JOIN inventory_fact AS i ON p.product_key = i.product_key
   JOIN date_dimension AS d ON d.date_key = i.date_key
   GROUP BY calendar_month_number_in_year;
2
SELECT DISTINCT s.store_name  
       , MIN(annual_salary) OVER (PARTITION BY s.store_name) AS MinSalary  
       , MAX(annual_salary) OVER (PARTITION BY s.store_name) AS MaxSalary  
       , round(AVG(annual_salary) OVER (PARTITION BY s.store_name),1) AS AvgSalary  
       ,COUNT(ed.employee_key) OVER (PARTITION BY s.store_name) AS EmployeesPerStore 
FROM store.store_dimension AS s
JOIN store.store_orders_fact as sof 
     ON s.store_key = sof.store_key
JOIN public.employee_dimension AS ed  
     ON sof.employee_key = ed.employee_key 
WHERE s.store_state = 'MA'  
ORDER BY AvgSalary DESC;  
3
SELECT DISTINCT s.product_key, p.product_description 
FROM store.store_sales_fact s, public.product_dimension p 
WHERE s.product_key = p.product_key 
AND s.product_version = p.product_version AND s.store_key IN (
  SELECT store_key 
  FROM store.store_dimension 
  WHERE store_state = 'MA') 
ORDER BY s.product_key;
4
SELECT store_state, round(avg(monthly_rent_cost),2) as state_avg_rent,
RANK() OVER(
  ORDER BY avg(monthly_rent_cost) desc) AS RANK
  FROM store.store_dimension
  GROUP BY store_state;

/* Sample queries about Joins */

5
SELECT title, name FROM movie JOIN casting ON id = movieid 
JOIN actor ON casting.actorid = actor.id 
WHERE movieid IN (SELECT movieid FROM casting
WHERE actorid IN (SELECT id FROM actor
  WHERE name='Julie Andrews')) and ord = 1
6
SELECT distinct name FROM actor 
JOIN casting ON actorid = id WHERE movieid IN 
(SELECT movieid FROM casting WHERE actorid IN 
	(SELECT id FROM actor WHERE name = 'Art Garfunkel')) 
and name != 'Art Garfunkel'
7
SELECT mdate,
       team1,
       SUM(CASE WHEN teamid = team1 THEN 1 ELSE 0 END) AS score1,
       team2,
       SUM(CASE WHEN teamid = team2 THEN 1 ELSE 0 END) AS score2 FROM
    game LEFT JOIN goal ON (id = matchid)
    GROUP BY mdate,team1,team2
    ORDER BY mdate, matchid, team1, team2
8
SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
WHERE name='John Travolta'
GROUP BY yr
HAVING COUNT(title)>2

/* Sample queries about Self Join */

9
SELECT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
where stopa.name = 'Craiglockhart' and stopb.name = 'Tollcross'
10
SELECT stopb.name,b.company, b.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
where stopa.name= 'Craiglockhart'