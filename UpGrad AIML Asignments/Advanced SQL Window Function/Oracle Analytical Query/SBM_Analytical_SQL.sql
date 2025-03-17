/*************************************************************************************************************************
                                          Analytical Function
1. Arithmetic  : MAX, MIN, COUNT, AVG, MEDIAN,SUM
2. Statistical : STDVAR, CORR, COVAR_POP, VARIANCE, CUME_DIST etc
3. Positional  : DENSE_RANK, FIRST_VALUE, LASTST_VALUE, NTH_VALUE, NTITLE, PERCENT_RANK, RANK, ROW_int etc
4. Relative    : LEAD, LAG

https://dev.mysql.com/doc/refman/8.4/en/window-function-descriptions.html
**************************************************************************************************************************/

create database analytical;
use analytical;

-- drop table SBM_analytic_employee;

create table SBM_analytic_employee
(employee_id int,
first_name varchar(20),
last_name varchar(20),
email varchar(20),
phone_number varchar(15),
hire_date date,
job_code varchar(10),
salary int,
comm_pct int,
manager_id int,
department_id int
);

 select * 
-- delete 
from SBM_analytic_employee where employee_id <> 1000 ;

insert into SBM_analytic_employee values (100,'Steven','King','SKING','515.123.4567','2003-06-01','AD_PRES',24000,null,null,90);
insert into SBM_analytic_employee values (101,'Neena','Kochhar','NKOCHHAR','515.123.4568','2005-09-21','AD_VP',17000,null,100,90);
insert into SBM_analytic_employee values (102,'Lex','Dehaan','LDEHAAN','515.123.4569','2001-06-13','AD_VP',17000,null,100,90);
insert into SBM_analytic_employee values (103,'Alexander','Hunold','AHUNOLD','590.423.4567','2006-06-03','IT_PROG',9000,null,102,60);
insert into SBM_analytic_employee values (104,'Bruce','Ernst','BERNST','590.423.4568','2011-05-21','IT_PROG',6000,null,103,60);
insert into SBM_analytic_employee values (105,'David','Austin','DAUSTIN','590.423.4569','2005-06-25','IT_PROG',4500,null,103,60);
insert into SBM_analytic_employee values (106,'Valli','Petaballa','VPETABALLA','590.423.4570','2006-02-05','IT_PROG',4800,null,103,60);
insert into SBM_analytic_employee values (107,'Diana','Lorentz','DLORENTZ','590.423.4567','2002-02-07','IT_PROG',4200,null,103,60);
insert into SBM_analytic_employee values (108,'Nancy','Greenberg','NGREENBERG','515.124.4569','2002-08-17','FT_ACCOUNT',4800,null,101,100);
insert into SBM_analytic_employee values (109,'Daniel','Faviet','DFAVIET','515.124.4569','2002-08-17','FT_ACCOUNT',9000,null,108,100);
insert into SBM_analytic_employee values (110,'Suzaine','Decosta','DFAVIET','515.124.4569','2002-01-15','VP',19000,null,108,100);

-- Syntax
-- select analytic_func (column_name) over (
-- [ partition by column_name]
-- [order by column_name]
-- [Windowing-Clause]
-- )
-- from table_name

-- Example
-- select analytic_func (column_name) over (
-- [ partition by column_name]
-- )
-- from table_name
-- Find the average salary of employee department wise
select  avg(salary) over (partition by department_id ) as avg_sal,e.* 
from SBM_analytic_employee e order by department_id,employee_id ;
/

-- Syntax
-- select analytic_func (column_name) over (
-- [ partition by column_name]
-- [order by column_name]
-- )
-- from table_name

-- find the employee who joined 1st. LEAD function will return prior employee hire date 
-- for a depertment after arranging the records in hire date in DEscending Order
-- so for the 1st employee there will be no record so prior employee hire date will be NULL
-- so take the records where prior_emp_hire_dt is NULL
select * from
(
select lead(hire_date) over (partition by department_id order by hire_date desc) as prior_emp_hire_dt ,e.* 
from SBM_analytic_employee e order by department_id,hire_date
)
where prior_emp_hire_dt is NULL ;
/
-- Similary if you want the employee who joined most recent, you can use the LEAD function
-- only in partition you have to make "order by hire_date asc"
-- in LEAD or LAG function order by clause is MANDATORY , partition by is NOT
select * from
(
select lead(hire_date) over (partition by department_id order by hire_date asc) as prior_emp_hire_dt ,e.* 
from SBM_analytic_employee e order by department_id,hire_date
)
where prior_emp_hire_dt is NULL
/
-- display the department wise employee arranged by salary and show the previous employee salary
-- LEAD(column_name,n-th previous row <default is 1>,default_value,default is NULL>)
select lead(salary) over (partition by department_id order by salary asc) as prior_emp_sal ,e.* 
from SBM_analytic_employee e order by department_id,salary
/
-- here for the highest salaried employee of a department will not have any prior record and the prior_emp_sal will ne NULL
-- to avoid we can use LEAD(column_name,n-th previous row,default_value)
select lead(salary,1,0) over (partition by department_id order by salary asc) as prior_emp_sal ,e.* 
from SBM_analytic_employee e order by department_id,salary
/
-- LAG with order by DESC is same as LEAD with order by ASC
select lag(salary,1,0) over (partition by department_id order by salary desc) as prior_emp_sal ,e.* 
from SBM_analytic_employee e order by department_id,salary
/

