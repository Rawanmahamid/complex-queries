CREATE DATABASE Yahoo 

USE Yahoo

GO 

IF OBJECT_ID('dbo.Tablea','U') IS NOT NULL
DROP TABLE dbo.Tablea;

CREATE TABLE Tablea 
(user_id Int NOT NULL,
item_id varchar(10) NOT NULL,
searches Int NOT NULL,
clicks Int NOT NULL) 

INSERT INTO Tablea 
VALUES 
(1234,990011,100,11),
(1234,990012,20,1),
(1212,990011,3,2),
(1212,990013,4,3),
(1212,990015,6,5),
(1212,990017,7,5),
(1200,990018,6,4),
(1244,990019,3,3),
(1244,990020,2,2),
(1244,990021,30,3)


--CREATING TABLE THAT CONTAIN A NEW CALCULATING COLUMN (CTR) 

create table #Tableaa
(User_id Int NOT NULL,
Item_id Varchar(10) NOT NULL,
Searches Int NOT NULL,
Clicks Int NOT NULL) 

SELECT * ,CONCAT(ROUND((CAST(Clicks as float)/ CAST(Searches as float) )*100,0),'%') 'CTR',DENSE_RANK () OVER (Partition by User_id Order by Item_id) AS 'Rank'
INTO Tableaa
FROM Tablea 

SELECT *
FROM Tableaa

-- Creating Table B.

GO

WITH CTE1 AS
(SELECT USER_ID,Item_id as Item_id1,CTR as CTR1
FROM Tableaa WHERE Rank=1 )
, CTE2 AS
(SELECT USER_ID,Item_id as Item_id2,CTR as CTR2
FROM Tableaa WHERE Rank=2 )
, CTE3 AS
(SELECT USER_ID,Item_id as Item_id3,CTR as CTR3
FROM Tableaa WHERE Rank=3 )

SELECT C1.User_id,ISNULL(C1.Item_id1,'') AS Item_id1,ISNULL (c1.ctr1,'') AS CTR1,
                  ISNULL(C2.Item_id2,'') AS Item_id2,ISNULL (c2.ctr2,'') AS CTR2,
				  ISNULL(C3.Item_id3,'') AS Item_id3,ISNULL (c3.ctr3,'') AS CTR3
INTO Tableb
FROM CTE1 C1 FULL OUTER JOIN CTE2 C2 ON C1.User_id=C2.User_id
             FULL OUTER JOIN CTE3 C3 ON C2.User_id=C3.User_id
ORDER BY C1.Item_id1,C2.Item_id2,C3.Item_id3



SELECT *
FROM Tableb
ORDER BY Item_id1,Item_id2,Item_id3
