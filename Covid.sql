-- Looking at total cases VS total death

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeath
WHERE location like 'New Zealand';

-- Looking at the total cases VS population
-- what percentage of population got covid
SELECT location, date, total_cases, population, (total_cases/population)*100 as CovidPercentage
FROM coviddeath
WHERE location like 'New Zealand';

-- Looking at countries with highest infection rate compare to population
SELECT location, population, MAX(total_cases), MAX(total_cases/population)*100 AS PercentagePopulationInfected
FROM coviddeath
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC;



-- Showing countries with higest death rate

SELECT location, MAX(total_deaths) as TotalDeath
FROM coviddeath
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeath DESC;


-- Let's break thing down by continent
SELECT continent, MAX(total_deaths) as TotalDeath
FROM coviddeath
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeath DESC;

-- Global Numbers
SELECT  SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths,SUM(new_deaths)/SUM(new_cases)*100 as Total_DeathPercentage
FROM coviddeath
WHERE continent is not null
;



-- Look at Total Population VS Total vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER(Partition BY dea.location ORDER by dea.location, dea.date) as IncrementalVaccination
FROM PortifolioProject.coviddeath dea 
JOIN PortifolioProject.covidvaccination vac
ON dea.location = vac.location
and dea.date = vac.date;

SELECT *,IncrementalVaccination/population*100 as VaccinationPercentage
FROM(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER(Partition BY dea.location ORDER by dea.location, dea.date) as IncrementalVaccination
FROM PortifolioProject.coviddeath dea 
JOIN PortifolioProject.covidvaccination vac
ON dea.location = vac.location
and dea.date = vac.date) as wwe;

CREATE VIEW PercentPopulationVaccinated as SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER(Partition BY dea.location ORDER by dea.location, dea.date) as IncrementalVaccination
FROM PortifolioProject.coviddeath dea 
JOIN PortifolioProject.covidvaccination vac
ON dea.location = vac.location
and dea.date = vac.date;


