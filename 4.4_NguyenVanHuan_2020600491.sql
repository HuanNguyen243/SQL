use master
go
create database QLBanHang
on primary(
name='QLBanHang.dat',
filename='C:\Redvelvet\QLBanHang.mdf',
size=5MB,
maxsize=20MB,
filegrowth=20%
)
log on(
name='QLBanHang.log',
filename='C:\Redvelvet\QLBanHang.ldf',
size=1MB,
maxsize=10MB,
filegrowth=20%
)
go
use QLBanHang
go
create table NhanVien(
MaNV nchar(15) not null primary key,
TenNV nvarchar(20),
GioiTinh nvarchar(10),
DiaChi nvarchar(20),
SoDT nvarchar(20),
Email nvarchar(20),
TenPhong nvarchar(15)
)
create table HangSX(
MaHangSX nchar(20) not null primary key,
TenHang nvarchar(15),
DiaChi nvarchar(15),
SoDT nvarchar(20),
Email nvarchar(15)
)
create table SanPham(
MaSP nchar(20) not null primary key,
MaHangSX nchar(20),
TenSP nvarchar(15),
SoLuong int,
MauSac nvarchar(10),
GiaBan money,
DonViTinh nchar(10),
MoTa nvarchar(15),
constraint fk_sp_hangsx foreign key(MaHangSX) references HangSX(MaHangSX)

)
create table PNhap(
SoHDN nchar(10) not null primary key,
NgayNhap date,
MaNV nchar(15),
constraint fk_PNhap_NhanVien foreign key(MaNV) references NhanVien(MaNV)
)
create table Nhap(
SoHDN nchar(10),
MaSP nchar(20),
SoLuongN int,
DonGiaN money,
constraint pk_nhap primary key(SoHDN,MaSP),
constraint fk_nhap_pn foreign key(SoHDN) references PNhap(SoHDN),
constraint fk_nhap_sp foreign key(MaSP) references SanPham(MaSP)
)
create table PXuat(
SoHDX nchar(10) not null primary key,
NgayXuat date,
MaNV nchar(15),
constraint fk_PXuat_NhanVien foreign key(MaNV) references NhanVien(MaNV)
)
create table Xuat(
SoHDX nchar(10),
MaSP nchar(20),
SoLuongX int,
constraint pk_xuat primary key(SoHDX,MaSP),
constraint fk_xuat_px foreign key(SoHDX) references PXuat(SoHDX),
constraint fk_xuat_sp foreign key(MaSP) references SanPham(MaSP)
)
go
insert into HangSX values('H01','SamSung','Korea','011-08272727','ss@gmail.com.kr')
insert into HangSX values('H02','OPPO','China','081-08626262','oppo@gmail.com.cn')
insert into HangSX values('H03','Vinafone',N'Việt Nam','084-098262626','vf@gmail.com.vn')

insert into SanPham values('SP01','H02','F1 Plus',100,N'Xám',7000000,N'Chiếc',N'Hàng cận cao cấp')
insert into SanPham values('SP02','H01','Galaxy Note11',50,N'Đỏ',19000000,N'Chiếc',N'Hàng cao cấp')
insert into SanPham values('SP03','H02','F1 lite',200,N'Nâu',3000000,N'Chiếc',N'Hàng phổ thông')
insert into SanPham values('SP04','H03','Vjoy3',200,N'Xám',1500000,N'Chiếc',N'Hàng phổ thông')
insert into SanPham values('SP05','H01','Galaxy v21',500,N'Nâu',8000000,N'Chiếc',N'Hàng cận cao cấp')

insert into NhanVien values('NV01',N'Nguyễn Thị Thu',N'Nữ',N'Hà Nội','0982626521','thu@gmail.com',N'Kế toán')
insert into NhanVien values('NV02',N'Lê Văn Nam',N'Nam',N'Bắc Ninh','0972525252','nam@gmail.com',N'Vật tư')
insert into NhanVien values('NV03',N'Trần Hòa Bình',N'Nữ',N'Hà Nội','0328388388','hb@gmail.com',N'Kế toán')

insert into PNhap values('N01','02-05-2019','NV01')
insert into PNhap values('N02','04-07-2020','NV02')
insert into PNhap values('N03','05-17-2020','NV02')
insert into PNhap values('N04','03-22-2020','NV03')
insert into PNhap values('N05','07-07-2020','NV01')

insert into Nhap values('N01','SP02',10,17000000)
insert into Nhap values('N02','SP01',30,6000000)
insert into Nhap values('N03','SP04',20,1200000)
insert into Nhap values('N04','SP01',10,6200000)
insert into Nhap values('N05','SP05',20,7000000)

insert into PXuat values('X01','06-14-2020','NV02')
insert into PXuat values('X02','03-05-2019','NV03')
insert into PXuat values('X03','02-03-2020','NV01')
insert into PXuat values('X04','06-02-2020','NV02')
insert into PXuat values('X05','05-18-2020','NV01')

insert into Xuat values('X01','SP03',5)
insert into Xuat values('X02','SP01',3)
insert into Xuat values('X03','SP02',1)
insert into Xuat values('X04','SP03',2)
insert into Xuat values('X05','SP05',1)

go
select * from NhanVien
select * from HangSX
select * from SanPham
select * from PNhap
select * from Nhap
select * from PXuat
select * from Xuat
go
select SUM(SoLuongN*DonGiaN) as 'Tong tien nhap' from Nhap
inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
where MONTH(NgayNhap)=8 and YEAR(NgayNhap)=2018
having count(*) > 100000
go
Select SanPham.MaSP,TenSP
From SanPham Inner join nhap on SanPham.MaSP = nhap.MaSP
Where SanPham.MaSP Not In (Select MaSP From Xuat)
go
select SanPham.MaSP, TenSP
from SanPham inner join Nhap on SanPham.MaSP=Nhap.MaSP
inner join Xuat on SanPham.MaSP=Xuat.MaSP
inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
inner join PXuat on Xuat.SoHDX=PXuat.SoHDX
where YEAR(NgayNhap)=2020 and YEAR(NgayXuat)=2020
go
select NhanVien.MaNV,TenNV
from NhanVien inner join PNhap on PNhap.MaNV=NhanVien.MaNV
inner join PXuat on PXuat.MaNV=NhanVien.MaNV
go
select NhanVien.MaNV,TenNV
from NhanVien
where MaNV not in (select MaNV from PNhap inner join PXuat on PNhap.MaNV=PXuat.MaNV)