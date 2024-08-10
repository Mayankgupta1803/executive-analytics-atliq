#CODEBASICS_SQL_PROJECT_CHALLENGE

#TASK 1
-- 1. Provide the list of markets in which customer "Atliq Exclusive" operates its 
-- 		business in the APAC region

select distinct market from gdb023.dim_customer
where customer = "Atliq Exclusive" and region = "APAC";


#TASK 2
-- What is the percentage of unique product increase in 2021 vs. 2020?
-- 	  the final output contains these fields-> unique_products_2020, unique_products_2021, percentage_chg 

create temporary table temp_prd_year as
select product_code, fiscal_year from gdb023.fact_gross_price
where fiscal_year in (2020, 2021);

select count(distinct product_code) into @unique_prd_year_2020
from temp_prd_year
where fiscal_year =2020;

select count(distinct product_code) into @unique_prd_year_2021
from gdb023.temp_prd_year
where fiscal_year =2021;

select 
	@unique_prd_year_2020 unique_prd_2020,
    @unique_prd_year_2021 unique_prd_2021,
    ((@unique_prd_year_2021 - @unique_prd_year_2020)/@unique_prd_year_2020)*100 as 'percentage change';
    
## Another way to approach same question

with distinct_prd_year as (
select distinct product_code,fiscal_year
from gdb023.fact_gross_price)

select
	sum(case when fiscal_year =2020 then 1 else 0 end) unique_products_2020,
    sum(case when fiscal_year = 2021 then 1 else 0 end) unique_products_2021,
    ((sum(case when fiscal_year =2021 then 1 else 0 end) - sum(case when fiscal_year = 2020 then 1 else 0 end))/sum(case when fiscal_year = 2020 then 1 else 0 end))*100 as 'percentage_growth'
from distinct_prd_year;


#TASK 3
-- Provide a report with all the unique product counts for each segment and sort them in descending order of product counts. 
-- The final output contains 2 fields-> segment and product_count

select segment, count(distinct product_code) product_count
from gdb023.dim_product
group by segment
order by product_count Desc;


#TASK 4
-- Which segment had the most increase in unique products in 2021 vs 2020? 
-- The final output contains these fields-> segment , product_count_2020, product_count_2021,difference

with cte_20_21 as (
select dim_product.segment, fact_sales_monthly.fiscal_year, dim_product.product_code
from dim_product
join fact_sales_monthly
on dim_product.product_code = fact_sales_monthly.product_code
where fiscal_year in (2020,2021)
)
select segment ,
	count(distinct case when fiscal_year =2020 then product_code end) unique_product_2020,
    count(distinct case when fiscal_year = 2021 then product_code end) unique_product_2021,
    (count(distinct case when fiscal_year =2021 then product_code end) - 
     count(distinct case when fiscal_year = 2020 then product_code end)) 'difference'
from cte_20_21
group by segment
order by difference Desc
limit 1;


#TASK 5
-- Get the products that have the highest and lowest manufacturing costs.
-- The final output should contain these fields -> product_code, product, manufacturing_cost

select p.product_code, p.product,m.cost_year, m.manufacturing_cost
from dim_product p
join fact_manufacturing_cost m
on m.product_code = p.product_code
where m.manufacturing_cost = (select max(manufacturing_cost) from fact_manufacturing_cost)
or m.manufacturing_cost = (select min(manufacturing_cost) from fact_manufacturing_cost)
order by m.manufacturing_cost Desc;

#TASK 6
-- Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market. 
-- The final output contains these fields-> customer_code, customer, average_discount_percentage

with cte_top_customer as (
select dim_customer.customer_code, dim_customer.customer,
		fact_pre_invoice_deductions.fiscal_year, fact_pre_invoice_deductions.pre_invoice_discount_pct
from gdb023.dim_customer 
join fact_pre_invoice_deductions
on dim_customer.customer_code = fact_pre_invoice_deductions.customer_code
where fact_pre_invoice_deductions.fiscal_year =2021 and dim_customer.market = "India")
-- select avg(pre_invoice_discount_pct) from cte_top_customer;
select distinct customer_code,customer, sum(pre_invoice_discount_pct) average_discount_percentage from cte_top_customer 
where pre_invoice_discount_pct > (select avg(pre_invoice_discount_pct) from cte_top_customer)
group by customer_code, customer
order by average_discount_percentage desc
limit 5;


#TASK 7
-- 7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month.
-- This analysis helps to get an idea of low and high-performing months and take strategic decisions.
-- The final report contains these columns: Month, Year, Gross sales Amount

drop temporary table if exists temp_Atliqex_sales;
create temporary table temp_Atliqex_sales as
select dim_customer.customer_code, customer, platform,date as dates, fact_gross_price.product_code,
		sold_quantity, gross_price, fact_sales_monthly.fiscal_year
from dim_customer
join fact_sales_monthly on fact_sales_monthly.customer_code = dim_customer.customer_code
join fact_gross_price on fact_gross_price.product_code = fact_sales_monthly.product_code
where customer = "Atliq Exclusive";

select monthname(dates) months,year(dates) years, 
		concat(format(sum(gross_price * sold_quantity)/1000000,2),"M") gross_sales_amount
from temp_Atliqex_sales
group by months,month(dates), years
order by years,month(dates),months Asc;


#TASK 8
-- In which quarter of 2020, got the maximum total_sold_quantity? 
-- The final output contains these fields sorted by the total_sold_quantity-> Quarter,total_sold_quantity

select 
	case 
		when month(date) between 9 and 11 then "Q1"
		when month(date) in (12,1, 2) then "Q2"
        when month(date) between 3 and 5 then "Q3"
        when month(date) between 6 and 8 then "Q4"
	end 'Quarter',
	concat(format(sum(sold_quantity)/1000000,2),"M") total_sold_quantity 
from fact_sales_monthly
where fiscal_year =2020
group by Quarter
order by Quarter ASC;


#TASK 9
-- Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? 
-- The final output contains these fields: channel, gross_sales_mln, percentage

with temp_table as 
(
select channel, round(sum(gross_price*sold_quantity)/1000000,2) 'gross_sales_in_million' from dim_customer
join fact_sales_monthly on fact_sales_monthly.customer_code = dim_customer.customer_code
join fact_gross_price on fact_gross_price.product_code = fact_sales_monthly.product_code
where fact_sales_monthly.fiscal_year =2021
group by channel
order by gross_sales_in_million Desc
)

select 
	channel, 
    gross_sales_in_million,
    round((gross_sales_in_million/(select sum(gross_sales_in_million) from temp_table))*100,2) as percentage
from temp_table
group by channel;


#TASK 10
-- Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021?
-- The final output contains these fields: division,product_code,product,total_sold_quantity,rank_order

with top_product as
(
select 
	division,
    dim_product.product_code,
    product,
    sum(sold_quantity) total_sold_quantity
from dim_product
join fact_sales_monthly on fact_sales_monthly.product_code = dim_product.product_code
where fiscal_year=2021
group by division, product_code,product
),
top_product1 as
(
select 
	division,
    product_code,
    product,
	total_sold_quantity,
    row_number() over(partition by division order by total_sold_quantity Desc) rnk
from top_product
)
select * from top_product1
where rnk<=3;