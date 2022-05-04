

---- Data exploring


select * from CovidDeath 
order by 3,4;


---- Data exploring

select *from Covid_Vaccination
order by 3,4;


-----------------Looking for total Deaths and Cases in Vietnam
-----------------Shows the deathrate if you catch Covid-19 in Customed Countries (e.g., Austria)



select Location, date, total_cases, total_deaths, round(((total_deaths/total_cases)*100),2) as Death_percent , population
from CovidDeath
where Location like'%Austria%'
order by 1,2;


------------------Searching for Total Cases vs Population
------------------Displaying chances that you likely catch Covid in the countries (e.g, Austria) 

select population,total_cases, location,date, round(((total_cases/population)*100),2) as Cases_percent from CovidDeath
where location like'%Austria%'
order by location,date;


------------------Showing Countries with Highest Death count per Population

select continent, max(cast(total_deaths as nvarchar(max))) as TotalDeathCount
from CovidDeath
where continent is not null
group by continent
order by TotalDeathCount desc;



----Global number

select  date,sum(new_cases) as total_Cases,sum(cast( total_deaths as int)) as total_deaths,  sum(cast( total_deaths as int))/sum(new_cases)*100  as DeathRate
from CovidDeath
where continent is not null
group by date
order by 1,2;



-------- Looking at Total Population vs Vaccinations

with PopvsVac(continent, location ,date, population, new_vaccinations, RollinPeopleVaccinated) as
(
select dead.continent, dead.location, dead.date , dead.population, vac.new_vaccinations,
sum( convert (bigint, vac.new_vaccinations)) over ( partition by dead.location order by dead.location,dead.date) as RollinPeopleVaccinated
from CovidDeath dead
join Covid_Vaccination vac
	on dead.location = vac.location
		and dead.date = vac.date
where dead.continent is not null
--order by 2,3
)


select *, (RollinPeopleVaccinated/population)*100 as Roll_per_pop from PopvsVac;






