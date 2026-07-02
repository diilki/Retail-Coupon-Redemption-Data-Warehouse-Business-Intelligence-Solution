CREATE TABLE dbo.DimDate (
    DateSK INT IDENTITY(1,1) PRIMARY KEY,
    FullDate DATE NOT NULL UNIQUE,
    [Year] INT,
    MonthName VARCHAR(20),
    [Week] INT
);

CREATE TABLE dbo.DimCategory (
    CategorySK INT IDENTITY(1,1) PRIMARY KEY,
    CategoryAlternateID VARCHAR(50) NOT NULL UNIQUE,
    CategoryName VARCHAR(100),
    InsertDate DATETIME,
    ModifiedDate DATETIME
);

CREATE TABLE dbo.DimProductBrand (
    BrandSK INT IDENTITY(1,1) PRIMARY KEY,
    BrandAlternateID VARCHAR(50) NOT NULL UNIQUE,
    BrandType VARCHAR(100),
    CategoryIDKey INT,
    InsertDate DATETIME,
    ModifiedDate DATETIME,
    FOREIGN KEY (CategoryIDKey) REFERENCES dbo.DimCategory(CategorySK)
);

CREATE TABLE dbo.DimItem (
    ItemSK INT IDENTITY(1,1) PRIMARY KEY,
    ItemAlternateID VARCHAR(50) NOT NULL UNIQUE,
    BrandIDKey INT,
    InsertDate DATETIME,
    ModifiedDate DATETIME,
    FOREIGN KEY (BrandIDKey) REFERENCES dbo.DimProductBrand(BrandSK)
);


CREATE TABLE dbo.DimCampaign (
    CampaignSK INT IDENTITY(1,1) PRIMARY KEY,
    CampaignAlternateID VARCHAR(50) NOT NULL UNIQUE,
    CampaignType VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    InsertDate DATETIME,
    ModifiedDate DATETIME
);


CREATE TABLE dbo.DimCustomer (
    CustomerSK INT IDENTITY(1,1) PRIMARY KEY,
    CustomerAlternateID VARCHAR(50) NOT NULL,
    AgeRange VARCHAR(50),
    MaritalStatus VARCHAR(50),
    FamilySize INT,
    IncomeBracket INT,
    AddressLine VARCHAR(255),
    City VARCHAR(100),
    ContactNumber VARCHAR(50),
    StartDate DATETIME NULL,
    EndDate DATETIME NULL,
    IsCurrent BIT DEFAULT 1,
    InsertDate DATETIME,
    ModifiedDate DATETIME
);

CREATE TABLE dbo.DimCouponRedemption (
    CouponRedemptionSK INT IDENTITY(1,1) PRIMARY KEY,
    CouponAlternateID VARCHAR(50) NOT NULL UNIQUE,
    CampaignIDKey INT,
    RedemptionStatus INT,
    InsertDate DATETIME,
    ModifiedDate DATETIME,
    FOREIGN KEY (CampaignIDKey) REFERENCES dbo.DimCampaign(CampaignSK)
);

CREATE TABLE dbo.FactTransaction (
    TransactionSK BIGINT IDENTITY(1,1) PRIMARY KEY,
    TransactionAlternateID VARCHAR(50),
    DateKey INT NOT NULL,
    CustomerKey INT NOT NULL,
    ItemKey INT NOT NULL,
    CouponKey INT NULL,
    Quantity INT,
    SellingPrice DECIMAL(18,2),
    OtherDiscount DECIMAL(18,2),
    ExpectedCustomerExpense DECIMAL(18,2),
    CouponUsedExpense DECIMAL(18,2),
    TotalDiscountedExpense DECIMAL(18,2),
    InsertDate DATETIME,
    ModifiedDate DATETIME,
    FOREIGN KEY (DateKey) REFERENCES dbo.DimDate(DateSK),
    FOREIGN KEY (CustomerKey) REFERENCES dbo.DimCustomer(CustomerSK),
    FOREIGN KEY (ItemKey) REFERENCES dbo.DimItem(ItemSK),
    FOREIGN KEY (CouponKey) REFERENCES dbo.DimCouponRedemption(CouponRedemptionSK)
);


select * 
from DimDate

CREATE OR ALTER PROCEDURE dbo.UpdateDimCategory
    @CategoryID NVARCHAR(50),
    @CategoryName NVARCHAR(100)
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.DimCategory
        WHERE CategoryAlternateID = @CategoryID
    )
    BEGIN
        INSERT INTO dbo.DimCategory
        (
            CategoryAlternateID,
            CategoryName,
            InsertDate,
            ModifiedDate
        )
        VALUES
        (
            @CategoryID,
            @CategoryName,
            GETDATE(),
            GETDATE()
        );
    END
    ELSE
    BEGIN
        UPDATE dbo.DimCategory
        SET
            CategoryName = @CategoryName,
            ModifiedDate = GETDATE()
        WHERE CategoryAlternateID = @CategoryID;
    END
