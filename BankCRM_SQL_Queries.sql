use project;
--  
-- Objective Questions --
--
-- 1
select c.Geography, round(sum(b.balance)) as Region_Total_Balance
from customer_info c
join bank_churn b
on c.CustomerID = b.CustomerID
group by c.Geography;
-- 2 
select CustomerID, round(EstimatedSalary) as Salary
from customer_info
where quarter(JoiningDate) = 4
order by EstimatedSalary desc
limit 5;
-- 3
select sum(NumOfProducts)/count(*) as Avg_Num
from bank_churn 
where HasCrCard = 1;
-- 4
select c.Gender, count(case when b.Exited=1 then 1 end)/count(*) as Churn_Rate
from customer_info c
join bank_churn b
on c.CustomerID = b.CustomerID
group by c.Gender;
-- 5 
select ExitStatus, avg(CreditScore)
from bank_churn
group by ExitStatus;
-- 6
select c.Gender, ActiveStatus, round(avg(c.EstimatedSalary)) as Avg_Salary, count(*) as Counts
from customer_info c
join bank_churn b
on c.CustomerID = b.CustomerID
group by c.Gender, ActiveStatus
order by c.Gender;
-- 7
with cte as(
	select c.CustomerID, b.Exited, case
					when  b.CreditScore >= 800 then "Excellent"
                    when  b.CreditScore between 740 and 799 then "Very Good"
					when  b.CreditScore between 670 and 739 then "Good"
					when  b.CreditScore between 580 and 669 then "Fair"
                    else "Poor"
				   end as Segment
	from customer_info c
	join bank_churn b
	on c.CustomerID = b.CustomerID
)
select Segment, round(count(case when Exited = 1 then 1 end)/count(*) * 100, 2) as Exit_Rate
from cte
group by Segment
order by count(case when Exited = 1 then 1 end)/count(*) desc;
-- 8
select c.Geography, count(*) as Customer_Count
from customer_info c
join bank_churn b
on c.CustomerID = b.CustomerID
where b.Tenure > 5 and b.IsActiveMember = 1
group by c.Geography
order by count(*) desc;
-- 9
select CrCardStatus, count(case when Exited =1 then 1 end)/count(*) as Churn_Rate
from bank_churn
group by CrCardStatus;
-- 10
select distinct NumOfProducts, count(*) as Count
from bank_churn 
where Exited = 1
group by NumOfProducts
order by count(*) desc;
-- 11
select year(JoiningDate) as Join_Year,
	count(*) as Employee_Joined,
	count(*) - lag(count(*)) over(order by year(JoiningDate)) as Increase
from customer_info
group by year(JoiningDate)
order by year(JoiningDate);
-- 12
select distinct NumOfProducts, round(sum(Balance))
from bank_churn
where Exited = 1
group by NumOfProducts;
-- 
-- 13th question done in Power BI
--
-- 14
-- There are a total of 7 tables in the dataset, out of which 5 are categorical ones.
--
-- 15 
select c.GeographyID, c.Gender, round(avg(b.Balance)) as Income,
	dense_rank() over(partition by c.GeographyID orDer by avg(b.Balance) desc) as Ranks
