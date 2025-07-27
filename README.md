# Social-Media-Engagement-Report
Power BI project exploring social media engagement patterns + SQL
---

## Dataset

- Source: [Kaggle – Social Media Engagement Dataset](https://www.kaggle.com/datasets/divyaraj2006/social-media-engagement)
- Contains information on post metadata, engagement metrics, time of publication, platform and sentiment.
- Columns: `post_id`, `platform`, `post_type`, `post_time`, `likes`, `comments`, `shares`, `post_day`, `sentiment_score`

---

## Technologies Used

- **SQL Server** – database normalization, star schema, views
- **Power BI** – data visualization, DAX measures, KPI analysis

---

## Data Model

Structured using a **star schema**:
- **Fact Table**: 'fact_post' (likes, comments, shares)
- **Dimension Tables**:
  - 'dim_platform'
  - 'dim_post_type'
  - 'dim_time'
  - 'dim_day'
  - 'dim_sentiment'

Additional views were created to simplify analysis and reporting in Power BI.

---

## Dashboard Pages

| Page | Title                   | Description |
|------|-------------------------|-------------|
|1️⃣   | **Landing Page**         | Report intro, navigation buttons, no KPIs |
| 2️⃣   | **Engagement Overview**  | Top platforms, total metrics, engagement |
| 3️⃣   | **Content Performance**     | Performance by post type and sentiment |
| 4️⃣   | **Time-Based Performance**  | Best days/hours, posting trends over time |

File: '/powerbi/SM Report.pbix'  
Screenshots: available in '/screenshots' folder

---

## Key Insights

- The **best hour for engagement** is **1:00 AM**, while the **highest overall engagement** was recorded for posts published at **midnight**.
- **Wednesdays** consistently yield the **highest average engagement** across all post types and platforms.
- **Carousel posts** receive the **most comments and shares on average**, suggesting they encourage user interaction - worth focusing more on this content type.
- **Instagram posts** show **the most sentiment variation**, and hold the **highest proportion of negative sentiment**.
- **Polls** tend to receive more **engagement on negatively perceived posts**, indicating a need to reconsider poll tone or phrasing.
- There is a **gradual decline in engagement** across the dataset - possibly signaling content fatigue or timing misalignment.
- Despite assumptions, **Twitter posts** are generally received **positively**, with very **low levels of negative sentiment**.

---

## Author

Created by Julia Stróżyńska  
Email: julia.strozynska@onet.pl 
LinkedIn: (https://www.linkedin.com/in/julia-strozynska)

---

## Feedback Welcome!

If you have suggestions or feedback, feel free to open an issue or connect with me on LinkedIn!
