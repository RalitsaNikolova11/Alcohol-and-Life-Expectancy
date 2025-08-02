-- average life expectancy by country
SELECT country, ROUND(AVG(`Value`), 1) AS average
FROM expectancy_clean
GROUP BY country
ORDER BY average DESC
LIMIT 10;


-- Average life expectancy by region
SELECT Region, ROUND(AVG(`Value`), 1) AS avg_expec
FROM expectancy_clean
GROUP BY Region
ORDER BY avg_expec DESC;


-- top 10 countries that consume most alcohol
SELECT country, total_litres_of_pure_alcohol
FROM drinks
ORDER BY total_litres_of_pure_alcohol DESC
LIMIT 10;


-- consumption of alcohol in the 10 countries with the highest life expectancy
SELECT DISTINCT e.country, ROUND(AVG(e.Value), 1) AS avg_expectancy, 
d.total_litres_of_pure_alcohol
FROM drinks d
JOIN expectancy_clean e ON d.country = e.country
GROUP BY e.country, d.total_litres_of_pure_alcohol
ORDER BY avg_expectancy DESC
LIMIT 10;


-- rank countries over beer consumed
SELECT 
RANK() OVER (ORDER BY beer_servings DESC) AS `rank`,
country, beer_servings
FROM drinks
ORDER BY beer_servings DESC
LIMIT 10;


-- rank countries over spirits consumed
SELECT 
RANK() OVER (ORDER BY spirit_servings DESC) AS `rank`,
country, spirit_servings
FROM drinks
ORDER BY spirit_servings DESC
LIMIT 10;

-- ranking countries over wine consumption
SELECT 
RANK() OVER (ORDER BY wine_servings DESC) AS `rank`,
country, wine_servings
FROM drinks
ORDER BY wine_servings DESC
LIMIT 10;


-- rank countries over total alcohol consumption
SELECT 
RANK() OVER (ORDER BY total_litres_of_pure_alcohol DESC) AS `rank`,
country, total_litres_of_pure_alcohol
FROM drinks
ORDER BY total_litres_of_pure_alcohol DESC
LIMIT 10;


-- Average alcohol consumption by region
SELECT e.Region, ROUND(AVG(d.total_litres_of_pure_alcohol), 2) AS avg_consumption
FROM expectancy_clean e
JOIN drinks d ON e.country = d.country
GROUP BY e.Region
ORDER BY avg_consumption DESC;


-- Do wine-heavy regions live longer?
SELECT e.Region, 
ROUND(AVG(e.`Value`), 1) AS avg_expec,
ROUND(AVG(d.wine_servings), 1) AS avg_wine
FROM expectancy_clean e
JOIN drinks d
ON e.country = d.country
GROUP BY e.Region
ORDER BY avg_expec DESC, avg_wine;


-- which countries have both high alcohol consumption and high expectancy
SELECT 
  d.country, 
  MAX(d.total_litres_of_pure_alcohol) AS alcohol_consumption, 
  ROUND(AVG(e.Value), 1) AS expec
FROM drinks d
JOIN expectancy_clean e ON d.country = e.country
GROUP BY d.country
HAVING expec > 80
ORDER BY alcohol_consumption DESC
LIMIT 10;


-- Which have low alcohol consumption but low life expectancy?
SELECT d.country, d.total_litres_of_pure_alcohol, ROUND(AVG(e.Value), 1) AS expec
FROM drinks d
JOIN expectancy_clean e
ON d.country = e.country
GROUP BY d.country, d.total_litres_of_pure_alcohol
HAVING expec < 55
ORDER BY d.total_litres_of_pure_alcohol ASC
LIMIT 10;