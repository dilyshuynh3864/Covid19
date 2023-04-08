select * from CovidDeaths
select * from CovidVaccinations

--Select data that we are going to use 

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths

select location, date, total_cases, total_deaths, 
        round((total_deaths/total_cases) *100,2) as Death_Percentage
from CovidDeaths
-- where location like '%States%'
order by 1,2 

-- Looking at Total Cases vs Population 
-- Shows what percentage of population get Covid

select location, date, population, total_cases, 
        round((total_cases/population)*100,2) as Death_Percentage
from CovidDeaths
-- where location like '%States%' 

-- Looking at Countries with Highest Infection Rate compared to Population 

select location, 
        population,
        MAX((total_cases/population)*100) as percent_infection, 
        MAX(total_cases) as Highest_Infection_count
from CovidDeaths
group by location, population
order by percent_infection DESC 

-- Looking at the countries with highest death count per population 

select location, population,
         max(total_deaths) as Total_Death_count 
from CovidDeaths
where continent is not null 
group by location, population
order by Total_Death_count DESC 

-- Showing the total death per continent

select continent, sum(total_deaths) as Total_Death
from CovidDeaths
where continent is not null 
group by continent
order by Total_Death DESC

-- GLOBAL NUMBERS 

select SUM(new_cases) as Number_of_Cases, 
        SUM(cast(new_deaths as bigint)) as Number_of_Deaths, 
        round(SUM(cast(new_deaths as bigint))/SUM(new_cases)*100, 2) as Percentage_of_Death
from CovidDeaths
where continent is not null
-- group by date
order by 1,2

-- Looking at Total Population vs Vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
        sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated
from CovidDeaths dea 
join CovidVaccinations vac
on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 2,3 

-- Creating View to store data for later visualization 

CREATE VIEW Percent_Population_Vaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
        sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated
from CovidDeaths dea 
join CovidVaccinations vac
on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null  

select * 
from Percent_Population_Vaccinated 








