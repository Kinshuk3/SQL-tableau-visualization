/* 
Tableau queries
@author- Kinshuk Chadha
The following 4 queries run against the employee_mod database and give back results which
are visualized in Tableau Public for better illustration

The quert results were stored in excel(.csv) file and imported into Tableau.
*/

use employees_mod;

# Book-1

SELECT 
    YEAR(de.from_date) AS calendar_year,
    e.gender,
    COUNT(e.emp_no) AS num_of_employees
FROM
    t_employees e
        JOIN
    t_dept_emp de ON e.emp_no = de.emp_no
GROUP BY calendar_year , e.gender
HAVING calendar_year >= 1990
ORDER BY calendar_year ASC;


# Book-2

SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN
            YEAR(dm.to_date) >= e.calendar_year
                AND YEAR(dm.from_date) <= e.calendar_year
        THEN
            1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN
    t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no , calendar_year;



# Book-2
SELECT 
    d.dept_name,
    e.gender,
    ROUND(s.salary, 2) AS salary,
    YEAR(s.from_date) AS calendar_year
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
GROUP BY e.gender , d.dept_no , calendar_year
HAVING calendar_year <= 2002
ORDER BY d.dept_name , e.gender , calendar_year; 


# # Book-4

DROP procedure if exists new_procedure
DELIMITER $$

CREATE procedure new_procedure (IN salary_1 INT, IN salary_2 INT)
BEGIN
SELECT
	d.dept_name,
    e.gender,
    AVG(s.salary) as avg_salary
FROM
	t_employees e
		JOIN
	t_salaries s ON e.emp_no = s.emp_no
		JOIN
	t_dept_emp de ON de.emp_no = e.emp_no
		JOIN
	t_departments d ON d.dept_no = de.dept_no
WHERE
	s.salary BETWEEN salary_1 AND salary_2
GROUP BY e.gender, d.dept_no;

END $$

DELIMITER ;

Call new_procedure(50000, 90000)