END;


select * from DimDate
select * from DimCategory

truncate table DimDate
truncate table DimCategory


USE Coupon_DW;
GO

TRUNCATE TABLE dbo.DimDate;

USE Coupon_DW;
GO

DECLARE @StartDate DATE, @EndDate DATE;

SELECT 
    @StartDate = MIN(TRY_CONVERT(DATE, [date])),
    @EndDate   = MAX(TRY_CONVERT(DATE, [date]))
FROM Coupon_Staging.dbo.Stg_Customer_ItemTransaction;

;WITH DateSeries AS
(
    SELECT @StartDate AS FullDate
    UNION ALL
    SELECT DATEADD(DAY, 1, FullDate)
    FROM DateSeries
    WHERE FullDate < @EndDate
)
INSERT INTO dbo.DimDate (FullDate, [Year], MonthName, [Week])
SELECT
    FullDate,
    YEAR(FullDate),
    DATENAME(MONTH, FullDate),
    DATEPART(WEEK, FullDate)
FROM DateSeries d
WHERE FullDate IS NOT NULL
OPTION (MAXRECURSION 0);




USE Coupon_DW;
GO

CREATE OR ALTER PROCEDURE dbo.UpdateDimProductBrand
    @BrandID NVARCHAR(50),
    @BrandType NVARCHAR(100),
    @CategoryKey INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.DimProductBrand
        WHERE BrandAlternateID = @BrandID
    )
    BEGIN
        INSERT INTO dbo.DimProductBrand
        (
            BrandAlternateID,
            BrandType,
            CategoryIDKey,
            InsertDate,
            ModifiedDate
        )
        VALUES
        (
            @BrandID,
            @BrandType,
            @CategoryKey,
            GETDATE(),
            GETDATE()
        );
    END
    ELSE
    BEGIN
        UPDATE dbo.DimProductBrand
        SET
            BrandType = @BrandType,
            CategoryIDKey = @CategoryKey,
            ModifiedDate = GETDATE()
        WHERE BrandAlternateID = @BrandID;
    END
END;
GO

USE Coupon_DW;
GO

CREATE OR ALTER PROCEDURE dbo.UpdateDimItem
    @ItemID NVARCHAR(50),
    @BrandKey INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.DimItem
        WHERE ItemAlternateID = @ItemID
    )
    BEGIN
        INSERT INTO dbo.DimItem
        (
            ItemAlternateID,
            BrandIDKey,
            InsertDate,
            ModifiedDate
        )
        VALUES
        (
            @ItemID,
            @BrandKey,
            GETDATE(),
            GETDATE()
        );
    END
    ELSE
    BEGIN
        UPDATE dbo.DimItem
        SET
            BrandIDKey = @BrandKey,
            ModifiedDate = GETDATE()
        WHERE ItemAlternateID = @ItemID;
    END
END;
GO


USE Coupon_DW;
GO

CREATE OR ALTER PROCEDURE dbo.UpdateDimCampaign
    @CampaignID NVARCHAR(50),
    @CampaignType NVARCHAR(50),
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.DimCampaign
        WHERE CampaignAlternateID = @CampaignID
    )
    BEGIN
        INSERT INTO dbo.DimCampaign
        (
            CampaignAlternateID,
            CampaignType,
            StartDate,
            EndDate,
            InsertDate,
            ModifiedDate
        )
        VALUES
        (
            @CampaignID,
            @CampaignType,
            @StartDate,
            @EndDate,
            GETDATE(),
            GETDATE()
        );
    END
    ELSE
    BEGIN
        UPDATE dbo.DimCampaign
        SET
            CampaignType = @CampaignType,
            StartDate = @StartDate,
            EndDate = @EndDate,
            ModifiedDate = GETDATE()
        WHERE CampaignAlternateID = @CampaignID;
    END
END;
GO

USE Coupon_DW;
GO

SELECT * FROM dbo.DimProductBrand;

USE Coupon_DW;
GO

SELECT * FROM dbo.DimCampaign;

SELECT CampaignSK, CampaignAlternateID
FROM Coupon_DW.dbo.DimCampaign
ORDER BY CampaignAlternateID;

USE Coupon_DW;
GO

