-- DDL 
Drop Database if Exists onlineBooking;
Create Database onlineBooking;  -- Create Database

Use onlineBooking;

-- DDL
-- Create tables and add constraints
-- Customers Table
Drop Table If Exists Customers; 
Create Table Customers
(
customer_ID INT IDENTITY(1,1),
cust_Fname VARCHAR(255) NOT NULL,
cust_Lname VARCHAR(255) NOT NULL,
cust_BirthDate DATE NOT NULL,
cust_Email VARCHAR(500) NOT NULL,
cust_Password VARCHAR(500) NOT NULL,
cust_MobileNo VARCHAR(10),
cust_Sex CHAR(1) NOT NULL Constraint CK_Customers_custSex Check( cust_Sex IN ('F','M') ),
cust_City VARCHAR(500) NOT NULL,
cust_Location VARCHAR(500),
cust_PostalCode INT
Constraint PK_Customers_customerID Primary Key(customer_ID)
);

-- Shows Table
Drop Table If Exists Shows; 
Create Table Shows
(
show_ID INT IDENTITY(1,1),
show_StartTime TIME,
show_EndTime TIME,
show_Date DATE,
show_Language VARCHAR(500),
movie_ID INT,
theatre_ID INT,
Constraint PK_Shows Primary Key( show_ID, show_StartTime, show_EndTime, show_Date, theatre_ID)
);

-- Movie Table
Drop Table If Exists Movies; 
Create Table Movies
(
movie_ID INT IDENTITY(1,1),
movie_Name NVARCHAR(500) NOT NULL,
movie_Description NVARCHAR(500),
movie_Age INT,
movie_Genre VARCHAR(500),
movie_Duration TIME,
movie_ReleaseDate DATE,
movie_FnameDirector NVARCHAR(255),
movie_LnameDirector NVARCHAR(255)
Constraint PK_Movies_movieID Primary Key(movie_ID)
);

-- Theatres Table
Drop Table If Exists Theatres; 
Create Table Theatres
(
theatre_ID INT IDENTITY(1,1),
theatre_Name VARCHAR(500),
city_ID INT,
floor_ID INT,
mall_ID INT,
Constraint UQ_Theatres_theatreName UNIQUE(theatre_Name),
Constraint PK_Theatres_theatreID Primary Key(theatre_ID)
);

-- Cities Table
Drop Table If Exists Cities; 
Create Table Cities
(
city_ID INT IDENTITY(1,1),
city_Name VARCHAR(500) NOT NULL
Constraint PK_Cities_cityID Primary Key(city_ID)
);

-- Floors Table
Drop Table If Exists Floors; 
Create Table Floors
(
floor_ID INT IDENTITY(1,1),
floor_Name INT NOT NULL
Constraint PK_Floors_floorID Primary Key(floor_ID)
);

-- Malls Table
Drop Table If Exists Malls; 
Create Table Malls
(
mall_ID INT IDENTITY(1,1),
mall_Name VARCHAR(500) NOT NULL
Constraint PK_Malls_mallID Primary Key(mall_ID)
);

-- Rows_Theatre Table
Drop Table If Exists Rows_Theatre; 
Create Table Rows_Theatre
(
row_ID INT IDENTITY(1,1),
row_Name CHAR(1) NOT NULL Constraint CK_RowsTheatre_rowName CHECK( row_Name IN ('A','B','C','D','E','F','G','H','J','K','L','M') ),
theatre_ID INT
Constraint PK_RowsTheatre_rowID Primary Key(row_ID)
);

-- Seats Table
Drop Table If Exists Seats;
Create Table Seats
(
seat_ID INT IDENTITY(1,1),
seat_No INT NOT NULL Constraint CK_Seats_seatNo CHECK( seat_No IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15) ),
row_ID INT NOT NULL,
seatType_ID INT NOT NULL
Constraint PK_Seats_seatID Primary Key(seat_ID)
);

