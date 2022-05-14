Use Northwind
Go
--1. Create a view named “view_product_order_[your_last_name]”, 
--list all products and total ordered quantity for that product.

create view view_product_order_Gao as
select p.ProductName, Count(o.Quantity) QuantityCount 
from Products p inner join [Order Details] o
on o.ProductID = p.ProductID
group by p.ProductName;

Select * from view_product_order_Gao

---
Create View view_product_order_Gao as (
select p.ProductName, SUM(od.Quantity) as 'Total ordered quantity'
from Orders o join [Order Details] od
on o.OrderID = od.OrderID
join Products p on p.ProductID = od.ProductID
group by p.ProductName
)

Select * from view_product_order_Gao


--2. Create a stored procedure “sp_product_order_quantity_[your_last_name]”
--that accept product id as an input and total quantities of order as output parameter.
create proc sp_product_order_quantity_Gao
@id int,
@total int output
as
begin
select @id = view_product_order_Gao_ID.ProductID
,@total = view_product_order_Gao_ID.[Total Ordered Quantity]
from view_product_order_Gao_ID
where ProductID = @id
return;
end

declare @all int 
exec sp_product_order_quantity_Gao 23, @total=@all output;
print @all

----
Create Proc sp_product_order_quantity_He
@a int
As 
Begin
	select * from view_product_order_He_ID
	where ProductID = @a
End

--ID:23 totalquantity:580
Exec sp_product_order_quantity_He 23


--3. Create a stored procedure “sp_product_order_city_[your_last_name]” 
--that accept product name as an input and top 5 cities that ordered most 
--that product combined with the total quantity of that product ordered from 
--that city as output.

Create Proc sp_product_order_city_Gao
@a varchar(15)
As 
Begin
	Select top 5 *, dense_RANK() over(Partition by ProductName
	Order by [Total Ordered] desc) as 'Rank of city sales'
	from (
	Select p.ProductName , o.ShipCity, 
	Sum(od.Quantity) as [Total Ordered]
	from Orders o join [Order Details] od
	on o.OrderID = od.OrderID join Products p
	on od.ProductID = p.ProductID
	group by p.ProductName, o.ShipCity) as [ProductCityQuantity]
	where @a = ProductName
End

Exec sp_product_order_city_Gao 'Alice Mutton'


--4. Create 2 new tables “people_your_last_name” “city_your_last_name”. 
--City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. 
--People has three records: {id:1, Name: Aaron Rodgers, City: 2}, 
--{id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. 
--Remove city of Seattle. If there was anyone from Seattle, put them into a new city 
--“Madison”. Create a view “Packers_your_name” lists all people from Green Bay. 
--If any error occurred, no changes should be made to DB. 
--(after test) Drop both tables and view.

create table people_gao(id int,name char(20),cityid int)
create table city_gao(cityid int,city char(20))
insert into people_gao(id,name,cityid)values(1,'Aaron Rodgers',2)
insert into people_gao(id,name,cityid)values(2,'Russell Wilson',1)
insert into people_gao(id,name,cityid)values(3,'Jody Nelson',2)
insert into city_gao(cityid,city)values(1,'Settle')
insert into city_gao(cityid,city)values(2,'Green Bay')

select * from people_gao
select * from city_gao

create view Packers_celia_gao as
select p.id, p.name from people_gao p inner join city_gao c on p.cityid=c.cityid
where c.city='Green bay'

Select * from Packers_celia_gao


begin tran rollback
drop table people_gao
drop table city_gao
drop view Packers_celia_gao



--5. Create a stored procedure “sp_birthday_employees_[you_last_name]”
--that creates a new table “birthday_employees_your_last_name” and fill it 
--with all employees that have a birthday on Feb. (Make a screen shot) drop the table. 
--Employee table should not be affected.

Create Proc sp_birthday_employees_Gao
As 
Begin
	create Table birthday_employees_your_Gao(
	EmployeeId int unique,
	LastName varchar(30),
	FirstName varchar(30),
	Title varchar(30),
	Birthday datetime
	);
	Insert Into birthday_employees_your_Gao 
	(EmployeeId, LastName, FirstName, Title, Birthday)
	Select EmployeeID, LastName, FirstName, Title, BirthDate 
	From Employees
	Where Month(BirthDate) = 2
End


Exec sp_birthday_employees_Gao
Select * from birthday_employees_your_Gao
Drop table birthday_employees_your_Gao



--6.      How do you make sure two tables have the same data?

--store the total data number for both table and do the union, and check, if the
--number of data for two table is not the same number of data with union table, then they
--do not have same data.