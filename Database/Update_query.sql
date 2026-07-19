-- SELECT 
--     c.course_code,
--     c.course_name,
--     COUNT(a.attendance_id) AS total_sessions_tracked,
--     ROUND(100.0 * COUNT(CASE WHEN a.status = 'Present' THEN 1 END) / NULLIF(COUNT(a.attendance_id), 0), 1) || '%' AS presence_rate,
--     ROUND(100.0 * COUNT(CASE WHEN a.status = 'Late' THEN 1 END) / NULLIF(COUNT(a.attendance_id), 0), 1) || '%' AS lateness_rate,
--     ROUND(100.0 * COUNT(CASE WHEN a.status = 'Absent' THEN 1 END) / NULLIF(COUNT(a.attendance_id), 0), 1) || '%' AS absence_rate
-- FROM attendance a
-- JOIN enrollments e ON a.enrollment_id = e.enrollment_id
-- JOIN classes cl ON e.class_id = cl.class_id
-- JOIN courses c ON cl.course_id = c.course_id
-- GROUP BY c.course_id, c.course_code, c.course_name
-- ORDER BY presence_rate DESC;


-- SELECT 
--     d.department_name,
--     u.username AS student_name,
--     s.major,
--     s.gpa,
--     DENSE_RANK() OVER (PARTITION BY s.department_id ORDER BY s.gpa DESC) as rank_in_department
-- FROM students s
-- JOIN users u ON s.user_id = u.user_id
-- LEFT JOIN departments d ON s.department_id = d.department_id -- Changed to LEFT JOIN
-- ORDER BY d.department_name, rank_in_department;



-- Step 1: Mark the transaction as completed
-- UPDATE payments 
-- SET status = 'Paid', paid_at = NOW(), updated_at = NOW()
-- WHERE transaction_id = 'TXN-10000-some-uuid-string' -- Example ID
-- RETURNING fee_id, amount;

-- -- Step 2: Clear or update the related fee status based on payment fulfillment
-- UPDATE fees 
-- SET status = 'Paid', updated_at = NOW()
-- WHERE fee_id = (SELECT fee_id FROM payments WHERE transaction_id = 'TXN-10000-some-uuid-string')
--   AND amount <= (SELECT SUM(amount) FROM payments WHERE fee_id = fees.fee_id AND status = 'Paid');


-- UPDATE students
-- SET 
--     year_level = year_level + 1,
--     graduation_date = CASE WHEN year_level + 1 > 4 THEN CURRENT_DATE ELSE graduation_date END,
--     updated_at = NOW()
-- WHERE year_level <= 4;






















	