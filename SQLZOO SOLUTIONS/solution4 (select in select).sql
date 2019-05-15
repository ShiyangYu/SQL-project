/*
SQLZOO chapter4: SELECT in SELECT
*/
/*
1.List each country name WHERE the population is larger than that of 'Russia'. 
*/

SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Romania');
/*
2.Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
*/
SELECT name
FROM world
WHERE continent='Europe'
AND gdp/population>(
      SELECT gdp/population  FROM world
		WHERE name = 'United Kingdom');
      
/*
3.List the name AND continent of countries in the continents 
cONtaining either Argentina or Australia. Order by name of the country.
*/
SELECT name, continent 
FROM world
WHERE continent in (
	SELECT continent FROM world 
		WHERE name in ('Argentina' ,'Australia'))
order by name;

/*      
4.Which country has a population that is more than Canada but less than PolAND? 
Show the name AND the population.
*/
SELECT name ,population FROM world
WHERE population > (
	SELECT population FROM world 
		WHERE name = 'Canada') 
AND population < (
	SELECT population FROM world 
		WHERE name = 'PolAND') ;

/*      
5.Show the name AND the population of each country in Europe. 
Show the population as a percentage of the population of Germany.   
*/ 
SELECT name, cONcat(round(100*population/(
	SELECT population FROM world 
		WHERE name = 'Germany'),0),'%')
FROM world
WHERE continent = 'Europe';

/*
6.Which countries have a GDP greater than every country in Europe? [Give the name ONly.] 
(Some countries may have NULL gdp values) 
*/
SELECT name FROM world
WHERE gdp  > (
	SELECT max(gdp) FROM world 
		WHERE continent='Europe');
 
 /*
7.Find the largest country (by area) in each continent, show the continent, 
the name AND the area: 
*/
SELECT A.continent,A.name, A.area FROM world as A join(
	SELECT continent,max(area) as maxarea
		FROM world
			GROUP BY continent) as B
ON A.area=B.maxarea AND A.continent = B.continent;

/*
8.List each continent AND the name of the country that comes first alphabetically.
*/
SELECT continent,min(name) as name
FROM world
GROUP BY continent;

/*
9.Find the continents WHERE all countries have a population <= 25000000. 
Then find the names of the countries associated with these continents. 
Show name, continent AND population. 
*/
SELECT name,continent,population
FROM world
WHERE continent in
(SELECT continent
	FROM world
		GROUP BY continent
			having max(population)<=25000000);

/*10.Some countries have populations more than three times that of any of their neighbours 
(in the same continent). Give the countries AND continents.
*/
SELECT name,continent FROM world as A
WHERE population>all(SELECT population*3 FROM world as B
                         WHERE A.continent = B.continent
                          AND population>0
                            AND A.name!=B.name);

 