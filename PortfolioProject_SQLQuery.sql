Select *
From PortfolioProject..CovidDeaths
order by 3,4

--Select *
--From PortfolioProject..CovidVacines
--order by 3,4

--Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1, 2

--Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
Select location, date, total_cases,  total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1, 2

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid

Select location, date, population, total_cases, (total_cases/population) *100 as TotalCasesPerPopulation
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1, 2

--Looking at Countries with Highest Infection Rate compared to population
Select location, population, MAX(total_cases) as HighestInfectionCount,  Max(total_cases/population) *100 as TotalCasesPerPopulation
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by population, location
order by TotalCasesPerPopulation desc

--Showing Countries with Highest Death Count per Population
Select location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT
Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


--Showing Continents with the Highest death count per population
Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc



--GLOBAL NUMBERS

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(cast(New_Cases as int))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where continent is not null
where continent is not null
Group By date
order by 1,2


--Global Numbers grand total
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where continent is not null
where continent is not null
--Group By date
order by 1,2



--Looking at Total Population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--(rollingpeoplevaccinated/population) *100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacines VAC
	On dea.Location = vac.location 
	and dea.Date = vac.date

Where dea.continent is not null
Order by 2,3

--USE CTE
With popvsVac (Continent, location, date, population, New_Vaccinations, rollingpeoplevaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--(rollingpeoplevaccinated/population) *100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacines VAC
	On dea.Location = vac.location 
	and dea.Date = vac.date

Where dea.continent is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
FROm popvsVac

--TEMP Table
DROP Table if exists #PercentPopulationVaccinated2
Create Table #PercentPopulationVaccinated2
(
continent nvarchar(255), 
Location nvarchar(255), 
Date datetime, 
Population numeric, 
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

Insert into PercentPopulationVaccinated2
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--, (RollingPeopleVaccinated/population) *100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacines VAC
	On dea.Location = vac.location 
	and dea.Date = vac.date
--Where dea.continent is not null
--Order by 2,3

Views

Select *, (RollingPeopleVaccinated/Population)*100
FROm #PercentPopulationVaccinated2

--Creating View to store data for later visualization

Create View PercentPopulationVaccinated3 AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--, (RollingPeopleVaccinated/population) *100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacines VAC
	On dea.Location = vac.location 
	and dea.Date = vac.date
Where dea.continent is not null
--Order by 2,3

Create View Test4 as 
Select *
From PortfolioProject..CovidDeaths dea
GO