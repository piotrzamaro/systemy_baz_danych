-- 1. Skopiuj dane z HR.REGIONS do swojej tabeli REGIONS
INSERT INTO regions
SELECT * FROM HR.regions;

-- 2. Usuń wszystkie tabele oprócz REGIONS
DROP TABLE job_history CASCADE CONSTRAINTS;
DROP TABLE employees CASCADE CONSTRAINTS;
DROP TABLE departments CASCADE CONSTRAINTS;
DROP TABLE jobs CASCADE CONSTRAINTS;
DROP TABLE locations CASCADE CONSTRAINTS;
DROP TABLE countries CASCADE CONSTRAINTS;

-- 3. Przekopiuj wszystkie tabele z HR do własnych (bez kluczy, same dane)
CREATE TABLE employees AS SELECT * FROM HR.employees;
CREATE TABLE jobs AS SELECT * FROM HR.jobs;
CREATE TABLE departments AS SELECT * FROM HR.departments;
CREATE TABLE job_history AS SELECT * FROM HR.job_history;
CREATE TABLE countries AS SELECT * FROM HR.countries;
CREATE TABLE locations AS SELECT * FROM HR.locations;

-- 4a. Imię i nazwisko z tabeli EMPLOYEES
SELECT first_name, last_name FROM employees;

-- 4b. Imię i nazwisko w jednym polu dla osób zarabiających > 4000
SELECT first_name || ' ' || last_name AS full_name
FROM employees
WHERE salary > 4000;

-- 4c. Imię i nazwisko oraz zarobki dla osób z nazwiskiem zawierającym 'a' lub 'e'
SELECT first_name, last_name, salary
FROM employees
WHERE salary BETWEEN 3000 AND 7000
  AND (last_name LIKE '%a%' OR last_name LIKE '%e%');

-- 4d. Imię i nazwisko oraz departament_id dla wskazanych departamentów
SELECT first_name, last_name, department_id
FROM employees
WHERE department_id IN (10, 20, 50, 70, 80, 100);

-- 4e. Różne numery departamentów
SELECT DISTINCT department_id
FROM employees;

-- 4f. 5 najdłużej pracujących osób
SELECT first_name, last_name, hire_date
FROM employees
ORDER BY hire_date
FETCH FIRST 5 ROWS ONLY;

-- 4g. Liczba departamentów
SELECT COUNT(*) AS liczba_departamentow
FROM departments;

-- 4h. Minimalne i maksymalne zarobki dla każdego job_id
SELECT job_id, MIN(salary) AS min_salary, MAX(salary) AS max_salary
FROM employees
GROUP BY job_id;

-- 4i. Imię i nazwisko osób zatrudnionych w latach 2005-2007
SELECT first_name, last_name
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) BETWEEN 2005 AND 2007
ORDER BY last_name, first_name;

-- 4j. Imię, nazwisko i suma zarobków z uwzględnieniem commission_pct
SELECT first_name, last_name,
       salary + salary * NVL(commission_pct, 0) AS suma_zarobkow
FROM employees;

-- 4k. Średnia zarobków w latach 2006–2010 dla każdego departamentu
SELECT department_id, ROUND(AVG(salary), 2) AS srednia
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) BETWEEN 2006 AND 2010
GROUP BY department_id;

-- 4l. Liczba pracowników dla każdego departamentu > 2
SELECT department_id, COUNT(*) AS liczba_pracownikow
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;

-- 4m. Liczba różnych stanowisk dla każdego departamentu
SELECT department_id, COUNT(DISTINCT job_id) AS liczba_stanowisk
FROM employees
GROUP BY department_id;

-- 4n. Suma zarobków dla departamentów o średniej > 5000
SELECT department_id, SUM(salary) AS suma_zarobkow
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 5000;
