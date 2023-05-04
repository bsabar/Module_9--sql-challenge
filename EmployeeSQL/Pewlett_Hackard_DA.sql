-- DATA MODELING (10 points)
-- please check the attached ERD Diagram on ../Resouces
-- bonus: created a spreadsheet guide to summarize all the columns with corresponding Primary Keys and Foreign Keys to made sense of the tables 

-- DATA ENGINEERING (70 points)
CREATE TABLE titles (
title_id VARCHAR (30) NOT NULL, 
title VARCHAR (30) NOT NULL
);

CREATE TABLE employees (
emp_no VARCHAR (30) NOT NULL, 
emp_title_id VARCHAR (30) NOT NULL,
birth_date DATE NOT NULL,
first_name VARCHAR (30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
sex VARCHAR(10) NOT NULL,
hire_date DATE NOT NULL
);

CREATE TABLE salaries (
emp_no VARCHAR (30) NOT NULL, 
salaries INT NOT NULL
);

CREATE TABLE departments (
dept_no VARCHAR (30) NOT NULL, 
dept_name VARCHAR (30) NOT NULL, 
);

CREATE TABLE dept_emp (
emp_no VARCHAR (30) NOT NULL, 
dept_no VARCHAR (30) NOT NULL, 
);

CREATE TABLE dept_manager (
dept_no VARCHAR (30) NOT NULL, 
emo_no VARCHAR (30) NOT NULL, 
);


-- assigning composite, foreign and primary keys
ALTER TABLE titles
ADD PRIMARY KEY (title_id) 

ALTER TABLE employees 
ADD FOREIGN KEY (emp_title_id) REFERENCES titles(title_id) 

ALTER TABLE employees
ADD PRIMARY KEY (emp_no)

ALTER TABLE salaries
ADD PRIMARY KEY (emp_no)

ALTER TABLE departments
ADD PRIMARY KEY (dept_no)

ALTER TABLE dept_emp
ADD FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
ADD FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
ADD PRIMARY KEY (emp_no,dept_no)

ALTER TABLE dept_manager
ADD FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
ADD FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
ADD PRIMARY KEY (dept_no, emp_no)


--DATA ANALYSIS--

-- List the employee number, last name, first name, sex, and salary of each employee (2 points)
SELECT EM.emp_no, EM.last_name, EM.first_name, EM.sex, sl.salaries
FROM employees AS EM 
LEFT JOIN salaries AS sl
ON (EM.emp_no = sl.emp_no);

-- List the first name, last name, and hire date for the employees who were hired in 1986 (2 points)
SELECT EM.first_name, EM.last_name, EM.hire_date
FROM employees AS EM
WHERE EM.hire_date BETWEEN '1986-01-01' AND '1986-12-31';

-- List the manager of each department along with their department number, department name, employee number, last name, and first name (2 points)
SELECT EM.first_name, EM.last_name, EM.emp_no, TI.title, D.dept_no, D.dept_name
FROM employees AS EM
JOIN titles as TI ON (EM.emp_title_id = TI.title_ID) 
JOIN dept_manager AS DM ON (EM.emp_no = DM.emp_no) 
JOIN departments AS D ON (D.dept_no = DM.dept_no)
WHERE (TI.title = 'Manager'); 

-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name (2 points)
SELECT EM.emp_no, EM.last_name, EM.first_name, D.dept_name, D.dept_no
FROM employees AS EM
JOIN dept_emp AS DE ON EM.emp_no = DE.emp_no
JOIN departments AS D ON DE.dept_no = D.dept_no; 

-- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B (2 points)
SELECT EM.first_name, EM.last_name, EM.sex
FROM employees AS EM
WHERE EM.first_name = 'Hercules' AND EM.last_name LIKE 'B%'; 

-- List each employee in the Sales department, including their employee number, last name, and first name (2 points)
SELECT EM.emp_no, EM.first_name, EM.last_name, D.dept_name
FROM employees AS EM JOIN dept_emp AS DE ON (DE.emp_no = EM.emp_no) 
JOIN departments as D ON (D.dept_no = DE.dept_no) 
WHERE (D.dept_name = 'Sales');

-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name (4 points)
SELECT EM.emp_no, EM.last_name, EM.first_name, D.dept_name
FROM employees AS EM
JOIN dept_emp AS DE ON EM.emp_no = DE.emp_no
JOIN departments AS D ON DE.dept_no = D.dept_no
WHERE D.dept_no = 'd005' or D.dept_no = 'd007'
ORDER BY EM.last_name DESC;

-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name) (4 points)
SELECT last_name, count(last_name) FROM employees
GROUP BY 1 
ORDER BY count DESC;

--BONUS: Listing all the frequency of employees last_names that share the same hire_date
WITH COUNTER AS (
SELECT hire_date, count(last_name) AS FRQ FROM employees
GROUP BY 1 
)

SELECT EM.last_name, EM.hire_date, B.FRQ
FROM employees AS EM, COUNTER as B
WHERE EM.hire_date = B.hire_date
ORDER BY last_name DESC;















