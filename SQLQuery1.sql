CREATE DATABASE Spotify
USE Spotify

CREATE TABLE Artists
(
Id int PRIMARY KEY IDENTITY,
Name nvarchar(255) UNIQUE,
)

CREATE TABLE Musics
(
Id int PRIMARY KEY IDENTITY,
Name nvarchar(255) UNIQUE  ,
Duration int,
ListenerCount int,
AlbumId int FOREIGN KEY REFERENCES Albums(Id),
)

CREATE TABLE Albums
(
Id int PRIMARY KEY IDENTITY,
Name nvarchar(255) UNIQUE,
ArtistId int FOREIGN KEY REFERENCES Artists(Id),
)

-- TASK 1

CREATE VIEW MusicInfoView AS
SELECT m.Name [Music Name], m.Duration, al.Name [Album Name], ar.Name [Artist Name] FROM Musics m
JOIN Albums al ON m.AlbumId=al.Id
JOIN Artists ar ON ar.Id=al.ArtistId

SELECT * FROM MusicInfoView


--TASK 2

CREATE VIEW AlbumNameWithMusicCountView AS
SELECT a.Name, (SELECT COUNT(*) FROM Musics m WHERE m.AlbumId=a.Id) [Music Count] FROM Albums a

-- TASK 3

CREATE PROCEDURE ListenerCountProcedure @listenerCount int, @albumName nvarchar(255)
AS
SELECT * FROM Musics m
JOIN Albums a ON a.Id=m.AlbumId
WHERE m.ListenerCount > @listenerCount AND a.Name=@albumName



EXEC ListenerCountProcedure @listenerCount=3, @albumName='Mahni'


-- TASK 4
CREATE DATABASE BookStore
USE BookStore

CREATE TABLE Books
(
Id int PRIMARY KEY IDENTITY,
Name nvarchar(100),
CHECK (Name >=2),
AuthorId int FOREIGN KEY REFERENCES Authors(Id),
PageCount int,
)

CREATE TABLE Authors
(
Id int PRIMARY KEY IDENTITY,
Name nvarchar(100),
Surname nvarchar(100),
)

CREATE VIEW BookInfoView
AS
SELECT b.Id, b.Name, b.PageCount, CONCAT(a.Name, ' ', a.Surname) AuthorFullName FROM Books b
JOIN Authors a ON a.Id=b.AuthorId

-- TASK 5


CREATE PROCEDURE BookSearchProcedure @query nvarchar(255)
AS
SELECT * FROM BookInfoView
WHERE AuthorFullName LIKE CONCAT('%',@query,'%') OR Name LIKE CONCAT('%',@query,'%')

-- TASK 6

CREATE VIEW AuthorInfoView
AS
SELECT a.Id, CONCAT(a.Name, ' ', a.Surname) FullName, (SELECT COUNT(*) FROM Books b WHERE a.Id=b.AuthorId) BooksCount,(SELECT MAX(PageCount) FROM Books b WHERE a.Id=b.AuthorId) MaxPageCount FROM Authors a
