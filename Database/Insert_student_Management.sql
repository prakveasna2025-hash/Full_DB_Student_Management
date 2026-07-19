-- Clean slate across all tables before seeding
-- TRUNCATE TABLE 
--   payments, fees, assessment_submissions, assessments, attendance, 
--   enrollments, schedules, classes, courses, student_parents, 
--   parents, students, teachers, departments, users, roles 
-- CASCADE;


-- -- 1. Insert 20 Rows into roles
-- INSERT INTO "roles" ("role_id", "role_name", "description") VALUES
-- (gen_random_uuid(), 'Super Admin', 'Full system access'),
-- (gen_random_uuid(), 'Academic Admin', 'Manages courses, classes, and departments'),
-- (gen_random_uuid(), 'Registrar', 'Manages student enrollments and records'),
-- (gen_random_uuid(), 'Bursar', 'Manages fees, invoices, and payment tracking'),
-- (gen_random_uuid(), 'Teacher', 'Academic staff handling instruction and grading'),
-- (gen_random_uuid(), 'Student', 'Enrolled learners'),
-- (gen_random_uuid(), 'Parent', 'Student guardians and emergency contacts'),
-- (gen_random_uuid(), 'Department Head', 'Manages specific academic departments'),
-- (gen_random_uuid(), 'IT Support', 'Handles technical infrastructure'),
-- (gen_random_uuid(), 'Auditor', 'View-only access for compliance checking'),
-- (gen_random_uuid(), 'Counselor', 'Student support and mental health services'),
-- (gen_random_uuid(), 'Librarian', 'Manages library resources'),
-- (gen_random_uuid(), 'Dean', 'High-level academic supervisor'),
-- (gen_random_uuid(), 'HR Specialist', 'Manages employee records'),
-- (gen_random_uuid(), 'Substitute Teacher', 'Temporary instructional staff'),
-- (gen_random_uuid(), 'Alumni Observer', 'Graduated student view access'),
-- (gen_random_uuid(), 'Guest Lecturer', 'Temporary teacher access'),
-- (gen_random_uuid(), 'Facilities Lead', 'Manages physical classroom spaces'),
-- (gen_random_uuid(), 'Assessor', 'External grading supervisor'),
-- (gen_random_uuid(), 'Academic Advisor', 'Guides students on major paths');

-- -- 2. Insert 20 Rows into departments
-- INSERT INTO "departments" ("department_id", "department_name", "description") VALUES
-- (gen_random_uuid(), 'Computer Science', 'Software engineering, algorithms, and systems'),
-- (gen_random_uuid(), 'Data Science', 'Data analysis, statistics, and machine learning'),
-- (gen_random_uuid(), 'Mathematics', 'Pure and applied mathematical sciences'),
-- (gen_random_uuid(), 'Physics', 'Classical, quantum, and experimental physics'),
-- (gen_random_uuid(), 'Chemistry', 'Organic, inorganic, and physical chemistry'),
-- (gen_random_uuid(), 'Biology', 'Molecular biology, genetics, and ecology'),
-- (gen_random_uuid(), 'Civil Engineering', 'Structural, environmental, and infrastructure design'),
-- (gen_random_uuid(), 'Mechanical Engineering', 'Thermodynamics, robotics, and fluid mechanics'),
-- (gen_random_uuid(), 'Electrical Engineering', 'Circuits, power systems, and signal processing'),
-- (gen_random_uuid(), 'English Literature', 'Analysis of classical and modern literature'),
-- (gen_random_uuid(), 'World History', 'Global historical timelines and developments'),
-- (gen_random_uuid(), 'Economics', 'Macroeconomic frameworks and microeconomic analysis'),
-- (gen_random_uuid(), 'Business Administration', 'Corporate management, finance, and marketing'),
-- (gen_random_uuid(), 'Psychology', 'Human behavior, cognitive science, and therapy'),
-- (gen_random_uuid(), 'Political Science', 'Governance frameworks and international relations'),
-- (gen_random_uuid(), 'Philosophy', 'Ethics, logic, and existential analysis'),
-- (gen_random_uuid(), 'Sociology', 'Social structures, dynamics, and institutions'),
-- (gen_random_uuid(), 'Fine Arts', 'Visual arts, sculpture, and design principles'),
-- (gen_random_uuid(), 'Musicology', 'Theory, history, and practice of music'),
-- (gen_random_uuid(), 'Environmental Science', 'Climate tracking and sustainability systems');

-- Select count(department_id) AS totat_department
-- From "departments"
-- Select count(role_id) AS totat_roles
-- From "roles"


-- Remove the remaining circular checks if they are still there
-- ALTER TABLE "users" DROP CONSTRAINT IF EXISTS "users_user_id_fkey";
-- ALTER TABLE "users" DROP CONSTRAINT IF EXISTS "users_user_id_fkey2";

-- ALTER TABLE "users" DROP CONSTRAINT IF EXISTS "users_user_id_fkey1";
-- ALTER TABLE "users" DROP CONSTRAINT IF EXISTS "users_user_id_fkey2";
-- ALTER TABLE "users" DROP CONSTRAINT IF EXISTS "users_user_id_fkey";

