use master
go
if(exists(select * from sysdatabases where name='QLBanHang'))
	drop database QLBanHang
go
use master
go
create database QLBanHang
go
use QLBanHang
go
create table HangSX
(
		MaHangSX nchar(10) not null primary key,
		TenHang nvarchar(20) not null,
		DiaCHi nvarchar(30),
		SoDT nvarchar(20),
		Email nvarchar(30),
)
create table SanPham
(
       MaSP nchar(10) not null primary key,
	   MaHangSX nchar(10) not null,
	   TenSP nvarchar(20) not null,
	   SoLuong int,
	   MauSac nvarchar(20),
	   GiaBan money,
	   DonViTinh nchar(10),
	   MoTa nvarchar(20),
	   constraint fk_SanPham_HangSX foreign key(MaHangSX) references HangSX(MaHangSX),
)
create table NhanVien
(
		MaNV nchar(10) not null primary key,
		TenNV nvarchar(20) not null,
		GioiTinh nchar(10),
		DiaChi nvarchar(30),
		SoDT nvarchar(20),
		Email nvarchar(30),
		TenPhong nvarchar(30),
)
create table PNhap
(
		SoHDN nchar(10) not null primary key,
		NgayNhap date,
		MaNV nchar(10) not null,
		constraint fk_PNhap_NhanVien foreign key(MaNV) references NhanVien(MaNV),
)
create table Nhap
(
		SoHDN nchar(10) not null,
		MaSP nchar(10) not null,
		SoLuongN int,
		DonGiaN money,
		constraint pk_Nhap primary key(SoHDN,MaSP),
		constraint fk_Nhap_PNhap foreign key(SoHDN) references PNhap(SoHDN),
		constraint fk_Nhap_SanPham foreign key(MaSP) references SanPham(MaSP),

)
create table PXuat
(
		SoHDX nchar(10) not null primary key,
		NgayXuat date,
		MaNV nchar(10) not null,
		constraint fk_PXuat_NhanVien foreign key(MaNV) references NhanVien(MaNV),
)
create table Xuat
(
		SoHDX nchar(10) not null,
		MaSP nchar(10) not null,
		SoLuongX int,
		constraint pk_Xuat primary key(SoHDX,MaSP),
		constraint fk_Xuat_PXuat foreign key(SoHDX) references PXuat(SoHDX),
		constraint fk_Xuat_SanPham foreign key(MaSP) references SanPham(MaSP),
)
go
insert into HangSX values('H01','SamSung','Korea','011-08272727','ss@gmail.com.kr'),('H02','OPPO','China','081-08626262','oppo@gmail.com.cn'),('H03','Vinafone',N'Việt Nam','084-098262626','vf@gmail.com.vn')
insert into SanPham values('SP01','H02','F1 Plus',100,N'Xám',7000000,N'Chiếc',N'Hàng cận cao cấp'),('SP02','H01','Galaxy Note11',50,N'Đỏ',19000000,N'Chiếc',N'Hàng cao cấp'),('SP03','H02','F1 lite',200,N'Nâu',3000000,N'Chiếc',N'Hàng phổ thông')
insert into NhanVien values('NV01',N'Nguyễn Thị Thu',N'Nữ',N'Hà Nội','0982626521','thu@gmail.com',N'Kế toán'),('NV02',N'Lê Văn Nam',N'Nam',N'Bắc Ninh','0972525252','nam@gmail.com',N'Vật tư'),('NV03',N'Trần Hòa Bình',N'Nữ',N'Hà Nội','0328388388','hb@gmail.com',N'Kế toán')
insert into PNhap values('N01','02-05-2019','NV01'),('N02','04-07-2020','NV02'),('N04','03-22-2020','NV03')
insert into Nhap values('N01','SP02',10,17000000),('N02','SP01',30,6000000),('N04','SP01',20,1200000)
insert into PXuat values('X01','06-14-2020','NV02'),('X02','03-05-2019','NV03'),('X03','12-12-2020','NV01')
insert into Xuat values('X01','SP03',5),('X02','SP01',3),('X03','SP02',1)

