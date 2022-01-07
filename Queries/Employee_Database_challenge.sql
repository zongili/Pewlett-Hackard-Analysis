-- Deliverable 1.
SELECT e.emp_no,e.first_name,e.last_name,
t.title, t.from_date,t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- Write another query in the Employee_Database_challenge.sql file to retrieve 
--the number of employees by their most recent job title who are about to retire.

SELECT COUNT (title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;
-- select sum(count) from retiring_titles;

--Deliverable 2
-- write a query to create a Mentorship Eligibility table that holds the 
-- employees who are eligible to participate in a mentorship program.
SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date,
de.from_date, de.to_date,
ti.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
INNER JOIN titles AS ti
ON ti.emp_no = e.emp_no
WHERE (ti.to_date = '9999-01-01') 
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

--DELIVERABLE 3
--queriying the title table gives me information on the currently working employees
--the number of currently working employees is 240,124
select count(emp_no) from titles where (to_date = '9999-01-01');
select count(emp_no) from employees ;
select count(emp_no) from dept_emp where (to_date = '9999-01-01');

--this gives me the percentage of actively working/held titles in the company
--according to the table majority is senior enginer and senior stuff, 35 and 34 percent of 240,124 employees

select title, 
count(title) as currently_working_num_of_titles, 
count(title)*100/ (select count(emp_no) from titles where (to_date = '9999-01-01')) as percentage_to_total_emp  
into currently_working_titles_percentage
from titles 
where (to_date = '9999-01-01') group by title
ORDER BY currently_working_num_of_titles DESC;
 
--this gives me info on the retiring titles percentage on the total num of employees
SELECT title, COUNT (title) as retiring_titles, 
count(title)*100/ (select count(emp_no) from titles where (to_date = '9999-01-01')) as retiring_percentage_to_total_emp  
INTO retiring_titles_percentage
FROM unique_titles
GROUP BY title
ORDER BY retiring_titles DESC;

--this gives me info on the retiring titles percentage on the total num of total titles
-- it gives a clear picture on how many percent of the specific job titles need to be hired
SELECT rt.title, ct.currently_working_num_of_titles, 
rt.retiring_titles, ct.percentage_to_total_emp,
rt.retiring_percentage_to_total_emp, 
rt.retiring_titles*100 / ct.currently_working_num_of_titles as percentage_of_retiring_titles
--INTO retiring_titles_vs_titles_percentage
FROM retiring_titles_percentage as rt
INNER JOIN currently_working_titles_percentage as ct
ON rt.title = ct.title
ORDER BY retiring_titles DESC;

--How many roles will need to be filled as the "silver tsunami" 
-- begins to make an impact? --90398
SELECT sum(retiring_titles) from retiring_titles_percentage;

-- Are there enough qualified, retirement-ready employees in 
-- the departments to mentor the next generation of Pewlett Hackard employees?
-- This querry will tell me how many mentors are available for each group
--
SELECT mentorship_eligibility.title, count(mentorship_eligibility.title) as mentor_count
INTO mentors_by_titles
FROM mentorship_eligibility
GROUP BY mentorship_eligibility.title
ORDER BY mentor_count DESC; 
--
--this gives the total number of mentors.1549

SELECT sum(mentor_count) from mentors_by_titles;

SELECT sum(rt.retiring_titles) / sum(mentors_by_titles.mentor_count) 
from retiring_titles_percentage as rt,mentors_by_titles;

--this query will tell me how many percent of the mentors are suppose to
-- mentor the retirement age employees and if there is enough mentor to do this.
SELECT rt.count, rt.title as retiring_title, 
mbt.title as mentor_title, mbt.mentor_count,
(rt.count / mbt.mentor_count) as mentor_per_employee
INTO mentor_vs_retiree_num
FROM retiring_titles as rt
left JOIN mentors_by_titles as mbt
ON rt.title = mbt.title
ORDER BY rt.title  DESC;


