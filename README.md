# Customer-Support-DB

A SQL Server database for analyzing customer support operations, employee performance and ticket metrics including five core tables :
•	Offices – Physical office locations 
•	Channels – Geographic regions or countries from which tickets are received.
•	Teamleaders – Team management and supervisory information.
•	Employees – Personnel records and employee information for rb.company.
•	Tickets – Support ticket transactions and related operational data.


                                                      Database Features :
  Data Integrity
•	Foreign key relationships across all entities
•	Check constraints for data validation
•	Email domain validation

  Performance Optimization
•	Non-clustered indexes on foreign key columns
•	Optimized for reporting queries

## Terminology

| Term | Description |
|------|-------------|
| CSAT | Customer Satisfaction Score (1-5 scale) |
| FRT  | First Response Time (time to first agent reply) |
| HT   | Handling Time (total time to resolve) |
| MoM  | Month-over-Month percentage change |
| Tag  | Ticket category/issue type |
