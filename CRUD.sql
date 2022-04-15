go
---piese
CREATE FUNCTION validarePiese(@denumire NVARCHAR(50),@suma MONEY)
RETURNS INT AS
BEGIN
       DECLARE @ok INT=1
	   if @denumire LIKE ''
	      SET @ok=0;
	   if @suma <1
	      SET @ok=0;
	   RETURN @ok;
END;
go

CREATE PROCEDURE insertPiese
@id INT,
@denumire NVARCHAR(50),
@suma MONEY
AS
BEGIN
     if dbo.validarePiese(@denumire,@suma)=0
	     PRINT 'date invalide!'
	 else
	     INSERT INTO Piese(id_piesa,denumire,pret) VALUES (@id,@denumire,@suma)
END
go

EXEC insertPiese 10,'antena',50
EXEC insertPiese 11,'pompa',350

go
ALTER PROCEDURE updatePiese
@id INT,
@denumire NVARCHAR(50),
@suma MONEY
AS 
BEGIN
     if not exists(SELECT * FROM Piese WHERE id_piesa=@id)
	     RAISERROR('Nu exista piesa cu acest id',12,1);
	 else
	 BEGIN
	    if dbo.validarePiese(@denumire,@suma)=0
		   PRINT 'date invalide'
		   else
		      UPDATE Piese SET denumire=@denumire,pret=@suma
			  WHERE id_piesa=@id
	 END
END
go

EXEC updatePiese 9,'tacheti',150
EXEC updatePiese 111,'et',400
EXEC updatePiese 2,'oglinda',0
select * from Piese

go


CREATE PROCEDURE deletePiese
@id INT
AS
BEGIN
    if not exists(SELECT * FROM Piese WHERE id_piesa=@id)
	    RAISERROR('Nu exista piesa cu acest id',12,1);
	else
	   DELETE FROM Piese WHERE id_piesa=@id
END
go

EXEC deletePiese 9
EXEC deletePiese 3000

go

CREATE PROCEDURE getAllPiese
@suma MONEY
AS
BEGIN
   SELECT * FROM Piese WHERE pret=@suma
END
go

EXEC getAllPiese 600

go

--clienti
CREATE FUNCTION validareClienti(@nume NVARCHAR(30),@prenume NVARCHAR(30),@oras NVARCHAR(20))
RETURNS INT AS
BEGIN
       DECLARE @ok INT=1
	   if @nume LIKE ''
	      SET @ok=0;
	   if @prenume LIKE ''
	      SET @ok=0;
	   if @oras LIKE ''
	      SET @ok=0;
	   
	   RETURN @ok;
END;

go

CREATE PROCEDURE insertClienti
@nume NVARCHAR(30),
@prenume NVARCHAR(30),
@oras NVARCHAR(20)
AS
BEGIN
     if dbo.validareClienti(@nume,@prenume,@oras)=0
		RAISERROR('Date invalide!',12,1)
	ELSE
	    INSERT INTO Clienti (nume,prenume,oras) VALUES (@nume,@prenume,@oras)
END

go

EXEC insertClienti 'Tache','Valentina','Aiud'
EXEC insertClienti '','',''
SELECT * FROM Clienti
go




CREATE PROCEDURE updateClienti
@id INT,
@nume NVARCHAR(30),
@prenume NVARCHAR(30),
@oras NVARCHAR(20)
AS
BEGIN
    if not exists(select * from Clienti where CNP=@id)
		RAISERROR('Nu exista clientul',12,1)
	ELSE
	BEGIN
		if dbo.validareClienti(@nume,@prenume,@oras)=0
			RAISERROR('Date invalide!',12,1)
		ELSE
		    UPDATE Clienti SET nume=@nume,prenume=@prenume,oras=@oras 
			WHERE CNP=@id
	END
END
go

EXEC updateClienti 1,'Dinde','Anamaria','Fetesti'
EXEC updateClienti -1,'Rol','Alin','Turda'
SELECT * FROM Clienti

go

