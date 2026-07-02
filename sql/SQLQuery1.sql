
USE Coupon_SourceDB;
GO

-- 1. Campaign Data
CREATE TABLE CampaignData (
    campaign_id INT PRIMARY KEY,
    campaign_type VARCHAR(10),
    start_date DATE,
    end_date DATE
);

-- 2. Coupon Redemption Information
CREATE TABLE CouponRedemp (
    redemption_id INT PRIMARY KEY,
    customer_id INT,
    campaign_id INT,
    coupon_id INT,
    redemption_status INT
);

-- 3. Customer Information (from CSV)
CREATE TABLE customer_Info (
    customer_id INT PRIMARY KEY,
    age_range VARCHAR(20),
    marital_status VARCHAR(20),
    family_size INT,
    income_bracket INT
);

-- 4. Product Brands
CREATE TABLE productBrand (
    brand_id INT PRIMARY KEY,
    brand_type VARCHAR(50)
);

-- 5. Items
CREATE TABLE Items (
    item_id INT PRIMARY KEY,
    brand_id INT FOREIGN KEY REFERENCES dbo.productBrand(brand_id)
);

-- 6. Main Transactions (The 1M Row Table)
CREATE TABLE Customer_ItemTransaction (
    transaction_id INT PRIMARY KEY,
    date DATE,
    customer_id INT,
    item_id INT,
    quantity INT,
    selling_price DECIMAL(18, 2),
    other_discount DECIMAL(18,2)
);
GO

USE Coupon_SourceDB;
GO

USE Coupon_SourceDB;
GO

-- Try this specific version for CouponRedemp
BULK INSERT dbo.CouponRedemp
FROM 'C:\data\CouponRedemp.csv' -- Ensure this path is correct
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a', -- This forces a Unix-style New Line
    TABLOCK
);

-- Try this for CampaignData
BULK INSERT dbo.CampaignData
FROM 'C:\data\CampaignData.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);


-- Load Customer Info
BULK INSERT customer_Info
FROM 'C:\Data\customer_info.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

-- Load Brands
BULK INSERT productBrand
FROM 'C:\Data\productBrand.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

-- Load Items
BULK INSERT Items
FROM 'C:\Data\items.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);


USE Coupon_SourceDB;
GO

-- Expand columns to prevent "Too Long" errors
ALTER TABLE dbo.customer_Info ALTER COLUMN marital_status VARCHAR(255);
ALTER TABLE dbo.productBrand ALTER COLUMN brand_type VARCHAR(255);
-- Add more ALTER commands if other tables fail on different columns
GO


USE Coupon_SourceDB;
GO

-- Load Customer Info
BULK INSERT dbo.customer_info
FROM 'C:\Data\customer_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a', -- Use Hex instead of '\n'
    TABLOCK
);

-- Load Brands
BULK INSERT dbo.productBrand
FROM 'C:\Data\productBrand.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

-- Load Items
BULK INSERT dbo.Items
FROM 'C:\Data\items.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);


CREATE TABLE dbo.Customer_ItemTransaction (
    transaction_id INT PRIMARY KEY,
    date DATE,
    customer_id INT,
    item_id INT,
    quantity INT,
    selling_price DECIMAL(18, 2),
    other_discount DECIMAL(18, 2),
    coupon_discount DECIMAL(18, 2) -- Added to match Python CSV output
);
GO

USE Coupon_SourceDB;
GO

BULK INSERT dbo.Customer_ItemTransaction
FROM 'C:\Data\transactions.csv' -- Verify your folder path here
WITH (
    FIRSTROW = 2,           -- Skips the header
    FIELDTERMINATOR = ',',  -- CSV comma
    ROWTERMINATOR = '0x0a', -- Standard Python/Unix Newline
    TABLOCK,                -- Speeds up the 1M row insert
    MAXERRORS = 10          -- Allows small skipped errors if they occur
);
GO




USE Coupon_SourceDB;
GO

-- 1. Drop and Re-create with 'Safe' lengths to avoid "Column too long" errors
IF OBJECT_ID('dbo.Customer_ItemTransaction', 'U') IS NOT NULL 
    DROP TABLE dbo.Customer_ItemTransaction;

CREATE TABLE dbo.Customer_ItemTransaction (
    transaction_id VARCHAR(50),
    [date] VARCHAR(50),
    customer_id VARCHAR(50),
    item_id VARCHAR(50),
    quantity VARCHAR(50),
    selling_price VARCHAR(50),
    other_discount VARCHAR(50),
    coupon_discount VARCHAR(50)
);
GO

-- 2. Bulk Insert using the most stable configuration
BULK INSERT dbo.Customer_ItemTransaction
FROM 'C:\Data\transactions.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a', -- Standard for Python-generated CSVs
    TABLOCK,
    CODEPAGE = '65001',     -- Supports UTF-8
    MAXERRORS = 100         -- Allows the load to finish if a few lines are messy
);
GO

USE Coupon_SourceDB;
GO

-- Ensure the table matches the CSV columns exactly
IF OBJECT_ID('dbo.Customer_ItemTransaction', 'U') IS NOT NULL 
    DROP TABLE dbo.Customer_ItemTransaction;

CREATE TABLE dbo.Customer_ItemTransaction (
    transaction_id INT PRIMARY KEY,
    [date] DATE,
    customer_id INT,
    item_id INT,
    quantity INT,
    selling_price DECIMAL(18, 2),
    other_discount DECIMAL(18, 2)
);
GO

drop table dbo.Customer_ItemTransaction

-- Use FORMAT = 'CSV' to handle the "End of File" issue
BULK INSERT dbo.Customer_ItemTransaction
FROM '"C:\Data\transactions.csv"'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001', -- UTF-8
    TABLOCK
);
GO


BULK INSERT dbo.Customer_ItemTransaction
FROM 'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\transactions.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK,
    MAXERRORS = 1000
);


USE Coupon_SourceDB;
SELECT COUNT(*) AS [Total_Rows_Found] FROM dbo.Customer_ItemTransaction;

select *
from dbo.Customer_ItemTransaction


USE Coupon_SourceDB;
GO

SELECT 'CampaignData' AS [Table], COUNT(*) AS [Rows] FROM CampaignData
UNION ALL
SELECT 'CouponRedemp', COUNT(*) FROM CouponRedemp
UNION ALL
SELECT 'customer_Info', COUNT(*) FROM customer_Info
UNION ALL
SELECT 'productBrand', COUNT(*) FROM productBrand
UNION ALL
SELECT 'Items', COUNT(*) FROM Items
UNION ALL
SELECT 'Customer_ItemTransaction', COUNT(*) FROM Customer_ItemTransaction;


USE Coupon_SourceDB;
GO

SELECT TOP 20 *
FROM dbo.productBrand;

