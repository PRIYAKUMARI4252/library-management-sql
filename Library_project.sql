create database Library;
use Library;

drop table tbl_publisher;

create table tbl_publisher(publisher_PublisherName varchar(50) primary key,
publisher_PublisherAddress varchar(150),publisher_PublisherPhone varchar(50));

select * from tbl_publisher;

drop table tbl_book;

create table tbl_book(book_BookId int primary key auto_increment,book_Title varchar(100),
book_PublisherName varchar(50),foreign key(book_PublisherName)
references tbl_publisher(publisher_PublisherName)
on delete cascade on update cascade);
 
 select * from tbl_book;
 
 drop table tbl_book_authors;
 
 create table tbl_book_authors(book_authors_AuthorId int primary key auto_increment,
 book_authors_BookId int,book_authors_AuthorName varchar(50),foreign key(book_authors_BookId) 
 references tbl_book(book_BookId) on delete cascade on update cascade);
 
select * from tbl_book_authors; 


create table tbl_library_branch(library_branch_BranchId int primary key auto_increment,
library_branch_BranchName varchar(20),library_branch_BranchAdress varchar(20));

select * from tbl_library_branch;

drop table tbl_book_copies;

create table tbl_book_copies(book_copies_CopiesId int primary key auto_increment,
book_copies_BookId int,book_copies_BranchId int,book_copies_No_of_Copies int,
foreign key(book_copies_BookId) references tbl_book(book_BookId),
foreign key(book_copies_BranchId) references tbl_library_branch(library_branch_BranchId)
on delete cascade on update cascade);

select * from tbl_book_copies;

create table tbl_borrower(borrower_CardNo int primary key auto_increment,
borrower_BorrowerName varchar(50),borrower_BorrowerAdress varchar(50),
borrower_BorrowerPhone varchar(50));

select * from tbl_borrower;

drop table tbl_book_loans;

create table tbl_book_loans(book_loans_LoansId int primary key auto_increment,
book_loans_BookId int,book_loans_BranchId int,book_loans_CardNo int,
book_loans_DateOut date,book_loans_DueDate date,
foreign key(book_loans_BookId) references tbl_book(book_BookId),
foreign key(book_loans_BranchId) references tbl_library_branch(library_branch_BranchId),
foreign key(book_loans_CardNo) references tbl_borrower(borrower_CardNo)
on delete cascade on update cascade);

select * from tbl_book_loans;


-- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select * from tbl_library_branch;
select * from tbl_book_copies;
select * from tbl_book;

select bo.book_title,br.library_branch_BranchName,co.book_copies_No_of_Copies from
tbl_library_branch as br inner join tbl_book_copies as co on br.library_branch_BranchId=co.book_copies_BranchId
inner join tbl_book as bo on co.book_copies_BookId=bo.book_BookId  
where bo.book_Title='The Lost Tribe' and br.library_branch_BranchName='Sharpstown';

-- 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?

select bo.book_title,br.library_branch_BranchName,co.book_copies_No_of_Copies from
tbl_library_branch as br inner join tbl_book_copies as co on br.library_branch_BranchId=co.book_copies_BranchId
inner join tbl_book as bo on co.book_copies_BookId=bo.book_BookId  
where bo.book_Title='The Lost Tribe';

select sum(co.book_copies_No_of_Copies) from
tbl_library_branch as br inner join tbl_book_copies as co on br.library_branch_BranchId=co.book_copies_BranchId
inner join tbl_book as bo on co.book_copies_BookId=bo.book_BookId  
where bo.book_Title='The Lost Tribe';

-- 3.Retrieve the names of all borrowers who do not have any books checked out.
select * from tbl_borrower;
select * from tbl_book_loans;
select * from tbl_borrower left join tbl_book_loans on tbl_borrower.borrower_CardNo=tbl_book_loans.book_loans_CardNo;

select borrower_BorrowerName from tbl_borrower left join tbl_book_loans on tbl_borrower.borrower_CardNo=tbl_book_loans.book_loans_CardNo
where book_loans_CardNo is NULL;

-- 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, 
-- retrieve the book title, the borrower's name, and the borrower's address. 
select * from tbl_borrower;
select * from tbl_library_branch;
select * from tbl_book_loans;
select * from  tbl_book;

select t.book_title,b.borrower_BorrowerName,b.borrower_BorrowerAdress from tbl_book as t inner join
tbl_book_loans as l on t.book_BookId=l.book_loans_BookId inner join tbl_library_branch as br on l.book_loans_BranchId=br.library_branch_BranchId
inner join tbl_borrower as b on l.book_loans_CardNo=b.borrower_CardNo where l.book_loans_DueDate='2018-02-03' and 
br.library_branch_BranchName='Sharpstown';

-- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select * from tbl_library_branch;
select * from tbl_book_loans;
select * from tbl_book;

select br.library_branch_BranchName,count(l.book_loans_BranchId) from tbl_library_branch as br inner join tbl_book_loans as l on
br.library_branch_BranchId=l.book_loans_BranchId group by br.library_branch_BranchName;

-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select * from tbl_borrower;
select * from tbl_book_loans;

select b.borrower_BorrowerName,b.borrower_BorrowerAdress,count(l.book_loans_CardNo)as bookchecked from tbl_borrower as b inner join tbl_book_loans as l
on b.borrower_CardNo=l.book_loans_CardNo group by b.borrower_CardNo,b.borrower_BorrowerName,b.borrower_BorrowerAdress 
having bookchecked>5;

-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

select * from tbl_book_authors;
select * from tbl_book;
select * from tbl_book_copies;
select * from tbl_book_loans;
select * from tbl_library_branch;

select b.book_Title,c.book_copies_No_of_Copies from tbl_book_copies as c inner join tbl_book as b on b.book_BookId=c.book_copies_BookId
inner join tbl_book_authors as a on b.book_BookId=a.book_authors_BookId 
inner join tbl_library_branch as br on c.book_copies_BranchId=br.library_branch_BranchId
where a.book_authors_AuthorName='Stephen King' and br.library_branch_BranchName='Central';






