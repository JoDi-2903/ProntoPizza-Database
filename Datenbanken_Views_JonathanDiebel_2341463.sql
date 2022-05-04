/* 
 * DHBW Stuttgart | Datenbanken 1 | Semester 4
 * ********************************************
 * Autor:            Jonathan Diebel
 * Matrikelnummer:   2341463
 * Erstelldatum:     03.05.2022
 * Letzte Änderung:  04.05.2022
 */

----------------------------------------------------------------------------------

/*
 * View 1: Personalabteilung
 * The data of the cooks and deliverers should be displayed completely in an employee table.
 */

CREATE View View1_Mitarbeiter AS
SELECT mitarbeiter.*, koch.Kuechenposten, lieferant.FuehrerscheinID
from mitarbeiter 
left join koch ON mitarbeiter.SteuerID = koch.SteuerID 
left join lieferant ON mitarbeiter.SteuerID = lieferant.SteuerID
;

----------------------------------------------------------------------------------

/*
 * View 2: Personalabteilung
 * Output employees who earn more than the average salary with tax ID, first name and last name sorted by salary.
 */

CREATE View View2_UeberDurchschnittsgehalt AS
SELECT mitarbeiter.SteuerID, Vorname, Nachname, Gehalt
from mitarbeiter 
left join koch ON mitarbeiter.SteuerID = koch.SteuerID 
left join lieferant ON mitarbeiter.SteuerID = lieferant.SteuerID
WHERE Gehalt > (SELECT AVG(Gehalt) from Mitarbeiter)
Order BY Gehalt DESC
;

----------------------------------------------------------------------------------

/*
 * View 3: Köche
 * Overview of all currently open pizza orders with items, responsible cooks and sorted by order date.
 */

CREATE View View3_AuftraegeFuerKoeche_Speisen AS
SELECT DISTINCT zeitstempel, bestellung.bestellnummer, anzahlspeisen, artikel.artikelnummer, menge, bezeichnung, zutatenanzahl, groesse, zubereitet_von, vorname, nachname
from mitarbeiter 
Join bestellung ON mitarbeiter.SteuerID = bestellung.zubereitet_von
Join besteht_aus ON bestellung.BestellNummer = besteht_aus.BestellNummer
Join artikel ON besteht_aus.ArtikelNummer = artikel.ArtikelNummer
Join pizza ON artikel.ArtikelNummer = pizza.ArtikelNummer
WHERE artikel.kategorie = 'Speisen'
Order BY zeitstempel
;

----------------------------------------------------------------------------------

/*
 * View 4: Köche
 * Overview of all currently open wine orders with articles, responsible chefs and sorted by order date.
 */

CREATE View View4_AuftraegeFuerKoeche_Getraenke AS
SELECT DISTINCT zeitstempel, bestellung.bestellnummer, anzahlgetraenke, artikel.artikelnummer, menge, rebsorte, jahrgang, zubereitet_von, vorname, nachname
from mitarbeiter 
Join bestellung ON mitarbeiter.SteuerID = bestellung.zubereitet_von
Join besteht_aus ON bestellung.BestellNummer = besteht_aus.BestellNummer
Join artikel ON besteht_aus.ArtikelNummer = artikel.ArtikelNummer
Join wein ON artikel.ArtikelNummer = wein.ArtikelNummer
WHERE artikel.kategorie = 'Getraenke'
Order BY zeitstempel
;

----------------------------------------------------------------------------------
-- END OF FILE