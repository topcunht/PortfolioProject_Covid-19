Select * from PortfolioProject.coviddeaths order by 3,4;

Select * from PortfolioProject.covidvaccinations order by 3,4;

Select Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.coviddeaths
ORDER BY 1,2;

-- Total Cases vs Total Deaths

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercantage
FROM PortfolioProject.coviddeaths
WHERE location like "%turkey%"
ORDER BY 1,2;

-- Total Cases vs Population

SELECT Location, date, total_cases, population, (total_cases/population)*100 AS PopulationEffectedPercentage
FROM PortfolioProject.coviddeaths;
-- WHERE location LIKE "%turkey%";

-- Countries with Highest Rate 

SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) AS PercentInfected
FROM PortfolioProject.coviddeaths
GROUP BY location, population
ORDER BY PercentInfected DESC;


-- Countries with Highest Death count per Pop 

SELECT Location, MAX(CAST(total_deaths as UNSIGNED)) AS TotalDeathCount
FROM PortfolioProject.coviddeaths
WHERE continent NOT LIKE ""
GROUP BY Location
ORDER BY TotalDeathCount DESC;

-- Continent

SELECT continent, MAX(CAST(total_deaths as UNSIGNED)) AS TotalDeathCount
FROM PortfolioProject.coviddeaths
WHERE continent NOT LIKE ""
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Global values

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as Perc
FROM PortfolioProject.coviddeaths
-- WHERE location like "%turkey%"
WHERE continent NOT LIKE "";
-- GROUP BY date;

-- JOIN THE TABLES 
WITH PopvsVac (continent, location, date, population, new_vaccinations, RollPeopleVacc) AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition by dea.location ORDER BY dea.location) as RollPeopleVacc
FROM PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent != "" 
)
SELECT *, (RollPeopleVacc/population)*100
FROM PopvsVac;

DROP TABLE PercentPopVacc;
CREATE TABLE PercentPopVacc
(
continent VARCHAR(25),
location VARCHAR(35),
date VARCHAR(25),
population VARCHAR(25),
new_vaccinations VARCHAR(25),
RollPeopleVacc VARCHAR(25)
);
-- TEMP TABLE
INSERT INTO PercentPopVacc
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition by dea.location ORDER BY dea.location) as RollPeopleVacc
FROM PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent != "" ;

SELECT *, (RollPeopleVacc/population)*100
FROM PercentPopVacc;

-- Creating View to store data for vis

CREATE VIEW PercentPopVaccView as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition by dea.location ORDER BY dea.location) as RollPeopleVacc
FROM PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent != "" ;





