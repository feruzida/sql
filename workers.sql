CREATE TABLE departments (
 id     SERIAL PRIMARY KEY,
 name   VARCHAR(50) NOT NULL,
 location VARCHAR(50)
);

CREATE TABLE employees (
 id           SERIAL PRIMARY KEY,
 name         VARCHAR(50) NOT NULL,
 position     VARCHAR(50),
 salary       NUMERIC(10,2),
 department_id INTEGER REFERENCES departments(id) ON DELETE SET NULL,
 manager_id   INTEGER REFERENCES employees(id) ON DELETE SET NULL
);

CREATE TABLE customers (
 id   SERIAL PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 city VARCHAR(50)
);

CREATE TABLE orders (
 id          SERIAL PRIMARY KEY,
 order_date  DATE NOT NULL,
 amount      NUMERIC(10,2),
 employee_id INTEGER REFERENCES employees(id) ON DELETE SET NULL,
 customer_id INTEGER REFERENCES customers(id) ON DELETE SET NULL
);

CREATE TABLE products (
 id    SERIAL PRIMARY KEY,
 name  VARCHAR(100) NOT NULL,
 price NUMERIC(10,2)
);

CREATE TABLE order_items (
 id         SERIAL PRIMARY KEY,
 order_id   INTEGER REFERENCES orders(id) ON DELETE CASCADE,
 product_id INTEGER REFERENCES products(id) ON DELETE SET NULL,
 quantity   INTEGER NOT NULL
);

INSERT INTO departments (name, location) VALUES
('Striking Department', 'Las Vegas'),
('Wrestling Department', 'Dagestan'),
('Bjj Department', 'Brazil');

INSERT INTO employees (name, position, salary, department_id, manager_id) VALUES
('Jon Jones', 'Head Coach', 7000, 1, NULL),
('Islam Makhachev', 'Wrestling Coach', 6000, 2, 1),
('Alex Pereira', 'Striking Coach', 5500, 1, 1),
('Merab Dvalishvili', 'Conditioning Trainer', 4000, 3, NULL),
('Ilia Topuria', 'Boxing Coach', NULL, NULL, 2);

INSERT INTO customers (name, city) VALUES
('UFC', 'Las Vegas'),
('Bellator', 'New York'),
('PFL', 'Miami'),
('ONE Championship', 'Singapore');

INSERT INTO orders (order_date, amount, employee_id, customer_id) VALUES
('2025-09-01', 400, 2, 1),
('2025-09-03', 250, 3, 2),
('2025-09-05', 600, 1, 3),
('2025-09-07', 0, NULL, 1),
('2025-09-10', 150, 4, NULL);

INSERT INTO products (name, price) VALUES
('Private Training Session', 200),
('Seminar Ticket', 50),
('Gym Membership', 120),
('Fight Analysis Package', 300),
('Nutrition Plan', 80);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),   --2 Private Sessions
(1, 2, 1),   --1 Seminar
(2, 3, 2),   --2 Gym Memberships
(3, 4, 1),   --1 Analysis Package
(3, 5, 2);   --2 Nutrition Plans

--1. Вывести employee.id, employee.name, department.name — сотрудники без отдела должны показать No Department.
SELECT
	employee.id,
	employee.name,
	COALESCE(department.name, 'No Department') AS department_name
FROM
	employees AS employee
LEFT JOIN departments AS department 
    ON
	department.id = employee.department_id
ORDER BY
	employee.id;
--2. Сотрудники, у которых есть менеджер (показать имя сотрудника и имя менеджера).
SELECT
	e.name AS employee_name,
	m.name AS manager_name
FROM
	employees AS e
JOIN employees AS m 
    ON
	e.manager_id = m.id;
--3. Отделы без сотрудников.
SELECT
	d.id,
	d.name AS department_name
FROM
	departments AS d
LEFT JOIN employees AS e 
    ON
	d.id = e.department_id
WHERE
	e.id IS NULL;
--4. Все заказы с именем сотрудника и именем клиента — если employee или customer отсутствует, показывать No Employee / No Customer.
SELECT
	o.id AS order_id,
	COALESCE(e.name, 'No Employee') AS employee_name,
	COALESCE(c.name, 'No Customer') AS customer_name,
	o.order_date,
	o.amount
FROM
	orders AS o
LEFT JOIN employees AS e 
    ON
	o.employee_id = e.id
LEFT JOIN customers AS c 
    ON
	o.customer_id = c.id
ORDER BY
	o.id;
--5. Список заказов с товарами: для каждого заказа вывести order_id, product_name, quantity. Показать также заказы без позиций.
SELECT
	o.id AS order_id,
	p.name AS product_name,
	oi.quantity
FROM
	orders AS o
LEFT JOIN order_items AS oi 
    ON
	o.id = oi.order_id
LEFT JOIN products AS p 
    ON
	oi.product_id = p.id
ORDER BY
	o.id;
--6. Для каждого отдела — все заказы (через сотрудников этого отдела); включать отделы с нулём заказов.
SELECT
	d.name AS department_name,
	o.id AS order_id,
	o.amount,
	o.order_date
