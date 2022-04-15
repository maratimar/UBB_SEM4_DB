--1.afisarea numelor clientilor fara duplicate care locuiesc in Cluj-Napoca si care au inchiriat cel putin un vehicul
--1 SELECT, 1 DISTINCT, 1 WHERE, 3 tabele
Select DISTINCT nume
 FROM Clienti C
 INNER JOIN Inchirieri i
    on c.CNP = i.id_client
INNER JOIN Vehicule v
    on i.id_vehicul = v.id_vehicul
 where oras='Cluj-Napoca'

--2.afisarea denumirilor pieselor fara duplicate pentru care pretul este mai mare de 100
--1 SELECT, 1 DISTINCT, 1 WHERE
SELECT DISTINCT denumire FROM Piese
 WHERE pret>100

--3.afisarea numelor angajatilor care au lucrat la un vehicul din service
--2 SELECT, 1 WHERE, 1 GROUP BY
SELECT nume FROM Angajati 
WHERE id_service in (Select id_service FROM Service)
 group by nume

--4.afisarea numarului total de vehicule cumparate si a sumei totale pentru fiecare client pt care val totala este strict mai mare decat 50000
--1 SELECT , 1 GROUP BY, 1 HAVING ,3 tabele , relatie m-n
SELECT id_client, COUNT(id_bon) AS nr_cumparaturi, SUM(suma) AS valoare_totala
FROM Bon_fiscal_vehicul
GROUP BY id_client
HAVING SUM(suma)>50000;

--5.afisarea nr total de cumparaturi de piese si a sumei totale pt fiecare client pt care val totala este strict mai mare decat 23
--1 SELECT, 1 GROUP BY ,1 HAVING 
SELECT id_client, COUNT(id_bon) AS nr_cumparaturi, SUM(suma) AS valoare_totala
FROM Bon_fiscal_piese
GROUP BY id_client
HAVING SUM(suma)>23;

--6.toate datele despre clientii care au inchiriat vehicule cat si despre vehiculele inchiriate
--relatie m-n, 3 tabele, 1 SELECT
SELECT *
FROM Clienti c
INNER JOIN Inchirieri i
    on c.CNP = i.id_client
INNER JOIN Vehicule v
    on i.id_vehicul = v.id_vehicul

--7.problemele vehiculelor care au iesit deja din service
-- 1 SELECT
Select problema from Service
 where data_iesire is not NULL

--8.detaliile despre piesele cumparate si despre clientii care le-au achizitonat
--3 tabele, 1 SELECT
Select *
FROM Piese p
INNER JOIN Bon_fiscal_piese b
   on p.id_piesa=b.id_piesa
INNER JOIN Clienti c
   on c.CNP=b.id_client

--9.id-ul vehiculului pentru care taxa de inchiriere achitata de un client este strict mai mare decat 100
--3 tabele, 1 SELECT, 1 WHERE
SELECT id_vehicul
FROM Inchirieri
FULL OUTER JOIN Clienti
ON Inchirieri.id_client = Clienti.CNP
WHERE taxa>100;

--10.detaliile despre angajati si vehiculele reparate de acestia,ordonate dupa problemele vehiculelor
--3 tabele, 1 SELECT, 1 WHERE
SELECT *
FROM Angajati, Service,Vehicule
WHERE Angajati.id_service =Service.id_service  AND Service.id_vehicul=Vehicule.id_vehicul
ORDER BY Service.problema ASC