
-- finding the null ride_id in classic_bike/rideable_type

WITH station_nulls AS
(
	SELECT ride_id AS null_rider FROM
	(SELECT ride_id, rideable_type, start_station_name, end_station_name
	 FROM all_months
     WHERE rideable_type = 'classic_bike' OR rideable_type = 'docked_bike'
	) AS some_bikes
	WHERE start_station_name IS NULL OR
	end_station_name IS NULL
),

-- returning all latitude and longtitute that do not have any nulls

cleaned_stations as (
SELECT * 
	FROM 
	all_months am
	LEFT JOIN station_nulls sn
	ON am.ride_id = sn.null_rider
	WHERE 
      am.start_lat IS NOT NULL AND
      am.start_lng IS NOT NULL AND
      am.end_lat IS NOT NULL AND
      am.end_lng IS NOT NULL
	
),

-- Removing the reparing and maintenance stations

Reparing_stations as
 (
	select * FROM 
 	cleaned_stations
 	where  
	  start_station_name <> 'DIVVY CASSETTE REPAIR MOBILE STATION' AND
      start_station_name <> 'Lyft Driver Center Private Rack' AND 
      start_station_name <> '351' AND 
      start_station_name <> 'Base - 2132 W Hubbard Warehouse' AND 
      start_station_name <> 'Hubbard Bike-checking (LBS-WH-TEST)' AND 
      start_station_name <> 'WEST CHI-WATSON' AND 
      end_station_name <> 'DIVVY CASSETTE REPAIR MOBILE STATION' AND
      end_station_name <> 'Lyft Driver Center Private Rack' AND 
      end_station_name <> '351' AND 
      end_station_name <> 'Base - 2132 W Hubbard Warehouse' AND 
      end_station_name <> 'Hubbard Bike-checking (LBS-WH-TEST)' AND 
      end_station_name <> 'WEST CHI-WATSON'
	 ),
	 
--   Replacening the docked_bike to classic_bike
--   Trim the start and end station names
--   Extracting the day,months and years

 aggregating_data as (
 	select 
 	      ride_id,
 	      REPLACE(rideable_type, 'docked_bike', 'classic_bike') as rides,
 	      TRIM(start_station_name) as Departure,
	      TRIM(end_station_name) as Arrival,
 	      to_char(started_at, 'Day') as day,
 	      to_char(started_at, 'Month') as month,
 	      extract(year from started_at) as year,
 	      FLOOR(EXTRACT(EPOCH FROM (ended_at-started_at)/60)) as mins,
	      EXTRACT(HOUR FROM started_at) as hours,
	      start_lat,
 	      end_lat,
	      start_lng,
 	      end_lng,
 	      member_casual as member_type     
 	FROM
 	      Reparing_stations

),

-- Returning the rides in between 1 min and 24 hrs 

cleaned_data_in_mins as (
	SELECT * FROM aggregating_data
	WHERE mins > 1 AND mins < 1440
),

-- The data is clean to analyze now time for analyzing



-- Return the average journey length

avg_joun_length as (
SELECT member_type, AVG(mins) AS joun_len
	FROM cleaned_data_in_mins
	GROUP BY member_type
),

-- Return Rides per day

rides_per_day as (
SELECT member_type, DAY, COUNT(*) AS per_day_rides
	FROM cleaned_data_in_mins
	GROUP BY member_type, DAY
),

-- Return Rides per months

rides_per_months AS (
SELECT member_type, month, count(*) AS per_months_ride
	FROM cleaned_data_in_mins
	GROUP BY member_type, month
	ORDER BY member_type
),

-- Return Rides per hour

rides_per_hour as (
SELECT member_type, hours, count(*) AS per_hours_ride
	FROM cleaned_data_in_mins
	GROUP BY member_type, hours
),

-- Return Maximum rides_length group by member_type

max_ride_length AS (
SELECT member_type, MAX(hours) as max_ride_hours
	FROM cleaned_data_in_mins
	GROUP BY member_type
),

-- return average length of rides per day

perday_avg_len AS (
SELECT member_type, DAY, AVG(mins) as perday_avg_len
	FROM cleaned_data_in_mins
	GROUP BY member_type, day
)

SELECT * FROM perday_avg_len
