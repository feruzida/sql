CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    group_id INT REFERENCES groups(id)
);

CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    faculty_id INT REFERENCES faculties(id)
);

CREATE TABLE faculties (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    teacher_id INT REFERENCES teachers(id)
);

CREATE TABLE teachers (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE student_courses (
    student_id INT REFERENCES students(id),
    course_id INT REFERENCES courses(id),
    grade INT CHECK (grade BETWEEN 1 AND 5),
    PRIMARY KEY (student_id, course_id)
);