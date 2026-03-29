CREATE TABLE students (
   student_id INT PRIMARY KEY,
   full_name VARCHAR(100),
   age INT,
   group_id INT
);

CREATE TABLE groups (
   group_id INT PRIMARY KEY,
   group_name VARCHAR(50)
);

CREATE TABLE subjects (
   subject_id INT PRIMARY KEY,
   subject_name VARCHAR(50)
);

CREATE TABLE grades (
   grade_id INT PRIMARY KEY,
   student_id INT,
   subject_id INT,
   grade INT,
   FOREIGN KEY (student_id) REFERENCES students(student_id),
   FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);
--Напишите INSERT для заполнения таблиц
INSERT INTO groups (group_id, group_name) VALUES
(1, 'Java Developers'),
(2, 'Go Developers'),
(3, 'C-- Developers');
INSERT INTO students (student_id, full_name, age, group_id) VALUES
(1, 'Jon Jones', 34, 1),
(2, 'Islam Makhachev', 33, 1),
(3, 'Illia Topuria', 27, 2),
(4, 'Merab Dvalishvili', 34, 2),
(5, 'Alex Pereira', 36, 3);
INSERT INTO subjects (subject_id, subject_name) VALUES
(1, 'Databases'),
(2, 'Core'),
(3, 'Math');
INSERT INTO grades (grade_id, student_id, subject_id, grade) VALUES
(1, 1, 1, 9),
(2, 1, 2, 10),
(3, 2, 1, 8),
(4, 2, 2, 9),
(5, 3, 1, 7),
(6, 3, 3, 8),
(7, 4, 1, 9),
(8, 4, 3, 10),
(9, 5, 3, 6);
--Подсчитайте количество студентов в университете.
SELECT COUNT(*) AS total_students
FROM students;
--Найдите средний возраст студентов.
SELECT AVG(age) AS average_age
FROM students;
--Определите минимальный и максимальный возраст студентов.
SELECT MIN(age) AS min_age, MAX(age) AS max_age
FROM students;
--Подсчитайте, сколько всего оценок выставлено.
SELECT COUNT(*) AS total_grades
FROM grades;
--Подсчитайте, сколько студентов учится в каждой группе.
SELECT group_id, COUNT(*) AS student_count
FROM students
GROUP BY group_id;
--Найдите средний возраст студентов по каждой группе.
SELECT group_id, AVG(age) AS average_age
FROM students
GROUP BY group_id;
--Определите средний балл по каждому предмету.
SELECT subject_id, AVG(grade) AS average_grade
FROM grades
GROUP BY subject_id;
--Найдите количество студентов, у которых есть оценки по каждому предмету.
SELECT s.full_name, COUNT(DISTINCT g.subject_id) AS subjects_count
FROM students s
JOIN grades g ON s.student_id = g.student_id
GROUP BY s.full_name
HAVING COUNT(DISTINCT g.subject_id) = (SELECT COUNT(*) FROM subjects);
--Выведите только те группы, где учится больше 1 студента.
SELECT group_id, COUNT(*) AS student_count
FROM students
GROUP BY group_id
HAVING COUNT(*) > 1;
--Покажите предметы, где средний балл выше 8.
SELECT subject_id, AVG(grade) AS average_grade
FROM grades
GROUP BY subject_id
HAVING AVG(grade) > 8;
--Найдите студентов, у которых средний балл по всем предметам выше 8.5.
SELECT s.full_name, AVG(g.grade) AS average_grade
FROM students s
JOIN grades g ON s.student_id = g.student_id
GROUP BY s.full_name
HAVING AVG(g.grade) > 8.5;
