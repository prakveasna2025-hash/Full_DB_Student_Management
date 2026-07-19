-- CREATE OR REPLACE VIEW analytics_student_master_dashboard AS
-- SELECT 
--     -- 1. Student Identity Details
--     s.student_id,
--     u.username AS student_username,
--     u.email AS student_email,
--     s.major,
--     s.year_level,
--     s.gpa AS cumulative_gpa,
--     d.department_name,

--     -- 2. Academic & Enrollment Tracking
--     COUNT(DISTINCT e.class_id) AS total_courses_enrolled,
    
--     -- 3. Attendance Performance Metrics
--     COUNT(a.attendance_id) AS total_attendance_sessions,
--     ROUND(
--         100.0 * COUNT(CASE WHEN a.status = 'Present' THEN 1 END) 
--         / NULLIF(COUNT(a.attendance_id), 0), 1
--     ) AS attendance_rate_percentage,

--     -- 4. Academic Grading Insights
--     ROUND(AVG(sub.score_achieved), 2) AS average_assignment_score,

--     -- 5. Financial Audit Fields
--     COALESCE(SUM(DISTINCT f.amount), 0.00) AS total_fees_charged,
--     COALESCE(SUM(p.amount), 0.00) AS total_amount_paid,
--     (COALESCE(SUM(DISTINCT f.amount), 0.00) - COALESCE(SUM(p.amount), 0.00)) AS net_outstanding_balance

-- FROM students s
-- -- Link back to base user identity and department
-- JOIN users u ON s.user_id = u.user_id
-- LEFT JOIN departments d ON s.department_id = d.department_id

-- -- Link to academic metrics
-- LEFT JOIN enrollments e ON s.student_id = e.student_id
-- LEFT JOIN attendance a ON e.enrollment_id = a.enrollment_id
-- LEFT JOIN assessment_submissions sub ON s.student_id = sub.student_id

-- -- Link to financial metrics
-- LEFT JOIN fees f ON s.student_id = f.student_id
-- LEFT JOIN payments p ON f.fee_id = p.fee_id AND p.status = 'Paid'

-- -- Group everything by the unique student
-- GROUP BY 
--     s.student_id, 
--     u.username, 
--     u.email, 
--     s.major, 
--     s.year_level, 
--     s.gpa, 
--     d.department_name;


-- B. Find "At-Risk" Students (Low attendance OR low grades)

-- SELECT student_username, major, attendance_rate_percentage, average_assignment_score
-- FROM analytics_student_master_dashboard
-- WHERE attendance_rate_percentage < 85.0 OR average_assignment_score < 75.0;


-- C. Find Students with Collections Holds (Owing more than $1,000)

-- SELECT student_username, student_email, net_outstanding_balance
-- FROM analytics_student_master_dashboard
-- WHERE net_outstanding_balance > 1000.00;


-- SELECT * FROM analytics_student_master_dashboard;

	