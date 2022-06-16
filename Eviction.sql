/*Data Cleaning and Exploration

This dataset lists pending, scheduled and executed evictions within the five boroughs, for the year 2017 - Present.
The data fields may be sorted by Court Index Number, Docket Number, Eviction Address, Apartment Number, Executed Date, Marshal First Name,
Marshal Last Name, Residential or Commercial (property type), Borough, Zip Code and Scheduled Status (Pending/Scheduled).

Eviction data is compiled from the majority of New York City Marshals.

Dataset description available: https://data.cityofnewyork.us/City-Government/Evictions/6z8x-wfk4 
*/

-- Merge two cells. Marshal First Name & Marshal Last Name as Full Name.

SELECT [Marshal First Name], [Marshal Last Name],
CONCAT([Marshal First Name], ' ', [Marshal Last Name]) AS Full_Name FROM Evictions$;

ALTER TABLE Evictions$
ADD Full_Name NVARCHAR(50);

UPDATE Evictions$
SET Full_Name = CONCAT([Marshal First Name], ' ', [Marshal Last Name]);

-- Number Of Boroughs

SELECT DISTINCT BOROUGH, (SELECT COUNT(DISTINCT BOROUGH) FROM Evictions$) 
[Total Number of Boroughs] FROM Evictions$;

-- Remove Duplicates

WITH DUPLICATE AS (
SELECT *, ROW_NUMBER() OVER( PARTITION BY [Docket Number],[Eviction Address], BOROUGH, [Eviction Apartment Number],
Full_name ORDER BY [Court Index Number]) row_num
FROM Evictions$)
SELECT * FROM DUPLICATE
--DELETE FROM DUPLICATE
WHERE row_num > 1;

-- Borough with the highest number of evictions.

SELECT BOROUGH, [Eviction/Legal Possession], COUNT([Eviction/Legal Possession]) [Number of Evictions]
FROM Evictions$ WHERE [Eviction/Legal Possession] = 'Eviction'
GROUP BY BOROUGH, [Eviction/Legal Possession];

-- Borough with the highest and lowest number of possessions.

SELECT BOROUGH, [Eviction/Legal Possession], COUNT([Eviction/Legal Possession]) [Number of Possessions]
FROM Evictions$ WHERE [Eviction/Legal Possession] = 'Possession'
GROUP BY BOROUGH, [Eviction/Legal Possession];

-- Borough with the highest and lowest number of Ejectments.

SELECT BOROUGH, Ejectment, COUNT(Ejectment) AS [Number of Ejectment]
FROM Evictions$ WHERE Ejectment = 'Ejectment'
GROUP BY BOROUGH, Ejectment;

-- Borough with the highest and lowest number of not an Ejectment.

SELECT BOROUGH, Ejectment, COUNT(Ejectment) AS [Number of not an Ejectment]
FROM Evictions$ WHERE Ejectment = 'Not an Ejectment'
GROUP BY BOROUGH, Ejectment;

-- Number of Residentials Eviction.

SELECT BOROUGH, [Residential/Commercial], [Eviction/Legal Possession], 
COUNT([Eviction/Legal Possession]) [Residential Eviction]
FROM Evictions$
WHERE [Eviction/Legal Possession] = 'Eviction' AND [Residential/Commercial] = 'Residential'
GROUP BY BOROUGH, [Residential/Commercial], [Eviction/Legal Possession];

-- Number of Residentials Possession.

SELECT BOROUGH, [Residential/Commercial], [Eviction/Legal Possession], 
COUNT([Eviction/Legal Possession]) [Residential Possession]
FROM Evictions$
WHERE [Eviction/Legal Possession] = 'Possession' AND [Residential/Commercial] = 'Residential'
GROUP BY BOROUGH, [Residential/Commercial], [Eviction/Legal Possession];

-- Number of Commercials possession.

SELECT BOROUGH, [Residential/Commercial], [Eviction/Legal Possession], 
COUNT([Eviction/Legal Possession]) [Commercial Possession ]
FROM Evictions$
WHERE [Eviction/Legal Possession] = 'Possession' AND [Residential/Commercial] = 'Commercial'
GROUP BY BOROUGH, [Residential/Commercial], [Eviction/Legal Possession];

-- Number of Commercials Eviction.

SELECT BOROUGH, [Residential/Commercial], [Eviction/Legal Possession], 
COUNT([Eviction/Legal Possession]) [Commercial Eviction]
FROM Evictions$
WHERE [Eviction/Legal Possession] = 'Eviction' AND [Residential/Commercial] = 'Commercial'
GROUP BY BOROUGH, [Residential/Commercial], [Eviction/Legal Possession];

-- Numbber of evictions over the time

SELECT [BOROUGH], [Executed Date], 
COUNT([Eviction/Legal Possession]) [Number of Evictions/date]
FROM Evictions$ 
WHERE [Eviction/Legal Possession] = 'Eviction'
GROUP BY  [BOROUGH], [Executed Date]
ORDER BY 2;

-- Number of possessions over the time.

SELECT [BOROUGH], [Executed Date], 
COUNT([Eviction/Legal Possession]) [Number of Possession/date]
FROM Evictions$ 
WHERE [Eviction/Legal Possession] = 'Possession'
GROUP BY [BOROUGH], [Executed Date];



