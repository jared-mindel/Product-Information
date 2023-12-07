# Product-Information #
This pbix report is an example of my skills and capabilities as a Power BI report developer and a SQL coder. The SQL code for view creation is available as 
the [Product Information View](https://github.com/jared-mindel/Product-Information/blob/main/Product%20Information%20View.sql) file, and the PBIX file with all of the visuals and DAX formulas
is available in the [Product Information](https://github.com/jared-mindel/Product-Information/blob/main/Product%20Information.pbix) file, but I will include code blocks and images in this
README for the sake of efficiency. 

## View Creation ##
This small project uses the [AdventureWorks2019 database](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms), 
which is available for free from Microsoft. This report only looks at the product-level, so the view and report will look at information concerning products available in the various
Production tables in AdventureWorks2019, like Production.Product, Production.Location, etc. The view itself is defined as follows:

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

## SELECT Statement ##

I included the 
```sql
USE AdventureWorks2019
GO
```
portion because I want to be able to run the query without the need to click on the database name first. It simply saves time.

Beyond that, I created a view because while all of this data is available in various tables, I don't need every field that is in each table. Creating a single view is simply easier on Power BI - and on myself - 
than loading each table into Power BI. 

I used the 
```sql
SELECT DISTINCT
```
statement because, again, I'm looking at a product level, and I do not want duplicates. 

Most of the fields are left unchanged, though I use occasional 
```sql
AS 
```
statement to make names clearer, as there are multiple fields called "name" from different tables. This is appropriate for each individual table, but when bringing each field to the view, it would be confusing to leave 
all of them that way. However, I included a case statement to define what I believe are cheap, mid-range, and expensive products based on their price. 

## FROM Statement and JOINs ##
This is a somewhat complex joining of tables, but it nonetheless was necessary for each of the fields we want in the report. We start with the 
```sql
FROM Production.Product p
```
statement because Production.Product is our driving table. It has the level of granularity that we want, which is each individual product. After that, we have the following:


