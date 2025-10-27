 ------------------------------------------------------------------------------- Data validation -------------------------------------------------------------------------------
 --Extracting min-max date from hire_date and ticket creation for PBI DATE TABLE.
SELECT MIN(created_datetime) min_ticket , 
MAX(created_datetime) max_ticket FROM tickets

-- Check BI results for specific year month and emp_name
SELECT  CAST(AVG(t.csat * 1.0) AS DECIMAL(10,2)) AS average_CSAT,
CONCAT(e.first_name,' ',e.last_name) as 'Employees_Name'
FROM employees e 
JOIN TICKETS t ON
t.emp_id = e.emp_id
WHERE MONTH(t.created_datetime) = 4 AND YEAR(t.created_datetime) = 2024
AND e.emp_ID	= 14
GROUP BY  CONCAT(e.first_name,' ',e.last_name)
--ORDER BY  CONCAT(e.first_name,' ',e.last_name)  desc

 --How many tickets were received by each country?
SELECT 
 c.channel_name AS country,
COUNT(t.ticket_id) AS total_tickets
FROM tickets t
LEFT JOIN channels c  ON t.channel_code = c.channel_code
WHERE c.channel_name IN ('Cyprus', 'Greece', 'Malta')
GROUP BY c.channel_name;



-- What is the average CSAT of each country ?
SELECT  'Greece' AS country,
CAST(AVG(t.csat * 1.0) AS DECIMAL(10,2)) AS average_CSAT
FROM tickets t
LEFT JOIN channels c ON t.channel_code = c.channel_code
WHERE c.channel_name = 'greece'
GROUP BY c.channel_name

UNION ALL
SELECT 'Malta' AS country, 
CAST(AVG(t.csat * 1.0) AS DECIMAL(10,2)) AS average_CSAT
FROM tickets t
LEFT JOIN channels c ON t.channel_code = c.channel_code
WHERE c.channel_name = 'Malta'

UNION ALL 
SELECT 'Cyprus' AS country, 
 CAST(AVG(t.csat * 1.0) AS DECIMAL(10,2)) AS average_CSAT
FROM tickets t
LEFT JOIN channels c ON t.channel_code = c.channel_code
WHERE c.channel_name = 'Cyprus';

---- What is the average HT of Greece?

SELECT  c.channel_name,
CAST(AVG(t.handling_time_min * 1.0) AS DECIMAL(10,2)) AS average_ht
FROM tickets t
LEFT JOIN channels c ON t.channel_code = c.channel_code
WHERE c.channel_name = 'greece'
GROUP BY c.channel_name

-- Which are the most/less frequent tickets in Greece?
SELECT TOP 3 
c.channel_name,
t.tag,
COUNT(*) AS count_per_tag
FROM tickets t
LEFT JOIN channels c ON t.channel_code = c.channel_code
WHERE c.channel_name = 'greece'
GROUP BY t.tag,c.channel_name
ORDER BY COUNT(*) DESC -- ORDER BY COUNT(*) ASC to get bottom 3


-- What is the % MoM in received tickets from Februayr to March, 2024 for Cyprus?
DECLARE @curr_month INT = 3 
DECLARE @prev_month INT = 2 
DECLARE @year INT = 2024
DECLARE @curr_month_tickets INT;
DECLARE @prev_month_tickets INT;

SELECT @curr_month_tickets = COUNT(t.ticket_id)
FROM tickets t
INNER JOIN channels c ON t.channel_code = c.channel_code
WHERE c.channel_name = 'Cyprus' 
AND MONTH(t.created_datetime) = @curr_month
AND YEAR(t.created_datetime) = @year;

SELECT @prev_month_tickets = COUNT(t.ticket_id)
FROM tickets t
INNER JOIN channels c ON t.channel_code = c.channel_code
WHERE c.channel_name = 'Cyprus' 
AND MONTH(t.created_datetime) = @prev_month
AND YEAR(t.created_datetime) = @year;

SELECT 
  @curr_month_tickets AS total_tickets_current_month,
  @prev_month_tickets AS total_tickets_previous_month,
CAST(ROUND(((@curr_month_tickets - @prev_month_tickets) * 100.0) / NULLIF(@prev_month_tickets, 0), 2) AS DECIMAL(10,2)) AS '%MoM'

