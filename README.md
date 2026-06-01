**Project Overview**

This project is an SQL-based analysis of the Superstore dataset, a fictional retail company selling office supplies, furniture, and technology products.
The goal of this project is to explore key business areas such as sales performance, customer behavior, product profitability, returns, and shipping efficiency.

**Objectives**

The main questions answered in this analysis include:
- What is the overall sales and profit performance?
- Which products and categories are the most/least profitable?
- Which customer segments generate the highest sales?
- How do customers behave in terms of orders and returns?
- How efficient is the shipping process?

**Dataset Description**

The dataset consists of the following tables:
- orders – order-level information (order date, ship date, customer ID, shipping mode)
- customers – customer details and segments
- products – product information (category, sub-category, product name)
- order_items – sales, profit, quantity, discount per product per order
- returns – information about returned orders

**Key Analysis**
- **Overview**
  - Total sales and total profit
  - Number of orders
- **Product Analysis**
  - Most profitable products
  - Products generating losses
  - Sales by sub-category
  - Profit margin by category
- **Customer Analysis**
  - Sales by customer segment
  - Customer order frequency and segmentation (New / Regular / Loyal)
  - Global customer ranking based on sales
  - Ranking within segments
- **Returns Analysis**
  - Products with the highest return rate
  - Customers with no returns
- **Shipping Analysis**
  - Average shipping time by shipping mode
  - Orders with above-average delivery time
  - Shipping mode with the highest number of returns

**SQL Concepts Used**
- SELECT, WHERE, GROUP BY
- JOINs
- Subqueries
- Common Table Expressions
- CASE WHEN
- Aggregate functions
- Window functions

**Key insights**
- The Canon imageCLASS 2200 Advanced Copier was the most profitable product, generating more than three times higher profit than the second-ranked product. Additionally, products from Technology category dominated the top five most profitable products.
- The Cubify CubeX 3D Printer Double Head Print generated a significantly higher loss than any other product, with a negative profit exceeding the second-ranked product by more than 4,000.
- Phones generated the highest total sales among all product sub-categories.
- Consumer segment generates the highest sales.
- Sean Miller generated the highest total sales among all customers, ranking first with over 25,000 in total revenue.
- Product OFF-PA-10001970 has relatively high return rate compared to the total number of orders placed.
- Standard Class shows both the highest return volume and the longest average shipping time, which may indicate that longer delivery times are associated with a higher probability of product returns.
