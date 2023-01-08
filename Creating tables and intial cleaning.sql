--creating table so that import data from "divvy-tripdata"

CREATE TABLE january_2021 (
	ride_id VARCHAR(250),
	rideable_type VARCHAR(250),
	started_at TIMESTAMP,
	ended_at TIMESTAMP,
	start_station_name VARCHAR(250),
	start_station_id VARCHAR(250),
	end_station_name VARCHAR(250),
	end_station_id VARCHAR(250),
	start_lat FLOAT,
	start_lng FLOAT,
	end_lat FLOAT,
	end_lng FLOAT,
	member_casual VARCHAR(250)
)



CREATE TABLE february_2021 (
	ride_id VARCHAR(250),
	rideable_type VARCHAR(250),
	started_at TIMESTAMP,
	ended_at TIMESTAMP,
	start_station_name VARCHAR(250),
	start_station_id VARCHAR(250),
	end_station_name VARCHAR(250),
	end_station_id VARCHAR(250),
	start_lat FLOAT,
	start_lng FLOAT,
	end_lat FLOAT,
	end_lng FLOAT,
	member_casual VARCHAR(250)
)

.
.
.
.
.
-- creating table upto december_2021

CREATE TABLE  december_2021 (
	ride_id VARCHAR(250),
	rideable_type VARCHAR(250),
	started_at TIMESTAMP,
	ended_at TIMESTAMP,
	start_station_name VARCHAR(250),
	start_station_id VARCHAR(250),
	end_station_name VARCHAR(250),
	end_station_id VARCHAR(250),
	start_lat FLOAT,
	start_lng FLOAT,
	end_lat FLOAT,
	end_lng FLOAT,
	member_casual VARCHAR(250)


-- creating table for importing all data into a single table

CREATE TABLE all_months (
	ride_id VARCHAR(250),
	rideable_type VARCHAR(250),
	started_at TIMESTAMP,
	ended_at TIMESTAMP,
	start_station_name VARCHAR(250),
	start_station_id VARCHAR(250),
	end_station_name VARCHAR(250),
	end_station_id VARCHAR(250),
	start_lat FLOAT,
	start_lng FLOAT,
	end_lat FLOAT,
	end_lng FLOAT,
	member_casual VARCHAR(250)
)

-- Using UNION ALL command to import all the months from january_2021 to december_2021 in all_months table

INSERT INTO all_months
SELECT * FROM january_2021
UNION ALL
SELECT * FROM february_2021
UNION ALL
SELECT * FROM march_2021
UNION ALL
SELECT * FROM april_2021
UNION ALL
SELECT * FROM may_2021
UNION ALL
SELECT * FROM june_2021
UNION ALL
SELECT * FROM july_2021
UNION ALL
SELECT * FROM august_2021
UNION ALL
SELECT * FROM september_2021
UNION ALL
SELECT * FROM october_2021
UNION ALL
SELECT * FROM november_2021
UNION ALL
SELECT * FROM december_2021;


-- counting the nulls in  start_station_name 

SELECT COUNT(*) FROM all_months 
WHERE start_station_name IS NULL

-- counting the nulls in end_station_name

SELECT COUNT(*) FROM all_months 
WHERE end_station_name IS NULL

-- counting nulls in end_lat

SELECT COUNT(*) FROM all_months 
WHERE end_lat IS NULL


-- counting nulls in end_lng

SELECT COUNT(*) FROM all_months 
WHERE end_lng IS NULL

-- time in minutes

select FLOOR(EXTRACT(EPOCH FROM(ended_at - started_at)/60)) from all_months
