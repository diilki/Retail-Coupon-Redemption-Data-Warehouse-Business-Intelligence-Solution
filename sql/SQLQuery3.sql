CREATE DATABASE Coupon_Staging;
GO
USE Coupon_Staging;
GO

USE Coupon_Staging;
GO

-- 1. Staging for the 1M Transaction rows
CREATE TABLE Stg_Customer_ItemTransaction (
    transaction_id NVARCHAR(255),
    [date] NVARCHAR(255),
    customer_id NVARCHAR(255),
    item_id NVARCHAR(255),
    quantity NVARCHAR(255),
    selling_price NVARCHAR(255),
    other_discount NVARCHAR(255)
);

-- 2. Staging for Campaigns
CREATE TABLE Stg_CampaignData (
    campaign_id NVARCHAR(255),
    campaign_type NVARCHAR(255),
    start_date NVARCHAR(255),
    end_date NVARCHAR(255)
);

-- 3. Staging for Customer Information
CREATE TABLE Stg_customer_Info (
    customer_id NVARCHAR(255),
    age_range NVARCHAR(255),
    marital_status NVARCHAR(255),
    family_size NVARCHAR(255),
    income_bracket NVARCHAR(255)
);

-- 4. Staging for Product Brands
CREATE TABLE Stg_productBrand (
    brand_id NVARCHAR(255),
    brand_type NVARCHAR(255)
);

-- 5. Staging for Items
CREATE TABLE Stg_Items (
    item_id NVARCHAR(255),
    brand_id NVARCHAR(255)
);

-- 6. Staging for Coupon Redemptions
CREATE TABLE Stg_CouponRedemp (
    redemption_id NVARCHAR(255),
    customer_id NVARCHAR(255),
    campaign_id NVARCHAR(255),
    coupon_id NVARCHAR(255),
    redemption_status NVARCHAR(255)
);

-- 7. Staging for External Excel (Customer Address)
CREATE TABLE Stg_CouponCustomerAddress (
    customer_id NVARCHAR(255),
    address_line NVARCHAR(255),
    city NVARCHAR(255),
    contact_number NVARCHAR(255)
);

-- 8. Staging for External Text (Item Category)
CREATE TABLE Stg_CouponItemCategory (
    category_id NVARCHAR(255),
    category_name NVARCHAR(255)
);
GO



TRUNCATE TABLE Stg_Customer_ItemTransaction;
TRUNCATE TABLE Stg_customer_Info;
TRUNCATE TABLE Stg_CampaignData;
TRUNCATE TABLE Stg_CouponItemCategory;
TRUNCATE TABLE Stg_CouponCustomerAddress;
TRUNCATE TABLE Stg_CouponRedemp;
TRUNCATE TABLE Stg_Items;
TRUNCATE TABLE Stg_productBrand;
-- (Add truncate for all other stg tables)
-- (Add truncate for all other stg tables)
-- (Add truncate for all other stg tables)
-- (Add truncate for all other stg tables)

use Coupon_Staging

select * from  Stg_CampaignData

select * 
from Stg_customer_Info

select * 
from Stg_CouponItemCategory

select * 
from Stg_productBrand

select * 
from Stg_CouponRedemp

select * 
from Stg_Items

select * 
from Stg_CouponCustomerAddress

select * 
from Stg_Customer_ItemTransaction


SELECT TOP 100 * FROM  Stg_Customer_ItemTransaction

USE Coupon_Staging;
GO

-- Drop the old version
IF OBJECT_ID('Stg_productBrand', 'U') IS NOT NULL
    DROP TABLE Stg_productBrand;
GO

-- Create the correct version with category_id
CREATE TABLE Stg_productBrand (
    brand_id NVARCHAR(255),
    brand_type NVARCHAR(255),
    category_id NVARCHAR(255) -- <--- ADD THIS COLUMN
);
GO


USE Coupon_Staging;
GO

SELECT TOP 20 [date]
FROM dbo.Stg_Customer_ItemTransaction;


