SELECT * FROM fact_post;
SELECT * FROM dim_time;

-- Show post type count
SELECT 
	dpt.post_type AS PostType, 
	COUNT(*) AS PostCount
FROM fact_post f
JOIN dim_post_type dpt ON f.post_type_id = dpt.post_type_id
GROUP BY dpt.post_type
ORDER BY PostCount DESC;

-- Show average of likes, comments and shares by platform
SELECT
	dp.platform_name,
	AVG(f.likes) AS AvgLikes,
	AVG(f.comments) AS AvgComments,
	AVG(f.shares) AS AvgShares
FROM fact_post f
JOIN dim_platform dp ON f.platform_id = dp.platform_id
GROUP BY dp.platform_name;


-- Show sum of engagement grouping by hour of publishing 
SELECT
	dt.hour AS BestHour,
	SUM(f.likes)+ SUM(f.comments) + SUM(f.shares) as Engagement
FROM fact_post f
JOIN dim_time dt ON f.time_id = dt.time_id
GROUP BY dt.hour
ORDER BY Engagement DESC;

-- Show 10 post with the most engagement
SELECT TOP 10
	f.post_id,
	dp.platform_name,
	dpt.post_type,
	dt.post_time,
	SUM(f.likes)+ SUM(f.comments) + SUM(f.shares) as Engagement
FROM fact_post f
JOIN dim_platform dp ON f.platform_id = dp.platform_id
JOIN dim_post_type dpt ON f.post_type_id = dpt.post_type_id
JOIN dim_time dt ON f.time_id = dt.time_id
GROUP BY dp.platform_name, dpt.post_type, f.post_id, dt.post_time
ORDER BY Engagement DESC;


-- Show average engagement grouping by weekday
SELECT
	dt.post_day,
	AVG(f.likes)+ AVG(f.comments) + AVG(f.shares) as AvgEngagement
FROM fact_post f
JOIN dim_time dt ON f.time_id = dt.time_id
GROUP BY dt.post_day
ORDER BY AvgEngagement DESC;


-- Show average engagement grouping by platform
SELECT
	dp.platform_name,
	AVG(f.likes)+ AVG(f.comments) + AVG(f.shares) as AvgEngagement
FROM fact_post f
JOIN dim_platform dp ON f.platform_id = dp.platform_id
GROUP BY dp.platform_name
ORDER BY AvgEngagement DESC;

SELECT * FROM PlatformbyEngagement
ORDER BY AvgEngagement DESC;

SELECT * FROM BestDay
ORDER BY AvgEngagement DESC;

SELECT TOP 10 * FROM Toppost
ORDER BY Engagement DESC;

SELECT * FROM HoursEngagement
ORDER BY Engagement DESC;
