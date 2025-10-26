# Customer-Support-DB

A SQL Server database for analyzing customer support operations, employee performance and ticket metrics.The idea came up from a company I was working for in the past, and the way that team leaders used to evaluate us at the end of the month.
The database is structured as provided below, including five core tables:

- Offices – Physical office locations  
- Channels – Geographic regions or countries from which tickets are received  
- Teamleaders – Team management and supervisory information  
- Employees – Personnel records and employee information for rb.company  
- Tickets – Support ticket transactions and related operational data

## Database Views
### emp_details
Employee analytics view with pre-calculated demographics including age groups, employment status (Active/Inactive), work type (On Site/Remote), and tenure ranges for workforce analysis.
### ticket_rep
Ticket analytics view with time-based segmentation (hourly and time-of-day periods), CSAT score mapping, and performance metrics for operational dashboards.


## Terminology

| Term | Description |
|------|-------------|
| CSAT | Customer Satisfaction Score (1-5 scale) |
| FRT  | First Response Time (time to first agent reply) |
| HT   | Handling Time (total time to resolve) |
| MoM  | Month-over-Month percentage change |
| Tag  | Ticket category/issue type |