SELECT TOP 20
    [date],
    TRY_CONVERT(DATE, [date]) AS ConvertedDate
FROM dbo.Stg_Customer_ItemTransaction;


USE Coupon_Staging;
GO

SELECT DISTINCT category_id
FROM dbo.Stg_productBrand
ORDER BY category_id;


USE Coupon_Staging;
GO


drop table constraint dbo.DimBrand
drop table dbo.DimDate

SELECT TOP 20 *
FROM dbo.Stg_Items;


USE Coupon_Staging;
GO

SELECT TOP 20 *
FROM dbo.Stg_CouponRedemp;

SELECT DISTINCT campaign_id
FROM Coupon_Staging.dbo.Stg_CouponRedemp
ORDER BY campaign_id;

select * 
from Stg_CouponRedemp


USE Coupon_Staging;
GO

SELECT COUNT(*) AS TransactionRows
FROM dbo.Stg_Customer_ItemTransaction;

SELECT COUNT(*) AS CouponRedempRows
FROM dbo.Stg_CouponRedemp;

SELECT COUNT(*) AS CampaignRows
FROM dbo.Stg_CampaignData;

SELECT COUNT(*) AS CustomerRows
FROM dbo.Stg_customer_Info;

SELECT COUNT(*) AS ItemRows
FROM dbo.Stg_Items;

SELECT COUNT(*) AS BrandRows
FROM dbo.Stg_productBrand;

USE Coupon_Staging;
GO

SELECT TOP 20 *
FROM dbo.Stg_customer_Info;

SELECT TOP 20 *
FROM dbo.Stg_CouponCustomerAddress;


SELECT COUNT(*) AS CustomerInfoRows
FROM dbo.Stg_customer_Info;

SELECT COUNT(*) AS CustomerAddressRows
FROM dbo.Stg_CouponCustomerAddress;


SELECT TOP 20
    c.customer_id,
    a.customer_id
FROM dbo.Stg_customer_Info c
LEFT JOIN dbo.Stg_CouponCustomerAddress a
    ON c.customer_id = a.customer_id;



    USE Coupon_Staging;
GO

-- 1. Drop FACT table first
IF OBJECT_ID('dbo.FactTransaction', 'U') IS NOT NULL
    DROP TABLE dbo.FactTransaction;
GO

-- 2. Drop DIM tables (order doesn’t matter much after fact is removed)

IF OBJECT_ID('dbo.DimCoupon', 'U') IS NOT NULL
    DROP TABLE dbo.DimCoupon;
GO

IF OBJECT_ID('dbo.DimItem', 'U') IS NOT NULL
    DROP TABLE dbo.DimItem;
GO

IF OBJECT_ID('dbo.DimBrand', 'U') IS NOT NULL
    DROP TABLE dbo.DimBrand;
GO

IF OBJECT_ID('dbo.DimCampaign', 'U') IS NOT NULL
    DROP TABLE dbo.DimCampaign;
GO

IF OBJECT_ID('dbo.DimCustomer', 'U') IS NOT NULL
    DROP TABLE dbo.DimCustomer;
GO

IF OBJECT_ID('dbo.DimDate', 'U') IS NOT NULL
    DROP TABLE dbo.DimDate;
GO

select * 
from Stg_Customer_ItemTransaction


USE Coupon_Staging;
GO

CREATE TABLE dbo.Stg_FactTransactionCompletion (
    txn_id NVARCHAR(50),
    accm_txn_complete_time DATETIME
);
GO

TRUNCATE TABLE dbo.Stg_FactTransactionCompletion;
GO

INSERT INTO Coupon_Staging.dbo.Stg_FactTransactionCompletion
(
    txn_id,
    accm_txn_complete_time
)
SELECT TOP (50000)
    TransactionAlternateID,
    DATEADD(DAY, (ABS(CHECKSUM(NEWID())) % 5) + 1, accm_txn_create_time)
FROM Coupon_DW.dbo.FactTransaction
ORDER BY NEWID();
GO



select * 
from dbo.Stg_FactTransactionCompletion