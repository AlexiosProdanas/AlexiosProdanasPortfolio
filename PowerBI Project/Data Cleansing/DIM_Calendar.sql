-- Cleansed DIM_DateTable -- 
SELECT 
  [DateKey], 
  [FullDateAlternateKey] as Date,  
  --,[DayNumberOfWeek] 
  
  [EnglishDayNameOfWeek] as Day,
  --,[SpanishDayNameOfWeek]
  --,[FrenchDayNameOfWeek]
  --,[DayNumberOfMonth]
  --,[DayNumberOfYear]
  --,[WeekNumberOfYear]
 
  [EnglishMonthName] as MonthName,
  left([EnglishMonthName],3) as Month,
  --,[SpanishMonthName]
  --,[FrenchMonthName]

  [MonthNumberOfYear] as MonthNumber, 
  [CalendarQuarter] as Quarter, 
  [CalendarYear] as Year
  --,[CalendarSemester]
  --,[FiscalQuarter]
  --,[FiscalYear]
  --,[FiscalSemester]
FROM [AdventureWorksDW2022].[dbo].[DimDate]
where CalendarYear >= 2019