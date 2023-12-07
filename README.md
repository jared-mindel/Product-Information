# Product Information #
This Power BI report exemplifies my proficiency as a Power BI report developer and SQL coder. The SQL code for view creation is accessible in the 
[Product Information View](https://github.com/jared-mindel/Product-Information/blob/main/Product%20Information%20View.sql) file. Additionally, the PBIX file containing all visuals and DAX formulas can be found in the  [Product Information](https://github.com/jared-mindel/Product-Information/blob/main/Product%20Information.pbix) file. For the sake of efficiency, code blocks and images are included directly in this README.

## View Creation ##
This project leverages the [AdventureWorks2019 database](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms), 
freely available from Microsoft. Focused solely on the product level, the view and report provide insights into product-related information from various Production tables in AdventureWorks2019, such as Production.Product and Production.Location. The view is defined as follows:

```sql
USE AdventureWorks2019
GO

CREATE OR ALTER VIEW "Product Information" AS (
	SELECT DISTINCT
		p.Name AS "Product",
		p.StandardCost AS "Cost",
		p.ListPrice AS "Price",
		p.Color,
		p.Size,
		p.Weight,
		p.Class,
		p.Style,
		p.DiscontinuedDate,
		pc.Name AS "Product Category",
		psc.Name AS "Product Subcategory",
		pr.Rating,
		pr.Comments,
		l.Name AS "Location",
		CASE 
			WHEN 
				p.ListPrice < 1000
				THEN 'Cheap'
			WHEN 
				p.ListPrice BETWEEN 1000 AND 1999
				THEN 'Mid-Range'
			WHEN 
				p.ListPrice > 2000
				THEN 'Expensive'
		END AS "Price Category"

	FROM 
		Production.Product p 
		LEFT JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
		LEFT JOIN Production.ProductCategory pc ON pc.ProductCategoryID = psc.ProductCategoryID
		LEFT JOIN Production.ProductReview pr ON p.ProductID = pr.ProductID
		LEFT JOIN Production.ProductInventory piv ON p.ProductID = p.ProductID
		JOIN Production.Location l ON piv.LocationID = l.LocationID

)
```

### SELECT Statement ###

The inclusion of the
```sql
USE AdventureWorks2019
GO
```
portion streamlines query execution without the need to manually click on the database name. This is a time-saving measure.

Additionally, a single view was created to simplify Power BI integration, focusing on the necessary fields rather than loading each table separately. The 
```sql 
SELECT DISTINCT
```
statement ensures the exclusion of duplicates.

Field names remain mostly unchanged, with occasional
```sql
AS 
```
statements for clarity, particularly when multiple fields share the same name from different tables. A case statement categorizes products as 'Cheap,' 'Mid-Range,' or 'Expensive' based on their prices.

### FROM Statement and JOINs ###
The joining of tables is crucial for gathering the required fields for the report. Beginning with the 
```sql
FROM Production.Product p
```
statement as our driver table, subsequent LEFT JOIN operations with other tables like ```Production.ProductSubcategory``` and ```Production.Location``` ensure the inclusion of all product rows, even if some fields
contain NULL values. This approach allows for a comprehensive dataset, offering valuable insights into the product landscape. 
```sql
LEFT JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN Production.ProductCategory pc ON pc.ProductCategoryID = psc.ProductCategoryID
LEFT JOIN Production.ProductReview pr ON p.ProductID = pr.ProductID
LEFT JOIN Production.ProductInventory piv ON p.ProductID = piv.ProductID
LEFT JOIN Production.Location l ON piv.LocationID = l.LocationID
```

## Power BI Report ##

The Power BI report provides a streamlined and efficient visualization, featuring a data table and a table of measures. While the same report could have been created by importing individual tables into Power BI, utilizing the view ensures a more efficient process.

### DAX Measures and Calculated Columns ###
#### Gross Profit Measure ####

```
Gross Profit = 

AVERAGE('Product Information'[Price]) - AVERAGE('Product Information'[Cost])
```
The ```AVERAGE``` function is used for aggregation since measures require it. This choice optimizes storage space without altering values due to the unique nature of each product having a single cost value.

#### Markup Percentage Measure ####

```
Markup Percentage = 

DIVIDE(
    [Gross Profit], 
    AVERAGE('Product Information'[Cost])
)
```
Similar to the Gross Profit measure, the ```AVERAGE``` aggregator is employed for the cost field, maintaining efficiency.

#### Profit Margin Measure ####

```
Profit Margin = 

DIVIDE(
    [Gross Profit], 
    AVERAGE('Product Information'[Price])
)
```
The Profit Margin measure follows a comparable structure, providing a meaningful metric for analysis.

#### Relative Price Position Calculated Column ####

```
Relative Price Position = 
VAR Average_Price = 
CALCULATE(
    AVERAGE('Product Information'[Price]),
    ALL('Product Information')
) 
VAR Relative_Price_Position = 
DIVIDE(
    'Product Information'[Price] - Average_Price, 
    Average_Price
)

RETURN Relative_Price_Position
```
Utilizing variables for readability, the Relative Price Position calculated column considers the average price for all products, regardless of context.

#### Cost Efficiency Score Calculated Column ####
```
Cost Efficiency Score = 
VAR Average_Cost = 
    CALCULATE(
        AVERAGE('Product Information'[Cost]), 
        ALL('Product Information')
    )

VAR Cost_Efficiency_Score = 
    1 - 
    DIVIDE(
        'Product Information'[Cost], 
        Average_Cost, 
        0
    )

RETURN Cost_Efficiency_Score
```
The Cost Efficiency Score calculated column mirrors the structure of the Relative Price Position, providing an insightful metric.

### Visuals ###
Now that I've described the measures and calculated columns, let's look at the visuals I've created, going page-by-page. 

#### Product Category Distribution ####
![image](https://github.com/jared-mindel/Product-Information/assets/153224910/108c91b7-0236-4d87-919f-d51cdf4c61c6)

This page showcases the "Count of Product by Product Category" visual, indicating the distinct count of products in each category, accompanied by slicers for enhanced flexibility.

#### Average Gross Profit by Product Category ####
![image](https://github.com/jared-mindel/Product-Information/assets/153224910/ced56abb-d4a0-4ceb-ab82-a1880ecfa57f)

Similar to the Product Category Distribution, this page introduces the average gross profit by product category, providing a different perspective on the data.

#### Gross Profit by Cost Efficiency Score ####
![image](https://github.com/jared-mindel/Product-Information/assets/153224910/2416604c-4c7b-49b7-9991-afb3fe9efb71)

A scatterplot on this page reveals an intriguing relationship between Cost Efficiency Score and Gross Profit, challenging expectations and encouraging further analysis.

#### Product Details ####
![image](https://github.com/jared-mindel/Product-Information/assets/153224910/9f727fbf-453f-43c4-8ed7-c8752e3cd4e2)

The final page presents a detailed table containing all relevant product data, catering to users who prefer custom analysis through data exports.

## Conclusion ##
This project serves as a comprehensive demonstration of my proficiency in SQL and Power BI. The ability to seamlessly create a view in SQL Server Management Studio and integrate the data into a Power BI report, complete with DAX measures and calculated columns, showcases my versatility and skills. I trust you found this project insightful and engaging. Thank you for your time!


