USE master;
GO

DROP DATABASE IF EXISTS EventManagement;
GO

CREATE DATABASE EventManagement;
GO

USE EventManagement;
GO

-- Создание таблицы узлов "Event" (Событие)
CREATE TABLE Event (
    EventID INT IDENTITY NOT NULL,
    EventName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    StartDateTime DATETIME NOT NULL,
    EndDateTime DATETIME NOT NULL,
    Venue NVARCHAR(100) NOT NULL,
    CityID INT NOT NULL,
    CONSTRAINT PK_Event PRIMARY KEY (EventID)
) AS NODE;
GO

-- Создание таблицы узлов "User" (Пользователь)
CREATE TABLE [User] (
    UserID INT IDENTITY NOT NULL,
    UserName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Password NVARCHAR(100) NOT NULL,
    RegistrationDate DATE NOT NULL,
    CityID INT NOT NULL,
    CONSTRAINT PK_User PRIMARY KEY (UserID)
) AS NODE;
GO

-- Создание таблицы узлов "City" (Город)
CREATE TABLE City (
    CityID INT IDENTITY NOT NULL,
    CityName NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_City PRIMARY KEY (CityID)
) AS NODE;
GO

-- Создание таблицы ребер "Organizes" (Организует)
CREATE TABLE Organizes AS EDGE;
GO
ALTER TABLE Organizes ADD CONSTRAINT EC_Organizes CONNECTION ([User] to Event);

-- Создание таблицы ребер "Participates" (Принимает участие)
CREATE TABLE Participates AS EDGE;
GO
ALTER TABLE Participates ADD CONSTRAINT EC_Participates CONNECTION ([User] to Event);

-- Создание таблицы ребер "ResidesIn" (Проживает)
CREATE TABLE ResidesIn AS EDGE;
GO
ALTER TABLE ResidesIn ADD CONSTRAINT EC_ResidesIn CONNECTION ([User] to City);

-- Заполнение таблицы узлов "Event" (Событие)
INSERT INTO Event (EventName, Description, StartDateTime, EndDateTime, Venue, CityID)
VALUES
  ('Music Festival 1', 'Annual music festival', '2024-07-15 18:00:00', '2024-07-17 23:59:59', 'Central Park', 1),
  ('Music Festival 2', 'Annual music festival', '2024-07-15 18:00:00', '2024-07-17 23:59:59', 'Central Park', 1),
  ('Conference 1', 'Tech conference', '2024-09-10 09:00:00', '2024-09-12 18:00:00', 'Convention Center', 2),
  ('Conference 2', 'Tech conference', '2024-09-10 09:00:00', '2024-09-12 18:00:00', 'Convention Center', 2),
  ('Movie Night 1', 'Outdoor movie screening', '2024-08-20 20:00:00', '2024-08-20 23:00:00', 'City Park', 3),
  ('Movie Night 2', 'Outdoor movie screening', '2024-08-20 20:00:00', '2024-08-20 23:00:00', 'City Park', 3),
  ('Sports Event 1', 'Professional sports event', '2024-06-01 19:00:00', '2024-06-01 22:00:00', 'Stadium', 1),
  ('Sports Event 2', 'Professional sports event', '2024-06-01 19:00:00', '2024-06-01 22:00:00', 'Stadium', 1),
  ('Art Exhibition 1', 'Contemporary art exhibition', '2024-07-05 10:00:00', '2024-07-05 18:00:00', 'Art Gallery', 2),
  ('Art Exhibition 2', 'Contemporary art exhibition', '2024-07-05 10:00:00', '2024-07-05 18:00:00', 'Art Gallery', 2);

-- Заполнение таблицы узлов "User" (Пользователь)
INSERT INTO [User] (UserName, Email, Password, RegistrationDate, CityID)
VALUES
  ('John Smith', 'john@example.com', 'password123', '2024-01-01', 1),
  ('Emily Johnson', 'emily@example.com', 'password456', '2024-02-01', 2),
  ('Michael Davis', 'michael@example.com', 'password789', '2024-03-01', 3),
  ('Jessica Wilson', 'jessica@example.com', 'passwordabc', '2024-04-01', 1),
  ('David Brown', 'david@example.com', 'passworddef', '2024-05-01', 2),
  ('Sarah Taylor', 'sarah@example.com', 'passwordghi', '2024-06-01', 3),
  ('Robert Johnson', 'robert@example.com', 'passwordjkl', '2024-07-01', 1),
  ('Jennifer Anderson', 'jennifer@example.com', 'passwordmno', '2024-08-01', 2),
  ('Christopher Martin', 'christopher@example.com', 'passwordpqr', '2024-09-01', 3),
  ('Amanda Thompson', 'amanda@example.com', 'passwordstu', '2024-10-01', 1);

-- Заполнение таблицы узлов "City" (Город)
INSERT INTO City (CityName)
VALUES
  ('New York'),
  ('Los Angeles'),
  ('Chicago'),
  ('San Francisco'),
  ('Miami'),
  ('Seattle'),
  ('Boston'),
  ('Dallas'),
  ('Denver'),
  ('Houston');

  INSERT INTO Organizes ($from_id, $to_id)
