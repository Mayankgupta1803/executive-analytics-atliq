# Atliq Hardwares SQL Challenge

## Overview

This repository contains my submission for the SQL challenge conducted by Atliq Hardwares, a leading computer hardware producer in India. The challenge was designed to assess my technical and soft skills as a data analyst, focusing on my ability to extract and present business insights from a structured database. The target audience for this project is top-level management, and the objective is to provide actionable insights to support data-driven decision-making.

## Repository Contents

- **SQL Queries**: A collection of SQL queries to address the 10 ad hoc business requests provided in the challenge.
- **Presentation**: A creative presentation showcasing the insights derived from the SQL queries, tailored for top-level management.
- **Data Overview**: A detailed description of the tables used in this project.

## Database Structure

The database used for this challenge is `gdb023` (referred to as `atliq_hardware_db`). It consists of six main tables:

### 1. dim_customer
Contains customer-related data.
- `customer_code`: Unique identification code for each customer.
- `customer`: Name of the customer.
- `platform`: Sales platform (e.g., Brick & Mortar, E-Commerce).
- `channel`: Distribution method (e.g., Retailers, Direct, Distributors).
- `market`: Country where the customer is located.
- `region`: Geographic region (e.g., APAC, EU, NA, LATAM).
- `sub_zone`: Sub-regions within the main regions (e.g., India, ANZ, SE, NE).

### 2. dim_product
Contains product-related data.
- `product_code`: Unique identification code for each product.
- `division`: Product group (e.g., P & A, N & S, PC).
- `segment`: Further categorization within the division (e.g., Peripherals, Accessories).
- `category`: Specific subcategories within the segment.
- `product`: Name of the product.
- `variant`: Different versions of the product (e.g., Standard, Plus, Premium).

### 3. fact_gross_price
Contains gross price information for each product.
- `product_code`: Unique identification code for each product.
- `fiscal_year`: Fiscal year of the recorded sale (e.g., 2020, 2021).
- `gross_price`: Initial price of the product before deductions or taxes.

### 4. fact_manufacturing_cost
Contains the cost incurred in the production of each product.
- `product_code`: Unique identification code for each product.
- `cost_year`: Fiscal year of the recorded manufacturing cost.
- `manufacturing_cost`: Total cost of production including raw materials, labor, and overhead expenses.

### 5. fact_pre_invoice_deductions
Contains pre-invoice deductions information for each product.
- `customer_code`: Unique identification code for each customer.
- `fiscal_year`: Fiscal year of the recorded sale.
- `pre_invoice_discount_pct`: Percentage of pre-invoice deductions applied to the gross price.

### 6. fact_sales_monthly
Contains monthly sales data for each product.
- `date`: Date of the sale in monthly format for fiscal years 2020 and 2021.
- `product_code`: Unique identification code for each product.
- `customer_code`: Unique identification code for each customer.
- `sold_quantity`: Number of units sold.
- `fiscal_year`: Fiscal year of the recorded sale.

## How to Use

1. **SQL Queries**: Run the SQL queries provided in the `.sql` file to extract the required insights from the database.
2. **Presentation**: Review the presentation file to see how the extracted data is transformed into insights for top-level management.
3. **Data Structure**: Familiarize yourself with the database structure and column descriptions provided above to understand the context of the data.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or feedback, feel free to reach out to me via [LinkedIn](https://www.linkedin.com/in/mayankgupta).
