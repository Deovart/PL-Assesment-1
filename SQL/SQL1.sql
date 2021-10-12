
create database assessment

use assessment

CREATE SCHEMA cd AUTHORIZATION dbo 

create table assessment.cd.members(memid int,surname varchar(200),firstname varchar(200),address varchar(300), zipcode int, joindate timestamp )
drop table cd.members




create table assessment.cd.bookings(memid int,facid int, no_of_slots_booked int,starttime timestamp)


create table assessment.cd.facilities(facid int,name varchar(200), membercost numeric,guestcost numeric,initialcost numeric, monthlymaintenance numeric)


select * from cd.members

delete cd.members
--Members
insert into cd.members(memid,surname,firstname,address,zipcode) values (1,'Verma','Dev','Raipur',490001),(2,'Sharma','Deva','Bhilai',490006)
insert into cd.members(memid,surname,firstname,address,zipcode) values (3,'Rathore','Abhay','Raipur',490009),(4,'D','Rupesh','Bhilai',490006)
--Bookings
insert into cd.bookings(memid,facid,no_of_slots_booked) values(1,100,5)
insert into cd.bookings(memid,facid,no_of_slots_booked) values(2,200,9),(3,300,2),(4,400,12)
--Assessment
insert into cd.facilities values(100,'Dev',1500,1000,500,100)

insert into cd.facilities values(100,'Abhay',1700,1100,600,100),(100,'Ketan',1600,1200,700,100),(100,'Deva',2000,1300,800,100)

UPDATE cd.facilities
SET name = 'Facility1' WHERE cd.facilities.name in ('Dev','Deva','Abhay','Ketan');

--Q1
select cd.members.memid, cd.members.firstname,cd.bookings.starttime, cd.bookings.no_of_slots_booked from cd.bookings full join cd.members on cd.bookings.memid = cd.members.memid where cd.members.firstname like 'Dev';

select   cd.members.memid,distinct cd.members.firstname from cd.members where cd.members.memid is not null;

--Q2
select cd.members.surname,cd.members.firstname, count(cd.members.surname)  from cd.members
group by cd.members.surname, cd.members.firstname having cd.members.surname is not null order by cd.members.surname,cd.members.firstname ;

--Q3

--select cd.members.surname,cd.members.firstname as 'Name' from cd.members right join cd.bookings on cd.bookings.memid = cd.members.memid where cd.bookings.facid in (select cd.facilities.facid from cd.facilities);`
select * from cd.facilities
select * from cd.bookings

--select cd.members.surname,cd.bookings.name) as 'Name' from cd.members right join cd.members on cd.members.memid = cd.bookings.memid where cd.bookings.facid in (select cd.facilities.facid from cd.facilities);

select cd.members.firstname,cd.members.surname, cd.bookings.facid  into mem_book from cd.bookings full join cd.members on cd.members.memid = cd.bookings.memid;

select distinct (concat(mem_book.firstname, cd.facilities.name)) as Concat_Facility from mem_book right join cd.facilities on cd.facilities.facid = mem_book.facid order by Concat_Facility

--Q4

select * from cd.facilities where cd.facilities.guestcost >1000;

--Q5

select cd.facilities.name, count(facilities.name) as Count_Facility ,  count(cd.bookings.no_of_slots_booked) as Count_Booking from cd.bookings right join cd.facilities on cd.facilities.facid = cd.bookings.facid group by cd.facilities.name;

--Q6

select memid, surname, firstname, joindate 
	from cd.members
	where joindate >= convert(timestamp,'2012-09-01')

--Q7
select cd.facilities.name, cd.facilities.facid, cd.bookings.no_of_slots_booked, cd.bookings.memid  into Facility_Table_mem from cd.bookings full join cd.facilities on cd.facilities.facid = cd.bookings.facid
select* from Facility_Table
--select Facility_Table.facid from Facility_Table where max(Facility_Table.no_of_slots_booked) = Facility_Table.no_of_slots_booked

SELECT Facility_Table.facid, MAX(Facility_Table.no_of_slots_booked)
FROM Facility_Table
GROUP BY Facility_Table.facid


--Q8

select cd.members.firstname, Facility_Table_mem.no_of_slots_booked, rank() over (partition by Facility_Table_mem.no_of_slots_booked order by cd.members.firstname) as Rank1 from Facility_Table_mem full join cd.members on cd.members.memid = Facility_Table_mem.facid order by Rank1


--Q9 No of slots * membercost
select cd.facilities.name, cd.facilities.facid, cd.facilities.membercost, cd.bookings.no_of_slots_booked, cd.bookings.memid  into Facility_Table_All from cd.bookings full join cd.facilities on cd.facilities.facid = cd.bookings.facid

select Facility_Table_All.name, rank() over (partition by Facility_Table_All.no_of_slots_booked order by cd.members.firstname) as Rank2, (Facility_Table_All.no_of_slots_booked*Facility_Table_All.membercost) as Revenue from Facility_Table_All full join cd.members on cd.members.memid = Facility_Table_All.memid order by Rank2, Facility_Table_All.name