CREATE OR ALTER PROCEDURE dbo.UpdateDimCouponRedemption
    @CouponID NVARCHAR(50),
    @CampaignKey INT,
    @RedemptionStatus INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.DimCouponRedemption
        WHERE CouponAlternateID = @CouponID
    )
    BEGIN
        INSERT INTO dbo.DimCouponRedemption
        (
            CouponAlternateID,
            CampaignIDKey,
            RedemptionStatus,
            InsertDate,
            ModifiedDate
        )
        VALUES
        (
            @CouponID,
            @CampaignKey,
            @RedemptionStatus,
            GETDATE(),
            GETDATE()
        );
    END
    ELSE
    BEGIN
        UPDATE dbo.DimCouponRedemption
        SET
            CampaignIDKey = @CampaignKey,
            RedemptionStatus = @RedemptionStatus,
            ModifiedDate = GETDATE()
        WHERE CouponAlternateID = @CouponID;
    END
END;
GO

select * from DimCouponRedemption

USE Coupon_DW;
GO

SELECT COUNT(*) FROM dbo.DimCouponRedemption;


USE Coupon_DW;
GO

CREATE OR ALTER PROCEDURE dbo.InsertDimCustomer
    @CustomerID NVARCHAR(50),
    @AgeRange NVARCHAR(50),
    @MaritalStatus NVARCHAR(50),
    @FamilySize INT,
    @IncomeBracket INT,
    @AddressLine NVARCHAR(255),
    @City NVARCHAR(100),
    @ContactNumber NVARCHAR(50)
AS
BEGIN
    INSERT INTO dbo.DimCustomer
    (
        CustomerAlternateID,
        AgeRange,
        MaritalStatus,
        FamilySize,
        IncomeBracket,
        AddressLine,
        City,
        ContactNumber,
        StartDate,
        EndDate,
        IsCurrent,
        InsertDate,
        ModifiedDate
    )
    VALUES
    (
        @CustomerID,
        @AgeRange,
        @MaritalStatus,
        @FamilySize,
        @IncomeBracket,
        @AddressLine,
        @City,
        @ContactNumber,
        GETDATE(),
        NULL,
        1,
        GETDATE(),
        GETDATE()
    );
END;
GO

USE Coupon_DW;
GO

CREATE OR ALTER PROCEDURE dbo.ExpireDimCustomer
    @CustomerID NVARCHAR(50)
AS
BEGIN
    UPDATE dbo.DimCustomer
    SET
        IsCurrent = 0,
        EndDate = GETDATE(),
        ModifiedDate = GETDATE()
    WHERE CustomerAlternateID = @CustomerID
      AND IsCurrent = 1;
END;
GO


USE Coupon_DW;
GO

CREATE OR ALTER PROCEDURE dbo.InsertDimCustomer
    @CustomerID VARCHAR(50),
    @AgeRange VARCHAR(50),
    @MaritalStatus VARCHAR(50),
    @FamilySize INT,
    @IncomeBracket INT,
    @AddressLine VARCHAR(255),
    @City VARCHAR(100),
    @ContactNumber VARCHAR(50)
AS
BEGIN
    INSERT INTO dbo.DimCustomer
    (
        CustomerAlternateID,
        AgeRange,
        MaritalStatus,
        FamilySize,
        IncomeBracket,
        AddressLine,
        City,
        ContactNumber,
        StartDate,
        EndDate,
        IsCurrent,
        InsertDate,
        ModifiedDate
    )
    VALUES
    (
        @CustomerID,
        @AgeRange,
        @MaritalStatus,
        @FamilySize,
        @IncomeBracket,
        @AddressLine,
        @City,
        @ContactNumber,
        GETDATE(),
        NULL,
        1,
        GETDATE(),
        GETDATE()
    );
END;
GO


USE Coupon_DW;
GO

CREATE OR ALTER PROCEDURE dbo.ExpireDimCustomer
    @CustomerID VARCHAR(50)
AS
BEGIN
    UPDATE dbo.DimCustomer
    SET
        IsCurrent = 0,
        EndDate = GETDATE(),
        ModifiedDate = GETDATE()
    WHERE CustomerAlternateID = @CustomerID
      AND IsCurrent = 1;
END;
GO

use Coupon_DW


select * 
from DimCustomer


USE Coupon_DW;
GO

ALTER TABLE dbo.FactTransaction
ADD
    accm_txn_create_time DATETIME NULL,
    accm_txn_complete_time DATETIME NULL,
    txn_process_time_hours DECIMAL(18,2) NULL;
GO

select * 
from dbo.FactTransaction


CREATE INDEX IX_FactTransaction_TransactionAlternateID
ON dbo.FactTransaction(TransactionAlternateID);
GO

select * 
from dbo.FactTransaction


USE Coupon_DW;
GO

USE Coupon_DW;
GO

