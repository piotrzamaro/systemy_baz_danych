-- a. Widok: pracownicy z departamentu o nazwie "Sales"
CREATE OR REPLACE VIEW view_sales_employees AS
SELECT e.employee_id, e.last_name, e.first_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Sales';

-- Sprawdzenie danych
SELECT * FROM view_sales_employees;

-- b. Widok: pracownicy z zarobkami 3000–10000
CREATE OR REPLACE VIEW view_employees_salary_range AS
SELECT employee_id, last_name, first_name, salary, job_id, email, hire_date
FROM employees
WHERE salary BETWEEN 3000 AND 10000;

-- Sprawdzenie danych
SELECT * FROM view_employees_salary_range;

-- c. Przykładowe operacje przez widoki

-- Dodanie (działa tylko jeśli widok spełnia warunki wstawiania)
INSERT INTO view_employees_salary_range (employee_id, last_name, first_name, salary, job_id, email, hire_date)
VALUES (300, 'Nowak', 'Jan', 5000, 'IT_PROG', 'jan.nowak@example.com', SYSDATE);

-- Edycja
UPDATE view_employees_salary_range
SET salary = 6000
WHERE employee_id = 300;

-- Usunięcie
DELETE FROM view_employees_salary_range
WHERE employee_id = 300;

-- d. Widok: nazwa departamentu, średnia i suma zarobków – tylko dla działów z >=2 pracownikami
CREATE OR REPLACE VIEW view_department_salary_summary AS
SELECT d.department_name,
       ROUND(AVG(e.salary), 2) AS avg_salary,
       SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) >= 2;

-- Sprawdzenie widoku
SELECT * FROM view_department_salary_summary;

-- e. Próba dodania do widoku agregującego – zakończy się błędem (niemodyfikowalny widok)
-- (OCZEKIWANY BŁĄD – ORA-01779 lub podobny)
INSERT INTO view_department_salary_summary (department_name, avg_salary, total_salary)
VALUES ('Test', 5000, 10000);

-- f. Widok z CHECK OPTION
CREATE OR REPLACE VIEW view_employees_salary_check AS
SELECT employee_id, last_name, first_name, salary, job_id, email, hire_date
FROM employees
WHERE salary BETWEEN 3000 AND 10000
WITH CHECK OPTION;

-- Dodanie poprawnego pracownika (mieści się w widełkach 3000–10000)
INSERT INTO view_employees_salary_check (employee_id, last_name, first_name, salary, job_id, email, hire_date)
VALUES (301, 'Kowalski', 'Adam', 7000, 'SA_REP', 'adam.kowalski@example.com', SYSDATE);

-- Próba dodania z wynagrodzeniem powyżej zakresu (spodziewany błąd)
-- (OCZEKIWANY BŁĄD – ORA-01402 lub ORA-01400)
INSERT INTO view_employees_salary_check (employee_id, last_name, first_name, salary, job_id, email, hire_date)
VALUES (302, 'Wiśniewska', 'Anna', 15000, 'AD_PRES', 'anna.w@example.com', SYSDATE);
