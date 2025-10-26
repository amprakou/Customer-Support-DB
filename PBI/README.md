# Power BI Dashboard

An interactive business intelligence dashboard analyzing customer support operations, providing actionable insights on employee performance, ticket metrics, and customer satisfaction across Greece, Cyprus, and Malta.

## Data Model

![Data Model](model_BI.png)

## Data Architecture

### Data Sources
**SQL Server Database (DBSupp_BI)**
- `emp_details` view - Employee demographics and analytics
- `ticket_rep` view - Enhanced ticket metrics with time segmentation
- `offices` table - Office locations
- `channels` table - Country/region codes (Greece, Cyprus, Malta)
- `teamleaders` table - Team management hierarchy
-  `cte_rnk` common table expression - Calculation to extract the 'Employee of the month within SQL'

### Power BI Enhancements

**Custom Tables Created:**
- **DateTable** - Calendar dimension for time-based analysis and MoM comparisons
- **HourTable** - Hour dimension for granular time-of-day workload analysis

**Data Modeling:**
- Configured relationships between fact and dimension tables using star schema

**DAX Measures:**
- **Performance Metrics**: Average FRT, Average HT, Total/Rated Tickets
- **CSAT Calculations**: Average CSAT with trend analysis
- **Trend Analysis**: MoM percentage changes for all key metrics
- **Employee Rankings**: Top performers by HT and CSAT
- **Time Segmentation**: Hourly and time-of-day aggregations

## Dashboard Pages

### 1. MED Support Overview
![MED Support Overview](Overview.png)

**Country-Level Analysis for Cyprus, Greece, and Malta:**
- Total Tickets with % MoM change
- Average Handling Time (minutes)
- Average CSAT score
- Weekly trend sparklines
- **Most Frequent Issues** with bookmark toggle between Top 3 and Bottom 3

**Interactive Features:**
- Custom filter menu (bookmarks) for focused analysis
- Toggle between Top 3 and Bottom 3 issues per country

---

### 2. Insights
![Insights Dashboard](Insights.png)

**Key Metrics with MoM indicators:**
- Total Tickets
- Average CSAT
- Average FRT (minutes)
- Average HT (minutes)
- Rated Tickets

**Analytics:**
- **vs Previous Month # of tickets by tag**: Comparison showing volume changes across issue categories
- **vs Previous Month CSAT by tag**: Performance variation across different issue types
- **vs Previous Month Handling Time by tag**: Efficiency analysis per ticket category
- **CSAT'S impact from HT**: Heatmap showing satisfaction scores based on handling time ranges (<=5min, 5-10min, 10-20min, 20-30min, 30-40min, 40-50min)
- **Total Tickets by CSAT Category**: Donut chart distribution (Not Rated, Very Satisfied, Satisfied, Neutral, Unsatisfied, Very Unsatisfied)

**Interactive Features:**
- Custom filter menu (bookmarks) for deeper analysis

---

### 3. Day/Hour Analysis (Time Analysis)
![Time Analysis](Time Analysis.png)

**Key Metrics with MoM indicators:**
- Total Tickets
- Average CSAT
- Average FRT (minutes)
- Average HT (minutes)
- Rated Tickets

**Time-Based Analytics:**
- **# of tickets per Hour Range**: Heatmap matrix showing volume by day of week (Sun-Sat) and hour (help button describes the meaning of gradient colors)
  - Morning (6am-12pm) with hourly breakdown
  - Afternoon (12pm-5pm) with hourly breakdown
  - Evening (5pm-9pm) with hourly breakdown
- **Total Tickets and Avg CSAT by Time Segment**: Dual-axis line chart showing volume vs satisfaction trends across Morning, Afternoon, and Evening periods
- **Total Tickets and Avg HT by Time Segment**: Dual-axis line chart showing volume vs handling time patterns throughout the day

**Interactive Features:**
- Custom filter menu (bookmarks) for time period selection
- Help tooltips explaining visual elements

### 4. Employee's Performance
![Employee Performance](Employee's Performance.png)

**Key Features:**
- **Employee search functionality** for quick lookup
- **Comprehensive performance table** showing (help button describes column metrics):
  - Employee Name with ranking
  - Total Tickets handled
  - Average CSAT score
  - Average FRT (minutes)
  - Average HT (minutes)
  - Rated Tickets count
  - Resolved Tickets percentage (%)
  - Color-coded performance indicators

**Employee of the Month Spotlight:**
- Highlighted top performer with name, HT, and CSAT metrics

**Trend Analysis:**
- **Over Month CSAT's Progress**: Line chart comparing current month average CSAT with previous month across the year
- **Over Month HT's Progress**: Line chart comparing current month average handling time with previous month trends

**Interactive Features:**
- Custom filter menu (bookmarks) for employee filtering
- Search box for quick employee lookup
- Help tooltips explaining performance metrics
