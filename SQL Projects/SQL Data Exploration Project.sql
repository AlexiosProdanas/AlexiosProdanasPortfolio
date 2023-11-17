select *
from Portfolio..covid19death
order by 3,4


-- Select Data we are going to use for this project and get more insightsselect *
select location,date, total_cases,new_cases,total_deaths,population
from Portfolio..covid19death
order by 1,2

-- Looking at Total Cases vs Total Deaths to get the death percentage value for all countries

select location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from Portfolio..covid19death
order by 1,2

-- Looking at Total Cases vs Total Deaths to get the death percentage value for Greece
-- Chance of death in case you get infected
select location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from Portfolio..covid19death
where location like 'Greece'
order by 1,2


-- Looking at total cases vs population so we can see the total percentage of infected people by the virus
-- All countries
select location,date, total_cases,population,(total_cases/population)*100 as InfectionPercentage
from Portfolio..covid19death
order by 1,2


-- Looking at total cases vs population so we can see the total percentage of infected people by the virus
-- Country: Greece
select location,date, total_cases,population,(total_cases/population)*100 as InfectionPercentage
from Portfolio..covid19death
where location='Greece'
order by 1,2

--We want to find the country with the highest infection rate

select location,population, max(total_cases) as HighestInfectionCount,max((total_cases/population))*100 as InfectionPercentage
from Portfolio..covid19death
group by location, population
order by InfectionPercentage desc

--We want to find the country with the highest death count per population 
select location, max(cast(total_deaths as int)) as totalDeathCount
from Portfolio..covid19death
group by location
order by totalDeathCount desc


-- We had an issue with the data because it is giving us values such as world and other continents which cannot be considered as countries

select location, max(cast(total_deaths as int)) as TotalDeathCount
from Portfolio..covid19death
where continent is not null
group by location
order by TotalDeathCount desc


-- Want to find total deaths Per Continent

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from Portfolio..covid19death
where continent is not null
group by continent
order by TotalDeathCount desc


-- Looking at a global scale the total number of cases for each date

select date,sum(new_cases) as TotalGlobalCases
from Portfolio..covid19death
where continent is not null
group by date
order by 1,2

-- Looking at a global scale the total percentage of death for each date

select date,sum(new_cases) as TotalGlobalCases,sum(cast(new_deaths as int)) as TotalGlobalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as TotalPercentage
from Portfolio..covid19death
where continent is not null
group by date
order by 1,2

-- Looking at a global scale the total percentage of death in total globally

select sum(new_cases) as TotalGlobalCases,sum(cast(new_deaths as int)) as TotalGlobalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as TotalPercentage
from Portfolio..covid19death
where continent is not null
order by 1,2

--Joins
-- Looking at total polulation that are vaccinated Globally per day

select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
from Portfolio..covid19death dea
join Portfolio..covid19vacc vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

-- Looking at total polulation that are vaccinated Greece per day

select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
from Portfolio..covid19death dea
join Portfolio..covid19vacc vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.location = 'Greece'
order by 1,2,3


-- Calculating Vaccination Count on each date 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date ROWS UNBOUNDED PRECEDING)
 as VaccinationCount
From Portfolio..covid19death dea
Join Portfolio..covid19vacc vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- Calculating Vaccination Count on each date for Greece
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date ROWS UNBOUNDED PRECEDING)
 as VaccinationCount
From Portfolio..covid19death dea
Join Portfolio..covid19vacc vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and dea.location = 'Greece'
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, VaccinationCount)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date ROWS UNBOUNDED PRECEDING)
 as VaccinationCount 
From Portfolio..covid19death dea
Join Portfolio..covid19vacc vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

)
Select *, (VaccinationCount/Population)*100 as VaccPercentage
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
VaccinationCount numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date ROWS UNBOUNDED PRECEDING)
 as VaccinationCount
From Portfolio..covid19death dea
Join Portfolio..covid19vacc vac
	On dea.location = vac.location
	and dea.date = vac.date

Select *, (VaccinationCount/Population)*100 as PercentPopulationVaccinated
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations

Create View VaccinationTable as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date ROWS UNBOUNDED PRECEDING)
 as VaccinationCount 
From Portfolio..covid19death dea
Join Portfolio..covid19vacc vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
