-- Drop table if exists
-- DROP TABLE IF EXISTS titles, salaries, employees, dept_manager, dept_emp, departments;

-- =================================== DATA MODELING & ENGINEERING ======================================= --

-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/VTa8Xl
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

CREATE TABLE "titles" (
    "emp_no" INTEGER   NOT NULL,
    "title" VARCHAR(30)   NOT NULL,
    "from_date" VARCHAR(15)   NOT NULL,
    "to_date" VARCHAR(15)   NOT NULL
);

CREATE TABLE "salaries" (
    "emp_no" INTEGER  NOT NULL,
    "salary" INTEGER  NOT NULL,
    "from_date" VARCHAR(15)   NOT NULL,
    "to_date" VARCHAR(15)   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INTEGER  NOT NULL,
    "birth_date" VARCHAR(15)   NOT NULL,
    "first_name" VARCHAR(30)   NOT NULL,
    "last_name" VARCHAR(30)   NOT NULL,
    "gender" VARCHAR(30)   NOT NULL,
    "hire_date" VARCHAR(15)   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(30)   NOT NULL,
    "emp_no" INTEGER   NOT NULL,
    "from_date" VARCHAR(15)   NOT NULL,
    "to_date" VARCHAR(15)   NOT NULL
);

CREATE TABLE "dept_emp" (
    "emp_no" INTEGER   NOT NULL,
    "dept_no" VARCHAR(30)   NOT NULL,
    "from_date" VARCHAR(15)   NOT NULL,
    "to_date" VARCHAR(15)   NOT NULL
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR(30)   NOT NULL,
    "dept_name" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

-- ======================================== DATA ANALYSIS ============================================ --

-- 1. List the following details of each employee: employee number, last name, first name, gender, and salary.
SELECT e.emp_no, e.last_name, e.first_name, e.gender, s.emp_no, s.salary
FROM employees AS e
FULL OUTER JOIN salaries AS s
ON e.emp_no = s.emp_no
ORDER BY e.emp_no;

-- 2. List employees who were hired in 1986.
SELECT last_name, first_name
FROM employees
WHERE hire_date LIKE '1986%'
ORDER By last_name;

-- 3. List the manager of each department with the following information: 
-- department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
SELECT d.dept_no, d.dept_name, dm.emp_no, dm.from_date,
		dm.to_date, e.first_name, e.last_name
FROM departments AS d
	JOIN dept_manager AS dm
	ON (d.dept_no = dm.dept_no)
		JOIN employees AS e
		ON (dm.emp_no = e.emp_no);
	
-- 4. List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT d.dept_name, e.emp_no, e.last_name, e.first_name
FROM employees AS e
	FULL JOIN dept_emp AS de
	ON (de.emp_no = e.emp_no)
		FULL JOIN departments as d
		ON (d.dept_no = de.dept_no);
		

-- 5. List all employees whose first name is "Hercules" and last names begin with "B."
SELECT first_name, last_name FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT d.dept_name, e.emp_no, e.last_name, e.first_name
FROM employees AS e
	FULL JOIN dept_emp AS de
	ON (de.emp_no = e.emp_no)
		FULL JOIN departments as d
		ON (d.dept_no = de.dept_no)
		WHERE d.dept_name = 'Sales';

-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT d.dept_name, e.emp_no, e.last_name, e.first_name
FROM employees AS e
	FULL JOIN dept_emp AS de
	ON (de.emp_no = e.emp_no)
		FULL JOIN departments as d
		ON (d.dept_no = de.dept_no)
		WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development';

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name, count(last_name) AS "Frequency" 
	FROM employees 
	GROUP by last_name;