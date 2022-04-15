-- Procedura Principala
GO
CREATE PROCEDURE pricipal
AS
BEGIN
DECLARE @id_Test INT, @descriere NVARCHAR(2000), @nume_Tabel NVARCHAR(60), @noOfRows INT;
DECLARE @id_View INT, @nume_View NVARCHAR(100), @id_Tabel INT;
DECLARE @sql_Delete VARCHAR(100), @sql_Insert VARCHAR(100), @sql_View VARCHAR(100);
DECLARE @test_RunId INT;

	-- declar cursorul pentru teste
	DECLARE cursor_teste CURSOR FOR
	SELECT TestId, Name FROM Tests

	OPEN cursor_teste;
	FETCH NEXT FROM cursor_teste INTO @id_Test, @descriere;
	-- pentru fiecare test trebuie sa sterg, inseres si testez view-urile
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- memorez timpul initial, inainte de a executa operatiile
		INSERT INTO TestRuns (Description, StartAt) VALUES (@descriere, GETDATE());
		SET @test_RunId = @@IDENTITY;
		-- TABELELE
		-- parcurg pe rand fiecare tabel din fiecare test
		-- declar cursorul pentru tabele
		DECLARE cursor_tabele CURSOR SCROLL FOR
		SELECT Name, T.TableID, NoOfRows 
		FROM TestTables TT INNER JOIN Tables T
		ON TT.TableID = T.TableID
		WHERE TT.TestID = @id_Test
		ORDER BY Position

		OPEN cursor_tabele;
		-- delete-urile
		FETCH NEXT FROM cursor_tabele INTO @nume_Tabel, @id_Tabel, @noOfRows;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @sql_Delete = 'DELETE FROM ' + @nume_Tabel;
			EXEC (@sql_Delete);

			FETCH NEXT FROM cursor_tabele INTO @nume_Tabel, @id_Tabel, @noOfRows;
		END


		-- insert-urile
		 FETCH PRIOR FROM cursor_tabele INTO @nume_Tabel, @id_Tabel, @noOfRows;
		 WHILE @@FETCH_STATUS = 0
		 BEGIN
			-- memorez timpul inainte de a executa
			INSERT INTO TestRunTables (TestRunID, TableID, StartAt, EndAt) VALUES (@test_RunId, @id_Tabel, GETDATE(), GETDATE());
			SET @sql_Insert = 'insert_'+@nume_Tabel;
			EXEC @sql_Insert @noOfRows;
			
			-- memorez timpul dupa executie
			UPDATE TestRunTables 
			SET EndAt = GETDATE() 
			WHERE TestRunID = @test_RunId AND TableID = @id_Tabel;

			FETCH PRIOR FROM cursor_tabele INTO @nume_Tabel, @id_Tabel, @noOfRows;
		END

		CLOSE cursor_tabele;
		DEALLOCATE cursor_tabele;

		-- view-uri
		-- aleg pe rand fiecare view din fiecare test

		-- declar cursor pentru view-uri
		DECLARE cursor_views CURSOR FOR
		SELECT TV.ViewID, NAME
		FROM TestViews TV INNER JOIN Views V
		ON TV.ViewID = V.ViewID
		WHERE TV.TestID = @id_Test

		OPEN cursor_views;
		FETCH NEXT FROM cursor_views INTO @id_View, @nume_View;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- memorez timpul inaite de a executa
			INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) VALUES (@test_RunId, @id_View, GETDATE(),GETDATE());
			SET @sql_View = 'SELECT * FROM '+@nume_View;
			EXEC(@sql_View)

			-- memorez timpul dupa executie
			UPDATE TestRunViews 
			SET EndAt = GETDATE()
			WHERE TestRunID = @test_RunId AND ViewID = @id_View;

			FETCH NEXT FROM cursor_views INTO @id_View, @nume_View;
		END

		CLOSE cursor_views;
		DEALLOCATE cursor_views;

		-- memorez timpul final (dupa stergerea, inserarea, executarea view-urilor)
		UPDATE TestRuns
		SET EndAt = GETDATE()
		WHERE TestRunID =@test_RunId;

		FETCH NEXT FROM cursor_teste INTO @id_Test, @descriere;
	END
	CLOSE cursor_teste;
	DEALLOCATE cursor_teste;
END

GO

EXEC pricipal

DELETE FROM TestRuns
DBCC CHECKIDENT ('TestRuns', RESEED, 0);
SELECT * FROM TestRuns
SELECT * FROM TestRunTables
SELECT * FROM TestRunViews
