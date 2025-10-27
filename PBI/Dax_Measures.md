# Power BI DAX Measures Documentation

## Average Values

### Average CSAT
```dax
Average CSAT = AVERAGE(ticket_rep[CSAT])
```

### Average FRT
```dax
Average FRT = AVERAGE(ticket_rep[FRT_MINS])
```

### Average HT
```dax
Average HT = AVERAGE(ticket_rep[handling_time_min])
```

## General Metrics

### Employees
```dax
Employees = COUNT(emp_details[emp_id])
```

### Total Tickets
```dax
Total Tickets = COUNT(ticket_rep[ticket_id])
```

### Rated Tickets
```dax
Rated Tickets = 
CALCULATE(
    [Total Tickets], 
    ticket_rep[CSAT] <> BLANK()
)
```

### Rated Tickets %
```dax
Rated Tickets % = 
DIVIDE(
    [Rated Tickets],
    [Total Tickets],
    0
)
```

### Resolved Tickets %
```dax
Resolved Tickets % = 
VAR resolved_tickets = CALCULATE([Total Tickets], FILTER(ticket_rep, ticket_rep[status] = "Resolved"))
RETURN
DIVIDE(resolved_tickets, [Total Tickets], 0)
```

### Selected Period
```dax
Selected Period = 
VAR SelectedMonth = SELECTEDVALUE('Datetable'[Month])
VAR SelectedYear = SELECTEDVALUE('Datetable'[Year])
VAR SelectedDate = SELECTEDVALUE('Datetable'[Date])
VAR IsSpecificDate = DISTINCTCOUNT('Datetable'[Date]) = 1
RETURN
    IF(
        IsSpecificDate,
        SelectedMonth & " " & SelectedYear & " | Date: " & FORMAT(SelectedDate, "DD-MM-YYYY"),
        SelectedMonth & " " & SelectedYear & " | No Specific Date Selected"
    )
```

## Month-over-Month (MoM) Metrics

### CSAT % MoM
```dax
CSAT % MoM = 
VAR _lastmonth = CALCULATE([Average CSAT], DATEADD(DateTable[Date], -1, MONTH))
VAR pct_MOM = DIVIDE([Average CSAT], _lastmonth, 0) - 1
RETURN
FORMAT(pct_MOM, "0.00%") & 
IF(pct_MOM > 0, "⬆", IF(pct_MOM < 0, "⬇", ""))
```

### FRT % MoM
```dax
FRT % MoM = 
VAR _lastmonth = CALCULATE([Average FRT], DATEADD(DateTable[Date], -1, MONTH))
VAR pct_MOM = DIVIDE([Average FRT], _lastmonth, 0) - 1
RETURN
FORMAT(pct_MOM, "0.00%") & 
IF(pct_MOM > 0, "⬆", IF(pct_MOM < 0, "⬇", ""))
```

### HT % MoM
```dax
HT % MoM = 
VAR _lastmonth = CALCULATE([Average HT], DATEADD(DateTable[Date], -1, MONTH))
VAR pct_MOM = DIVIDE([Average HT], _lastmonth, 0) - 1
RETURN
FORMAT(pct_MOM, "0.00%") & 
IF(pct_MOM > 0, "⬆", IF(pct_MOM < 0, "⬇", ""))
```

### Rated % MoM
```dax
Rated % MoM = 
VAR _lastmonth = CALCULATE([Rated Tickets], DATEADD(DateTable[Date], -1, MONTH))
VAR pct_MOM = DIVIDE([Rated Tickets], _lastmonth, 0) - 1
RETURN
FORMAT(pct_MOM, "0.00%") & 
IF(pct_MOM > 0, "⬆", IF(pct_MOM < 0, "⬇", ""))
```

### Tickets % MoM
```dax
Tickets % MoM = 
VAR _lastmonth = CALCULATE([Total Tickets], DATEADD(DateTable[Date], -1, MONTH))
VAR pct_MOM = DIVIDE([Total Tickets], _lastmonth, 0) - 1
RETURN
FORMAT(pct_MOM, "0.00%") & 
IF(pct_MOM > 0, "⬆", IF(pct_MOM < 0, "⬇", ""))
```

## Previous Month Metrics

### Previous Month Average CSAT
```dax
Previous Month Average CSAT = 
CALCULATE(
    [Average CSAT], 
    DATEADD(DateTable[Date], -1, MONTH)
)
```

### Previous Month Avg Handling Time
```dax
Previous Month Avg Handling Time = 
CALCULATE(
    [Average HT],
    DATEADD(DateTable[Date], -1, MONTH)
)
```

### Previous Month Total Tickets
```dax
Previous Month Total Tickets = 
CALCULATE(
    [Total Tickets],
    DATEADD(DateTable[Date], -1, MONTH)
)
```

## Date Table

### DateTable
```dax
DateTable = 
VAR MinDate = MIN(ticket_rep[created_datetime])
VAR MaxDate = MAX(ticket_rep[created_datetime])
RETURN
ADDCOLUMNS(
    CALENDAR(MinDate, MaxDate),
    "Year", YEAR([Date]),
    "Year-Month", FORMAT([Date], "YYYY-MM"),
    "Quarter", "Q" & FORMAT([Date], "Q"),
    "Month", FORMAT([Date], "MMMM"),
    "Month Number", MONTH([Date]),
    "Day", DAY([Date]),
    "Day of Week", FORMAT([Date], "dddd"),
    "Day Number", WEEKDAY([Date])
)
```