--  How many tickets of each tag were received from Cyprus during February and March 2024?
DECLARE @curr_month INT = 3 
DECLARE @prev_month INT = 2 
DECLARE @year INT = 2024

SELECT t.tag,
COUNT(CASE WHEN MONTH(t.created_datetime) = @curr_month THEN t.ticket_id END) AS this_month,
COUNT(CASE WHEN MONTH(t.created_datetime) = @prev_month THEN t.ticket_id END) AS previous_month
FROM tickets t
JOIN channels c ON t.channel_code = c.channel_code
WHERE c.channel_name = 'Cyprus' 
AND YEAR(t.created_datetime) = @year
AND MONTH(t.created_datetime) IN (@curr_month, @prev_month)
GROUP BY t.tag
ORDER BY this_month DESC;


-- What was the average CSAT for each tag during February and March 2024?

DECLARE @curr_month INT = 3;
DECLARE @prev_month INT = 2;
DECLARE @year INT = 2024;

SELECT 
t.tag,
CAST(AVG(CASE WHEN MONTH(t.created_datetime) = @curr_month THEN t.csat * 1.0 END) AS DECIMAL(10,2)) AS this_month,
CAST(AVG(CASE WHEN MONTH(t.created_datetime) = @prev_month THEN t.csat *1.0 END) AS DECIMAL(10,2)) AS previous_month
FROM tickets t
 JOIN channels c ON t.channel_code = c.channel_code
WHERE c.channel_name = 'Cyprus'
AND YEAR(t.created_datetime) = @year
AND MONTH(t.created_datetime) IN (@curr_month, @prev_month)
GROUP BY t.tag
ORDER BY this_month DESC;



-- What was the average Handling Time for each tag during February and March 2024?
DECLARE @curr_month INT = 3;
DECLARE @prev_month INT = 2;
DECLARE @year INT = 2024;

SELECT 
t.tag,
CAST(AVG(CASE WHEN MONTH(t.created_datetime) = @curr_month THEN t.handling_time_min * 1.0 END) AS DECIMAL(10,2)) AS this_month,
CAST(AVG(CASE WHEN MONTH(t.created_datetime) = @prev_month THEN t.handling_time_min * 1.0 END) AS DECIMAL(10,2)) AS previous_month
FROM tickets t
 JOIN channels c ON t.channel_code = c.channel_code
WHERE c.channel_name = 'Cyprus'
AND YEAR(t.created_datetime) = @year
AND MONTH(t.created_datetime) IN (@curr_month, @prev_month)
GROUP BY t.tag
ORDER BY this_month DESC;


-- What was the impact of employees' handling time on CSAT for Cyprus during April 2024?
SELECT 
t.tag AS Tag,
CAST(AVG(CASE WHEN t.handling_time_min <= 5 THEN t.csat * 1.0 END) AS DECIMAL(10,2)) AS [Early (<= 5 min)],
CAST(AVG(CASE WHEN t.handling_time_min> 5 AND t.handling_time_min <= 10 THEN t.csat * 1.0 END) AS DECIMAL(10,2)) AS [5-10 min],
CAST(AVG(CASE WHEN t.handling_time_min > 10 AND  t.handling_time_min<= 20 THEN t.csat * 1.0 END) AS DECIMAL(10,2)) AS [10-20 min],
CAST(AVG(CASE WHEN  t.handling_time_min > 20 AND  t.handling_time_min <= 30 THEN t.csat * 1.0 END) AS DECIMAL(10,2)) AS [20-30 min],
CAST(AVG(CASE WHEN t.handling_time_min > 30 AND  t.handling_time_min <= 40 THEN t.csat * 1.0 END) AS DECIMAL(10,2)) AS [30-40 min],
CAST(AVG(CASE WHEN  t.handling_time_min > 40 AND t.handling_time_min<= 50 THEN t.csat * 1.0 END) AS DECIMAL(10,2)) AS [40-50 min],
CAST(AVG(CASE WHEN  t.handling_time_min > 50 THEN t.csat * 1.0 END) AS DECIMAL(10,2)) AS '50+ min'
FROM tickets t
JOIN channels c ON t.channel_code = c.channel_code
WHERE c.channel_name = 'Cyprus' 
AND YEAR(t.created_datetime) = 2024
AND MONTH(t.created_datetime) = 4
GROUP BY t.tag
ORDER BY t.tag;