-- Seat_Types Table
Drop Table If Exists Seat_Types;
Create Table Seat_Types
(
seatType_ID INT IDENTITY(1,1),
seatType_Name VARCHAR(8) NOT NULL Constraint CK_SeatTypes_seatTypeName CHECK( seatType_Name IN ('STANDARD','RIGHT','LEFT') )
Constraint PK_SeatTypes_seatTypeID Primary Key(seatType_ID)
);

-- Admins Table
Drop Table If Exists Admins;
Create Table Admins
(
admin_ID INT IDENTITY(1,1),
admin_UserName VARCHAR(255),
admin_Email VARCHAR(500) NOT NULL,
admin_Password VARCHAR(500) NOT NULL,
admin_Sex VARCHAR(1) Constraint CK_Admins_adminSex CHECK( admin_Sex IN ('F','M') )
Constraint PK_Admins_adminID Primary Key(admin_ID)
);

-- Bookings Table
Drop Table If Exists Bookings;
Create Table Bookings
(
booking_ID INT IDENTITY(1,1),
booking_Date DATE Constraint DF_Bookings_bookingDate DEFAULT SYSDATETIME(),
has_paid_ticket BIT Constraint CK_Bookings_hasPaidTicket CHECK ( has_paid_ticket IN (0,1) ),
quantity INT DEFAULT(1),
customer_ID INT,
ticket_ID INT,
admin_ID INT,
Constraint PK_Bookings Primary Key( booking_ID, customer_ID, ticket_ID )
);

-- Create Sequance
CREATE SEQUENCE Ticket_Number
AS INT
START WITH 000001
INCREMENT BY 1;

-- Tickets Table
Drop Table If Exists Tickets;
Create Table Tickets
(
ticket_ID INT IDENTITY(1,1),
ticket_Num INT Constraint DF_Tickets_ticketNum DEFAULT( NEXT VALUE FOR Ticket_Number),
ticket_Price DECIMAL(10,2),
show_ID INT,
show_StartTime TIME,
show_EndTime TIME ,
show_Date DATE,
theatre_ID INT
Constraint PK_Tickets_ticketID Primary Key(ticket_ID)
); 
-------------------------------------------------------------------------------------------------------
-- Add FK Constraint for Tickets Table - Shows Table
ALTER TABLE Tickets
ADD CONSTRAINT FK_Tickets_Shows
FOREIGN KEY (show_ID,show_StartTime, show_EndTime, show_Date, theatre_ID)
REFERENCES Shows(show_ID,show_StartTime, show_EndTime, show_Date, theatre_ID)
on delete cascade on update cascade;

-- Add FK Constraint for Bookings Table - Customers Table
ALTER TABLE Bookings
ADD CONSTRAINT FK_Bookings_Customers
FOREIGN KEY (customer_ID) REFERENCES Customers(customer_ID) on delete cascade on update cascade;

-- Add FK Constraint for Bookings Table - Tickets Table
ALTER TABLE Bookings
ADD CONSTRAINT FK_Bookings_Tickets
FOREIGN KEY (ticket_ID) REFERENCES Tickets(ticket_ID) on delete cascade on update cascade;

-- Add FK Constraint for Bookings Table - Admins Table
ALTER TABLE Bookings
ADD CONSTRAINT FK_Bookings_Admins
FOREIGN KEY (admin_ID) REFERENCES Admins(admin_ID) on delete cascade on update cascade;

-- Add FK Constraint for Seats Table - Seat_Types Table
ALTER TABLE Seats
ADD CONSTRAINT FK_Seats_SeatTypes
FOREIGN KEY (seatType_ID) REFERENCES Seat_Types(seatType_ID) on delete cascade on update cascade;

-- Add FK Constraint for Seats Table - Rows_Theatre Table
ALTER TABLE Seats
ADD CONSTRAINT FK_Seats_RowsTheatre
FOREIGN KEY (row_ID) REFERENCES Rows_Theatre(row_ID) on delete cascade on update cascade;

-- Add FK Constraint for Rows_Theatre Table - Theatres Table
ALTER TABLE Rows_Theatre
ADD CONSTRAINT FK_RowsTheatre_Theatres
FOREIGN KEY (theatre_ID) REFERENCES Theatres(theatre_ID) on delete cascade on update cascade;

