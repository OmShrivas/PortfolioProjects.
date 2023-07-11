
--select * from TEST..CovidVacinations;

select location,date,total_cases,new_cases,total_deaths,population
from TEST..CovidDeaths;



-- looking at total cases vs total death.
--Shows likelihood of dying if you contract covid in your country.

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as percentage_of_Death
from TEST..CovidDeaths
where location like '%states%'
order by 1,2;



--looking at the total cases vs Population.
--Shows what percentage of population got Covid.

select location,date,population,total_cases,(total_cases/population)*100 as population_got_covid
from TEST..CovidDeaths
where location like '%India%'
order by 1,2;



--Looking at country with highest infection rate

select location,population,Max(total_cases) as Highest_Infectioncount,Max(total_cases/population)*100 
as percentage_population_got_covid
from TEST..CovidDeaths
--where location like '%India%'
Group by location,population
order by percentage_population_got_covid desc;


--Showing countries with highest death count per population

select location,max(cast(total_deaths as int)) as total_death_count
from TEST..CovidDeaths
--where location like '%India%'
Group by location
order by total_death_count desc;


--If we do not want to show the null continents

select * from TEST..CovidVacinations
where continent is not null
order by 1,2;



-- which countrie has most death cases

select location,max(cast(total_deaths as int)) as total_death_count
from TEST..CovidDeaths
--where location like '%India%'
where continent is not null
Group by location
order by total_death_count desc;



--let's break down things down by continent

select location,max(cast(total_deaths as int)) as total_death_count
from TEST..CovidDeaths
--where location like '%India%'
where continent is null
Group by location
order by total_death_count desc;



--New cases Per day around the World

select date,sum(new_cases) as new_cases_around_Globe 
from TEST..CovidDeaths
where continent is not null
group by date
order by 1,2;

--New deaths cases per day around the world

select date,sum(cast(new_deaths as int)) as new_death_cases_around_Globe
from TEST..CovidDeaths
where continent is not null
group by date
order by 1,2;



select date,sum(new_cases) as New_cases,sum(cast(new_deaths as int)) as new_death_cases_around_Globe,
sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
from TEST..CovidDeaths
where continent is not null
group by date
order by 1,2;


select sum(new_cases) as New_cases,sum(cast(new_deaths as int)) as new_death_cases_around_Globe,
sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
from TEST..CovidDeaths
where continent is not null
order by 1,2;




--Looking at Total Population vs Total Vacination
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

select D.continent, D.location, D.date, D.population, V.new_vaccinations
from TEST..CovidDeaths as D
Join TEST..CovidVacinations as V
on D.location = V.location and D.date = V.date
where D.continent is not null
order by 1,2,3;



select D.continent, D.location, D.date, D.population, V.new_vaccinations,
sum(convert(int,V.new_vaccinations)) over (partition by D.location order by D.location, D.date) as RollingPeopleVacinated
--,(RollingPeopleVacinated/population)*100
from TEST..CovidDeaths as D
Join TEST..CovidVacinations as V
on D.location = V.location and D.date = V.date
where D.continent is not null
order by 2,3; 


--USE CTE

with PopvsVac (continent,location,date,population,New_Vaccinations,RollingPeopleVacinated)
as
(

select D.continent, D.location, D.date, D.population, V.new_vaccinations,
sum(convert(int,V.new_vaccinations)) over (partition by D.location order by D.location, D.date) as RollingPeopleVacinated
--,(RollingPeopleVacinated/population)*100
from TEST..CovidDeaths as D
Join TEST..CovidVacinations as V
on D.location = V.location and D.date = V.date
where D.continent is not null
--order by 2,3
)

select *, ( RollingPeopleVacinated/population)*100
from PopvsVac



