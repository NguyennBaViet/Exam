Use DEV2410SQL35_NguyenBaViet_0393800331
--- == Tạo bảng == --
CREATE TABLE SalesPerson
(	SlsPerID char(4),
	TenNV nvarchar(50),
	Primary key(SlsPerID)
)
GO

CREATE TABLE Customer
(	CustID char(4),
	TenKH nvarchar(50),
	NoiO nvarchar(50)
	Primary key(CustID)
)
GO

CREATE TABLE Iventory
(	InvtID char(3),
	Descr nvarchar(50),
	StkBasePrc money
	primary key (InvtID)
)
GO

CREATE TABLE xswSalesOrd
(	OrderNbr char(4),
	OrderDate datetime,
	SlsPerID char(4),
	CustID char(4),
	OrdAmt money
	primary key (OrderNbr),
	foreign key (SlsPerID) references SalesPerson (SlsPerID),
	foreign key (CustID) references Customer (CustID)
)
GO

CREATE TABLE xswSalesOrdDet
(	OrderNbr char(4),
	InvtID char(3),
	LineQty int,
	LineAmt MONEY,
	SlsPrice MONEY
	primary key (OrderNbr,InvtID),
	foreign key (OrderNbr) references xswSalesOrd(OrderNbr),
	foreign key (InvtID) references Iventory (InvtID) 
)
GO

-- == Nhập dữ liệu == --
INSERT INTO SalesPerson VALUES ('NV01',N'Nhân')
INSERT INTO SalesPerson VALUES ('NV02',N'Nam')
INSERT INTO Customer VALUES ('KH01',N'Nhiên',N'Hải Phòng')
INSERT INTO Customer VALUES ('KH02',N'Đạt',N'Hà Nội')
INSERT INTO Customer VALUES ('KH03',N'Hạt',N'Hà Nội')
INSERT INTO Customer VALUES ('KH04',N'Ht',N'Huế')
INSERT INTO Iventory VALUES ('D01',N'Sữa tươi','18000')
INSERT INTO Iventory VALUES ('D02',N'Sữa bột','100000')
INSERT INTO Iventory VALUES ('D03',N'OMO','32000')
INSERT INTO xswSalesOrd VALUES ('HD01','20100101','NV01','KH01','100000')
INSERT INTO xswSalesOrd VALUES ('HD02','20100102','NV02','KH02','150000')
INSERT INTO xswSalesOrd VALUES ('HD03','20101103','NV02','KH03','132000')
INSERT INTO xswSalesOrd VALUES ('HD04','20101104','NV02','KH04','32000')
INSERT INTO xswSalesOrd VALUES ('HD05','20101104','NV02','KH04','32000')
INSERT INTO xswSalesOrdDet VALUES ('HD01','D02','01','100000','100000')
INSERT INTO xswSalesOrdDet VALUES ('HD04','D02','01','100000','100000')
INSERT INTO xswSalesOrdDet VALUES ('HD02','D01','01','132000','132000')
INSERT INTO xswSalesOrdDet VALUES ('HD03','D03','03','32000','96000')
--4.1
SELECT OD.[InvtID],Descr,TenKH FROM xswSalesOrdDet OD
	INNER JOIN Iventory IV ON OD.InvtID = IV.InvtID
	INNER JOIN xswSalesOrd SO ON OD.OrderNbr = SO.OrderNbr
	INNER JOIN Customer CM ON SO.CustID = CM.CustID
	WHERE  NoiO NOT LIKE N'Hà Nội' AND OrderDate = YEAR(2010)

--4.2
SELECT SP.SlsPerID,TenNV FROM [dbo].[SalesPerson]	SP
	INNER JOIN xswSalesOrd SO ON SP.SlsPerID = SO.SlsPerID
	INNER JOIN xswSalesOrdDet SD ON SO.OrderNbr = SD.OrderNbr
	INNER JOIN Iventory IV ON SD.InvtID = IV.InvtID
	WHERE Descr NOT LIKE 'OMO' AND OrderDate = YEAR(2010)

--4.3
SELECT TOP 1 WITH TIES SP.SlsPerID,TenNV,MAX(SlsPrice) AS DOANHSO FROM [dbo].[SalesPerson]	SP
	INNER JOIN xswSalesOrd SO ON SP.SlsPerID = SO.SlsPerID
	INNER JOIN xswSalesOrdDet SD ON SO.OrderNbr = SD.OrderNbr
	INNER JOIN Iventory IV ON SD.InvtID = IV.InvtID
	GROUP BY SP.SlsPerID,TenNV ORDER BY DOANHSO DESC 

--4.4
SELECT TOP 1 WITH TIES  Descr,MAX(LineQty) AS SODON FROM xswSalesOrdDet OD
	INNER JOIN Iventory IV ON OD.InvtID = IV.InvtID
	INNER JOIN xswSalesOrd SO ON OD.OrderNbr = SO.OrderNbr
	INNER JOIN Customer CM ON SO.CustID = CM.CustID
	GROUP BY Descr ORDER BY SODON DESC

--4.5
SELECT TOP 1 WITH TIES Descr,COUNT(OD.InvtID) XUATHIENNHIEUNHAT FROM xswSalesOrdDet OD
	INNER JOIN Iventory IV ON OD.InvtID = IV.InvtID
	INNER JOIN xswSalesOrd SO ON OD.OrderNbr = SO.OrderNbr
	INNER JOIN Customer CM ON SO.CustID = CM.CustID
	GROUP BY Descr ORDER BY XUATHIENNHIEUNHAT DESC
--4.6
SELECT TOP 1 WITH TIES SP.SlsPerID,TenNV,COUNT(SO.CustID) AS SOKHACHHANG FROM xswSalesOrdDet OD
	INNER JOIN Iventory IV ON OD.InvtID = IV.InvtID
	INNER JOIN xswSalesOrd SO ON OD.OrderNbr = SO.OrderNbr
	INNER JOIN Customer CM ON SO.CustID = CM.CustID
	INNER JOIN SalesPerson SP ON SP.SlsPerID = SO.SlsPerID
	GROUP BY SP.SlsPerID,TenNV ORDER BY SOKHACHHANG DESC
--4.7
SELECT TOP 1 WITH TIES TenKH,COUNT(CM.CustID) SODONHANG FROM [dbo].[SalesPerson]	SP
	INNER JOIN xswSalesOrd SO ON SP.SlsPerID = SO.SlsPerID
	INNER JOIN xswSalesOrdDet SD ON SO.OrderNbr = SD.OrderNbr
	INNER JOIN Iventory IV ON SD.InvtID = IV.InvtID
	INNER JOIN Customer CM ON SO.CustID = CM.CustID
	GROUP BY TenKH ORDER BY SODONHANG DESC