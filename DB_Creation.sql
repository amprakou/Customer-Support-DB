-- DB Creation

CREATE DATABASE [DBSupp_BI];
USE [DBSupp_BI];
GO

CREATE TABLE offices (
    office_id INT PRIMARY KEY,
    office_location VARCHAR(50) NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL
);
GO

CREATE TABLE channels (
    channel_code CHAR(3) PRIMARY KEY,
    channel_name VARCHAR(30) NOT NULL
);
GO

CREATE TABLE teamleaders (
    leader_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    email VARCHAR(40) NOT NULL UNIQUE,
    office_id INT NOT NULL,
    CONSTRAINT fk_teamleader_office FOREIGN KEY (office_id) REFERENCES offices(office_id),
    CONSTRAINT chk_tl_mail CHECK(email LIKE '%@company.rb')
);
GO

CREATE TABLE employees (
    emp_ID INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    birth_date DATE,
    gender CHAR(1),
    email VARCHAR(40) NOT NULL UNIQUE,
    hire_date DATE NOT NULL,
    emp_type VARCHAR(40),
    exit_date DATE NULL,
    term_reason VARCHAR(40),
    leader_id INT NOT NULL,
    office_id INT NOT NULL,
    channel_code CHAR(3) NOT NULL,
    CONSTRAINT check_gender CHECK (gender IN ('M','F')),
    CONSTRAINT check_term_reason CHECK (
    (exit_date IS NULL) OR 
    (term_reason IS NOT NULL AND term_reason IN ('Contract Ended','Terminated','Resigned','Other'))),
    CONSTRAINT check_emp_type CHECK(emp_type IN ('Full Time','Part Time','Contract')),
    CONSTRAINT check_emp_mail CHECK (email LIKE '%@company.rb'),
    CONSTRAINT chk_exit_date CHECK (exit_date IS NULL OR exit_date > hire_date),
    CONSTRAINT fk_employee_office FOREIGN KEY (office_id) REFERENCES offices(office_id),
    CONSTRAINT fk_employee_channel FOREIGN KEY (channel_code) REFERENCES channels(channel_code),
    CONSTRAINT fk_employee_leader FOREIGN KEY (leader_id) REFERENCES teamleaders(leader_id)
);
GO

CREATE TABLE tickets (
    ticket_id VARCHAR(10) PRIMARY KEY,
    ticket_type VARCHAR(30) CHECK (ticket_type IN ('Customer', 'Venues')),
    tag VARCHAR(40) NOT NULL,
    created_datetime DATETIME NOT NULL,
    first_response_sec INT NOT NULL,
    handling_time_min INT NOT NULL,
    status VARCHAR(40) CHECK (status IN('Resolved', 'Escalated')) NOT NULL,
    csat TINYINT NULL,
    feedback TEXT NULL,
    emp_id INT NOT NULL,
    channel_code CHAR(3) NOT NULL,
    CONSTRAINT fk_ticket_empid FOREIGN KEY (emp_id) REFERENCES employees(emp_ID),
    CONSTRAINT fk_ticket_channel FOREIGN KEY (channel_code) REFERENCES channels(channel_code)
);
GO
-- creating indexes for FK_columns
CREATE NONCLUSTERED INDEX FK_emp_id ON tickets(emp_id);

CREATE NONCLUSTERED INDEX FK_cc ON tickets(channel_code);

CREATE NONCLUSTERED INDEX FK_leader ON employees(leader_id);

CREATE NONCLUSTERED INDEX FK_office ON employees(office_id);

-- Creating Views/ EMP_Demographics
CREATE VIEW emp_details AS
SELECT e.emp_id,
leader_id,
office_id,
channel_code,
CONCAT(e.first_name,' ',e.last_name) as 'Employees_Name',
CASE
    WHEN e.gender='M' THEN 'Male'
ELSE 'Female'
    END AS Gender,
CASE 
    WHEN exit_date IS NULL THEN 'Active'
ELSE 'Inactive'
    END AS Status,
    CASE 
    WHEN DATEDIFF(YEAR, e.birth_date, GETDATE()) BETWEEN 19 AND 24 THEN '19-24'
    WHEN DATEDIFF(YEAR, e.birth_date, GETDATE()) BETWEEN 25 AND 29 THEN '25-29'
    WHEN DATEDIFF(YEAR, e.birth_date, GETDATE()) BETWEEN 30 AND 34 THEN '30-34'
    WHEN DATEDIFF(YEAR, e.birth_date, GETDATE()) BETWEEN 35 AND 40 THEN '35-40'
    ELSE 'Out of range'
END AS age_group,
CASE WHEN is_remote =0 THEN 'On Site'
    ELSE 'Remote'
    END AS Work_type,
e.hire_date,
e.exit_date,
e.term_reason,
CASE
    WHEN DATEDIFF(MONTH, e.hire_date, ISNULL(exit_date, GETDATE())) BETWEEN 0 AND 12 THEN '0-1'
    WHEN DATEDIFF(MONTH, e.hire_date, ISNULL(exit_date, GETDATE())) BETWEEN 13 AND 24 THEN '1-2'
    WHEN DATEDIFF(MONTH, e.hire_date, ISNULL(exit_date, GETDATE())) BETWEEN 25 AND 36 THEN '2-3'
    WHEN DATEDIFF(MONTH, e.hire_date, ISNULL(exit_date, GETDATE())) BETWEEN 37 AND 48 THEN '3-4'
    WHEN DATEDIFF(MONTH, e.hire_date, ISNULL(exit_date, GETDATE())) BETWEEN 49 AND 60 THEN '4-5'
ELSE '>5'
    END AS Stayed_For
FROM [dbo].[employees] e
select * from emp_details
GO

-- Ticket Analytics view
CREATE VIEW ticket_rep AS
SELECT 
[ticket_id],
emp_id,
tag,
[channel_code],
ISNULL([feedback],'N/A') AS Feedback,
CAST([created_datetime] AS DATE) AS Date, 
CONCAT(
DATEPART(HOUR, [created_datetime]), '-',  DATEPART(HOUR,[created_datetime]) + 1 ) AS HourRange,
[created_datetime],
[first_response_sec],
[handling_time_min],
CHOOSE(
    CASE 
        WHEN DATEPART(HOUR, CREATED_DATETIME) BETWEEN 0 AND 5 THEN 1
        WHEN DATEPART(HOUR, CREATED_DATETIME) BETWEEN 6 AND 11 THEN 2
        WHEN DATEPART(HOUR, CREATED_DATETIME) BETWEEN 12 AND 16 THEN 3
        WHEN DATEPART(HOUR, CREATED_DATETIME) BETWEEN 17 AND 20 THEN 4
        ELSE 5
    END,
    'Night (12am-6am)', 
    'Morning (6am-12pm)', 
    'Afternoon (12pm-5pm)', 
    'Evening (5pm-9pm)',
    'Late Night (9pm-12am)'
) AS time_of_day,
[status],
[csat],
ISNULL(CHOOSE([csat], 'Very unsatisfied', 'Unsatisfied', 'Neutral', 'Satisfied', 'Very satisfied'), 'Not Rated') AS Score,
CASE
WHEN[status] = 'Resolved' 
THEN DATEADD(MINUTE, [handling_time_min],[created_datetime])
ELSE NULL
END AS resolved_datetime,
CAST([first_response_sec] / 60.0 AS DECIMAL(10,2)) AS FRT_MINS
FROM [dbo].[tickets] 
GO