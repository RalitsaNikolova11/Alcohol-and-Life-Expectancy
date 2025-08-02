-- standardising column names where tables would be joined on
ALTER TABLE expectancy
RENAME COLUMN CountryDisplay TO country;


-- removing unnecessary columns
ALTER TABLE drinks
DROP COLUMN `index`;

ALTER TABLE expectancy
DROP COLUMN `index`;

ALTER TABLE expectancy
DROP COLUMN PublishStateCode;

ALTER TABLE expectancy
DROP COLUMN YearCode;

ALTER TABLE expectancy
DROP COLUMN RegionCode;

ALTER TABLE expectancy
DROP COLUMN WorldBankIncomeGroupGroupCode;

ALTER TABLE expectancy
DROP COLUMN GhoCode;

ALTER TABLE expectancy
DROP COLUMN CountryCode;

ALTER TABLE expectancy
DROP COLUMN SexCode;


-- renaming columns for ease of use
ALTER TABLE expectancy
RENAME COLUMN YearDisplay TO `Year`;

ALTER TABLE expectancy
RENAME COLUMN RegionDisplay TO Region;

ALTER TABLE expectancy
RENAME COLUMN SexDisplay TO Sex;

ALTER TABLE expectancy
RENAME COLUMN DisplayValue TO `Value`;


-- fixing country name inconsistencies
UPDATE expectancy
SET country = 'Bolivia'
WHERE country LIKE '%Bolivia%';

UPDATE expectancy
SET country = 'Cote d''Ivoire'
WHERE country LIKE '%Ivoire%';

UPDATE expectancy
SET country = 'Congo'
WHERE country LIKE '%Congo%';

UPDATE expectancy
SET country = 'North Korea'
WHERE country LIKE '%Democratic People''s Republic of Korea%';

UPDATE expectancy
SET country = 'Iran'
WHERE country LIKE '%Iran%';

UPDATE expectancy
SET country = 'Laos'
WHERE country LIKE '%Lao%';

UPDATE expectancy
SET country = 'Micronesia'
WHERE country LIKE '%Micronesia%';

UPDATE expectancy
SET country = 'South Korea'
WHERE country LIKE '%Republic of Korea%';

UPDATE expectancy
SET country = 'Moldova'
WHERE country LIKE '%Moldova%';

UPDATE expectancy
SET country = 'Syria'
WHERE country LIKE '%Syria%';

UPDATE expectancy
SET country = 'North Macedonia'
WHERE country LIKE '%Macedonia%';

UPDATE expectancy
SET country = 'Tanzania'
WHERE country LIKE '%Tanzania%';

UPDATE expectancy
SET country = 'Venezuela'
WHERE country LIKE '%Venezuela%';

UPDATE expectancy
SET country = 'Vietnam'
WHERE country LIKE '%Viet%';


-- checking for null values
SELECT *
FROM expectancy
WHERE country IS NULL
OR `Year` IS NULL
OR `Value` IS NULL
OR Sex IS NULL
OR Region IS NULL;

SELECT *
FROM drinks
WHERE country IS NULL;


-- checking for duplicates
SELECT country,
  COUNT(*) AS count
FROM drinks
GROUP BY country
HAVING COUNT(*) > 1;

SELECT `Year`, 
Region,
IncomeGroup,
country,
Sex, 
`Value`,
COUNT(*) AS count
FROM expectancy
GROUP BY `Year`, 
Region,
IncomeGroup,
country,
Sex, 
`Value`
HAVING COUNT(*) > 1;


-- fixing country name inconsistencies between the 2 tables
UPDATE drinks
SET country = REPLACE(country, 'St.', 'Saint')
WHERE country LIKE '%St.%';

UPDATE drinks
SET country = REPLACE(country, '&', 'and')
WHERE country LIKE '%&%';

UPDATE drinks
SET country = 'Bosnia and Herzegovina'
WHERE country LIKE '%Bosnia%';

UPDATE drinks
SET country = 'United States of America'
WHERE country LIKE '%USA%';

UPDATE expectancy
SET country = 'United Kingdom'
WHERE country LIKE '%United Kingdom%';


-- creating a clean table to have consistency in values across all countries
CREATE TABLE expectancy_clean AS
SELECT
  country,
  Region,
  `Year`,
  Sex,
  GhoDisplay,
 ROUND(AVG(`Value`), 0) AS `Value`
FROM expectancy
WHERE GhoDisplay = 'Life expectancy at birth (years)'
GROUP BY country, Region, `Year`, Sex, GhoDisplay;


ALTER TABLE expectancy_clean
RENAME COLUMN GhoDisplay TO Gho;


UPDATE expectancy_clean
SET Region = 'South East Asia'
WHERE Region LIKE '%South%';