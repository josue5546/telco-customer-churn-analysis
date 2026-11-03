# Customer Churn Analysis & Retention Strategy

**Business & Data Analytics Portfolio Project**

**Tools:** Excel Power Query | MySQL | Python | Power BI | ChatGPT (AI-Assisted)

## Project Overview

This project examines customer churn in a telecommunications business using 7,043 historical customer records.

The aim was to understand which customer groups had higher observed churn, identify where historical billing exposure was concentrated and recommend practical steps to improve customer retention.

The project combines data cleaning, SQL analysis, statistical testing, predictive modelling and business recommendations.

## Key Findings

- **26.54%** of customers in the dataset were recorded as churned.
- Month-to-month customers recorded **42.71%** churn, compared with **2.83%** for two-year contracts.
- Customers in their first 12 months recorded **47.44%** churn.
- Month-to-month, high-charge customers accounted for **50.98%** of historical churn-associated monthly billing.
- The narrower first-year, month-to-month, high-charge segment recorded **73.49%** churn.

A logistic regression model achieved an ROC-AUC of **0.8239** on historical held-out data.

## Business Recommendation

The analysis supports prioritising currently active first-year, month-to-month, high-charge customers for a controlled retention pilot.

The proposed intervention involves proactive customer-support check-ins, with results compared against a group receiving normal customer service.

Management should assess cancellation rates, implementation costs and financial value before considering a wider rollout.

No intervention has been implemented, and financial benefits remain unproven.

## Technical Approach

**Power Query:** Cleaned the dataset, handled missing values and checked data quality.

**MySQL:** Analysed churn by contract type, tenure and monthly charges, including combined customer segments and billing exposure.

**Python:** Conducted statistical tests and developed a logistic regression model.

**Power BI:** Created a four-page dashboard covering customer churn, billing exposure, management insights and model performance.

## AI Usage & Transparency

I used ChatGPT to support this project. AI helped me understand technical concepts, develop and troubleshoot code, structure the analytical approach, and prepare the written report and presentation.

My role involved working through the analysis in Power Query, MySQL, Python and Power BI, running and reviewing the analytical steps, checking the results and developing the business interpretation.

I used ChatGPT as a learning and, most importantly, a productivity tool.


## Project Deliverables

The project includes a Power BI dashboard, SQL analysis, Python modelling, a consulting report and a management presentation.

## Data Source

IBM Telco Customer Churn — a publicly available fictional telecommunications dataset.

**Limitations:** The findings describe historical associations, not proven causes of churn. Churn-associated monthly billing is not confirmed revenue loss.

---

*This project demonstrates how data analysis, AI-assisted workflows and business reasoning can support practical management decisions.*