-- Add FK Constraint for Theatres Table - Cities Table
ALTER TABLE Theatres
ADD CONSTRAINT FK_Theatres_Cities
FOREIGN KEY (city_ID) REFERENCES Cities(city_ID) on delete cascade on update cascade;

-- Add FK Constraint for Theatres Table - Floors Table
ALTER TABLE Theatres
ADD CONSTRAINT FK_Theatres_Floors
FOREIGN KEY (floor_ID) REFERENCES Floors(floor_ID) on delete cascade on update cascade;

-- Add FK Constraint for Theatres Table - Malls Table
ALTER TABLE Theatres
ADD CONSTRAINT FK_Theatres_Malls
FOREIGN KEY (mall_ID) REFERENCES Malls(mall_ID) on delete cascade on update cascade;

-- Add FK Constraint for Shows Table - Movies Table
ALTER TABLE Shows
ADD CONSTRAINT FK_Shows_Movies
FOREIGN KEY (movie_ID) REFERENCES Movies(movie_ID) on delete cascade on update cascade;

-- Add FK Constraint for Shows Table - Theatres Table
ALTER TABLE Shows
ADD CONSTRAINT FK_Shows_Theatres
FOREIGN KEY (theatre_ID) REFERENCES Theatres(theatre_ID) on delete cascade on update cascade;
---------------------------------------------------------------------------------------------------------------
-- DML
Use onlineBooking;

-- Admins
INSERT INTO Admins (admin_UserName, admin_Email, admin_Password, admin_Sex)
OUTPUT Inserted.*
VALUES
    ('Mays Smith', 'mayssmith@gmail.com', '1234567', 'F'),
    ('Nadeen Johnson', 'nadeenjohnson@gmail.com', '1234', 'F'),
    ('John Doe', 'johndoe@gmail.com', 'password3', 'M'),
    ('Jane Smith', 'janesmith@gmail.com', 'password4', 'F'),
    ('Bob Johnson', 'bobjohnson@gmail.com', 'password5', 'M'),
    ('Alice Smith', 'alicesmith@gmail.com', 'password6', 'F'),
    ('Michael Johnson', 'michaeljohnson@gmail.com', 'password7', 'M'),
    ('Sara White', 'sarawhite@gmail.com', 'password8', 'F'),
    ('David Smith', 'davidsmith@gmail.com', 'password9', 'M'),
    ('Emily Johnson', 'emilyjohnson@gmail.com', 'password10', 'F'),
    ('Daniel White', 'danielwhite@gmail.com', 'password11', 'M'),
    ('Olivia Smith', 'oliviasmith@gmail.com', 'password12', 'F'),
    ('Matthew Johnson', 'matthewjohnson@gmail.com', 'password13', 'M'),
    ('Ella White', 'ellawhite@gmail.com', 'password14', 'F'),
    ('James Smith', 'jamessmith@gmail.com', 'password15', 'M'),
    ('Ava Johnson', 'avajohnson@gmail.com', 'password16', 'F'),
    ('William White', 'williamwhite@gmail.com', 'password17', 'M'),
    ('Sophia Smith', 'sophiasmith@gmail.com', 'password18', 'F'),
    ('Christopher Johnson', 'christopherjohnson@gmail.com', 'password19', 'M'),
    ('Emma White', 'emmawhite@gmail.com', 'password20', 'F');