-- Find the cumulative salary of employees department wise
-- see here in over clause we are partitioning by department and using order by to sum the value with previous value
-- or in simple word treating ech record to undergo the analytic function
select  sum(salary) over (partition by department_id order by employee_id ) as cum_sal,e.* 
from SBM_analytic_employee e order by department_id,employee_id
/
select  sum(salary) over (partition by department_id order by employee_id rows 2 preceding) as cum_sal_2,e.* 
from SBM_analytic_employee e order by department_id,employee_id
/
-- if we don't use order by employee_id, then it will sum the salary of all employee of the department
select  sum(salary) over (partition by department_id  ) as cum_sal,e.* 
from SBM_analytic_employee e order by department_id,employee_id
/

-- FIRST_VALUE, LAST_VALUE
-- Find out the heighest and lowest salary from the employee table
-- To do this 1st we have to arrange records order by salary and we need to apply Fisrt and Last VALUE function
-- Note these functions by default work in a range of "rows between unbounded preceding" till current row.
-- So for for record 1 FIRST_VALUE will apply only 1st recors, for 2nd row it will select FIRST_VALUE from 1 & 2 nd row 
-- from the ordered record set, which is again 1st row. 
select first_name,salary,FIRST_VALUE (first_name) over (order by salary) as ls,FIRST_VALUE (first_name) over (order by salary desc) as hs
from SBM_analytic_employee
/
--But for LAST_VALUE it keeps on changing for each record
-- it will 1 for 1st recors, for 2nd record LAST_VALUE will choose 2nd only from 1 & 2 records.
-- so to work with LAST_VALUE we have to use "onbounded following rows" alonh with "onbounded preceeding rows"
select first_name,salary,FIRST_VALUE (first_name) over (order by salary) as ls,
LAST_VALUE (first_name) over (order by salary rows between unbounded preceding and unbounded following) as hs
from SBM_analytic_employee
/
-- department wise
select first_name,salary,department_id,FIRST_VALUE (first_name) over (partition by department_id order by salary) as min_sal_emp_name,
LAST_VALUE (first_name) over (partition by department_id order by salary rows between unbounded preceding and unbounded following) as max_sal_emp_name
from SBM_analytic_employee
order by department_id,salary
/
-- To find department wise employee salary ranking from lowst to highest salary
select first_name,salary,department_id,FIRST_VALUE (salary) over (partition by department_id order by salary) as low_sal,
LAST_VALUE (salary) over (partition by department_id order by salary rows between unbounded preceding and unbounded following) as high_sal
from SBM_analytic_employee
order by department_id,salary
/
-- same we can use with DENSE_RANK and FIRST & LAST function also
-- To find department wise employee salary ranking from lowst to highest salary
select employee_id,first_name,salary,department_id,
MIN(salary) keep (DENSE_RANK FIRST order by salary) over (partition by department_id) as low_sal,
MAX(salary) keep (DENSE_RANK LAST order by salary) over (partition by department_id) as high_sal
from SBM_analytic_employee
order by department_id,salary
/
-- Now if we want to display only the MIN & MAX salaryed employee name with salary
-- we will remove the partition by clause and get MIN(name) / MAX(name)
select 
MIN(first_name) keep (DENSE_RANK FIRST order by salary)  as min_sal_emp_name,
min(salary) as min_sal,
MAX(first_name) keep (DENSE_RANK LAST order by salary)  as max_sal_emp_name,
max(salary) as max_sal
from SBM_analytic_employee
/
-- use of only DENSE_RANK for ranking
-- To find department wise employee salary ranking from lowst to highest salary
select employee_id,first_name,salary,department_id, 
DENSE_RANK () over (partition by department_id order by salary) as sal_wise_rank
from SBM_analytic_employee 
/
-- to find the lowest salary of employee department wise 
select * from
(
select employee_id,first_name,salary,department_id, 
DENSE_RANK () over (partition by department_id order by salary ) as sal_wise_rank
from SBM_analytic_employee 
)
where sal_wise_rank=1
/
-- to find the hiehest salary of employee department wise 
select * from
(
select employee_id,first_name,salary,department_id, 
DENSE_RANK () over (partition by department_id order by salary desc) as sal_wise_rank
from SBM_analytic_employee 
)
where sal_wise_rank=1
/

--- With clause
-- find the employee for those who get more than average salary
WITH temp_avg_sal(avg_sal) as
(select avg(salary) from SBM_analytic_employee)
select employee_id,first_name,last_name,salary from SBM_analytic_employee,temp_avg_sal where SBM_analytic_employee.salary > temp_avg_sal.avg_sal
/
---------------Output -------
/*
100	Steven	King	24000
101	Neena	Kochhar	17000
102	Lex	    Dehaan	17000
*/

-- find the department wise employee for those who get more than average salary
WITH temp_avg_sal_dept(job_code_dept,avg_sal) as
(select job_code,avg(salary) from SBM_analytic_employee group by job_code)
select employee_id,first_name,last_name,salary,job_code from SBM_analytic_employee,temp_avg_sal_dept 
where SBM_analytic_employee.salary > temp_avg_sal_dept.avg_sal and SBM_analytic_employee.job_code = temp_avg_sal_dept.job_code_dept
/
---------------Output -------
/*
104	Bruce	    Ernst	6000	IT_PROG
103	Alexander	Hunold	9000	IT_PROG
109	Daniel	    Faviet	9000	FT_ACCOUNT
*/