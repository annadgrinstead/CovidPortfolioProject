SELECT * FROM covid_project.covidvaccinations;


-- Joining deaths and vaccinations


SELECT * FROM covid_project.coviddeaths dea
JOIN covid_project.covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date;
    
    
-- Looking at total population vs total vaccination rate


SELECT dea.continent, dea.location, dea.date, dea.population, vac.people_fully_vaccinated,
(vac.people_fully_vaccinated/dea.population)*100 AS 'Vaccination Rate Percentage'
FROM covid_project.coviddeaths dea
JOIN covid_project.covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent <> ''
    AND dea.location <> 'international'
	AND dea.location <> 'world'
	AND dea.location <> 'North America';
  
  
-- Creating View for vaccination rate


CREATE VIEW covid_project.VaccinationVSPopulation AS
SELECT dea.location, dea.population, vac.people_fully_vaccinated as 'Highest Vaccination Count', 
		(vac.people_fully_vaccinated)/dea.population*100 AS 'Vaccination Rate Percentage'
FROM covid_project.coviddeaths dea
JOIN covid_project.covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent <> ''
    AND dea.location <> 'international'
	AND dea.location <> 'world'
	AND dea.location <> 'North America'
    AND dea.date LIKE '2022-03-13';


-- Using population to get rolling vaccination total


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS 'Rolling Vaccination Total'
FROM covid_project.coviddeaths dea
JOIN covid_project.covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent <> ''
ORDER BY 2, 3;


-- Using 'Rolling Vaccination Total' in CTE


WITH PopulationVacc (Continent, Location, Date, Population, 
	New_Vaccinations, Rolling_Vaccination_Total)
as
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS 'Rolling Vaccination Total'
FROM covid_project.coviddeaths dea
JOIN covid_project.covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
	WHERE dea.continent <> ''
	-- ORDER BY 2, 3
    )
    
SELECT *, 
(Rolling_Vaccination_Total/Population)*100 AS 'Vaccinated Population Percentage'
FROM PopulationVacc;


-- Using 'Rolling Vaccination Total' in Temp Table


DROP TEMPORARY TABLE IF EXISTS covid_project.PercentPopulationVaccinated;
CREATE TEMPORARY TABLE covid_project.PercentPopulationVaccinated 
(
Continent VARCHAR (50) NULL, Location VARCHAR (50) NOT NULL, Date DATETIME NOT NULL, 
Population INT NOT NULL, Rolling_Vaccination_Total BIGINT NOT NULL
);

INSERT INTO covid_project.PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS 'Rolling Vaccination Total'
FROM covid_project.coviddeaths dea
JOIN covid_project.covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
	WHERE dea.continent <> '';
    
SELECT * FROM covid_project.PercentPopulationVaccinated;




-- Creating Views for visualization 


CREATE VIEW covid_project.RollingVaccinations AS
SELECT dea.continent, dea.location, dea.date, dea.population, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS 'Rolling Vaccination Total'
FROM covid_project.coviddeaths dea
JOIN covid_project.covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
	WHERE dea.continent <> ''
    AND dea.location <> 'international'
	AND dea.location <> 'world'
	AND dea.location <> 'North America';