-- -- 4. Create Users (No loop required! Simple SELECT mapping)
-- INSERT INTO "users" ("user_id", "role_id", "username", "email", "password_hash", "phone_number", "status", "is_verified")
-- SELECT 
--     gen_random_uuid(),
--     (SELECT role_id FROM roles WHERE role_name = 'Teacher' LIMIT 1),
--     'teacher_' || gs,
--     'teacher' || gs || '@school.edu',
--     'hash_t_' || gs,
--     '+155501' || (10 + gs),
--     'active',
--     true
-- FROM generate_series(1, 20) as gs;

-- INSERT INTO "users" ("user_id", "role_id", "username", "email", "password_hash", "phone_number", "status", "is_verified")
-- SELECT 
--     gen_random_uuid(),
--     (SELECT role_id FROM roles WHERE role_name = 'Student' LIMIT 1),
--     'student_' || gs,
--     'student' || gs || '@school.edu',
--     'hash_s_' || gs,
--     '+155502' || (10 + gs),
--     'active',
--     true
-- FROM generate_series(1, 20) as gs;

-- INSERT INTO "users" ("user_id", "role_id", "username", "email", "password_hash", "phone_number", "status", "is_verified")
-- SELECT 
--     gen_random_uuid(),
--     (SELECT role_id FROM roles WHERE role_name = 'Parent' LIMIT 1),
--     'parent_' || gs,
--     'parent' || gs || '@home.com',
--     'hash_p_' || gs,
--     '+155503' || (10 + gs),
--     'active',
--     true
-- FROM generate_series(1, 20) as gs;

 -- -- 5. Insert Sub-Type Tables (Map directly to the Users we just created)
-- INSERT INTO "teachers" ("teacher_id", "user_id", "department_id", "hire_date", "specialization", "office_location")
-- SELECT 
--     gen_random_uuid(),
--     u.user_id,
--     d.department_id,
--     CURRENT_DATE - (rn * 30),
--     'Specialization ' || rn,
--     'Room ' || (100 + rn)
-- FROM (SELECT user_id, row_number() OVER () as rn FROM users WHERE username LIKE 'teacher_%') u
-- JOIN (SELECT department_id, row_number() OVER () as rn FROM departments) d ON u.rn = d.rn;

-- INSERT INTO "students" ("student_id", "user_id", "department_id", "enrollment_date", "major", "year_level", "gpa")
-- SELECT 
--     gen_random_uuid(),
--     u.user_id,
--     d.department_id,
--     CURRENT_DATE - (u.rn * 60 * INTERVAL '1 day'), -- Multiplied by a 1-day interval to fix the bigint error
--     'Major ' || u.rn,
--     (u.rn % 4) + 1,
--     3.00 + (u.rn * 0.04)
-- FROM (SELECT user_id, row_number() OVER () as rn FROM users WHERE username LIKE 'student_%') u
-- JOIN (SELECT department_id, row_number() OVER () as rn FROM departments) d ON u.rn = d.rn;

-- SELECT COUNT(*) FROM students;


-- INSERT INTO "parents" ("parent_id", "user_id", "parent_name", "email", "phone_number", "address")
-- SELECT 
--     gen_random_uuid(),
--     u.user_id,
--     'Parent Guardian ' || rn,
--     u.email,
--     u.phone_number,
--     rn || ' Main St, Metro City'
-- FROM (SELECT user_id, email, phone_number, row_number() OVER () as rn FROM users WHERE username LIKE 'parent_%') u;

-- INSERT INTO teachers
-- (
--     teacher_id,
--     user_id,
--     department_id,
--     hire_date,
--     specialization,
--     office_location
-- )
-- SELECT
--     gen_random_uuid(),
--     u.user_id,
--     d.department_id,
--     CURRENT_DATE - (u.rn * INTERVAL '30 days'),
--     'Specialization ' || u.rn,
--     'Room ' || (100 + u.rn)
-- FROM (
--     SELECT
--         user_id,
--         row_number() OVER () AS rn
--     FROM users
--     WHERE username LIKE 'teacher_%'
-- ) u
-- JOIN (
--     SELECT
--         department_id,
--         row_number() OVER () AS rn
--     FROM departments
-- ) d
-- ON u.rn = d.rn;

-- SELECT COUNT(*) FROM "teachers";


-- 6. Insert student_parents
-- INSERT INTO "student_parents" ("student_id", "parent_id", "relationship_type", "is_emergency_contact")
-- SELECT 
--     s.student_id, 
--     p.parent_id, 
--     CASE WHEN row_number() OVER () % 2 = 0 THEN 'Mother' ELSE 'Father' END,
--     CASE WHEN row_number() OVER () % 3 = 0 THEN true ELSE false END
-- FROM (SELECT student_id, row_number() OVER () as rn FROM students) s
-- JOIN (SELECT parent_id, row_number() OVER () as rn FROM parents) p ON s.rn = p.rn;

 -- -- 7. Insert courses
