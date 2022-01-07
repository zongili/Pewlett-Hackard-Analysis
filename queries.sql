select * from dept_emp;

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;
DROP TABLE retirement_info cascade; 

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;


SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date

FROM retirement_info as ri
LEFT JOIN dept_emp as de
--And we can continue using the aliases to finish the code.
ON ri.emp_no = de.emp_no;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date

FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
--Next, we need to create a new table to hold the information. Let's name it "current_emp."
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
--Finally, because this is a table of current employees, we need to add a filter, 
--using the WHERE keyword and the date 9999-01-01.
--a new table containing only the current employees who are eligible for retirement will be returned.
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
--use COUNT and GROUP BY with joins to separate the employees into their departments. 
--These two components are very similar to functions used in Pandas. 
--COUNT will count the rows of data in a dataset, and we can use GROUP BY to group our data by type. 
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- Create new table and write into a csv file from employee count by department number
--The COUNT function was used on the employee numbers.
--Aliases were assigned to both tables.
--GROUP BY was added to the SELECT statement.
--We added COUNT() to the SELECT statement because we wanted a total number of employees. 
--We used a LEFT JOIN in this query because we wanted all employee numbers 
--from Table 1 to be included in the returned data. Also, if any employee numbers weren't 
--assigned a department number, that would be made apparent.
--The ON portion of the query tells Postgres which columns we're using to match the data. 
--Both tables have an emp_no column, so we're using that to match the records from both tables.
--GROUP BY is the magic clause that gives us the number of employees retiring from each department.
SELECT COUNT(ce.emp_no), de.dept_no
into emp_count_by_dep_number
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

--Employee Information: A list of employees containing their unique employee number, 
--their last name, first name, gender, and salary
SELECT emp_no,
    first_name,
last_name,
    gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Now that our employees table has been filtered again and is being saved into 
--a new temporary table (emp_info), we need to join it to the salaries table to add the t
--o_date and Salary columns to our query.
--Up to this point, we have updated and added code to:
--Select columns from three tables
--Create a new temp table
--Add aliases
--Join two of the three tables
drop table emp_info;
SELECT e.emp_no,
    e.first_name,
e.last_name,
    e.gender,
    s.salary,
    de.to_date
	INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
--Adding a third join seems tricky, but thankfully, the syntax is exactly the same. 
--All we need to do is add the next join right under the first. 
--Back in the query editor, add the following:
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
--we still need to make sure the filters are in place correctly. 
--The birth and hire dates are still resting right under our joins, 
--so update that with the proper aliases. 
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
--The last filter we need is the to_date of 999-01-01 from the dept_emp table. 
--To add another filter to our current WHERE clause, we will use AND again. 
--In the query editor, add this last line:
     AND (de.to_date = '9999-01-01');	 
	 
--Management: A list of managers for each department, 
--including the department number, name, and the manager's employee number, last name, 
--first name, and the starting and ending employment dates
--The next list to work on involves the management side of the business. 
-- Many employees retiring are part of the management team, and these positions 
-- require training, so Bobby is creating this list to reflect the upcoming departures.

-- We can see that the information we need is in three tables: Departments, Managers, and Employees. 
-- Remember, we're still using our filtered Employees table, current_emp, for this query.
-- Let's do this one together. At the bottom of the query editor, type the following:

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
--The result of this query looks even more strange than the salaries. How can only 
-- 		five departments have active managers? 
-- -- -- 	This is another question Bobby will need to ask his manager.


--Department Retirees: An updated current_emp list that includes everything 
--it currently has, but also the employee's departments
-- The final list needs only to have the departments added to the current_emp table. 
-- We've already consolidated most of the information into one table, 
-- but let's look at the department names and numbers we'll need.
-- The Dept_Emp and Departments tables each have a portion of the data we'll need, so we'll 
-- need to perform two more joins in the next query.

-- We'll use inner joins on the current_emp, departments, and dept_emp 
-- to include the list of columns we'll need to present to Bobby's manager:

-- emp_no
-- first_name
-- last_name
-- dept_name
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);
-- After executing the code and checking the results, a few folks 
-- are are appearing twice. Maybe they moved departments? It's interesting how each 
-- list has given Bobby a question to ask his manager. So far, Bobby would like to know the following:

-- What's going on with the salaries?
-- Why are there only five active managers for nine departments?
-- Why are some employees appearing twice?

-- The department head for Sales was a little surprised at how many folks will be 
-- leaving, so has asked for an additional list, containing only employees in their department.
-- The new list Bobby will need to make will contain everything in 
-- the retirement_info table, only tailored for the Sales team.

-- Create a query that will return only the information relevant to the Sales team. The requested list includes:

-- Employee numbers
-- Employee first name
-- Employee last name
-- Employee department name
select retirement_info.first_name,
retirement_info.last_name,
retirement_info.emp_no,
dept_emp.dept_no
from retirement_info  
LEFT JOIN dept_emp
--And we can continue using the aliases to finish the code.
ON retirement_info.emp_no = dept_emp.emp_no
where dept_emp.dept_no = 'd007';

--Create another query that will return the following information for the Sales and Development teams:
-- Employee numbers
-- Employee first name
-- Employee last name
-- Employee department name
-- Hint: You'll need to use the IN condition with the WHERE clause. See the PostgreSQL documentation 
-- (Links to an external site.) for additional information.
-- The IN condition is necessary because you're creating two items in the same column.

SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
	d.dept_name,
	de.dept_no
--Next, we need to create a new table to hold the information. Let's name it "current_emp."
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
LEFT JOIN departments as d
ON d.dept_no = de.dept_no
where d.dept_name IN ('Sales','Development');