-- Customers
INSERT INTO Customers (cust_Fname, cust_Lname, cust_BirthDate, cust_Email, cust_Password, cust_MobileNo, cust_Sex, cust_City, cust_Location, cust_PostalCode)
OUTPUT Inserted.*
VALUES
(
    'Saleh', 'Abdullah', '1990-05-15', 'saleh.abdullah@gmail.com', 'password1', '1234567890', 'M', 'Amman', 'Rainbow Street', '11110'
),
(
    'Layla', 'Mohammed', '1985-08-20', 'layla.mohammed@gmail.com', 'password2', '9876543210', 'F', 'Irbid', 'Abu Bakr Street', '21110'
),
(
    'Ahmed', 'Ali', '1993-03-10', 'ahmed.ali@gmail.com', 'password3', '5555555555', 'M', 'Zarqa', 'Al-Zaytoon Street', '13100'
),
(
    'Fatima', 'Hassan', '1988-12-05', 'fatima.hassan@gmail.com', 'password4', '1111111111', 'F', 'Aqaba', 'Al-Hussein Street', '77110'
),
(
    'Omar', 'Khalid', '1991-09-25', 'omar.khalid@gmail.com', 'password5', '2222222222', 'M', 'Karak', 'Al-Mutasim Street', '66110'
),
(
    'Mona', 'Hamed', '1987-07-15', 'mona.hamed@gmail.com', 'password99', '9999999999', 'F', 'Tafilah', 'Al-Ahmad Street', '66111'
),
(
    'Hassan', 'Ibrahim', '1992-02-03', 'hassan.ibrahim@gmail.com', 'password100', '8888888888', 'M', 'Maan', 'Al-Hussein Street', '72110'
);



