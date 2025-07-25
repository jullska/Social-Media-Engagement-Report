-- Creating empty table
CREATE TABLE raw_posts (
	post_id INTEGER PRIMARY KEY,
	platform_ VARCHAR(25),
	post_type VARCHAR(25),
	post_time DATETIME,
	likes INTEGER,
	comments INTEGER,
	shares INTEGER,
	post_day VARCHAR(15),
	sentiment_score VARCHAR(10)
);

-- Insert data to table from downloaded file from kaggle
BULK INSERT raw_posts
FROM 'D:\Power Bi\Social Media\social_media_engagement1.csv'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
);

-- Creating dimension and facts tables

-- Table with name of platform
CREATE TABLE dim_platform (
	platform_id INTEGER IDENTITY(1,1) PRIMARY KEY,
	platform_name VARCHAR(25) UNIQUE NOT NULL
);

-- Table with type of post
CREATE TABLE dim_post_type (
		post_type_id INTEGER IDENTITY (1,1) PRIMARY KEY,
		post_type VARCHAR(25) UNIQUE NOT NULL
);

-- Table with date of posting
CREATE TABLE dim_time (
	time_id INT IDENTITY (1,1) PRIMARY KEY,
	post_time DATETIME,
	post_day VARCHAR(15),
	hour INT,
	date DATE,
	CONSTRAINT uc_time UNIQUE(post_time)
);

-- Fact table
CREATE TABLE fact_post (
	post_id INT PRIMARY KEY,
	platform_id INT,
	post_type_id INT,
	time_id INT,
	likes INT,
	comments INT,
	shares INT,
	sentiment_score VARCHAR(15),
	FOREIGN KEY (platform_id) REFERENCES dim_platform(platform_id),
	FOREIGN KEY (post_type_id) REFERENCES dim_post_type(post_type_id),
	FOREIGN KEY (time_id) REFERENCES dim_time(time_id)
);

-- Insert data to dimension tables

INSERT INTO dim_platform (platform_name)
SELECT DISTINCT platform_ FROM raw_posts
WHERE platform_ IS NOT NULL;


INSERT INTO dim_post_type (post_type)
SELECT DISTINCT post_type FROM raw_posts
WHERE post_type IS NOT NULL;


INSERT INTO dim_time (post_time, post_day, hour, date)
SELECT DISTINCT
    CAST(post_time AS DATETIME) AS post_time,
    DATENAME(WEEKDAY, CAST(post_time AS DATETIME)) AS post_day,
    DATEPART(HOUR, CAST(post_time AS DATETIME)) AS hour,
    CAST(CAST(post_time AS DATETIME) AS DATE) AS date
FROM raw_posts
WHERE ISDATE(post_time) = 1;

-- Insert data to fact table
INSERT INTO fact_post (
    post_id,
    platform_id,
    post_type_id,
    time_id,
    likes,
    comments,
    shares,
    sentiment_score
)
SELECT
    rp.post_id,
    dp.platform_id,
    dpt.post_type_id,
    dt.time_id,
    rp.likes,
    rp.comments,
    rp.shares,
    rp.sentiment_score
FROM raw_posts rp
JOIN dim_platform dp
    ON rp.platform_ = dp.platform_name
JOIN dim_post_type dpt
    ON rp.post_type = dpt.post_type
JOIN dim_time dt
    ON CAST(rp.post_time AS DATETIME) = dt.post_time;

SELECT * FROM fact_post;

-- Adding another dimension table
CREATE TABLE dim_sentiment (
    sentiment_id INT IDENTITY(1,1) PRIMARY KEY,
    sentiment_label VARCHAR(20) UNIQUE
);

INSERT INTO dim_sentiment (sentiment_label)
SELECT DISTINCT sentiment_score
FROM raw_posts
WHERE sentiment_score IS NOT NULL;

-- Changing column with sentiment from fact table
ALTER TABLE fact_post
ADD sentiment_id INT FOREIGN KEY REFERENCES dim_sentiment(sentiment_id);

UPDATE fp
SET fp.sentiment_id = ds.sentiment_id
FROM fact_post fp
JOIN raw_posts rp ON fp.post_id = rp.post_id
JOIN dim_sentiment ds ON rp.sentiment_score = ds.sentiment_label;

ALTER TABLE fact_post
DROP COLUMN sentiment_score;