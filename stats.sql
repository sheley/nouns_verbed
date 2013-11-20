
##### for google spreadsheet data =TRANSPOSE(A1:A11)

# Between
-- SELECT column_name(s) FROM table_name WHERE column_name BETWEEN value1 AND value2

# AVG() - Returns the average value

# COUNT() - Returns the number of rows
-- The COUNT(*) function returns the number of records in a table:
-- The COUNT(column_name) function returns the number of values
-- (NULL values will not be counted) of the specified column:
-- SELECT COUNT(column_name) FROM table_name;
-- The COUNT(DISTINCT column_name) function returns the number
-- of distinct values of the specified column:
-- SELECT COUNT(DISTINCT column_name) FROM table_name;

# FIRST() - Returns the first value
-- when would this ever be useful?
# LAST() - Returns the last value
-- ??

# MAX() - Returns the largest value
-- SELECT MAX(column_name) FROM table_name;
# MIN() - Returns the smallest value
-- SELECT MIN(column_name) FROM table_name;

# SUM() - Returns the sum
--SELECT SUM(column_name) FROM table_name;

# ROUND() - Rounds a numeric field to the number of decimals specified
-- SELECT ROUND(column_name,decimals) FROM table_name;

# NOW() - Returns the current system date and time
-- SELECT NOW() FROM table_name;

# FORMAT() - Formats how a field is to be displayed
-- SELECT FORMAT(column_name,format) FROM table_name;
-- example: SELECT ProductName, Price, FORMAT(Now(),'YYYY-MM-DD') AS PerDate
-- 			FROM Products;


# The IN operator allows you to specify multiple values in a WHERE clause.
-- SELECT column_name(s) FROM table_name WHERE column_name IN (value1,value2,...);



MySQL Date Functions
The following table lists the most important built-in date functions in MySQL:

Function	Description
NOW()	Returns the current date and time
CURDATE()	Returns the current date
CURTIME()	Returns the current time
DATE()	Extracts the date part of a date or date/time expression
EXTRACT()	Returns a single part of a date/time
DATE_ADD()	Adds a specified time interval to a date
DATE_SUB()	Subtracts a specified time interval from a date
DATEDIFF()	Returns the number of days between two dates
DATE_FORMAT()	Displays date/time data in different formats


SQL Server Date Functions
The following table lists the most important built-in date functions in SQL Server:

Function	Description
GETDATE()	Returns the current date and time
DATEPART()	Returns a single part of a date/time
DATEADD()	Adds or subtracts a specified time interval from a date
DATEDIFF()	Returns the time between two dates
CONVERT()	Displays date/time data in different formats


SQL Date Data Types
MySQL comes with the following data types for storing a date or a date/time value in the database:

DATE - format YYYY-MM-DD
DATETIME - format: YYYY-MM-DD HH:MM:SS
TIMESTAMP - format: YYYY-MM-DD HH:MM:SS
YEAR - format YYYY or YY
SQL Server comes with the following data types for storing a date or a date/time value in the database:

DATE - format YYYY-MM-DD
DATETIME - format: YYYY-MM-DD HH:MM:SS
SMALLDATETIME - format: YYYY-MM-DD HH:MM:SS
TIMESTAMP - format: a unique number
Note: The date types are chosen for a column when you create a new table in your database!






# total days tracked
-- COUNT()

# min/max total grossing
#########################

# day of last 7 days -> date, count-entered
# day of all time -> date, count-entered
# month in last 12 months -> month, total count for that calendar month
# day in last 30 days -> date, count-entered
# day per calendar year -> date, count-entered
# month per calendar month -> month, total count for that calendar month
# week (7 day streak or calendar week?) per calendar year -> date-date, total count for that 7 day period

# average min/max
#########################
# per day by day of week (all-time)-> float
#	sunday
# 	monday
# 	tuesday
# 	wednesday
# 	thursday
#	friday
#	saturday
# per day last 30 days -> float
# per day per calendar year -> float
# 	2012
#	2013
# per (calendar or 7 day period?) week of last 28 days---(?) -> float
# per calendar week per calendar year -> float
# per month of all time -> float
# per month of calendar year -> float

# other
#########################
# longest running consecutive streak -> number of days, date-date
# highest grossing streak in lowest number of days?
# biggest improvement month-month --> month, year, count total - month, year, counbt total
# largest gap --> date-date
# most consistent month per calendar year -> month, year, number of days
# most consistent month per month --> month, year
# month with smallest difference between counts -> month
# average delta (rate of change)