CREATE PROCEDURE deleteClienti
@id INT
AS 
BEGIN
     if not exists(SELECT * FROM Clienti WHERE CNP=@id)
	     RAISERROR('Nu exista acest client',12,1)
	else
	    DELETE FROM Clienti WHERE CNP=@id
END
go

EXEC deleteClienti 5
EXEC deleteClienti 120
SELECT * FROM Clienti

go

CREATE PROCEDURE getAllClienti
@oras NVARCHAR(20)
AS
BEGIN
     SELECT * FROM Clienti WHERE oras=@oras
END
go

EXEC getAllClienti 'Cluj-Napoca'
EXEC getAllClienti 'Budapesta'
SELECT * FROM Clienti


go

--bon_fiscal_piese

ALTER FUNCTION validareBon(@id_piesa INT,@id_client INT,@suma MONEY)
RETURNS INT AS
BEGIN
      DECLARE @ok INT=1
	   if @id_client=0 
	      SET @ok=0;
	   if @id_piesa=0
	      SET @ok=0;
	   if @suma=0
	      SET @ok=0;
	   
      RETURN @ok
END
 go   
 
ALTER PROCEDURE insertBon
 @id INT,
 @id_piesa INT,
 @id_client INT,
 @suma MONEY
 AS
 BEGIN
      if dbo.validareBon(@id_piesa,@id_client,@suma)=0
	     RAISERROR('DATE INVALIDE',12,1)
	  else
	      INSERT INTO Bon_fiscal_piese(id_bon,id_piesa,id_client,suma) VALUES (@id,@id_piesa,@id_client,@suma)
END
go

EXEC insertBon 5,2,2,50
SELECT * FROM Bon_fiscal_piese

go

CREATE PROCEDURE updateBon
@id INT,
@id_piesa INT,
@id_client INT,
@suma MONEY
AS
BEGIN
     if not exists(SELECT * FROM Bon_fiscal_piese WHERE id_bon=@id)
	       RAISERROR('Bon inexistent!',12,1)
	 else
	 BEGIN
		if dbo.validareBon(@id_piesa,@id_client,@suma)=0
			RAISERROR('Date invalide!',12,1)
		ELSE
		    UPDATE Bon_fiscal_piese SET id_piesa=@id_piesa,id_client=@id_client,suma=@suma
			WHERE id_bon=@id
	END
END
go

EXEC updateBon 4,5,2,500
EXEC updateBon 100,1,5,200
SELECT * FROM Bon_fiscal_piese

go

CREATE PROCEDURE deleteBon
@id INT
AS
BEGIN
     if not exists(SELECT * FROM Bon_fiscal_piese WHERE id_bon=@id)
	     RAISERROR('Bon inexistent',12,1)
	 else
	     DELETE FROM Bon_fiscal_piese WHERE id_bon=@id
END
go

EXEC deleteBon 1
EXEC deleteBon 100

go

CREATE PROCEDURE getAllBon
@suma MONEY
AS
BEGIN
    SELECT * FROM Bon_fiscal_piese WHERE suma=@suma
END
go

EXEC getAllBon 50

go

--indecsi

CREATE NONCLUSTERED INDEX IX_Bon_fiscal_piese_suma_asc ON Bon_fiscal_piese (suma ASC);
CREATE NONCLUSTERED INDEX IX_Clienti_nume_prenume ON Clienti (nume ASC, prenume ASC);


--view-uri
go

CREATE VIEW vw_Bon AS
SELECT TOP 10 C.nume AS nume_client,C.prenume AS prenume_client, P.denumire AS piesa
FROM Bon_fiscal_piese B
INNER JOIN Piese P ON B.id_piesa=P.id_piesa
INNER JOIN Clienti C ON B.id_client=C.CNP
ORDER BY suma

SELECT * FROM vw_Bon

go

CREATE VIEW vw_Bon1 AS
SELECT TOP 10 C.nume AS nume_client,C.prenume AS prenume_client, P.denumire AS piesa
FROM Bon_fiscal_piese B
INNER JOIN Piese P ON B.id_piesa=P.id_piesa
INNER JOIN Clienti C ON B.id_client=C.CNP
ORDER BY C.nume, C.prenume

SELECT * FROM vw_Bon1





   