from customer_info c
join bank_churn b
on c.CustomerID = b.CustomerID
group by c.GeographyID, c.Gender
order by c.GeographyID;
-- 16
with cte as(
	select c.CustomerID, b.Tenure, case
						when c.Age between 18 and 30 then "18-30"
                        when c.Age between 30 and 50 then "30-50"
                        else "50+"
					 end as Age_Bracket
    from customer_info c
	join bank_churn b
	on c.CustomerID = b.CustomerID
    where b.Exited = 1
)
select Age_Bracket, round(avg(Tenure),2) as Avg_Tenure
from cte
group by Age_Bracket
order by Age_Bracket;
-- 
-- 17th question done in Power BI
--
-- 18
with cte as(
	select c.CustomerID, c.EstimatedSalary, case
					when  b.CreditScore >= 800 then "Excellent"
                    when  b.CreditScore between 740 and 799 then "Very Good"
					when  b.CreditScore between 670 and 739 then "Good"
					when  b.CreditScore between 580 and 669 then "Fair"
                    else "Poor"
				   end as Segment
	from customer_info c
	join bank_churn b
	on c.CustomerID = b.CustomerID
)
select Segment, round(sum(EstimatedSalary)) as Salary
from cte
group by Segment
order by sum(EstimatedSalary) desc;
-- 19
with cte as(
	select c.CustomerID, case
					when  b.CreditScore >= 800 then "Excellent"
                    when  b.CreditScore between 740 and 799 then "Very Good"
					when  b.CreditScore between 670 and 739 then "Good"
					when  b.CreditScore between 580 and 669 then "Fair"
                    else "Poor"
				   end as Segment
	from customer_info c
	join bank_churn b
	on c.CustomerID = b.CustomerID
    where b.Exited = 1
)
select dense_rank() over(order by count(*) desc) as Ranks, Segment, count(*) as Customers_Churned
from cte
group by Segment
order by count(*) desc;
-- 20 (1st part)
with cte as(
	select c.CustomerID, case
						when c.Age between 18 and 30 then "18-30"
                        when c.Age between 30 and 50 then "30-50"
                        else "50+"
					 end as Age_Bracket
    from customer_info c
	join bank_churn b
	on c.CustomerID = b.CustomerID
    where b.HasCrCard = 1
)
select Age_Bracket, count(*) as Total_CrCard
from cte
group by Age_Bracket
order by Age_Bracket;
-- 20 (2nd part)
with cte as(
	select c.CustomerID, case
						when c.Age between 18 and 30 then "18-30"
                        when c.Age between 30 and 50 then "30-50"
                        else "50+"
					 end as Age_Bracket
    from customer_info c
	join bank_churn b
	on c.CustomerID = b.CustomerID
    where b.HasCrCard = 1
)
select Age_Bracket, count(*) as Total_CrCard
from cte
group by Age_Bracket
having count(*) < (select avg(cnt) from (select count(*) as cnt from cte group by Age_Bracket) cte2)
order by Age_Bracket;
-- 21
select dense_rank() over(order by count(*), avg(Balance)) as Ranks,
	Geography, count(*) as People_Churned, round(avg(Balance)) as Avg_Balance
from customer_info c 
join bank_churn b
on c.CustomerID = b.CustomerID
where Exited =1
group by Geography
order by count(*);
-- 22 (This query has already been run 1 time)
alter table customer_info
add CustomerId_Surname VARCHAR(300);
update customer_info
set CustomerId_Surname = CONCAT(CustomerId, '_', Surname);
-- 23
select CustomerId, ExitCategory
from bank_churn, exitcustomer
where Exited=ExitID;
-- 24
-- Used Power BI for missing values and error
-- 25
select c.CustomerId, surname, ActiveStatus
from customer_info c 
join bank_churn b
on c.CustomerId = b.CustomerId
where surname like '%on';
--
-- Subjective Questions --
--
-- 9 
-- demographic can mean region, age & gender.
with cte as(
	select c.CustomerID, Geography, Balance, Gender, case
						when c.Age between 18 and 30 then "18-30"
                        when c.Age between 30 and 50 then "30-50"
                        else "50+"
					 end as Age_Bracket
    from customer_info c
	join bank_churn b
	on c.CustomerID = b.CustomerID
)
select Geography, Gender, Age_Bracket, round(sum(Balance)) as Sum_of_Balance 
from cte
group by Age_Bracket, Gender, Geography
order by Geography, Gender, Age_Bracket
--
-- 14
-- ALTER TABLE bank_churn
-- RENAME COLUMN HasCrCard TO Has_creditcard;
-- 