-- How many tickets were received in each CSAT category, categorized from worst to best, for Cyprus during April 2025? 
SELECT COUNT(t.ticket_id) as 'No of tickets',
CASE WHEN t.csat = 1 THEN 'Very unsatisfied'
WHEN t.csat =2 THEN 'Unsatisffied'
WHEN t.csat = 3 THEN 'Neutral'
WHEN t.csat = 4 THEN 'Satisfied'
WHEN t.csat = 5 THEN 'Very Satisfied'
ELSE 'Not Rated'
END AS csat_category
 FROM tickets t
LEFT  JOIN channels c ON
t.channel_code = c.channel_code
WHERE c.channel_name = 'Cyprus' AND  YEAR(t.created_datetime) = 2025 AND MONTH(t.created_datetime) = 4
GROUP BY CASE WHEN t.csat = 1 THEN 'Very unsatisfied'
WHEN t.csat =2 THEN 'Unsatisffied'
WHEN t.csat = 3 THEN 'Neutral'
WHEN t.csat = 4 THEN 'Satisfied'
WHEN t.csat = 5 THEN 'Very Satisfied'
ELSE 'Not Rated' END
ORDER BY COUNT(t.ticket_id) DESC;

--How does ticket volume vary by time of day and day of the week for MALTA?
SELECT 
t.time_of_day,
t.HourRange,
SUM(CASE WHEN DATENAME(WEEKDAY, t.created_datetime) = 'Sunday' THEN 1 ELSE 0 END) AS Sun,
SUM(CASE WHEN DATENAME(WEEKDAY, t.created_datetime) = 'Monday' THEN 1 ELSE 0 END) AS Mon,
SUM(CASE WHEN DATENAME(WEEKDAY, t.created_datetime) = 'Tuesday' THEN 1 ELSE 0 END) AS Tue,
SUM(CASE WHEN DATENAME(WEEKDAY, t.created_datetime) = 'Wednesday' THEN 1 ELSE 0 END) AS Wed,
SUM(CASE WHEN DATENAME(WEEKDAY, t.created_datetime) = 'Thursday' THEN 1 ELSE 0 END) AS Thu,
SUM(CASE WHEN DATENAME(WEEKDAY, t.created_datetime) = 'Friday' THEN 1 ELSE 0 END) AS Fri,
SUM(CASE WHEN DATENAME(WEEKDAY, t.created_datetime) = 'Saturday' THEN 1 ELSE 0 END) AS Sat,
COUNT(t.ticket_id) AS Total
FROM ticket_rep t 
LEFT JOIN channels c ON c.channel_code = t.channel_code
WHERE c.channel_name = 'Malta'
GROUP BY t.time_of_day, t.HourRange
ORDER BY 
CASE t.time_of_day 
WHEN 'Morning (6am-12pm)' THEN 1 
WHEN 'Afternoon (12pm-5pm)' THEN 2 
WHEN 'Evening (5pm-9pm)' THEN 3 
END,
t.HourRange;

    -- How do ticket volumes and average CSAT scores vary by time of day and hour range for Cyprus?

SELECT 
t.time_of_day,
t.HourRange,
COUNT(t.ticket_id) AS total_tickets,
CAST(AVG(t.csat * 1.0) AS DECIMAL(10,2)) AS average_csat
FROM ticket_rep t
LEFT JOIN channels c on c.channel_code = t.channel_code
WHERE c.channel_name = 'cyprus'
GROUP BY t.time_of_day, t.HourRange WITH ROLLUP
ORDER BY 
CASE t.time_of_day 
WHEN 'Morning (6am-12pm)' THEN 1 
WHEN 'Afternoon (12pm-5pm)' THEN 2 
WHEN 'Evening (5pm-9pm)' THEN 3 
END, t.HourRange

