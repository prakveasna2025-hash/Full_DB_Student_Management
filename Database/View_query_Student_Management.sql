-- -- Index frequently joined foreign keys
-- CREATE INDEX IF NOT EXISTS idx_users_role ON "users" ("role_id");
-- CREATE INDEX IF NOT EXISTS idx_teachers_dept ON "teachers" ("department_id");
-- CREATE INDEX IF NOT EXISTS idx_students_dept ON "students" ("department_id");

-- -- Index academic mapping tables
-- CREATE INDEX IF NOT EXISTS idx_classes_course ON "classes" ("course_id");
-- CREATE INDEX IF NOT EXISTS idx_classes_teacher ON "classes" ("teacher_id");
-- CREATE INDEX IF NOT EXISTS idx_schedules_class ON "schedules" ("class_id");

-- -- Index operational logs (highly critical as these grow daily)
-- CREATE INDEX IF NOT EXISTS idx_attendance_enrollment ON "attendance" ("enrollment_id");
-- CREATE INDEX IF NOT EXISTS idx_attendance_schedule ON "attendance" ("schedule_id");
-- CREATE INDEX IF NOT EXISTS idx_submissions_assessment ON "assessment_submissions" ("assessment_id");

-- -- Index financial tables
-- CREATE INDEX IF NOT EXISTS idx_fees_student ON "fees" ("student_id");
-- CREATE INDEX IF NOT EXISTS idx_payments_fee ON "payments" ("fee_id");

-- SELECT 
--     s_user.username AS student_name,
--     c.course_code,
--     c.course_name,
--     t_user.username AS teacher_name,
--     sch.day_of_week,
--     sch.start_time,
--     sch.room,
--     e.grade
-- FROM students s
-- JOIN users s_user ON s.user_id = s_user.user_id
-- LEFT JOIN enrollments e ON s.student_id = e.student_id   -- Changed to LEFT JOIN
-- LEFT JOIN classes cl ON e.class_id = cl.class_id         -- Changed to LEFT JOIN
-- LEFT JOIN courses c ON cl.course_id = c.course_id        -- Changed to LEFT JOIN
-- LEFT JOIN teachers t ON cl.teacher_id = t.teacher_id
-- LEFT JOIN users t_user ON t.user_id = t_user.user_id
-- LEFT JOIN schedules sch ON cl.class_id = sch.class_id
-- ORDER BY student_name, sch.day_of_week, sch.start_time;



-- SELECT 
--     u.username AS student_name,
--     f.fee_type,
--     f.amount AS total_fee_amount,
--     COALESCE(SUM(p.amount), 0.00) AS total_paid,
--     (f.amount - COALESCE(SUM(p.amount), 0.00)) AS outstanding_balance,
--     f.status AS fee_status
-- FROM fees f
-- JOIN students s ON f.student_id = s.student_id
-- JOIN users u ON s.user_id = u.user_id
-- LEFT JOIN payments p ON f.fee_id = p.fee_id AND p.status = 'Paid'
-- GROUP BY u.username, f.fee_id, f.fee_type, f.amount, f.status
-- ORDER BY outstanding_balance DESC;



-- SELECT 
-- 	s_user.username AS student_name, 
-- 	p.parent_name, 
-- 	sp.relationship_type,
-- 	p.phone_number AS parent_phone,
-- 	p.email AS parent_email,
-- 	sp.is_emergency_contact
-- FROM student_parents sp
-- JOIN students s ON sp.student_id = s.student_id
-- JOIN users s_user ON s.user_id = s_user.user_id
-- JOIN parents p ON sp.parent_id = p.parent_id 
-- ORDER BY student_name, sp.is_emergency_contact DESC;
