-- Movies
Insert Into Movies(movie_Name,movie_Description,movie_Age,movie_Genre,movie_Duration,movie_ReleaseDate,movie_FnameDirector,movie_LnameDirector)
Output Inserted.*
Values
(
N'من أجل زيكو',
N'تدور أحداثه حول زيكو الطفل الوحيد لعائلة مجنونة ومضحكة، تتحول حياتهم رأسًا على عقب عندما يربح زيكو فرصة المشاركة في مسابقة "أذكى طفل في مصر"، وياخذنا المخرج في رحلة مليئة بالكوميديا والمغامرات علي مدار يومين.',
1,'Comedy','01:33:22','05-01-2022',N'بيتر',N'ميمي'
);
-- Movies
INSERT INTO Movies (movie_Name, movie_Description, movie_Age, movie_Genre, movie_Duration, movie_ReleaseDate, movie_FnameDirector, movie_LnameDirector)
OUTPUT Inserted.*
VALUES
(
    'Bee Movie',
    N'Barry B. Benson, a bee just graduated from college, is disillusioned at his lone career choice: making honey. On a special trip outside the hive, Barrys life is saved by Vanessa, a florist in New York City. As their relationship blossoms, he discovers humans actually eat honey and subsequently decides to sue them.',
    1, 'Animation', '01:31:00', '02-02-2007', 'Steve', 'Hickner'
),
(
    'The Shawshank Redemption',
    N'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
    17, 'Drama', '02:22:00', '10-14-1994', 'Frank', 'Darabont'
),
(
    'The Godfather',
    N'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
    18, 'Crime', '02:55:00', '03-24-1972', 'Francis', 'Ford Coppola'
),
(
    'Pulp Fiction',
    N'The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.',
    18, 'Crime', '02:34:00', '10-14-1994', 'Quentin', 'Tarantino'
),
(
    'The Dark Knight',
    N'When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham. The Dark Knight must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
    13, 'Action', '02:32:00', '07-18-2008', 'Christopher', 'Nolan'
),
(
    'Forrest Gump',
    N'The presidencies of Kennedy and Johnson, the events of Vietnam, Watergate, and other history unfold through the perspective of an Alabama man with an IQ of 75, whose only desire is to be reunited with his childhood sweetheart.',
    13, 'Drama', '02:22:00', '07-06-1994', 'Robert', 'Zemeckis'
),
(
    'Inception',
    N'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
    13, 'Sci-Fi', '02:28:00', '07-16-2010', 'Christopher', 'Nolan'
),
(
    'The Matrix',
    N'A computer programmer discovers that reality as he knows it is a simulation created by machines to subdue humanity.',
    16, 'Sci-Fi', '02:16:00', '03-31-1999', 'The Wachowskis','The Wachowskis'
),
(
    'Fight Club',
    N'An insomniac office worker and a devil-may-care soapmaker form an underground fight club that evolves into something much, much more.',
    18, 'Drama', '02:19:00', '10-15-1999', 'David', 'Fincher'
),
(
    'Avatar',
    N'A paraplegic Marine dispatched to the moon Pandora on a unique mission becomes torn between following orders and protecting an alien civilization.',
    13, 'Sci-Fi', '02:42:00', '12-18-2009', 'James', 'Cameron'
),
(
    'The Lord of the Rings: The Return of the King',
    N'Gandalf and Aragorn lead the World of Men against Saurons army to draw his gaze from Frodo and Sam as they approach Mount Doom with the One Ring.',
    13, 'Fantasy', '03:21:00', '12-17-2003', 'Peter', 'Jackson'
),
(
    'The Lion King',
    N'Lion prince Simba and his father are targeted by his bitter uncle, who wants to ascend the throne himself.',
    1, 'Animation', '01:28:00', '06-24-1994', 'Roger', 'Allers'
),
(
    'Interstellar',
    N'A team of explorers travel through a wormhole in space in an attempt to ensure humanitys survival.',
    13, 'Sci-Fi','02:49:00', '11-07-2014', 'Christopher', 'Nolan'
),
(
    'The Avengers',
    N'Earths mightiest heroes must come together and learn to fight as a team if they are going to stop the mischievous Loki and his alien army from enslaving humanity.',
    13, 'Action', '02:23:00', '05-04-2012', 'Joss', 'Whedon'
),
(
    'Gladiator',
    N'A former Roman General sets out to exact vengeance against the corrupt emperor who murdered his family and sent him into slavery.',
    17, 'Action', '02:35:00', '05-05-2000', 'Ridley', 'Scott'
),
(
    'The Departed',
    N'An undercover cop and a mole in the police attempt to identify each other while infiltrating an Irish gang in South Boston.',
    18, 'Crime', '02:31:00', '10-06-2006', 'Martin', 'Scorsese'
),
(
    'The Terminator',
    N'A human soldier is sent from 2029 to 1984 to stop an almost indestructible cyborg killing machine, sent from the same year, which has been programmed to execute a young woman whose unborn son is the key to humanitys future salvation.',
    16, 'Sci-Fi', '01:47:00', '10-26-1984', 'James', 'Cameron'
),
(
    'The Social Network',
    N'As Harvard student Mark Zuckerberg creates the social networking site that would become known as Facebook, he is sued by the twins who claimed he stole their idea, and by the co-founder who was later squeezed out of the business.',
    13, 'Drama', '02:00:00', '10-01-2010', 'David', 'Fincher'
),
(
    'The Grand Budapest Hotel',
    N'A writer encounters the owner of an aging high-class hotel, who tells him of his early years serving as a lobby boy in the hotels glorious years under an exceptional concierge.',
    13, 'Comedy', '01:39:00', '03-28-2014', 'Wes', 'Anderson'
),
(
    'Spirited Away',
    N'During her familys move to the suburbs, a sullen 10-year-old girl wanders into a world ruled by gods, witches, and spirits, and where humans are changed into beasts.',
    1, 'Animation', '02:05:00', '07-20-2001', 'Hayao', 'Miyazaki'
);

-- Cities
Insert Into Cities (city_Name)
Output Inserted.*
Values
(
'Amman'
);

Insert Into Cities (city_Name)
Output Inserted.*
Values
(
'Irbid'
); 

-- Floors
Insert Into Floors (floor_Name)
Output Inserted.*
Values (1);
Insert Into Floors (floor_Name)
Output Inserted.*
Values (2);
Insert Into Floors (floor_Name)
Output Inserted.*
Values (3);
Insert Into Floors (floor_Name)
Output Inserted.*
Values (4);

-- Malls
Insert Into Malls (mall_Name)
Output Inserted.*
Values ('Abdali Mall');
Insert Into Malls (mall_Name)
Output Inserted.*
Values ('AlBaraka Mall');
Insert Into Malls (mall_Name)
Output Inserted.*
Values ('Irbid City Centre');

