
--Getting the 'IT' department employees' Details
SELECT e.first_name + ' ' + e.last_name as employee_name
,e.email
,e.phone_number
,e.hire_date
,datediff(month,getdate(), e.hire_date) as [as of month]
,d.department_name
FROM emp.departments as d
INNER JOIN emp.employees as e ON d.department_id = e.department_id
WHERE d.department_name = 'IT'
ORDER BY  [as of month] asc, employee_name;

--Getting the department with employees count
SELECT department_name
,COUNT(e.employee_id) as [Employee Count]
FROM emp.departments as d
INNER JOIN emp.employees as e ON d.department_id = e.department_id
GROUP BY d.department_name;

--Getting All the department with employees count
SELECT department_name
,COUNT(e.employee_id) OVER as [Employee Count]
FROM emp.departments as d
LEFT JOIN emp.employees as e ON d.department_id = e.department_id
GROUP BY d.department_name;

--MEDIAN is an inverse distribution function that assumes a continuous distribution model
--SELECT department_name
--,MEDIAN(SUM(e.[salary])) OVER(PARTITION BY d.department_name ORDER BY e.hire_date) as [Employee Count]
--FROM emp.departments as d
--INNER JOIN emp.employees as e ON d.department_id = e.department_id
--GROUP BY d.department_name;


--RANK differs from the DENSE_RANK window function in one respect: 
--For DENSE_RANK, if two or more rows tie, there is no gap in the sequence of ranked values. 
--For example, if two rows are ranked 1, the next rank is 2
SELECT DISTINCT
j.[job_title]
,j.[min_salary]
,j.[max_salary]
,e.first_name + ' ' + e.last_name as employee_name
,e.[salary]
,RANK() OVER(PARTITION BY j.[job_id] ORDER BY e.[salary] DESC) as [Rank_Salary]
,DENSE_RANK() OVER(PARTITION BY j.[job_id] ORDER BY e.[salary] DESC) as [Dense_Rank_Salary]
FROM emp.jobs as j
LEFT JOIN emp.employees as e ON j.[job_id] = e.[job_id]
ORDER BY j.[job_title], [Rank_Salary];

--The LAG window function returns the values for a row at a given offset above (before) the current row in the partition.
--The LEAD window function returns the values for a row at a given offset below (after) the current row in the partition
SELECT DISTINCT
d.department_name
,e.first_name + ' ' + e.last_name as employee_name
,e.email
,e.phone_number
,e.hire_date
,LAG(e.first_name + ' ' + e.last_name) OVER(PARTITION BY d.department_name ORDER BY e.hire_date) AS [Employee Joined Before]
,LEAD(e.first_name + ' ' + e.last_name) OVER(PARTITION BY d.department_name ORDER BY e.hire_date) AS [Employee Joined After]
FROM emp.departments as d
LEFT JOIN emp.employees as e ON d.department_id = e.department_id
ORDER BY d.department_name, e.hire_date;

--Further limits the rows within the partition by specifying start and end points within the partition.
--This is done by specifying a range of rows with respect to the current row either by logical association or physical association. 
--Physical association is achieved by using the ROWS clause.
--The RANGE clause logically limits the rows within a partition by specifying a range of values with respect to the value in the current row.
SELECT DISTINCT
d.department_name
,e.first_name + ' ' + e.last_name as employee_name
,e.hire_date
,COUNT(*) OVER(PARTITION BY d.department_name ORDER BY e.hire_date ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS [How Many Employee(s) Joind before]
,COUNT(*) OVER(PARTITION BY d.department_name ORDER BY e.hire_date ROWS BETWEEN 1 FOLLOWING AND UNBOUNDED FOLLOWING) AS [How Many Employee(s) Joind after]
FROM emp.departments as d
INNER JOIN emp.employees as e ON d.department_id = e.department_id
ORDER BY d.department_name, e.hire_date;


--Given an ordered set of rows, FIRST_VALUE returns the value of the specified expression with respect to the first row in the window frame. 
--The LAST_VALUE function returns the value of the expression with respect to the last row in the frame.
--While the LAST_VALUE changes for each record and is equal to the last value that was pulled 
SELECT DISTINCT
d.department_name
,FIRST_VALUE(e.first_name + ' ' + e.last_name) OVER(PARTITION BY d.department_name ORDER BY e.hire_date) AS [First Employee]
,LAST_VALUE(e.first_name + ' ' + e.last_name) OVER(PARTITION BY d.department_name ORDER BY e.hire_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [Recent Employee]
FROM emp.departments as d
INNER JOIN emp.employees as e ON d.department_id = e.department_id;

--PERCENTILE_CONT is an inverse distribution function that assumes a continuous distribution model
--PERCENTILE_CONT computes a linear interpolation between values after ordering them. Using the percentile value (P) and the number of not null rows (N) in the aggregation group, 
--the function computes the row number after ordering the rows according to the sort specification. 
--This row number (RN) is computed according to the formula RN = (1+ (P*(N-1)). 
--The final result of the aggregate function is computed by linear interpolation between the values from rows at row numbers CRN = CEILING(RN) and FRN = FLOOR(RN)
--PERCENTILE_DISC is an inverse distribution function that assumes a discrete distribution model. 

SELECT DISTINCT
d.department_name
,PERCENTILE_CONT(0) WITHIN GROUP (ORDER BY e.[salary]) OVER (PARTITION BY d.department_name) AS [MIN salary]
,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY e.[salary]) OVER (PARTITION BY d.department_name) AS [QUARTTER salary]
,PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY e.[salary]) OVER (PARTITION BY d.department_name) AS [MEDIAN salary]
,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY e.[salary]) OVER (PARTITION BY d.department_name) AS [THREE QUARTTER salary]
,PERCENTILE_CONT(1) WITHIN GROUP (ORDER BY e.[salary]) OVER (PARTITION BY d.department_name) AS [MAX salary]  
FROM emp.departments as d
INNER JOIN emp.employees as e ON d.department_id = e.department_id;   

--UPDATE emp.employees 
--SET salary = 8000
--WHERE first_name + ' ' + last_name  = 'Adam Fripp'

