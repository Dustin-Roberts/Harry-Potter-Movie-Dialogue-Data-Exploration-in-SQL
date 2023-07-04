-- Lines of Dialogue Per Movie --
SELECT COUNT(Dialogue.Dialogue_ID) AS Line_of_Dialogue, Movie_Title
FROM Dialogue
JOIN Chapters
ON Dialogue.Chapter_ID = Chapters.Chapter_ID
JOIN Movies
ON Chapters.Movie_ID = Movies.Movie_ID
GROUP BY Movie_Title, Movies.Movie_ID
ORDER BY Movies.Movie_ID


-- Movie Runtime --
SELECT Movie_Title, Runtime 
FROM Movies


-- Lines of Dialogue Per Character --
SELECT COUNT(Dialogue.Dialogue_ID) AS Line_of_Dialogue, Character_Name
FROM Dialogue
JOIN Chapters
ON Dialogue.Chapter_ID = Chapters.Chapter_ID
JOIN Characters
ON Dialogue.Character_ID = Characters.Character_ID
GROUP BY Character_Name, Characters.Character_ID
ORDER BY COUNT(Dialogue.Dialogue_ID) DESC


-- Lines of Dialogue Per Character, Per Movie, Selecting Top 10 Speakers --
DECLARE @i int = 1
DECLARE @j int
SET @j = (SELECT COUNT(DISTINCT Movie_ID) FROM Movies)

WHILE @i <= @j
BEGIN
	SELECT TOP 10 COUNT(Dialogue.Dialogue_ID) AS Line_of_Dialogue, Character_Name, Movie_Title
	FROM Dialogue
	JOIN Chapters
	ON Dialogue.Chapter_ID = Chapters.Chapter_ID
	JOIN Characters
	ON Dialogue.Character_ID = Characters.Character_ID
	JOIN Movies
	ON Chapters.Movie_ID = Movies.Movie_ID
	WHERE Movies.Movie_ID = @i
	GROUP BY Character_Name, Characters.Character_ID, Movies.Movie_Title, Movies.Movie_ID
	ORDER BY Movies.Movie_ID, COUNT(Dialogue.Dialogue_ID) DESC
	SET @i = @i + 1
END


-- Top 5 Locations Per Movie --
DECLARE @i int = 1
DECLARE @j int
SET @j = (SELECT COUNT(DISTINCT Movie_ID) FROM Movies)

WHILE @i <= @j
BEGIN
	SELECT TOP 5 SUM(DISTINCT Dialogue.Place_ID) AS Number_of_Times_Place_Appears, Place_Name, Movie_Title
	FROM Dialogue
	JOIN Chapters
	ON Dialogue.Chapter_ID = Chapters.Chapter_ID
	JOIN Movies
	ON Chapters.Movie_ID = Movies.Movie_ID
	JOIN Places
	ON Dialogue.Place_ID = Places.Place_ID
	WHERE Movies.Movie_ID = @i
	GROUP BY Place_Name, Movies.Movie_Title, Movies.Movie_ID
	ORDER BY Movies.Movie_ID, SUM(DISTINCT Dialogue.Place_ID) DESC
	SET @i = @i + 1
END


-- Number of Each Spell Across All Movies -- 
SELECT Incantation, COUNT(Dialogue) AS Number_Of_Times_Used
FROM Dialogue
JOIN Chapters
ON Dialogue.Chapter_ID = Chapters.Chapter_ID
JOIN Movies
ON Chapters.Movie_ID = Movies.Movie_ID 
CROSS JOIN Spells
WHERE Dialogue LIKE '%'+Spells.Incantation+'%'
GROUP BY Spells.Incantation
ORDER BY Incantation


-- Number of Each Spell Per Movie --
SELECT Incantation, COUNT(Dialogue) AS Number_Of_Times_Used, Movie_Title
FROM Dialogue
JOIN Chapters
ON Dialogue.Chapter_ID = Chapters.Chapter_ID
JOIN Movies
ON Chapters.Movie_ID = Movies.Movie_ID 
CROSS JOIN Spells
WHERE Dialogue LIKE '%'+Spells.Incantation+'%'
GROUP BY Spells.Incantation, Movies.Movie_Title, Movies.Movie_ID
ORDER BY Movies.Movie_ID, Incantation, COUNT(Dialogue)

-- Number of Each Spell Per Character Across All Movies (I.E. Character's Favorite Spells -- 
SELECT Character_Name, Incantation, COUNT(Dialogue) AS Number_Of_Times_Used
FROM Dialogue
JOIN Characters
ON Dialogue.Character_ID = Characters.Character_ID
JOIN Chapters
ON Dialogue.Chapter_ID = Chapters.Chapter_ID
CROSS JOIN Spells
WHERE Dialogue LIKE '%'+Spells.Incantation+'%'
GROUP BY Characters.Character_Name, Spells.Incantation
ORDER BY Characters.Character_Name, Incantation, COUNT(Dialogue)