go
create function fn_caua(@DiaCHi nvarchar(30))
returns @bang table(
MaHangSX nchar(10),
TenHang nvarchar(20),
DiaCHi nvarchar(30),
SoDT nvarchar(20),
Email nvarchar(30)
)
as
begin 
insert into @bang 
select HangSX.MaHangSX,TenHang,DiaCHi,SoDT,Email
from HangSX 
where DiaCHi=@DiaCHi
return
end
select * from fn_caua(N‘Hà Nội’)
go
create function fn_caub(@x date,@y date)
returns @bang table(
MaSP nvarchar(10),
TenSP nvarchar(20),
TenHang nvarchar(20),
NgayNhap date,
SoLuongN int,
DonGiaN float
)
as
begin
insert into @bang
select SanPham.MaSP, TenSP, TenHang, NgayNhap, SoLuongN, DonGiaN
from Nhap Inner join SanPham on Nhap.MaSP = SanPham.MaSP
Inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
Inner join PNhap on PNhap.SoHDN=Nhap.SoHDN
where NgayNhap Between @x And @y
Return
End
select * from fn_caub(‘2/9/2018’,’3/9/2021’)
go
create function fn_cauc(@TenHang nvarchar(20), @flag int)
returns @bang table(
MaSP nvarchar(10),
TenSP nvarchar(20),
TenHang nvarchar(20),
SoLuong int,
MauSac nvarchar(20),
GiaBan money,
DonViTinh nvarchar(10),
MoTa nvarchar(20)
)
as
begin
if(@flag=0)
insert into @bang
select SanPham.MaSP,TenSP,SoLuong,MauSac,GiaBan,DonViTinh,MoTa
from SanPham inner join HangSX on SanPham.MaHangSX=HangSX.MaHangSX
inner join Nhap on SanPham.MaSP=Nhap.MaSP
where TenHang=@TenHang
else
if(@flag=0)
insert into @bang
select SanPham.MaSP,TenSP,SoLuong,MauSac,GiaBan,DonViTinh,MoTa
from SanPham inner join HangSX on SanPham.MaHangSX=HangSX.MaHangSX
inner join Xuat on SanPham.MaSP=Xuat.MaSP
where TenHang=@TenHang
return
end
select * from fn_cauc(‘Samsung’,0)
select * from fn_cauc(‘Samsung’,1)
go
create function fn_caud(@NgayNhap int)
returns @bang table(
MaNV nchar(10),
TenNV nvarchar(20),
GioiTinh nchar(10),
DiaChi nvarchar(30),
SoDT nvarchar(20),
Email nvarchar(30),
TenPhong nvarchar(30)
)
as
begin
insert into @bang
select NhanVien.MaNV,TenNV,GioiTinh,DiaChi,SoDT,Email,TenPhong
from NhanVien inner join PNhap on NhanVien.MaNV=PNhap.MaNV
where DAY(NgayNhap)=@NgayNhap
return 
end
select * from fn_caud(24)
go
create function fn_caue(@x money,@y money,@z nvarchar(20))
returns @bang table(
MaSP nvarchar(10),
TenSP nvarchar(20),
TenHang nvarchar(20),
NgayNhap date,
SoLuongN int,
DonGiaN float
)
as
begin
insert into @bang
select SanPham.MaSP, TenSP, TenHang, NgayNhap, SoLuongN, DonGiaN
from Nhap Inner join SanPham on Nhap.MaSP = SanPham.MaSP
Inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
where GiaBan between @x and @y and TenHang=@z
return 
end
select * from fn_caue(120000,200000,'SamSung')
go
create function fn_cauf
returns @bang table(
MaSP nvarchar(10),
TenSP nvarchar(20),
TenHang nvarchar(20),
NgayNhap date,
SoLuongN int,
DonGiaN float
)
as
begin
insert into @bang
select SanPham.MaSP, TenSP, TenHang, NgayNhap, SoLuongN, DonGiaN
from Nhap Inner join SanPham on Nhap.MaSP = SanPham.MaSP
Inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
return 
end
select * from fn_cauf
go