-- Provide team's and individual employees performance metrics for cyprus
SELECT 
CONCAT(tl.first_name,' ',tl.last_name) AS Teams,
CONCAT(e.first_name,' ',e.last_name) AS emp_name,
COUNT(t.ticket_id) AS Total_Tickets,
CAST(AVG(t.csat * 1.0) AS DECIMAL(10,2)) AS Average_CSAT,
CAST(AVG(t.first_response_sec / 60.0) AS DECIMAL(10,2)) AS Average_FRt,
CAST(AVG(t.handling_time_min * 1.0) AS DECIMAL(10,2)) AS Average_HT,
SUM(CASE WHEN t.csat IS NOT NULL THEN 1 ELSE 0 END) AS Rated_ickets,
CAST(SUM(CASE WHEN t.status = 'Resolved' THEN 1 ELSE 0 END) * 100.0 / COUNT(t.ticket_id) AS DECIMAL(10,2)) AS 'Resolved Tickets %'
FROM tickets t
LEFT JOIN employees e ON t.emp_id = e.emp_id
LEFT JOIN teamleaders tl ON e.leader_id = tl.leader_id
LEFT JOIN channels c ON t.channel_code = c.channel_code
WHERE c.channel_name = 'Cyprus'
GROUP BY GROUPING SETS (
(CONCAT(tl.first_name,' ',tl.last_name)),
(CONCAT(tl.first_name,' ',tl.last_name), CONCAT(e.first_name,' ',e.last_name)))
ORDER BY 
CONCAT(tl.first_name,' ',tl.last_name),
CASE WHEN CONCAT(e.first_name,' ',e.last_name) IS NULL THEN 0 ELSE 1 END, 
CONCAT(e.first_name,' ',e.last_name);

-- How did the average CSAT for -random employee- change between February and March 2024?

DECLARE @curr_month INT = 3
DECLARE @prev_month INT = 2 
DECLARE @year INT = 2024

SELECT 
CONCAT(e.first_name,' ',e.last_name) AS emp_name,
DATENAME(MONTH, t.created_datetime) AS month_name,
CAST(AVG(t.csat * 1.0) AS DECIMAL(10,2)) AS average_CSAT
FROM tickets t
LEFT JOIN employees e ON t.emp_id = e.emp_id
WHERE e.emp_id = 14
AND YEAR(t.created_datetime) = @year
AND MONTH(t.created_datetime) IN (@curr_month, @prev_month)
GROUP BY 
CONCAT(e.first_name,' ',e.last_name), 
DATENAME(MONTH, t.created_datetime),
MONTH(t.created_datetime)
ORDER BY MONTH(t.created_datetime);


-- -- How did the average handling time for -random employee- change between February and March 2024?

DECLARE @curr_month INT = 3
DECLARE @prev_month INT = 2
DECLARE @year INT = 2024


SELECT 
CONCAT(e.first_name,' ',e.last_name) AS emp_name,
DATENAME(MONTH, t.created_datetime) AS month_name,
CAST(AVG(t.handling_time_min * 1.0) AS DECIMAL(10,2)) AS [AVG HT]
FROM tickets t
LEFT JOIN employees e ON t.emp_id = e.emp_id
WHERE e.emp_id =14
AND YEAR(t.created_datetime) = @year
AND MONTH(t.created_datetime) IN (@curr_month, @prev_month)
GROUP BY 
CONCAT(e.first_name,' ',e.last_name), 
DATENAME(MONTH, t.created_datetime),
MONTH(t.created_datetime)
ORDER BY 
MONTH(t.created_datetime);

    --Who is the employee of the month for March 2023?(based on Highest CSAT and Lowest HT)

WITH rnk_cte AS (
SELECT  
CONCAT(e.first_name, ' ', e.last_name) AS emp_name,
DATEPART(YEAR, t.created_datetime) AS [Year],
DATENAME(MONTH, t.created_datetime) AS [Month],
CAST(AVG(t.csat * 1.0) AS DECIMAL(10,2)) AS average_CSAT,
CAST(AVG(t.handling_time_min * 1.0) AS DECIMAL(10,2)) AS [AVG_HT],
DENSE_RANK() OVER (PARTITION BY DATEPART(YEAR, t.created_datetime), MONTH(t.created_datetime) ORDER BY AVG(t.csat * 1.0) DESC, AVG(t.handling_time_min * 1.0) ASC) AS rnk,
CAST(DATEFROMPARTS(YEAR(t.created_datetime), MONTH(t.created_datetime), 1) AS DATE) AS [BI_relationship]
FROM employees e
JOIN tickets t ON e.emp_id = t.emp_id
GROUP BY  
CONCAT(e.first_name, ' ', e.last_name),
DATEPART(YEAR, t.created_datetime),
DATENAME(MONTH, t.created_datetime),
MONTH(t.created_datetime))

SELECT *
FROM rnk_cte rn
WHERE rn.rnk = 1 
-- AND rn.Month = 'March' AND rn.YEAR = 2024;




