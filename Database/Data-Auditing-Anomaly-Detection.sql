
-- 1. The "Ghost Student" Audit (Structural Outliers)
-- SELECT 
--     s.student_id,
--     u.username AS student_name,
--     s.enrollment_date,
--     COUNT(DISTINCT e.enrollment_id) AS courses_enrolled,
--     COUNT(DISTINCT f.fee_id) AS fees_assigned
-- FROM students s
-- JOIN users u ON s.user_id = u.user_id
-- LEFT JOIN enrollments e ON s.student_id = e.student_id
-- LEFT JOIN fees f ON s.student_id = f.student_id
-- GROUP BY s.student_id, u.username, s.enrollment_date
-- HAVING COUNT(DISTINCT e.enrollment_id) = 0 OR COUNT(DISTINCT f.fee_id) = 0;



-- 2. Timetable Conflict Detection (Logical Collisions)
-- SELECT 
--     sch1.day_of_week,
--     sch1.room,
--     sch1.class_id AS class_a_id,
--     sch1.start_time AS class_a_start,
--     sch1.end_time AS class_a_end,
--     sch2.class_id AS class_b_id,
--     sch2.start_time AS class_b_start,
--     sch2.end_time AS class_b_end
-- FROM schedules sch1
-- JOIN schedules sch2 ON 
--     sch1.day_of_week = sch2.day_of_week 
--     AND sch1.room = sch2.room
--     AND sch1.schedule_id < sch2.schedule_id  -- Prevents matching a row against itself or duplicates
-- WHERE 
--     (sch1.start_time, sch1.end_time) OVERLAPS (sch2.start_time, sch2.end_time);



-- 3. Financial Discrepancies (Over-payments & Status Mismatches)
-- SELECT 
--     f.fee_id,
--     u.username AS student_name,
--     f.fee_type,
--     f.amount AS invoice_amount,
--     COALESCE(SUM(p.amount), 0.00) AS total_amount_paid,
--     f.status AS invoice_status
-- FROM fees f
-- JOIN students s ON f.student_id = s.student_id
-- JOIN users u ON s.user_id = u.user_id
-- LEFT JOIN payments p ON f.fee_id = p.fee_id AND p.status = 'Paid'
-- GROUP BY f.fee_id, u.username, f.fee_type, f.amount, f.status
-- HAVING 
--     COALESCE(SUM(p.amount), 0.00) > f.amount -- Flag Overpayments
--     OR (f.amount = COALESCE(SUM(p.amount), 0.00) AND f.status = 'Pending'); -- Flag Status desyncs

-- 4. Academic Data Anachronisms (Timeline Corruptions)
	
-- Check 1: Inverted graduation timelines
-- SELECT student_id, user_id, enrollment_date, graduation_date 
-- FROM students 
-- WHERE graduation_date IS NOT NULL AND graduation_date < enrollment_date;

-- Check 2: Submissions recorded completely past the hard due date
-- SELECT 
--     sub.submission_id,
--     sub.student_id,
--     a.title AS assignment_title,
--     a.due_date,
--     sub.submitted_at::date AS actual_submission_day
-- FROM assessment_submissions sub
-- JOIN assessments a ON sub.assessment_id = a.assessment_id
-- WHERE sub.submitted_at::date > a.due_date;

