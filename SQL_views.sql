-- Creating view with average engagement and sum of published posts grouping by platform
GO
CREATE VIEW PlatformbyEngagement AS
SELECT
	dp.platform_name,
	ROUND(AVG(f.likes + f.comments + f.shares),2) as AvgEngagement,
	COUNT(f.post_id) as TotalPosts
FROM fact_post f
JOIN dim_platform dp ON f.platform_id = dp.platform_id
GROUP BY dp.platform_name;

SELECT * FROM PlatformbyEngagement;

-- Creating view with average engagement grouping by weekday of publishing
GO
CREATE VIEW Bestday AS
SELECT
	dt.post_day,
	AVG(f.likes + f.comments + f.shares) as AvgEngagement
FROM fact_post f
JOIN dim_time dt ON f.time_id = dt.time_id
GROUP BY dt.post_day;

SELECT * FROM Bestday
ORDER BY AvgEngagement DESC;

GO

-- Creating view with top post by sum of engagement
CREATE VIEW Toppost AS
SELECT
	f.post_id,
	dp.platform_name,
	dpt.post_type,
	dt.post_time,
	SUM(f.likes)+ SUM(f.comments) + SUM(f.shares) as Engagement
FROM fact_post f
JOIN dim_platform dp ON f.platform_id = dp.platform_id
JOIN dim_post_type dpt ON f.post_type_id = dpt.post_type_id
JOIN dim_time dt ON f.time_id = dt.time_id
GROUP BY dp.platform_name, dpt.post_type, f.post_id, dt.post_time;

SELECT * FROM Toppost
ORDER BY Engagement DESC;

-- Creating view with sum of engagement grouping by hour of publishing
GO
CREATE VIEW HoursEngagement AS
SELECT
	dt.hour AS BestHour,
	SUM(f.likes)+ SUM(f.comments) + SUM(f.shares) as Engagement
FROM fact_post f
JOIN dim_time dt ON f.time_id = dt.time_id
GROUP BY dt.hour;

SELECT * FROM HoursEngagement
ORDER BY Engagement DESC;

-- Creating view with publishing time and post engagement
GO
CREATE VIEW EngagementTime AS
SELECT
    dt.post_time,
    SUM(fp.likes) AS total_likes,
    SUM(fp.comments) AS total_comments,
    SUM(fp.shares) AS total_shares,
	SUM(fp.likes + fp.comments + fp.shares) AS total_engagement
FROM fact_post fp
JOIN dim_time dt ON fp.time_id = dt.time_id
GROUP BY dt.post_time;

SELECT * FROM EngagementTime
ORDER BY total_engagement DESC;


-- Creating view with engagement grouping by type of post
GO
CREATE VIEW EngagementPost AS
SELECT 
	dpt.post_type,
	AVG(f.likes) AS AvgLikes,
	AVG(f.comments) AS AvgComments,
	AVG(f.shares) AS AvgShares,
	AVG(f.likes + f.comments + f.shares) AS TotalAvgEngagement
FROM fact_post f
JOIN dim_post_type dpt ON f.post_type_id = dpt.post_type_id
GROUP BY dpt.post_type;

SELECT * FROM EngagementPost
ORDER BY TotalAvgEngagement DESC;


-- Creating view with sentiment on the platform
GO
CREATE VIEW SentimentbyPlatform AS
SELECT
	dp.platform_name,
	ds.sentiment_label,
	COUNT(f.post_id) AS PostCount
FROM fact_post f
JOIN dim_sentiment ds ON f.sentiment_id = ds.sentiment_id
JOIN dim_platform dp ON f.platform_id = dp.platform_id
GROUP BY dp.platform_name, ds.sentiment_label;

SELECT * FROM SentimentbyPlatform
ORDER BY platform_name DESC, PostCount DESC;


-- Creating view with all dimensions
GO
CREATE VIEW vw_post_enriched AS
SELECT
    fp.post_id,
    dp.platform_name,
    dpt.post_type,
    dt.post_time,
    dt.post_day,
    fp.likes,
    fp.comments,
    fp.shares,
    (fp.likes + fp.comments + fp.shares) AS total_engagement,
    ds.sentiment_label
FROM fact_post fp
JOIN dim_platform dp ON fp.platform_id = dp.platform_id
JOIN dim_post_type dpt ON fp.post_type_id = dpt.post_type_id
JOIN dim_time dt ON fp.time_id = dt.time_id
JOIN dim_sentiment ds ON fp.sentiment_id = ds.sentiment_id;

SELECT * FROM vw_post_enriched;