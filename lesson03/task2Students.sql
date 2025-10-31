CREATE TABLE students (
                         student_id SERIAL PRIMARY KEY,
                         first_name VARCHAR(50) NOT NULL,
                         last_name VARCHAR(50) NOT NULL,
                         birth_date DATE NOT NULL,
                         email VARCHAR(100) UNIQUE,
                         group_id INT NOT NULL
);
--Напишите INSERT для заполнения таблицы
INSERT INTO students (first_name, last_name, birth_date, email, group_id) VALUES
('Jon', 'Jones', '1990-07-19', 'jon.jones1@example.com', 101),
('Jon', 'Jones', '1990-07-19', 'jon.jones2@example.com', 101),
('Islam', 'Makhachev', '1991-09-27', 'islam.makhachev@example.com', 102),
('Illia', 'Topuria', '1997-01-21', 'illia.topuria@example.com', 103),
('Merab', 'Dvalishvili', '1991-01-10', 'merab.dvalishvili@example.com', 104),
('Merab', 'Dvalishvili', '1991-01-10', 'merab.dvalishvili2@example.com', 104);
--Найти дубликаты по имени и фамилии студента
SELECT first_name, last_name, COUNT(*) AS duplicate_count
FROM students
GROUP BY first_name, last_name
HAVING COUNT(*) > 1;
--Удалить дубликаты, оставить только первую запись
DELETE FROM students
WHERE student_id NOT IN (SELECT MIN(student_id)
FROM students
GROUP BY first_name, last_name
);