-- Theatres
Insert Into Theatres (theatre_Name, city_ID, floor_ID, mall_ID)
Output Inserted.*
Values ('Prime Cinemas Abdali',1,3,1);
Insert Into Theatres (theatre_Name, city_ID, floor_ID, mall_ID)
Output Inserted.*
Values ('Prime Cinemas Amman',1,4,2);
Insert Into Theatres (theatre_Name, city_ID, floor_ID, mall_ID)
Output Inserted.*
Values ('Prime Cinemas Irbid',2,3,3);

-- Rows_Theatre
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('A',1);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('B',1);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('C',1);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('D',1);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('E',1);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('F',1);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('G',1);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('H',1);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('A',2);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('B',2);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('C',2);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('D',2);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('E',2);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('F',2);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('G',2);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('H',2);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('A',3);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('B',3);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('C',3);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('D',3);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('E',3);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('F',3);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('G',3);
Insert Into Rows_Theatre(row_Name, theatre_ID)
Output Inserted.*
Values ('H',3);

-- Seat_Types
Insert Into Seat_Types(seatType_Name)
Output Inserted.*
Values ('STANDARD');
Insert Into Seat_Types(seatType_Name)
Output Inserted.*
Values ('RIGHT');
Insert Into Seat_Types(seatType_Name)
Output Inserted.*
Values ('LEFT');

-- Seats
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (1,1,1);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (2,1,1);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (3,1,1);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (4,1,1);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (5,1,1);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (1,2,1);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (2,2,1);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (3,2,1);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (4,2,1);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (5,2,1);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (1,3,1);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (2,3,1);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (3,3,1);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (1,4,1);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (2,4,1);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (1,1,2);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (2,1,2);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (3,1,2);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (4,1,2);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (5,1,2);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (1,2,2);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (2,2,2);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (3,2,2);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (4,2,2);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (5,2,2);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (1,3,2);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (2,3,2);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (3,3,2);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (1,4,2);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (2,4,2);
--
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (1,1,3);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (2,1,3);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (3,1,3);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (4,1,3);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (5,1,3);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (1,2,3);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (2,2,3);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (3,2,3);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (4,2,3);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (5,2,3);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (1,3,3);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (2,3,3);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (3,3,3);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (1,4,3);
Insert Into Seats(seat_No, row_ID, seatType_ID)
Output Inserted.*
Values (2,4,3);

-- Shows
Insert Into Shows(show_StartTime,show_EndTime,show_Date,show_Language,movie_ID,theatre_ID)
Output Inserted.*
Values
(
'06:30','08:19','06-18-2023','English',8,1
);
Insert Into Shows(show_StartTime,show_EndTime,show_Date,show_Language,movie_ID,theatre_ID)
Output Inserted.*
Values
(
'05:00:00','06:33:22','06-20-2023','Arabic',9,1
);
Insert Into Shows(show_StartTime,show_EndTime,show_Date,show_Language,movie_ID,theatre_ID)
Output Inserted.*
Values
(
'04:00:00','05:33:22','06-22-2023','Arabic',9,2
); 
--
-- Shows
INSERT INTO Shows (show_StartTime, show_EndTime, show_Date, show_Language, movie_ID, theatre_ID)
OUTPUT Inserted.*
VALUES
(
    '04:00:00', '05:31:00', '06-28-2023', 'English', 10, 2
),
(
    '12:30:00', '14:01:00', '06-28-2023', 'English', 10, 3
),
(
    '15:15:00', '16:46:00', '06-28-2023', 'Spanish', 12, 1
),
(
    '10:30:00', '12:01:00', '06-29-2023', 'English', 11, 2
),
(
    '14:45:00', '16:16:00', '06-29-2023', 'English', 9, 3
),
(
    '17:30:00', '19:01:00', '06-29-2023', 'French', 7, 1
),
(
    '14:15:00', '15:46:00', '06-30-2023', 'English', 5, 2
),
(
    '17:30:00', '19:01:00', '06-30-2023', 'Spanish', 4, 3
);

