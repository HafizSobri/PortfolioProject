Select *
From CovidDeaths
order by 3,4

--Select *
--From CovidVaccinations
--order by 3,4

-- Select Data that Going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Order by 1,2

--Looking at Total Death Cases vs Total Death
--Use like function to find Malaysia

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
Where location like '%alaysia%'
Order by 1,2

--Looking at Total Cases vs Poulation
--Shows what percentage of population got covid

SELECT Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From CovidDeaths
Where location like '%alaysia%'
Order by 1,2

--Looking at country with highest infection rate compared to population

SELECT Location, MAX(total_cases) AS HighestInfectionCount, population, MAX((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
--Where location like '%States%'
Group by Location, population
Order by PercentPopulationInfected desc

--Showing Countries with hughest Death Count per Population

SELECT Location, MAX(cast(total_deaths as int)) AS TotalDeathCount
From CovidDeaths
--Where location like '%States%'
Where continent is not null
Group by Location
Order by TotalDeathCount desc

--Breaking by Continent

SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
From CovidDeaths
--Where location like '%States%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc


--GLOBAL NUMBER

SELECT sum(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST
(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
--Where location like '%alaysia%'
WHERE continent IS NOT NULL
Order by 1,2

-- Looking at Total Population vs Vaccinations

SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations,
SUM(CONVERT(INT,V.new_vaccinations)) OVER (Partition by D.location order by D.location,
D.Date) as RollingPeopleVaccinated
FROM CovidDeaths AS D
JOIN CovidVaccinations AS V
ON D.location = V.location
and D.date = V.date
where D.continent IS NOT NULL
order by 2,3

-- USE CTE

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations,
SUM(CONVERT(INT,V.new_vaccinations)) OVER (Partition by D.location order by D.location,
D.Date) as RollingPeopleVaccinated
FROM CovidDeaths AS D
JOIN CovidVaccinations AS V
ON D.location = V.location
and D.date = V.date
where D.continent IS NOT NULL
order by 2,3)

Select*, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Temp Table
Drop Table if Exists #PercentPopulationVaccinated
CREATE Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Poulation numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT D.continent, D.location, D.date, D.population, V.new_vaccinations,
SUM(CONVERT(INT,V.new_vaccinations)) OVER (Partition by D.location order by D.location,
D.Date) as RollingPeopleVaccinated
FROM CovidDeaths AS D
JOIN CovidVaccinations AS V
ON D.location = V.location
and D.date = V.date
where D.continent IS NOT NULL
order by 2,3)

Select *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated