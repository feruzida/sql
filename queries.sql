--1. Вывести сотрудников с зарплатой выше средней по компании
SELECT
	e.id,
	e.name,
	e.salary,
	d.name AS department_name
FROM
	employees e
LEFT JOIN departments d
    ON
	e.department_id = d.id
WHERE
	e.salary > (
	SELECT
		AVG(salary)
	FROM
		employees)
ORDER BY
	e.id;
--2. Вывести продукты дороже среднего
SELECT
p.id,
    p.name,
    p.price
FROM
    products p
WHERE
    p.price > (
SELECT
	AVG(price)
FROM
	products)
ORDER BY
    p.id;
--3. Вывести отделы, где есть хотя бы один сотрудник с зарплатой > 10 000
SELECT
	DISTINCT
    d.id,
	d.name
FROM
	departments d
JOIN employees e 
    ON
	e.department_id = d.id
WHERE
	e.salary > 10000
ORDER BY
	d.id;
--4. Вывести продукты, которые чаще всего встречаются в заказах
SELECT
	p.id AS product_id,
	p.name AS product_name,
	COUNT(oi.id) AS order_count
FROM
	products p
JOIN order_items oi
    ON
	p.id = oi.product_id
GROUP BY
	p.id,
	p.name
ORDER BY
	order_count DESC;
--5. Вывести для каждого клиента количество его заказов
SELECT
	c.id AS customer_id,
	c.name AS customer_name,
	COUNT(o.id) AS orders_count
FROM
	customers c
LEFT JOIN orders o
    ON
	c.id = o.customer_id
GROUP BY
	c.id,
	c.name
ORDER BY
	c.id;
--6. Вывести топ 3 отдела по средней зарплате
SELECT
	d.id AS department_id,
	d.name AS department_name,
	ROUND(AVG(e.salary), 2) AS avg_salary
FROM
	departments d
JOIN employees e
    ON
	d.id = e.department_id
GROUP BY
	d.id,
	d.name
ORDER BY
	avg_salary DESC
LIMIT 3;
--7. Вывести клиентов без заказов
SELECT
    c.id AS customer_id,
    c.name AS customer_name
FROM
    customers c
LEFT JOIN orders o
    ON c.id = o.customer_id
WHERE
    o.id IS NULL
ORDER BY
    c.id;
--8. Вывести сотрудников, зарабатывающих больше, чем любой из менеджеров.
SELECT
	e.id AS employee_id,
	e.name AS employee_name,
	e.salary
FROM
	employees e
WHERE
	e.salary > ALL (
	SELECT
		salary
	FROM
		employees
	WHERE
		id IN (
		SELECT
			DISTINCT manager_id
		FROM
			employees
		WHERE
			manager_id IS NOT NULL)
		AND salary IS NOT NULL
    )
ORDER BY
	e.id;
--9. Вывести отделы, где все сотрудники зарабатывают выше 5000.
SELECT
	d.id AS department_id,
	d.name AS department_name
FROM
	departments d
JOIN employees e ON
	e.department_id = d.id
GROUP BY
	d.id,
	d.name
HAVING
	MIN(e.salary) > 5000
ORDER BY
	d.id;




