USE [master]
GO

DECLARE @Rock char(4) = 'Rock'
DECLARE @Paper char(5) = 'Paper'
DECLARE @Scissors char(8) = 'Scissors'
DECLARE @Win char(3) = 'Win'
DECLARE @Draw char(4) = 'Draw'
DECLARE @Lose char(4) = 'Lose'

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

------------------------------
-- Make some tables
------------------------------
CREATE TABLE [StrategyGuide] (
	[OpponentChoice] char(1),
	[MyChoiceOrOutcome] char(1)
)

CREATE TABLE [ShapeScore] (
	[Shape] varchar(20),
	[Score] int
)

CREATE TABLE [OutcomeScore] (
	[Outcome] varchar(10),
	[Score] int
)

CREATE TABLE [CodeToShape] (
	[Code] char(1),
	[Shape] varchar(10)
)

CREATE TABLE [CodeToOutcome] (
	[Code] char(1),
	[Outcome] varchar(10)
)

CREATE TABLE [OutcomeMap] (
	[OppenentShape] varchar(20),
	[MyShape] varchar(20),
	[MyOutcome] varchar(10)
)

------------------------------
-- Load static data
------------------------------
INSERT INTO [ShapeScore]
VALUES
	(@Rock, 1),
	(@Paper, 2),
	(@Scissors, 3)

INSERT INTO [OutcomeScore]
VALUES
	(@Win, 6),
	(@Draw, 3),
	(@Lose, 0)

INSERT INTO [CodeToShape]
VALUES
	('A', @Rock),
	('B', @Paper),
	('C', @Scissors),
	('X', @Rock),
	('Y', @Paper),
	('Z', @Scissors)

INSERT INTO [CodeToOutcome]
VALUES
	('X', @Lose),
	('Y', @Draw),
	('Z', @Win)

INSERT INTO [OutcomeMap]
VALUES
	-- [OppenentShape], [MyShape], [MyOutcome]
	(@Rock, @Rock, @Draw),
	(@Rock, @Paper, @Win),
	(@Rock, @Scissors, @Lose),
	(@Paper, @Rock, @Lose),
	(@Paper, @Paper, @Draw),
	(@Paper, @Scissors, @Win),
	(@Scissors, @Rock, @Win),
	(@Scissors, @Paper, @Lose),
	(@Scissors, @Scissors, @Draw)

------------------------------
-- Load input
------------------------------
BULK INSERT [StrategyGuide]
   FROM 'C:\Repos\ben-chapman-iress\advent-of-code-2022\Day 2\input.txt'
   WITH
      (
         FIELDTERMINATOR = ' '
         , ROWTERMINATOR = '0x0A'
      );

------------------------------
-- Part 1
------------------------------
SELECT SUM([ShapeScore].[Score] + [OutcomeScore].[Score])
FROM [StrategyGuide]

-- Find out what shape is represented by my code
JOIN [CodeToShape] [MyShape] ON [StrategyGuide].[MyChoiceOrOutcome] = [MyShape].[Code]

-- Map the shape to a score
JOIN [ShapeScore] ON [MyShape].[Shape] = [ShapeScore].[Shape]

-- Find out what shape is represented by opponent's code
JOIN [CodeToShape] [OppenentShape] ON [StrategyGuide].[OpponentChoice] = [OppenentShape].[Code]

-- Figure out the outcome
JOIN [OutcomeMap] ON (
	[OppenentShape].[Shape] = [OutcomeMap].[OppenentShape] AND
	[MyShape].[Shape] = [OutcomeMap].[MyShape]
)

-- Map the outcome to a score
JOIN [OutcomeScore] ON [OutcomeMap].[MyOutcome] = [OutcomeScore].[Outcome]

------------------------------
-- Part 2
------------------------------
SELECT SUM([ShapeScore].[Score] + [OutcomeScore].[Score])
FROM [StrategyGuide]

-- Find out what outcome is represented by the outcome code
JOIN [CodeToOutcome] ON [StrategyGuide].[MyChoiceOrOutcome] = [CodeToOutcome].[Code]

-- Map the outcome to a score
JOIN [OutcomeScore] ON [CodeToOutcome].[Outcome] = [OutcomeScore].[Outcome]

-- Find out what shape is represented by my opponent's code
JOIN [CodeToShape] [OppenentShape] ON [StrategyGuide].[OpponentChoice] = [OppenentShape].[Code]

-- Find out what shape I need in order to get the correct outcome
JOIN [OutcomeMap] ON (
	[OppenentShape].[Shape] = [OutcomeMap].[OppenentShape] AND
	[CodeToOutcome].[Outcome] = [OutcomeMap].[MyOutcome]
)

-- Map the shape to a score
JOIN [ShapeScore] ON [OutcomeMap].[MyShape] = [ShapeScore].[Shape]

------------------------------
-- Debug info
------------------------------
/*
SELECT * FROM [ShapeScore]
SELECT * FROM [OutcomeScore]
SELECT * FROM [CodeToShape]
SELECT * FROM [CodeToOutcome]
SELECT * FROM [OutcomeMap]
SELECT * FROM [StrategyGuide]
*/
------------------------------
-- Cleanup
------------------------------
DROP TABLE [StrategyGuide]
DROP TABLE [ShapeScore]
DROP TABLE [OutcomeScore]
DROP TABLE [CodeToShape]
DROP TABLE [CodeToOutcome]
DROP TABLE [OutcomeMap]
