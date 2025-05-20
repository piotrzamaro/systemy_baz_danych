-- 1. Wynagrodzenie osób z działów 20 i 50, salary 2000–7000, sortowanie po nazwisku
SELECT last_name || ' - ' || salary AS wynagrodzenie
FROM employees
WHERE department_id IN (20, 50)
  AND salary BETWEEN 2000 AND 7000
ORDER BY last_name;

-- 2. Pracownicy z Toronto
SELECT e.last_name, e.department_id, d.department_name, e.job_id
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
WHERE l.city = 'Toronto';

-- 3. Działy z min_salary > 5000: suma i średnia zarobków (zaokrąglona)
SELECT d.department_id,
       ROUND(SUM(e.salary)) AS suma_zarobkow,
       ROUND(AVG(e.salary)) AS srednia_zarobkow
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_id
HAVING MIN(e.salary) > 5000;

-- 4. Współpracownicy Jennifer
SELECT DISTINCT e.first_name, e.last_name
FROM employees e
WHERE e.manager_id IN (
    SELECT employee_id
    FROM employees
    WHERE first_name = 'Jennifer'
);

-- 5. Departamenty bez pracowników
SELECT d.department_id, d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;

-- 6. Skopiowanie tabeli JOB_GRADES od użytkownika HR
CREATE TABLE job_grades AS
SELECT * FROM HR.job_grades;

-- 7. Dane pracownika + grade
SELECT e.first_name, e.last_name, e.job_id, d.department_name, e.salary, j.grade_level
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN job_grades j ON e.salary BETWEEN j.lowest_sal AND j.highest_sal;

-- 8. Pracownicy zarabiający powyżej średniej
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

-- 9. Osoby z działów, gdzie ktoś ma "u" w nazwisku
SELECT DISTINCT e.employee_id, e.first_name, e.last_name
FROM employees e
WHERE e.department_id IN (
    SELECT department_id
    FROM employees
    WHERE last_name LIKE '%u%'
);

-- 10. Zatrudnieni w 2005 z menedżerem – parametr kolumny i sortowania
SELECT hire_date, last_name, &nazwaKolumny
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 2005
  AND manager_id IS NOT NULL
ORDER BY &nazwaKolumny;

-- 11. Imię + nazwisko, salary, phone_number – z 3. literą 'e' i fragmentem imienia od użytkownika
SELECT first_name || ' ' || last_name AS full_name, salary, phone_number
FROM employees
WHERE SUBSTR(last_name, 3, 1) = 'e'
  AND LOWER(first_name) LIKE LOWER('%&fragmentImienia%')
ORDER BY 1 DESC, 2 ASC;

-- 12. Liczba miesięcy pracy i wysokość dodatku
SELECT first_name, last_name,
       ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) AS miesiace_pracy,
       CASE
           WHEN MONTHS_BETWEEN(SYSDATE, hire_date) < 150 THEN salary * 0.10
           WHEN MONTHS_BETWEEN(SYSDATE, hire_date) BETWEEN 150 AND 200 THEN salary * 0.20
           ELSE salary * 0.30
       END AS wysokosc_dodatku
FROM employees
ORDER BY miesiace_pracy DESC;
