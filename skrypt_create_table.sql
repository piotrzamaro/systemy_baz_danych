DROP TABLE countries;
DROP TABLE departments;
DROP TABLE employees;
DROP TABLE job_history;
DROP TABLE jobs;
DROP TABLE locations;
DROP TABLE products;
DROP TABLE regions;
DROP TABLE sales;
DROP TABLE hr;
DROP TABLE department;

-- REGIONS
CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(50)
);

-- COUNTRIES
CREATE TABLE countries (
    country_id CHAR(2) PRIMARY KEY,
    country_name VARCHAR(50),
    region_id INT
);

ALTER TABLE countries
ADD FOREIGN KEY (region_id) REFERENCES regions(region_id);

-- LOCATIONS
CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    street_address VARCHAR(100),
    postal_code VARCHAR(10),
    city VARCHAR(50),
    state_province VARCHAR(50),
    country_id CHAR(2)
);

ALTER TABLE locations
ADD FOREIGN KEY (country_id) REFERENCES countries(country_id);

-- DEPARTMENTS
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    manager_id INT,
    location_id INT
);

ALTER TABLE departments
ADD FOREIGN KEY (location_id) REFERENCES locations(location_id);

-- JOBS
CREATE TABLE jobs (
    job_id VARCHAR(10) PRIMARY KEY,
    job_title VARCHAR(50),
    min_salary INT,
    max_salary INT,
    CHECK (max_salary - min_salary >= 2000)
);

-- EMPLOYEES
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    hire_date DATE,
    job_id VARCHAR(10),
    salary DECIMAL(10,2),
    commission_pct DECIMAL(5,2),
    manager_id INT,
    department_id INT
);

ALTER TABLE employees
ADD FOREIGN KEY (job_id) REFERENCES jobs(job_id);

ALTER TABLE employees
ADD FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

ALTER TABLE employees
ADD FOREIGN KEY (department_id) REFERENCES departments(department_id);

-- JOB_HISTORY
CREATE TABLE job_history (
    employee_id INT,
    start_date DATE,
    end_date DATE,
    job_id VARCHAR(10),
    department_id INT,
    PRIMARY KEY (employee_id, start_date)
);

ALTER TABLE job_history
ADD FOREIGN KEY (employee_id) REFERENCES employees(employee_id);

ALTER TABLE job_history
ADD FOREIGN KEY (job_id) REFERENCES jobs(job_id);

ALTER TABLE job_history
ADD FOREIGN KEY (department_id) REFERENCES departments(department_id);