-- INSERT INTO "courses" ("course_id", "course_code", "course_name", "description", "credits", "department_id")
-- SELECT 
--     gen_random_uuid(),
--     'CS-' || (100 + rn),
--     'Introduction to ' || d.department_name,
--     'Foundations of ' || d.department_name,
--     (rn % 2) + 3,
--     d.department_id
-- FROM (SELECT department_id, department_name, row_number() OVER () as rn FROM departments) d;

-- 8. Insert classes
-- INSERT INTO "classes" ("class_id", "course_id", "teacher_id", "semester", "capacity")
-- SELECT 
--     gen_random_uuid(),
--     c.course_id,
--     t.teacher_id,
--     'Fall 2026',
--     30
-- FROM (SELECT course_id, row_number() OVER () as rn FROM courses) c
-- JOIN (SELECT teacher_id, row_number() OVER () as rn FROM teachers) t ON c.rn = t.rn;

-- 9. Insert schedules
-- INSERT INTO "schedules" ("schedule_id", "class_id", "day_of_week", "start_time", "end_time", "room")
-- SELECT 
--     gen_random_uuid(),
--     c.class_id,
--     CASE (rn % 5) 
--         WHEN 0 THEN 'Monday' WHEN 1 THEN 'Tuesday' WHEN 2 THEN 'Wednesday' 
--         WHEN 3 THEN 'Thursday' ELSE 'Friday' END,
--     '09:00:00'::time + ((rn % 4) * '2 hours'::interval),
--     '10:30:00'::time + ((rn % 4) * '2 hours'::interval),
--     'Auditorium ' || (200 + rn)
-- FROM (SELECT class_id, row_number() OVER () as rn FROM classes) c;

-- -- 10. Insert enrollments
-- INSERT INTO "enrollments" ("enrollment_id", "student_id", "class_id", "grade", "status")
-- WITH numbered_classes AS (
--     SELECT class_id, 
--            row_number() OVER () - 1 AS class_rn, -- Start at 0 for clean modulo math
--            COUNT(*) OVER () AS total_classes
--     FROM classes
-- ),
-- numbered_students AS (
--     SELECT student_id, 
--            row_number() OVER () AS stu_rn 
--     FROM students)
-- SELECT 
--     gen_random_uuid(),
--     s.student_id,
--     c.class_id,
--     CASE (s.stu_rn % 5) 
--         WHEN 0 THEN 'A' 
--         WHEN 1 THEN 'B' 
--         WHEN 2 THEN 'C' 
--         WHEN 3 THEN 'D' 
--         ELSE 'F' 
--     END,
--     'active'
-- FROM numbered_students s
-- JOIN numbered_classes c 
--   ON c.class_rn = (s.stu_rn - 1) % c.total_classes; -- Cycles students through available classes perfectly



  
-- -- 11. Insert attendance
-- INSERT INTO "attendance" ("attendance_id", "enrollment_id", "schedule_id", "status")
-- SELECT 
--     gen_random_uuid(),
--     e.enrollment_id,
--     s.schedule_id,
--     CASE (e.rn % 4) WHEN 0 THEN 'Present' WHEN 1 THEN 'Late' WHEN 2 THEN 'Absent' ELSE 'Excused' END
-- FROM (SELECT enrollment_id, class_id, row_number() OVER () as rn FROM enrollments) e
-- JOIN schedules s ON e.class_id = s.class_id;


-- select count(*) from "attendance"
-- TRUNCATE TABLE "attendance" CASCADE;

-- -- 12. Insert assessments
-- INSERT INTO "assessments" ("assessment_id", "class_id", "title", "description", "type", "max_score", "weight", "due_date")
-- SELECT 
--     gen_random_uuid(),
--     c.class_id,
--     'Assessment Project ' || rn,
--     'Coursework details for ' || rn,
--     CASE (rn % 4) WHEN 0 THEN 'Exam' WHEN 1 THEN 'Quiz' WHEN 2 THEN 'Assignment' ELSE 'Project' END,
--     100,
--     15.00 + rn,
--     CURRENT_DATE + 30
-- FROM (SELECT class_id, row_number() OVER () as rn FROM classes) c;

-- 13. Insert assessment_submissions
-- INSERT INTO "assessment_submissions" ("submission_id", "assessment_id", "student_id", "score_achieved", "feedback")
-- SELECT 
--     gen_random_uuid(),
--     a.assessment_id,
--     e.student_id,
--     80.00 + (a.rn % 20),
--     'Feedback details on project submission.'
-- FROM (SELECT assessment_id, class_id, row_number() OVER () as rn FROM assessments) a
-- JOIN enrollments e ON a.class_id = e.class_id;

-- -- 14. Insert fees
-- INSERT INTO "fees" ("fee_id", "student_id", "class_id", "fee_type", "amount", "due_date", "status")
-- SELECT 
--     gen_random_uuid(),
--     e.student_id,
--     e.class_id,
--     'Tuition Balance',
--     1250.00 + (rn * 50),
--     CURRENT_DATE + 15,
--     'Pending'
-- FROM (SELECT student_id, class_id, row_number() OVER () as rn FROM enrollments) e;



























