/* 
 * DHBW Stuttgart | Datenbanken 1 | Semester 4
 * ********************************************
 * Autor:            Jonathan Diebel
 * Matrikelnummer:   2341463
 * Erstelldatum:     03.05.2022
 * Letzte Änderung:  05.05.2022
 */

----------------------------------------------------------------------------------

/*
 * View 1: Personalabteilung
 * The data of the cooks and deliverers including phone numbers should be displayed completely in an employee table.
 */

CREATE View View1_Mitarbeiter AS
SELECT mitarbeiter.*, koch.Kuechenposten, lieferant.FuehrerscheinID, telefonnummern_mitarbeiter.telefonnummer, telefonnummern_mitarbeiter.art
from mitarbeiter 
left join koch ON mitarbeiter.SteuerID = koch.SteuerID 
left join lieferant ON mitarbeiter.SteuerID = lieferant.SteuerID
left join telefonnummern_mitarbeiter ON telefonnummern_mitarbeiter.Besitzer_M = mitarbeiter.SteuerID
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

/*
 * View 5: Köche
 * Output an overview of the ingredients, sorted by quantity, with no more than 20 pieces left in stock.
 */

CREATE View View5_ZutatenMitGeringemLagerbestand AS
SELECT ZutatenNummer, Bezeichnung, Hersteller, Vorrat
from zutat
WHERE vorrat <= 20
Order BY vorrat
;

----------------------------------------------------------------------------------

/*
 * View 6: Lieferanten
 * Overview of all currently open orders with customer address, responsible delivery person and sorted by order date.
 */

CREATE View View6_AuftraegeFuerLieferanten AS
SELECT DISTINCT zeitstempel, bestellnummer, anzahlspeisen, anzahlgetraenke, preis, ausgeliefert_von, kundennummer, vorname, nachname, strasse, hausnummer, postleitzahl, ort, stadtteil, zonennummer, lieferzone.bezeichnung
from lieferant 
Join bestellung ON lieferant.SteuerID = bestellung.ausgeliefert_von
Join kunde ON bestellung.erteilt_von = kunde.KundenNummer
Join lieferzone ON lieferant.SteuerID = lieferzone.Zustaendiger_Fahrer
Order BY zeitstempel
;

----------------------------------------------------------------------------------

/*BUG
 * View 7: Kunden
 * Menu with all pizzas and info on item numbers, sizes, prices and toppings.
 */

CREATE View View7_Speisekarte AS
SELECT artikel.artikelnummer, pizza.bezeichnung, groesse, stueckpreis, zutat.bezeichnung
from artikel 
Join pizza ON artikel.ArtikelNummer = pizza.ArtikelNummer
Join ist_belegt_mit ON pizza.ArtikelNummer = ist_belegt_mit.ArtikelNummer
Join zutat ON ist_belegt_mit.ZutatenNummer = zutat.ZutatenNummer
Order BY artikel.artikelnummer, zutat.bezeichnung
;

----------------------------------------------------------------------------------

/*BUG
 * View 8: Kunden
 * Menu with all vegetarian pizzas and info on item numbers, sizes, prices and toppings.
 */

CREATE View View8_Speisekarte_Vegetarisch AS
SELECT artikel.artikelnummer, pizza.bezeichnung, groesse, stueckpreis, zutat.bezeichnung
from artikel 
Join pizza ON artikel.ArtikelNummer = pizza.ArtikelNummer
Join ist_belegt_mit ON pizza.ArtikelNummer = ist_belegt_mit.ArtikelNummer
Join zutat ON ist_belegt_mit.ZutatenNummer = zutat.ZutatenNummer
WHERE pizza.artikelnummer NOT IN (
    SELECT pizza.artikelnummer from pizza
    Join ist_belegt_mit ON pizza.ArtikelNummer = ist_belegt_mit.ArtikelNummer
    Join zutat ON ist_belegt_mit.ZutatenNummer = zutat.ZutatenNummer
    WHERE vegetarisch = false
)
Order BY artikel.artikelnummer, zutat.bezeichnung
;

----------------------------------------------------------------------------------

/*
 * View 9: Kunden
 * Beverage list with all wines and info on item numbers, grape varieties, years and prices.
 */

CREATE View View9_Getraenkekarte AS
SELECT artikel.artikelnummer, rebsorte, jahrgang, stueckpreis
from artikel 
Join wein ON artikel.ArtikelNummer = wein.ArtikelNummer
Order BY rebsorte, jahrgang
;

----------------------------------------------------------------------------------

/*
 * View 10: Chef
 * 
 */

CREATE View View10_Kunden AS
SELECT kunde.*, telefonnummern_kunden.telefonnummer, telefonnummern_kunden.art
from kunde
left join telefonnummern_kunden ON telefonnummern_kunden.Besitzer_K = kunde.KundenNummer 
Order BY KundenNummer
;

----------------------------------------------------------------------------------

/*
 * View 11: Chef
 * Gesamtumsatz des Tages
 */

CREATE View View11_GesamtumsatzDesTages AS
SELECT SUM(bestellung.Preis)
from bestellung
WHERE DATE(Zeitstempel) = CURRENT_DATE 	--use '2022-04-08' in this example to get some output
;

----------------------------------------------------------------------------------
-- END OF FILE


/* TEMP
 * View 11: Chef
 * Anzahl der Kunden pro Lieferzone ausgeben
 */

CREATE View View10_AnzahlKundenProLieferzone AS
SELECT count(stadtteil)
from kunde
WHERE stadtteil IN ('Boeckingen', 'Heilbronn', 'Neckargartach')
;