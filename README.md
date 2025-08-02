# 🍹 Alcohol Consumption and Life Expectancy

Using MySQL to clean and analyse the Alcohol and Life Expectancy dataset.


## Overview
The project explores the relationship between alcohol consumption and life expectancy using MySQL.  
There are two goals:
- to practice data cleaning in MySQL
- to look for patterns between how much alcohol countries and regions consume and how long their people live


## Tools Used
- MySQL for data cleaning and analysis  


## Dataset Information
**Source:** [Alcohol and Life Expectancy (via Kaggle)](https://www.kaggle.com/datasets/thedevastator/relationship-between-alcohol-consumption-and-lif?select=Alcohol+and+Life+Expectancy.twbx)  
**Data Format:** CSV  
**Key Columns:**  
- country, Region, total_litres_of_pure_alcohol  
- beer_servings, wine_servings, spirit_servings  
- Value, Year, Sex  


## Data Cleaning Steps
- Checked for null or empty values on important columns
- Checked for duplicates
- Standardised country names between tables
- Removed unnecessary columns
- Renamed columns for ease of use
- Ensured countries appear only once and have consistent record counts


## Analysis Queries

1. Average life expectancy by country  

SELECT country, ROUND(AVG(`Value`), 1) AS average  
FROM expectancy_clean  
GROUP BY country  
ORDER BY average DESC  
LIMIT 10;  

2. Top 10 countries that consume the most alcohol  

SELECT country, total_litres_of_pure_alcohol  
FROM drinks  
ORDER BY total_litres_of_pure_alcohol DESC  
LIMIT 10;  

3. Consumption of alcohol in the 10 countries with the highest life expectancy  

SELECT DISTINCT e.country, ROUND(AVG(e.Value), 1) AS avg_expectancy,   
d.total_litres_of_pure_alcohol  
FROM drinks d  
JOIN expectancy_clean e ON d.country = e.country  
GROUP BY e.country, d.total_litres_of_pure_alcohol  
ORDER BY avg_expectancy DESC  
LIMIT 10;  

4. Ranking countries over spirits consumed  

SELECT   
RANK() OVER (ORDER BY spirit_servings DESC) AS `rank`,  
country, spirit_servings  
FROM drinks  
ORDER BY spirit_servings DESC  
LIMIT 10;  

5. Do wine-heavy regions live longer?  

SELECT e.Region,   
ROUND(AVG(e.`Value`), 1) AS avg_expec,  
ROUND(AVG(d.wine_servings), 1) AS avg_wine  
FROM expectancy_clean e  
JOIN drinks d  
ON e.country = d.country  
GROUP BY e.Region  
ORDER BY avg_expec DESC, avg_wine;  

6. Which countries have both high alcohol consumption and high life expectancy?  

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


## Key Insights
- Japan has the longest life expectancy, while Belarus consumes the most alcohol
- Andorra stands out as a country with both very high alcohol consumption and high life expectancy
- Regions with higher average wine consumption, like Europe, tend to report longer lifespans — suggesting a potential link
- Countries like France and Australia also show that high alcohol intake doesn't always equate to lower life expectancy, though further variables (e.g., healthcare, diet) would need to be analysed
