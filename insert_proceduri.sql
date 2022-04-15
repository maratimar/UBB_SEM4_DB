-- procedurile de insert

GO

CREATE PROCEDURE insert_Clienti
@NoOfRows INT
AS
BEGIN
	DECLARE @contor INT = 0;
	WHILE @contor < @NoOfRows
	BEGIN
		INSERT INTO Clienti (CNP, nume, prenume, oras) VALUES (@contor, 'Bot', 'Ana', 'Cluj-Napoca');
		SET @contor = @contor + 1;
	END
END

GO

CREATE PROCEDURE insert_Angajati
@NoOfRows INT
AS
BEGIN
	DECLARE @contor INT = 0;
	WHILE @contor < @NoOfRows
	BEGIN
		INSERT INTO Angajati (id_angajat, nume, prenume, rol,id_service) VALUES (@contor, 'Emilian', 'Mita', 'mecanic', @contor);
		SET @contor = @contor + 1;
	END
END

GO 

CREATE PROCEDURE insert_Service
@NoOfRows INT
AS
BEGIN
	DECLARE @contor INT = 0;
	WHILE @contor < @NoOfRows
	BEGIN
		INSERT INTO Service (id_service, data_intrare, data_iesire, problema, id_vehicul) VALUES (@contor, '2021-10-25', '2021-10-27', 'scurgeri ulei', @contor );
		SET @contor = @contor + 1;
	END
END

GO

CREATE PROCEDURE insert_Piese
@NoOfRows INT
AS
BEGIN
	DECLARE @contor INT = 0;
	WHILE @contor < @NoOfRows
	BEGIN
		INSERT INTO Piese (id_piesa, denumire, pret) VALUES (@contor, 'tacheti', 200);
		SET @contor = @contor + 1;
	END
END

GO

CREATE PROCEDURE insert_Bon_fiscal_piese
@NoOfRows INT
AS
BEGIN
	DECLARE @contor INT = 0;
	WHILE @contor < @NoOfRows-5
	BEGIN
		INSERT INTO Bon_fiscal_piese (id_bon, id_piesa,id_client,suma) VALUES (@contor, @contor+4, @contor+4,200);
		SET @contor = @contor + 1;
	END
	WHILE @contor < @NoOfRows
	BEGIN
		INSERT INTO Bon_fiscal_piese (id_bon, id_piesa,id_client,suma) VALUES (@contor, @contor+4, @contor+4,200);
		SET @contor = @contor + 1;
	END
END

GO

CREATE PROCEDURE insert_Vehicule
@NoOfRows INT
AS
BEGIN
	DECLARE @contor INT = 0;
	WHILE @contor < @NoOfRows
	BEGIN
		INSERT INTO Vehicule (id_vehicul, tip, putere, model, culoare) VALUES (@contor, 'Sedan', '100CP', 'GTX', 'negru' );
		SET @contor = @contor + 1;
	END
END

GO


