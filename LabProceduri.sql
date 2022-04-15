USE ParcAutoBun
GO

--noua tabela care memoreaza versiunea structurii bazei de date
--CREATE TABLE versiune(

--version_id INT PRIMARY KEY DEFAULT 0)
--GO

--INSERT INTO versiune(version_id)
--VALUES (0)
--GO

--procedura de MODIFICARE A TIPULUI UNEI COLOANE
 ALTER PROCEDURE DO1
AS
 
  DECLARE @v INT
  SELECT TOP 1 @v=version_id
  FROM versiune

  IF @v=0
  BEGIN
       
	     ALTER TABLE Piese
		 ALTER COLUMN denumire TEXT NOT NULL

		 UPDATE versiune SET version_id=1
		 PRINT 'denumire este acum de tip text nenul'
		 PRINT 'Baza de date se afla acum in VERSIUNEA 1'

  END
GO

--procedura de UNDO A MODIFICARII TIPULUI COLOANEI
CREATE PROCEDURE UNDO1
AS
  
   DECLARE @v INT
   SELECT TOP 1 @v=version_id
   FROM versiune

   IF @v=1
   BEGIN
       
	      ALTER TABLE Piese
		  ALTER COLUMN denumire NVARCHAR(50) NULL

		  UPDATE versiune SET version_id=0
		  PRINT 'denumire este acum de tip nvarchar null'
		  PRINT 'Baza de date se afla acum in VERSIUNEA 0'

	END
GO

--procedura de ADAUGARE CONSTRANGERE DEFALUT 
CREATE PROCEDURE DO2
AS
   
    DECLARE @v INT
	SELECT TOP 1 @v=version_id
	FROM versiune

	IF @v=1
	BEGIN
	  
	       ALTER TABLE Clienti
		   ADD CONSTRAINT df_oras DEFAULT 'Cluj-Napoca' FOR oras

		   UPDATE versiune SET version_id=2
		   PRINT 'oras e acum default Cluj-Napoca'
		   PRINT 'Baza de date se afla acum in VERSIUNEA 2'

	END
GO

--procedura de UNDO LA ADAUGAREA CONSTRANGERII DEFAULT
CREATE PROCEDURE UNDO2
AS

   DECLARE @v INT
   SELECT TOP 1 @v=version_id
   FROM versiune

   IF @v=2
   BEGIN
      
	       ALTER TABLE Clienti
		   DROP CONSTRAINT df_oras 

		   UPDATE versiune SET version_id=1
		   PRINT 'oras nu are valoare default'
		   PRINT 'baza de date se afla acum in VERSIUNEA 1'
	END
GO

--procedura care CREEAZA O TABELA NOUA
CREATE PROCEDURE DO3
AS
   
     DECLARE @v INT 
	 SELECT TOP 1 @v=version_id
	 FROM versiune

	 IF @v=2
	 BEGIN
	        CREATE TABLE Furnizori(
			id INT PRIMARY KEY,
			nume NVARCHAR(20) NOT NULL)

			UPDATE versiune SET version_id=3
			PRINT 's-a creat tabela noua Furnizori'
			PRINT 'baza de date se afla in VERSIUNEA 3'
	END
GO

--procedura care face UNDO LA CREAREA UNEI TABELE NOI
CREATE PROCEDURE UNDO3
AS
     DECLARE @v INT
	 SELECT TOP 1 @v=version_id
	 FROM versiune

	 IF @v=3
	 BEGIN 
	         DROP TABLE Furnizori

			 UPDATE versiune SET version_id=2
			 PRINT 's-a sters tabela Furnizori'
			 PRINT 'baza de date se afla in VERSIUNEA 2'
	END
GO

--procedura de adaugare a unei coloane noi

CREATE PROCEDURE DO4
AS
   DECLARE @v INT
   SELECT TOP 1 @v=version_id
   FROM versiune

   IF @v=3
   BEGIN
           ALTER TABLE Furnizori
		   ADD id_piesa INT

		   UPDATE versiune SET version_id=4
		   PRINT 's-a adaugat coloana id_piesa in tabela Furnizori'
		   PRINT 'Baza de date se afla in VERSIUNEA 4'
	END
GO

--procedura care face undo la adaugarea unei coloane

CREATE PROCEDURE UNDO4
AS
    DECLARE @v INT
	SELECT TOP 1 @v=version_id
	FROM versiune
	 
	if @v=4
	BEGIN
	       ALTER TABLE Furnizori
		   DROP COLUMN id_piesa
		     
		   UPDATE versiune SET version_id=3
		   PRINT 's-a sters coloana id_piesa din tabela Furnizori'
		   PRINT 'Baza de date se afla in VERSIUNEA 3'
	END
GO

--procedura de creare constrangere cheie straina
CREATE PROCEDURE DO5
AS
  DECLARE @v INT
  SELECT TOP 1 @v=version_id
  FROM versiune

  IF @v=4
  BEGIN
          ALTER TABLE Furnizori
		  ADD CONSTRAINT fk_furnizori_piese FOREIGN KEY(id_piesa) REFERENCES Piese(id_piesa)

		  UPDATE versiune SET version_id=5
		  PRINT 'am adaugat constrangerea cheie straina fk_furnizori_piese'
		  PRINT 'BAza de date se afla in VERSIUNEA 5'
	END
GO

--procedura de undo la crearea constrangerii foreign key
CREATE PROCEDURE UNDO5
AS
   DECLARE @v INT
   SELECT TOP 1 @v=version_id
   FROM versiune

   IF @v=5
   BEGIN 
           ALTER TABLE Furnizori
		   DROP CONSTRAINT fk_furnizori_piese

		   UPDATE versiune SET version_id=4
		   PRINT 'am sters constrangerea fk_furnizori_piese'
		   PRINT 'BAza de date se afla in VERSIUNEA 4'
	END 
GO

CREATE PROCEDURE EXEC_ALL
AS
	EXEC DO1
	EXEC DO2
	EXEC DO3
	EXEC DO4
	EXEC DO5
	EXEC UNDO5
	EXEC UNDO4
	EXEC UNDO3
	EXEC UNDO2
	EXEC UNDO1
GO

EXEC EXEC_ALL
GO

CREATE PROCEDURE PRINCIPAL
@new_vers INT
AS
	DECLARE @old_vers INT
	DECLARE @text VARCHAR(50)
	SELECT TOP 1 @old_vers = version_id
	FROM versiune

	IF @new_vers < 0 or @new_vers > 5
	BEGIN
		PRINT 'INVALID INPUT'
	END
	ELSE
	BEGIN
		IF @old_vers < @new_vers
		BEGIN
			SET @old_vers = @old_vers + 1
			WHILE @old_vers <= @new_vers
			BEGIN
				SET @text = 'DO' + CONVERT(VARCHAR(5), @old_vers)
				EXEC @text
				SET @old_vers = @old_vers + 1
			END
		END
		ELSE
		BEGIN
			IF @old_vers > @new_vers
			BEGIN
				WHILE @old_vers > @new_vers
				BEGIN
					SET @text = 'UNDO' + CONVERT(VARCHAR(5), @old_vers)
					EXEC @text
					SET @old_vers = @old_vers - 1
				END
			END
		END
	END
GO

EXEC PRINCIPAL 0   
