SELECT * FROM covid_project.coviddeaths;


-- Main data to work with


SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM covid_project.coviddeaths
ORDER BY 1, 2;


-- Looking at total cases vs total deaths 


SELECT 
	location, date, total_cases, total_deaths, 
	(total_deaths/total_cases)*100 AS 'Death Percentage'
FROM covid_project.coviddeaths
WHERE continent <> ''
-- AND date LIKE '2022-03%'
ORDER BY 1, 2;


-- Looking at total cases vs population


SELECT 
	location, date, population, total_cases,
	(total_cases/population)*100 AS 'Infection Rate Percentage'
FROM covid_project.coviddeaths
WHERE continent <> ''
ORDER BY 1, 2;


-- Looking at countries w/ highest infection rate per population


SELECT 
	location, population, MAX(total_cases) as 'Highest Infection Count',
    MAX(total_cases/population)*100 as 'Highest Infection Rate Percentage'
FROM covid_project.coviddeaths
WHERE continent <> ''
GROUP BY location, population
ORDER BY 4 DESC;


-- Looking at countries w/ highest death count per population


SELECT 
	location, MAX(CAST(total_deaths AS UNSIGNED)) as 'Total Death Count'
FROM covid_project.coviddeaths
WHERE continent <> ''
GROUP BY location
ORDER BY 2 DESC;


-- Continental breakdown of highest death count


SELECT 
	location, MAX(CAST(total_deaths AS UNSIGNED)) as 'Total Death Count'
FROM covid_project.coviddeaths
WHERE continent = ''
AND location NOT LIKE '%income%'
GROUP BY location
ORDER BY 2 DESC;


-- Global numbers


SELECT 
	date, SUM(new_cases) AS 'Total Global Cases', 
    SUM(new_deaths) AS 'Total Global Deaths',
    (SUM(new_deaths)/SUM(new_cases))*100 AS 'Global Death Percentage'
FROM covid_project.coviddeaths
WHERE continent = ''
AND location NOT LIKE '%income%'
GROUP BY date;




-- Creating Views for visualization 


CREATE VIEW covid_project.CasesVSDeaths AS
SELECT 
	location, date, total_cases, total_deaths, 
	(total_deaths/total_cases)*100 AS 'Death Percentage'
FROM covid_project.coviddeaths
WHERE continent <> ''
-- AND date LIKE '2022-03%'
ORDER BY 1, 2;


CREATE VIEW covid_project.CasesVSPopulation AS
SELECT 
	location, date, population, total_cases,
	(total_cases/population)*100 AS 'Infection Rate Percentage'
FROM covid_project.coviddeaths
WHERE continent <> ''
AND location <> 'international'
AND location <> 'world'
AND location <> 'North America'
ORDER BY 1, 2;


CREATE VIEW covid_project.HighestInfection AS
SELECT 
	location, population, MAX(total_cases) as 'Highest Infection Count',
    MAX(total_cases/population)*100 AS 'Highest Infection Rate Percentage'
FROM covid_project.coviddeaths
WHERE continent <> ''
AND location <> 'international'
AND location <> 'world'
AND location <> 'North America'
GROUP BY location, population
ORDER BY 4 DESC;


CREATE VIEW covid_project.HighestDeath AS
SELECT 
	location, MAX(CAST(total_deaths AS UNSIGNED)) as 'Total Death Count'
FROM covid_project.coviddeaths
WHERE continent <> ''
AND location <> 'international'
AND location <> 'world'
AND location <> 'North America'
GROUP BY location
ORDER BY 2 DESC;


CREATE VIEW covid_project.GlobalNumbers AS
SELECT 
	date, SUM(new_cases) AS 'Total Global Cases', 
    SUM(new_deaths) AS 'Total Global Deaths',
    (SUM(new_deaths)/SUM(new_cases))*100 AS 'Global Death Percentage'
FROM covid_project.coviddeaths
WHERE continent = ''
AND location NOT LIKE '%income%'
AND location <> 'international'
AND location <> 'world'
AND location <> 'North America'
GROUP BY date;


CREATE VIEW covid_project.MaxGlobalNumbers AS
SELECT 
	SUM(new_cases) AS 'Total Global Cases', 
    SUM(new_deaths) AS 'Total Global Deaths',
    (SUM(new_deaths)/SUM(new_cases))*100 AS 'Global Death Percentage'
FROM covid_project.coviddeaths
WHERE continent = ''
AND location NOT LIKE '%income%'
AND location <> 'international'
AND location <> 'world'
AND location <> 'North America'
ORDER BY 1, 2;


SELECT DISTINCT location FROM covid_project.coviddeaths
WHERE continent <> ''
AND location NOT LIKE '%income%'
AND location <> 'international'
AND location <> 'world'
AND location <> 'North America';