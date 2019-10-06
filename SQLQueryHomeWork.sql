--1. Create a database
CREATE DATABASE dbHomeWork
--2. Create a table called Director with following columns: FirstName, LastName, Nationality and Birth date. Insert 5 rows into it.

CREATE TABLE Director (
Id int IDENTITY(1,1) PRIMARY KEY,
First_Name nvarchar(MAX),
Last_Name nvarchar(MAX),
Nationality nvarchar(MAX),
Birh_Date date
);

INSERT INTO Director
VALUES
('Director','One','Romanian','1981-06-23'),
('Director','Two','American','1957-06-25'),
('Director','Three','English','1945-07-25'),
('Director','Four','Spanish','1955-01-11'),
('Director','Five','Italian','1958-03-10'),
('Director','Six','Russian','1965-03-10');

SELECT * FROM Director

--3. Delete the director with id = 3

DELETE FROM Director WHERE Id=3

SELECT * FROM Director

--4. Create a table called Movie with following columns: DirectorId, Title, ReleaseDate, Rating and Duration. Each movie has a director. 
--Insert some rows into it

CREATE TABLE Movies 
(
Id int IDENTITY(1,1) PRIMARY KEY,
Title nvarchar(MAX),
Release_Date date,
Rating decimal(3,1),
Duration TIME(0),
DirectorId int FOREIGN KEY (DirectorId) REFERENCES Director(Id)
);

SELECT * FROM Movies

INSERT INTO Movies(Title, Release_Date, Rating, Duration, DirectorId)
VALUES
('Joker','2019-10-03',9.4,'02:01:00',1),
('War','2019-10-02',0.1,'02:34:00',2),
('Lucy in the Sky','2019-10-04',4.5,'02:04:00',2),
('Abominable','2019-09-27',7.3,'01:37:00',4),
('Rambo:Last Blood','2019-09-20',6.8,'01:29:00',4),
('Angel Has Fallen','2019-08-20',6.7,'01:59:00',2);

SELECT * FROM Movies
--5. Update all movies that have a rating lower than 10.

UPDATE Movies
SET Rating=9.9
WHERE Rating<5;

SELECT * FROM Movies

--6. Create a table called Actor with following columns: FirstName, LastName, Nationality, Birth date and PopularityRating. 
--Insert some rows into it.

CREATE TABLE Actors (
Id int IDENTITY(1,1) PRIMARY KEY,
First_Name nvarchar(MAX),
Last_Name nvarchar(MAX),
Nationality nvarchar(MAX),
Birh_Date date,
Popularity_Rating decimal(4,1)
);

SELECT * FROM Actors

INSERT INTO Actors
VALUES
('Gerard ','Butler','Scotish','1969-11-13',123.5),
('Sylvester','Stallone','American','1946-07-06',255.4),
('Chloe','Bennet','American','1992-04-18',323.2),
('Natalie','Portman','Israeli','1981-06-09',515.2),
('Hrithik','Roshan','Indian','1974-01-10',484.8),
('Joaquin','Phoenix','Puerto Rican','1974-10-28',844.1);

SELECT * FROM Actors
--7. Which is the movie with the lowest rating?
SELECT * FROM Movies
WHERE Rating =(SELECT MIN(Rating) FROM Movies)

--8. Which director has the most movies directed?
SELECT DISTINCT DirectorId, COUNT(Id) AS NumberOfDirectedMovies
FROM Movies
GROUP BY DirectorId
HAVING COUNT(Id) >= ALL (SELECT COUNT(Id) FROM Movies GROUP BY DirectorId)
------------------------------------------------------------------------
--9. Display all movies ordered by director's LastName in ascending order, then by birth date descending. 

SELECT Title as LOWrateMOVIE , Rating FROM Movies
SELECT * FROM Movies
SELECT * FROM Director

SELECT Movies.Title, Director.Last_Name FROM Movies
INNER JOIN Director
ON Movies.DirectorId = Director.Id
ORDER BY Director.Last_Name;
---------------------------------------------------------------------------

SELECT Movies.Title, Director.Last_Name FROM Movies
INNER JOIN Director
ON Movies.DirectorId = Director.Id
ORDER BY Director.Birh_Date DESC;

