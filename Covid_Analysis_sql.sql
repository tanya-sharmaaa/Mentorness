use COVID_ANALYSIS;
1. select * 
   from dbo.[Corona Virus Dataset] 
   where province is null 
   or Country_Region is null 
   or latitude is null 
   or longitude is null 
   or date is null 
   or confirmed is null 
   or deaths is null 
   or recovered is null;
2. select isnull(province,0)as province,isnull(Country_Region,0)as Country_Region,
          isnull(Latitude,0)as Latitude,isnull(Longitude,0)as Longitude,
		  isnull(Date,0)as Date, isnull(Confirmed,0)as Confirmed,
		  isnull(Deaths,0)as Deaths,isnull(Recovered,0)as Recovered 
		  from dbo.[Corona Virus Dataset];
3. select count(*) as No_Of_Rows 
   from dbo.[Corona Virus Dataset];
4. alter table [Corona Virus Dataset] add Dates DATE;
   update [Corona Virus Dataset] set Dates = try_convert(date,date,103);
   alter table [Corona Virus Dataset] drop column date;
   exec sp_rename '[Corona Virus Dataset].date','Date','COLUMN';
   select min(Date) as start_date, max(Date) as end_date 
   from [Corona Virus Dataset];
5. select count(distinct month(date)) as No_Of_Months 
   from [Corona Virus Dataset];
6. alter table [Corona Virus Dataset] alter column	Confirmed float;
   alter table [Corona Virus Dataset] alter column	Deaths float;
   alter table [Corona Virus Dataset] alter column	Recovered int;
   select round(avg(confirmed),0) as monthly_avg_confirmed_cases,
          round(avg(deaths),0) as monthly_avg_deaths,avg(recovered) as monthly_avg_recovered_cases 
		  from [Corona Virus Dataset] 
		  group by month(date);
7. select Month, Year,
    max(Confirmed) AS Most_Frequent_Confirmed,
    max(Deaths) AS Most_Frequent_Deaths,
    max(Recovered) AS Most_Frequent_Recovered
    from (select month(date) as Month,year(date) as Year,Confirmed,Deaths,Recovered,
        ROW_NUMBER() OVER (PARTITION BY Month(date), Year(date) ORDER BY COUNT(*) DESC) AS rn
    from [Corona Virus Dataset] GROUP BY month(date), year(date),Confirmed, Deaths, Recovered) AS subquery
    where rn =1
	group by Month, Year;
8. select year(date) as Year, min(confirmed) as min_confirmed_cases, 
          min(deaths) as min_deaths, 
		  min(recovered) as min_recovered_cases 
   from [Corona Virus Dataset] 
   group by year(date);
9. select year(date) as Year, 
          max(confirmed) as max_confirmed_cases, 
          max(deaths) as max_deaths, 
		  max(recovered) as max_recovered_cases 
   from [Corona Virus Dataset] 
   group by year(date);
10. select month(date) as Month, 
           sum(confirmed) as total_confirmed_cases, 
		   sum(deaths) as total_deaths, 
		   sum(recovered) as total_recovered_cases 
	from [Corona Virus Dataset] 
	group by month(date) 
	order by month(date);
11. select year(date) as Year,month(date) as Month,
           sum(confirmed) as total_confirmed_cases, 
		   avg(confirmed) as average_confirmed_cases, 
		   var(confirmed) as variance_confirmed_cases,
		   stdev(confirmed) as Stdev_confirmed_cases 
    from [Corona Virus Dataset] 
	group by year(date),month(date) 
	order by year,month;
12. select year(date) as Year,
           month(date) as Month,
		   sum(deaths) as total_deaths_cases, 
		   avg(deaths) as average_deaths_cases, 
		   var(deaths) as variance_deaths_cases,
		   stdev(deaths) as Stdev_deaths_cases 
    from [Corona Virus Dataset] 
	group by year(date),month(date) 
	order by year,month;
13. select year(date) as Year,
           month(date) as Month,
		   sum(recovered) as total_recovered_cases, 
		   avg(recovered) as average_recovered_cases, 
		   var(recovered) as variance_recovered_cases,
		   stdev(recovered) as Stdev_recovered_cases 
    from [Corona Virus Dataset] 
	group by year(date),month(date) 
	order by year,month;
14. with cte as (select Country_Region, sum(confirmed) as total_confirmed_cases  
                 from [Corona Virus Dataset] 
				 group by Country_Region) 
    select top 1 * 
	from cte 
	order by total_confirmed_cases desc;
15. with cte as (select Country_Region, sum(Deaths) as total_deaths  
                 from [Corona Virus Dataset] 
				 group by Country_Region) 
    select * 
	from cte 
	order by total_deaths;
16. with cte as (select Country_Region, sum(Recovered) as total_recovered_cases  
                 from [Corona Virus Dataset] 
				 group by Country_Region) 
    select top 5 * 
	from cte 
	order by total_recovered_cases desc;