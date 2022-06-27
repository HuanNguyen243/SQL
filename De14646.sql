CREATE DATABASE QLYCTY
GO

USE QLYCTY
GO

CREATE TABLE CONGTY(
MaCT NCHAR(10) PRIMARY KEY,
TenCT NCHAR(50),
TrangThai NCHAR(50),
ThanhPho NCHAR(50)
)

CREATE TABLE SANPHAM(
MaSP NCHAR(10) PRIMARY KEY,
TenSP NCHAR(50), 
MauSac NCHAR(30),
SoLuong INT,
GiaBan MONEY
)

CREATE TABLE CUNGUNG(
MaCT NCHAR(10) FOREIGN KEY REFERENCES CONGTY(MaCT) ON UPDATE CASCADE ON DELETE CASCADE,
MaSP NCHAR(10) FOREIGN KEY REFERENCES SANPHAM(MaSP) ON UPDATE CASCADE ON DELETE CASCADE,
SoLuongCU INT,
PRIMARY KEY(MaCT, MaSP)
)

INSERT INTO CONGTY VALUES('CT001', 'FPT', N'?ang ho?t ??ng', N'H� N?i'),
							('CT002', 'Microsoft', N'?ang ho?t ??ng', 'LA'),
							('CT003', 'VinGroup', N'?ang ho?t ??ng', N'H� N?i');


INSERT INTO SANPHAM VALUES('SP001', N'M�y t�nh', N'?en', 500, 15000000),
							('SP002', N'?i?n tho?i', N'Tr?ng', 400, 30000000),
							('SP003', N'� t�', N'?en', 200, 500000000);

INSERT INTO CUNGUNG VALUES('CT001', 'SP001', 50),
							('CT002', 'SP002', 100),
							('CT003', 'SP003', 70),
							('CT002', 'SP001', 20),
							('CT001', 'SP002', 30);


SELECT * FROM CONGTY
SELECT * FROM SANPHAM
SELECT * FROM CUNGUNG

--cau2
CREATE FUNCTION fn_cau2(@tencty NCHAR(50))
RETURNS @bang TABLE(
TenSP NCHAR(50), MauSac NCHAR(30), SoLuong INT, GiaBan MONEY)
AS
BEGIN
INSERT INTO @bang
SELECT TenSP, MauSac, SoLuong, GiaBan
FROM SANPHAM INNER JOIN CUNGUNG
ON SANPHAM.MaSP=CUNGUNG.MaSP
INNER JOIN CONGTY ON CONGTY.MaCT=CUNGUNG.MaCT
WHERE TenCT=@tencty
RETURN
END

--test
SELECT * FROM fn_cau2('FPT')

--cau3
CREATE PROC pr_cau3(@mact NCHAR(10), @tensp NCHAR(50), @slcu INT)
AS
BEGIN
IF(NOT EXISTS(SELECT * FROM SANPHAM WHERE @tensp=TenSP))
PRINT N'T�n s?n ph?m kh�ng t?n t?i'
ELSE
INSERT INTO SANPHAM VALUES(@mact, @tensp, @slcu) 
PRINT N'Th�m th�nh c�ng'
END
