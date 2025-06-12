
# Q1:A Fetch Employee number,first name,last name

select employeeNumber,firstname,Lastname
From employees
where jobTitle='sales rep'
and reportsTo=1102;

#Q1:B Show the unique Productline

select distinct productline
from products
where productLine like '%cars'; 

#Q2 Case statements for segmentation

use classicmodels;
select CustomerNumber,CustomerName,
case
when country in ('usa','canada') then 'North America'
when country in ('uk','france','germany') then 'Europe'
else 'Other'
end as CustomerSegment
from customers;

#Q3:A Group by with Aggrigation function and Having clause,Date and Time function

select ProductCode,sum(quantityOrdered) As Total_Ordered
from orderdetails
group by productCode
order by Total_Ordered desc
limit 10;

#Q3:B
select monthname(paymentDate) As MonthName,count(*)As PaymentCount
From payments
group by monthname(paymentDate)
having count(*)>20
order by PaymentCount Desc;

#Q4 Constraints:Primary key,foreign key,Unique,not null,default

create database Customers_Orders;
use Customers_Orders;

create table Customers(
customer_id int primary key auto_increment,
first_name varchar(50) not null,
last_name varchar(50) not null,
email varchar(255) unique,
phone_number varchar(20)
);

create table Orders(
order_id int primary key auto_increment,
customer_id int,
order_date date,
total_amount decimal(10,2),
constraint fk_customer foreign key(customer_id)references customers(customer_id),
constraint chk_total check (total_amount>0)
);

#Q5 JOINS

use classicmodels;
select c.country,count(o.orderNumber)As order_count
from customers c
join orders o on c. customerNumber=o.customerNumber
group by c.country
order by order_count desc
limit 5;

#Q6 SELF JOIN
create table project(
EmployeeID int primary key auto_increment,
FullName varchar(50) not null,
Gender enum('Male','Female'),
ManagerID int
);

insert into project (FullName,Gender,ManagerID)values
('Pranaya','Male',3),
('Priyanka','Female',1),
('Preety','Female',null),
('Anurag','Male',1),
('Sambit','Male',1),
('Rajesh','Male',3),
('Hina','Female',3);

select m.fullName as Manager_Name,e.Fullname As Emp_Name
From project e
join project m on e.ManagerID=m.EmployeeID
order by m.FullName;

#Q7 DDL Commands:Create,Alter,Rename

create table facility(
Facility_id int,
Name varchar(100),
State varchar(50),
Country varchar(50)
);

Alter Table Facility
modify Facility_id int auto_increment primary key;

alter table facility
Add city varchar(100) not null After Name;
describe facility;

#Q8 Views in SQL

create view product_category_sales as
select
p1.productline,
sum(od.quantityOrdered*od.priceEach) as total_sales,
count(distinct o.orderNumber)as number_of_orders
from productlines p1
join products p on p1.productLine=p.productLine
join orderdetails od on p.productCode=od.productCode
join orders o on od.orderNumber=o.orderNumber
group by p1.productLine;
select*from product_category_sales;

#Q9 Store Procedure in SQL With Parameters

use classicmodels;
delimiter $$
create procedure Get_country_payments(in input_year int,in input_country varchar(50))
begin
select
year(p.paymentDate)As year,
c.country,
concat(round(sum(p.amount)/1000),'K')As total_amount
from customers c 
join payments p on c.customerNumber=p.customerNumber
where year(p.paymentDate)=input_year
And c.country=input_country
group by year(p.paymentDate),c.country;
end$$
Delimiter ;
call Get_country_payments(2003,'france');

#Q10A Window functions-Rank,dence rank,lead and lag

select
c.customerNumber,
c.customerName,
Count(o.orderNumber)as Order_count,
dense_rank()over(order by count(o.orderNumber)desc)As order_Frequency_rnk
from customers c 
join orders o on c.customerNumber=o.customerNumber
group by c. customerNumber,c.customerName;

#Q10B
select
year(orderDate)as Year,
monthname(orderDate)As Month,
count(orderNumber)As Total_Orders,
concat(
round(
(count(orderNumber)-
Lag(count(orderNumber))over( order by year(orderDate),month(orderDate))
)*100.0/
Lag(count(orderNumber))over(order by year(orderDate),month(orderDate))
),'%'
)As YOY_change
From orders
group by year(orderDate),month(orderDate)
order by year(orderDate),month(orderDate);

#Q11 Subqueries and their applications

use classicmodels;
select productline,count(*)As Total
From products
where buyprice>(
select avg(buyprice)
from products
)
group by productLine
order by total desc;

#Q12 Error handling in SQL

create table Emp_EH(
EmpID int primary key,
EmpName varchar(100),
EmailAddress varchar(100)
);

Delimiter $$
create procedure insert_Emp_EH(
in p_EmpID int,
in p_EmpName varchar(100),
in p_EmailAddress varchar(100)
)
begin
declare continue handler for sqlexception
begin
select'error occurred' As ErrorMessage;
end;
insert into Emp_EH (EmpID,EmpName,EmailAddress)
values(p_EmpID,p_EmpName,p_EmailAddress);
End$$
Delimiter ;
#Example For test Proceduere
call insert_Emp_EH(1,'Jhon Doe','john@example.com');
call insert_Emp_EH(1,'Hithesh','hitheshkgk@gamil.com'); #id's Were Same trigger An error
select*from Emp_EH;

#Q13 Triggers

create table Emp_BIT(
Name varchar(50),
Occupation varchar(50),
Working_date date,
Working_hours int
);

delimiter $$
create trigger before_insert_Emp_BIT
before insert on Emp_BIT
for each row
begin
if New.Working_hours<0 then
set new.working_hours=abs(new.Working_hours);
end if;
End$$
delimiter ;
insert into Emp_BIT values
('Robin','Scientist','2020-10-04',12),
('Warner','Engineer','2020-10-04',10),
('Peter','Actor','2020-10-04',13),
('Marco','Doctor','2020-10-04',14),
('Brayden','Teacher','2020-10-04',12),
('Antonio','Business','2020-10-04',-11);
select*from Emp_BIT;








