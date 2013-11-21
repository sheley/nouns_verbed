
# MIN/MAX
###########################################

# day of all time -> date, count-entered

# day of last 7 days -> date, count-entered

# month in last 12 months -> month, total count for that calendar month
# day in last 30 days -> date, count-entered
# day per calendar year -> date, count-entered
# month per calendar month -> month, total count for that calendar month
# week (7 day streak or calendar week?) per calendar year -> date-date, total count for that 7 day period



#   TOTALS
###########################################

# total per month_year
SELECT SUM(count) AS total_per_month_year, EXTRACT(YEAR_MONTH FROM date) 'year_month', tracked_id
	FROM tracking_data GROUP BY tracked_id, EXTRACT(YEAR_MONTH FROM date);


# total days tracked
SELECT COUNT(id) AS days_tracked, tracked_id FROM tracking_data GROUP BY tracked_id;


# total of last 7 days
SELECT SUM(count) AS cumulative_last_7_days, tracked_id
	FROM tracking_data WHERE (date BETWEEN DATE_SUB(NOW(), INTERVAL 7 DAY) AND NOW()) 
	GROUP BY tracked_id;
# OR
SELECT SUM(count) AS cumulative_last_7_days, tracked_id
	FROM tracking_data WHERE (date BETWEEN NOW() - INTERVAL 7 DAY AND NOW())
	GROUP BY tracked_id;

# total all time
SELECT SUM(count) AS total_all_time, tracked_id
	FROM tracking_data GROUP BY tracked_id;

# totals per year
SELECT SUM(count) AS total_per_year, YEAR(date) AS year, tracked_id
	FROM tracking_data GROUP BY tracked_id, YEAR(date) ORDER BY YEAR(date) DESC;

# totals per day by day of month
SELECT SUM(count) AS total_by_day_of_month, DAYOFMONTH(date), tracked_id 
	FROM tracking_data GROUP BY tracked_id, DAYOFMONTH(date);

# totals by day of the week
SELECT SUM(count) AS total_by_day_of_week, DAYNAME(date), tracked_id 
	FROM tracking_data GROUP BY tracked_id, DAYNAME(date) ORDER BY DAYOFWEEK(date);

# total of last 30 days
SELECT SUM(count) AS cumulative_last_30_days, tracked_id
	FROM tracking_data WHERE (DATE BETWEEN DATE_SUB(NOW(), INTERVAL 30 DAY) AND NOW())  
	GROUP BY tracked_id;



# averages
###########################################

# average per day all time
SELECT AVG(count) AS daily_average, tracked_id FROM tracking_data GROUP BY tracked_id;



# average per day per calendar year -> float
SELECT AVG(count) AS average_per_day, YEAR(date) AS year, tracked_id
	FROM tracking_data GROUP BY tracked_id, YEAR(date) DESC;


# average per calendar week per calendar year -> float

# general average per month
SELECT AVG(average_per_months) AS average_per_month, tracked_id  
	FROM (
	SELECT AVG(count) AS average_per_months, MONTH(date) AS month, tracked_id 
	FROM tracking_data GROUP BY tracked_id, MONTH(date)
	) as monthly GROUP BY tracked_id;


# average of each individual month_year
SELECT AVG(count) AS average_per_month_years, EXTRACT(YEAR_MONTH FROM date) 'year_month', tracked_id
	FROM tracking_data GROUP BY tracked_id, EXTRACT(YEAR_MONTH FROM date) 
	ORDER BY tracked_id, EXTRACT(YEAR_MONTH FROM date) DESC;

# average per month by name of month
SELECT AVG(count) AS average_per_month_by_month, MONTHNAME(date) AS month, tracked_id 
	FROM tracking_data GROUP BY tracked_id, MONTHNAME(date) ORDER BY tracked_id, MONTH(date) ASC;

# average delta (rate of change) per month


# average per (calendar or 7 day period?) week of last 28 days---(?) -> float















