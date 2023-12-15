-- Cleansed DIM_Custimers Table-- 
SELECT 
  c.customerkey AS CustomerKey, 
  --,[GeographyKey]
  --,[CustomerAlternateKey]
  --,[Title]
  c.firstname AS [FirstName], 
  --,[MiddleName]
  c.lastname AS [LastName], 
  c.firstname + ' ' + c.lastname AS [FullName],
  --,[NameStyle]
  --,[BirthDate]
  --,[MaritalStatus]
  --,[Suffix]
  c.gender as [GenderLetter],
  CASE c.gender WHEN 'M' then 'Male' WHEN 'F' then 'Female' END AS [Gender], 
  --,[EmailAddress]
  --,[YearlyIncome]
  --,[TotalChildren]
  --,[NumberChildrenAtHome]
  --,[EnglishEducation]
  --,[SpanishEducation]
  --,[FrenchEducation]
  --,[EnglishOccupation]
  --,[SpanishOccupation]
  --,[FrenchOccupation]
  --,[HouseOwnerFlag]
  --,[NumberCarsOwned]
  --,[AddressLine1]
  --,[AddressLine2]
  --,[Phone]
  c.datefirstpurchase AS [DateFirstPurchase], 
  --,[CommuteDistance]
  g.city AS [Customer City] -- Joined in Customer City from DimGeography Table 
FROM 
  [dbo].[DimCustomer] AS c 
  left join dbo.DimGeography AS g ON g.GeographyKey = c.GeographyKey 
ORDER BY 
  CustomerKey ASC -- Ordered List by CustomerKey