-- Tickets
Insert Into Tickets(ticket_Price, show_ID, show_StartTime, show_EndTime, show_Date, theatre_ID)
Output Inserted.*
Values
(
8,1,'06:30:00','08:19:00','2023-06-18',1
);
Insert Into Tickets(ticket_Price, show_ID, show_StartTime, show_EndTime, show_Date, theatre_ID)
Output Inserted.*
Values
(
8,1,'06:30','08:19:00','2023-06-18',1
);
Insert Into Tickets(ticket_Price, show_ID, show_StartTime, show_EndTime, show_Date, theatre_ID)
Output Inserted.*
Values
(
8,1,'06:30','08:19:00','2023-06-18',1
);
Insert Into Tickets(ticket_Price, show_ID, show_StartTime, show_EndTime, show_Date, theatre_ID)
Output Inserted.*
Values
(
8,1,'06:30','08:19:00','2023-06-18',1
);
Insert Into Tickets(ticket_Price, show_ID, show_StartTime, show_EndTime, show_Date, theatre_ID)
Output Inserted.*
Values
(
8,2,'05:00','06:33:22','2023-06-20',1
);
Insert Into Tickets(ticket_Price, show_ID, show_StartTime, show_EndTime, show_Date, theatre_ID)
Output Inserted.*
Values
(
8,2,'05:00','06:33:22','2023-06-20',1
);
Insert Into Tickets(ticket_Price, show_ID, show_StartTime, show_EndTime, show_Date, theatre_ID)
Output Inserted.*
Values
(
8,2,'05:00','06:33:22','2023-06-20',1
);
Insert Into Tickets(ticket_Price, show_ID, show_StartTime, show_EndTime, show_Date, theatre_ID)
Output Inserted.*
Values
(
8,2,'05:00','06:33:22','2023-06-20',1
);
Insert Into Tickets(ticket_Price, show_ID, show_StartTime, show_EndTime, show_Date, theatre_ID)
Output Inserted.*
Values
(
8,2,'05:00','06:33:22','2023-06-20',1
);

-- Bookings Table
Insert Into Bookings(booking_Date, has_paid_ticket, quantity, customer_ID, ticket_ID, admin_ID)
Output Inserted.*
Values
(
'06-18-2023',1,1,1,2,1
);
Insert Into Bookings(booking_Date, has_paid_ticket, quantity, customer_ID, ticket_ID, admin_ID)
Output Inserted.*
Values
(
'06-20-2023',1,2,6,2,1
);
Insert Into Bookings(has_paid_ticket, quantity, customer_ID, ticket_ID, admin_ID)
Output Inserted.*
Values
(
  1,1,1,3,1   -- use default value for booking_Date here..
);
-------------------------------------------------------------------------------------------------------------------

-- DQL
select * from Customers;




select * from Admins;

-- DDL
/*
CREATE LOGIN admin_user
WITH PASSWORD='123456';   -- DDL

CREATE USER mays
FOR LOGIN admin_user;
*/

GRANT SELECT 
ON Bookings TO mays;  -- DCL

Select CURRENT_USER, USER_NAME(), SUSER_SNAME(); 

select CONCAT_WS(cust_Fname,cust_Lname,' '),cust_Email as Email,cust_BirthDate as BirthDate
from Customers
where cust_Fname like '_a%'and cust_BirthDate>'06-06-1990';

Select movie_Name,movie_Description,movie_Genre
From Movies
Where movie_ReleaseDate = (select max(movie_ReleaseDate) from Movies);

select movie_Name,movie_Genre,show_Date
from Movies as m
Join Shows as s on (m.movie_ID=s.movie_ID);

-- calculate function to get age for customer
Create OR Alter function customer_age(@custID int) 
returns decimal
AS
Begin
Declare
@res int;
select @res = DATEDIFF(Year,c.cust_BirthDate,SYSDATETIME())
from Customers as c
where c.customer_ID=@custID;
return @res;  -- Scalar Function
End;

Select cust_Fname,dbo.customer_age(1) as "Age"
from Customers
where customer_ID=1; 


-- View holds info of the theater_ID=1
Create View V_theaters
As
Select *
from Theatres
where theatre_ID=1;

select * from V_theaters;