FROM
	departments AS d
LEFT JOIN employees AS e 
    ON
	e.department_id = d.id
LEFT JOIN orders AS o 
    ON
	o.employee_id = e.id
ORDER BY
	d.name,
	o.id;
--7. Найти пары клиентов и продуктов, которые этот клиент никогда не покупал (т.е. построить Cartesian клиент×продукт и исключить реальные покупки).
SELECT
	c.id AS customer_id,
	p.id AS product_id
FROM
	customers AS c
CROSS JOIN products AS p
WHERE
	NOT EXISTS (
	SELECT
		1
	FROM
		orders AS o
	JOIN order_items AS oi ON
		o.id = oi.order_id
	WHERE
		o.customer_id = c.id
		AND oi.product_id = p.id
)
ORDER BY
	c.id,
	p.id;
--8. Показать, какие продукты никогда не продавались.
SELECT
	p.id,
	p.name
FROM
	products AS p
LEFT JOIN order_items AS oi 
    ON
	p.id = oi.product_id
WHERE
	oi.id IS NULL;
--9. Для каждого менеджера — показать суммарную сумму заказов, оформленных его подчинёнными.
SELECT
	m.id AS manager_id,
	SUM(o.amount) AS total_orders_amount
FROM
	employees AS m
JOIN employees AS e 
    ON
	e.manager_id = m.id
JOIN orders AS o 
    ON
	o.employee_id = e.id
GROUP BY
	m.id
ORDER BY
	m.id;
--10. Общее количество заказов и суммарная выручка (amount).
SELECT
	COUNT(*) AS total_orders,
	SUM(amount) AS total_revenue
FROM
	orders;
--11. Средняя и максимальная зарплата по отделам.
SELECT
	department_id,
	AVG(salary) AS avg_salary,
	MAX(salary) AS max_salary
FROM
	employees
GROUP BY
	department_id
ORDER BY
	department_id;
--12. Для каждого заказа — общее количество товаров (sum quantity) и уникальных позиций (count distinct product_id).
SELECT
	o.id AS order_id,
	SUM(oi.quantity) AS total_quantity,
	COUNT(DISTINCT oi.product_id) AS unique_products
FROM
	orders AS o
LEFT JOIN order_items AS oi 
	ON
	o.id = oi.order_id
GROUP BY
	o.id
ORDER BY
	o.id;
--13. Топ-3 продукта по суммарной выручке (price*quantity).
SELECT
	p.id AS product_id,
	p.name AS product_name,
	SUM(p.price * oi.quantity) AS total_revenue
FROM
	products AS p
JOIN order_items AS oi 
	ON
	p.id = oi.product_id
GROUP BY
	p.id,
	p.name
ORDER BY
	total_revenue DESC
LIMIT 3;
--14. Количество клиентов, у которых есть хотя бы один заказ.
SELECT 
	COUNT(DISTINCT customer_id) AS customers_with_orders
FROM 
	orders
WHERE 
	customer_id IS NOT NULL;
--15. Для каждого отдела — количество сотрудников, средняя зарплата, суммарная сумма заказов (через сотрудников этого отдела).
SELECT 
	d.id AS department_id,
	d.name AS department_name,
	COUNT(e.id) AS employee_count,
	AVG(e.salary) AS avg_salary,
	SUM(o.amount) AS total_orders_amount
FROM 
	departments AS d
LEFT JOIN employees AS e 
	ON
	e.department_id = d.id
LEFT JOIN orders AS o 
	ON
	o.employee_id = e.id
GROUP BY 
	d.id,
	d.name
ORDER BY 
	d.id;
--16. Найти клиентов, чья средняя сумма заказа выше средней по всем заказам.
SELECT
	c.id AS customer_id,
	c.name AS customer_name,
	AVG(o.amount) AS avg_order_amount
FROM
	customers AS c
JOIN orders AS o 
	ON
	o.customer_id = c.id
GROUP BY
	c.id,
	c.name
HAVING
	AVG(o.amount) > (
	SELECT
		AVG(amount)
	FROM
		orders)
ORDER BY
	c.id;
--17. Сформировать полное имя сотрудника
SELECT
	id,
	name AS full_name
FROM
	employees;
--18. Вывести дату заказа в формате DD.MM.YYYY HH24:MI.
SELECT
	o.id AS order_id,
	TO_CHAR(o.order_date, 'DD.MM.YYYY HH24:MI') AS order_date_formatted
FROM
	orders AS o
ORDER BY
	o.id;
--19. Найти заказы старше N дней (параметр) 
SELECT
	o.id AS order_id,
	o.order_date,
	o.amount
FROM
	orders AS o
WHERE
--20. Для таблицы employees: заменить NULL в salary на 0 в вычислениях и вывести salary + bonus (bonus = 10% для определённой позиции).
SELECT
	id AS employee_id,
	name AS employee_name,
	POSITION,
	COALESCE(salary, 0) AS salary_no_null,