VALUES
    (
        (SELECT $node_id FROM [User] WHERE UserID = 1), -- John Smith
        (SELECT $node_id FROM Event WHERE EventID = 2) -- Music Festival 2
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 2), -- Emily Johnson
        (SELECT $node_id FROM Event WHERE EventID = 4) -- Conference 2
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 3), -- Michael Davis
        (SELECT $node_id FROM Event WHERE EventID = 6) -- Movie Night 2
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 4), -- Jessica Wilson
        (SELECT $node_id FROM Event WHERE EventID = 8) -- Sports Event 2
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 5), -- David Brown
        (SELECT $node_id FROM Event WHERE EventID = 10) -- Art Exhibition 2
    );

	INSERT INTO Participates ($from_id, $to_id)
VALUES
    (
        (SELECT $node_id FROM [User] WHERE UserID = 6), -- Sarah Taylor
        (SELECT $node_id FROM Event WHERE EventID = 2) -- Music Festival 2
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 7), -- Robert Johnson
        (SELECT $node_id FROM Event WHERE EventID = 4) -- Conference 2
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 8), -- Jennifer Anderson
        (SELECT $node_id FROM Event WHERE EventID = 6) -- Movie Night 2
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 9), -- Christopher Martin
        (SELECT $node_id FROM Event WHERE EventID = 8) -- Sports Event 2
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 10), -- Amanda Thompson
        (SELECT $node_id FROM Event WHERE EventID = 10) -- Art Exhibition 2
    );

	INSERT INTO ResidesIn ($from_id, $to_id)
VALUES
    (
        (SELECT $node_id FROM [User] WHERE UserID = 1), -- John Smith
        (SELECT $node_id FROM City WHERE CityID = 1) -- New York
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 2), -- Emily Johnson
        (SELECT $node_id FROM City WHERE CityID = 2) -- Los Angeles
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 3), -- Michael Davis
        (SELECT $node_id FROM City WHERE CityID = 3) -- Chicago
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 4), -- Jessica Wilson
        (SELECT $node_id FROM City WHERE CityID = 1) -- New York
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 5), -- David Brown
        (SELECT $node_id FROM City WHERE CityID = 2) -- Los Angeles
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 6), -- Sarah Taylor
        (SELECT $node_id FROM City WHERE CityID = 3) -- Chicago
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 7), -- Robert Johnson
        (SELECT $node_id FROM City WHERE CityID = 1) -- New York
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 8), -- Jennifer Anderson
        (SELECT $node_id FROM City WHERE CityID = 2) -- Los Angeles
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 9), -- Christopher Martin
        (SELECT $node_id FROM City WHERE CityID = 3) -- Chicago
    ),
    (
        (SELECT $node_id FROM [User] WHERE UserID = 10), -- Amanda Thompson
        (SELECT $node_id FROM City WHERE CityID = 1) -- New York
    );

	--5

SELECT U.UserName AS [UserName]
FROM [User] AS U, 
     Organizes AS O, 
     Event AS E, 
     City AS C
WHERE MATCH (U-(O)->E)
      AND E.CityID = C.CityID
      AND C.CityName = 'New York';


SELECT E.EventName AS [EventName]
FROM [User] AS U, 
     Participates AS P, 
     Event AS E
WHERE MATCH (U-(P)->E)
      AND U.UserName = 'Sarah Taylor';

SELECT U.UserName AS [UserName]
FROM [User] AS U, 
     ResidesIn AS R, 
     City AS C
WHERE MATCH (U-(R)->C)
      AND C.CityName = 'Chicago';

SELECT C.CityName AS [CityName]
FROM [User] AS U, 
     ResidesIn AS R, 
     City AS C
WHERE MATCH (U-(R)->C)
      AND U.UserName = 'John Smith';


SELECT U.UserName AS [UserName]
FROM [User] AS U, 
     Participates AS P, 
     Event AS E
WHERE MATCH (U-(P)->E)
      AND E.EventName = 'Music Festival 2';

--6

--Кратчайший путь от пользователя "John Smith" к мероприятиям любой длины:
SELECT U1.UserName AS UserName,
STRING_AGG(E.EventName, '->') WITHIN GROUP (GRAPH PATH) AS EventPath
FROM [User] AS U1,
Event FOR PATH AS E,
Organizes FOR PATH AS P
WHERE MATCH(SHORTEST_PATH(U1(-(P)->E)+))
AND U1.UserName = 'John Smith';

--Кратчайший путь от пользователя "Sarah Taylor" к мероприятиям длины от 1 до 3:
SELECT U1.UserName AS UserName,
       STRING_AGG(E.EventName, '->') WITHIN GROUP (GRAPH PATH) AS EventPath
FROM [User] AS U1,
     Event FOR PATH AS E,
     Participates FOR PATH AS P
WHERE MATCH(SHORTEST_PATH(U1(-(P)->E){1,3}))
  AND U1.UserName = 'Sarah Taylor';
