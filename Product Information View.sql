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
				THEN 'Very Expensive'
		END AS "Price Category"

	FROM 
		Production.Product p 
		LEFT JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
		LEFT JOIN Production.ProductCategory pc ON pc.ProductCategoryID = psc.ProductCategoryID
		LEFT JOIN Production.ProductReview pr ON p.ProductID = pr.ProductID
		LEFT JOIN Production.ProductInventory piv ON p.ProductID = piv.ProductID
		LEFT JOIN Production.Location l ON piv.LocationID = l.LocationID

)