SELECT * FROM Director
SELECT * FROM Movies
---------------------------------------------------------------------------
--12. Create a stored procedure that will increment the rating by 1 for a given movie id.

--STORED PROCEDURE

CREATE PROCEDURE IncrementRating
@Id int
AS
BEGIN TRANSACTION
	UPDATE dbo.Movies SET Rating = Rating +1 WHERE Id=@Id
COMMIT TRANSACTION
GO;
EXEC IncrementRating @Id = 5;
SELECT * FROM Movies WHERE Id=5
------------------------------------------------------------------
--15. Implement many to many relationship between Movie and Actor

CREATE TABLE MovieActor (
	MovieId int CONSTRAINT fk_movies REFERENCES Movies(Id),
	ActorId int CONSTRAINT fk_actors REFERENCES Actors(Id)
);

INSERT INTO MovieActor(MovieId,ActorId) VALUES(5,4);
INSERT INTO MovieActor(MovieId,ActorId) VALUES(4,3);
INSERT INTO MovieActor(MovieId,ActorId) VALUES(2,2);
INSERT INTO MovieActor(MovieId,ActorId) VALUES(1,1);
INSERT INTO MovieActor(MovieId,ActorId) VALUES(2,1);
INSERT INTO MovieActor(MovieId,ActorId) VALUES(1,4);
INSERT INTO MovieActor(MovieId,ActorId) VALUES(2,4);
INSERT INTO MovieActor(MovieId,ActorId) VALUES(5,1);

SELECT * FROM MovieActor;
--------------------------------------------------------------
--16. Implement many to many relationship between Movie and Genre

CREATE TABLE Genre(
	Id int IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(MAX) NOT NULL
);
INSERT INTO Genre(Name) VALUES('Action');
INSERT INTO Genre(Name) VALUES('Animated');
INSERT INTO Genre(Name) VALUES('Romantic');
INSERT INTO Genre(Name) VALUES('SF');

SELECT * FROM Genre;
----------------------------------------------------


CREATE TABLE MovieGenre(
	MovieId int CONSTRAINT fk_movieId REFERENCES Movies(Id),
	GenreId int CONSTRAINT fk_genreId REFERENCES Genre(Id)
);
INSERT INTO MovieGenre(MovieId,GenreId) VALUES(2,1);
INSERT INTO MovieGenre(MovieId,GenreId) VALUES(5,1);
INSERT INTO MovieGenre(MovieId,GenreId) VALUES(1,2);
INSERT INTO MovieGenre(MovieId,GenreId) VALUES(3,3);
INSERT INTO MovieGenre(MovieId,GenreId) VALUES(4,4);

SELECT * FROM MovieGenre;
----------------------------------------------------------------
--17. Which actor has worked with the most distinct movie directors?

SELECT A.Id, A.First_Name, A.Last_Name, COUNT(D.Id) AS NumberOfDirectors
FROM Actors A INNER JOIN MovieActor MA ON A.Id=MA.ActorId INNER JOIN Movies M ON MA.MovieId =M.Id INNER JOIN Director D ON M.DirectorId=D.Id
GROUP BY A.Id, A.First_Name, A.Last_Name
HAVING COUNT(D.Id) >= 
(SELECT DISTINCT TOP 1  COUNT(D.Id) AS NumberOfDirectors
FROM Actors A INNER JOIN MovieActor MA ON A.Id=MA.ActorId INNER JOIN Movies M ON MA.MovieId =M.Id INNER JOIN Director D ON M.DirectorId=D.Id
GROUP BY A.Id ORDER BY NumberOfDirectors DESC);

-----------------------------------------------------------------------------------
--18. Which is the preferred genre of each actor?
SELECT A.First_Name, A.Last_Name, G.Name
FROM 
Actors A INNER JOIN MovieActor MA ON A.Id=MA.ActorId 
INNER JOIN Movies M ON MA.MovieId =M.Id 
INNER JOIN MovieGenre MG ON M.Id=MG.MovieId 
INNER JOIN Genre G ON MG.GenreId=G.Id
---------------------------------------------------------------------------------------

