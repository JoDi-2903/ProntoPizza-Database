/* 
 * DHBW Stuttgart | Datenbanken 1 | Semester 4
 * ********************************************
 * Autor:            Jonathan Diebel
 * Matrikelnummer:   2341463
 * Erstelldatum:     31.03.2022
 * Letzte Änderung:  03.04.2022
 */

----------------------------------------------------------------------------------

/*
 * Delete tables if they already exist
 */

DROP TABLE if EXISTS mitarbeiter;
DROP TABLE if EXISTS lieferant;
DROP TABLE if EXISTS koch;
DROP TABLE if EXISTS lieferzone;
DROP TABLE if EXISTS kunde;
DROP TABLE if EXISTS bestellung;
DROP TABLE if EXISTS artikel;
DROP TABLE if EXISTS wein;
DROP TABLE if EXISTS pizza;
DROP TABLE if EXISTS zutat;
DROP TABLE if EXISTS besteht_aus;
DROP TABLE if EXISTS ist_belegt_mit;
DROP TABLE if EXISTS telefonnummern_mitarbeiter;
DROP TABLE if EXISTS telefonnummern_kunden;

----------------------------------------------------------------------------------

/*
 * Set up the tables
 */

-- Create the table "mitarbeiter"
CREATE TABLE IF NOT EXISTS mitarbeiter 
 (
   	SteuerID integer,
    Vorname varchar,
    Nachname varchar NOT NULL,
    Strasse varchar,
    Hausnummer int,
    Postleitzahl int,
    Ort varchar,
    Email varchar,
    Gehalt int NOT NULL,
    IBAN char(22) NOT NULL,
    BIC char(11),

	PRIMARY KEY (SteuerID),
	CHECK (Gehalt BETWEEN 450 AND 3500),
    CHECK (SteuerID < 100000000000)
);	

-- Create the table "lieferant"
CREATE TABLE IF NOT EXISTS lieferant
 (
   	SteuerID integer,
    Vorname varchar,
    Nachname varchar NOT NULL,
    Strasse varchar,
    Hausnummer int,
    Postleitzahl int,
    Ort varchar,
    Email varchar,
    Gehalt int NOT NULL,
    IBAN char(22) NOT NULL,
    BIC char(11),
    FuehrerscheinID char(11) NOT NULL,

	PRIMARY KEY (SteuerID),
	CHECK (Gehalt BETWEEN 450 AND 3500),
    CHECK (SteuerID < 100000000000)
);

-- Create the table "koch"
CREATE TABLE IF NOT EXISTS koch
 (
   	SteuerID integer,
    Vorname varchar,
    Nachname varchar NOT NULL,
    Strasse varchar,
    Hausnummer int,
    Postleitzahl int,
    Ort varchar,
    Email varchar,
    Gehalt int NOT NULL,
    IBAN char(22) NOT NULL,
    BIC char(11),
    Kuechenposten char(3) NOT NULL,

	PRIMARY KEY (SteuerID),
	CHECK (Gehalt BETWEEN 450 AND 3500),
    CHECK (SteuerID < 100000000000),
    CHECK (Kuechenposten IN ('PZA', 'VIN', 'ABW', 'AZU'))
);

-- Create the table "lieferzone"
CREATE TABLE IF NOT EXISTS lieferzone
 (
    ZonenNummer int,
    Bezeichnung char(13),

	PRIMARY KEY (ZonenNummer),
    CHECK (Bezeichnung IN ('Biberach', 'Boeckingen', 'Frankenbach', 'Horkheim', 'Kirchhausen', 'Klingenberg', 'Neckargartach', 'Sontheim'))
);

-- Create the table "kunde"
CREATE TABLE IF NOT EXISTS kunde
 (
    KundenNummer int,
    Vorname varchar,
    Nachname varchar NOT NULL,
    Strasse varchar NOT NULL,
    Hausnummer int NOT NULL,
    Postleitzahl int NOT NULL,
    Ort varchar NOT NULL,
    Email varchar,

	PRIMARY KEY (KundenNummer)
);

-- Create the table "bestellung"
CREATE TABLE IF NOT EXISTS bestellung
 (
    BestellNummer int,
    Zeitstempel timestamp,
    Artikelanzahl int NOT NULL,
    Preis decimal NOT NULL,
    
	PRIMARY KEY (BestellNummer)
);

-- Create the table "artikel"
CREATE TABLE IF NOT EXISTS artikel
 (
    ArtikelNummer int,
    Kategorie char(9),
    Stueckpreis decimal,
    
	PRIMARY KEY (ArtikelNummer),
    CHECK (Kategorie IN ('Speisen', 'Getraenke'))
);

-- Create the table "wein"
CREATE TABLE IF NOT EXISTS wein
 (
    ArtikelNummer int,
    Kategorie char(9),
    Stueckpreis decimal,
    Jahrgang int,
    Rebsorte varchar,
    Vorrat int,
    
	PRIMARY KEY (ArtikelNummer),
    CHECK (Kategorie IN ('Speisen', 'Getraenke')),
    CHECK (Jahrgang BETWEEN 1990 AND date_part('year', CURRENT_DATE))
);

-- Create the table "pizza"
CREATE TABLE IF NOT EXISTS pizza
 (
    ArtikelNummer int,
    Kategorie char(9),
    Stueckpreis decimal,
    Groesse char(6),
    
	PRIMARY KEY (ArtikelNummer),
    CHECK (Kategorie IN ('Speisen', 'Getraenke')),
    CHECK (Groesse IN ('small', 'medium', 'large', 'family', 'party'))
);

-- Create the table "zutat"
CREATE TABLE IF NOT EXISTS zutat
 (
    ZutatenNummer int,
    Bezeichnung varchar,
    Hersteller varchar,
    vegetarisch boolean NOT NULL,
    Vorrat int,
    
	PRIMARY KEY (ZutatenNummer)
);

-- Create the table "besteht_aus"
CREATE TABLE IF NOT EXISTS besteht_aus
 (
    BestellNummer int,
    ArtikelNummer int,
    
	PRIMARY KEY (BestellNummer, ArtikelNummer)
);

-- Create the table "ist_belegt_mit"
CREATE TABLE IF NOT EXISTS ist_belegt_mit
 (
    ArtikelNummer int,
    ZutatenNummer int,
    
	PRIMARY KEY (ArtikelNummer, ZutatenNummer)
);

-- Create the table "Telefonnummern_Mitarbeiter"
CREATE TABLE IF NOT EXISTS telefonnummern_mitarbeiter
 (
    Telefonnummer varchar,
    Art char(8),
    
	PRIMARY KEY (Telefonnummer),
    CHECK (Art IN ('festnetz', 'mobil', 'fax'))
);

-- Create the table "Telefonnummern_Kunden"
CREATE TABLE IF NOT EXISTS telefonnummern_kunden
 (
    Telefonnummer varchar,
    Art char(8),
    
	PRIMARY KEY (Telefonnummer),
    CHECK (Art IN ('festnetz', 'mobil', 'fax'))
);

----------------------------------------------------------------------------------

/*
 * Insert Foreign Keys
 */

 -- Mitarbeiter
ALTER TABLE mitarbeiter 
ADD Vertretung_fuer int,
ADD FOREIGN KEY(Vertretung_fuer) REFERENCES mitarbeiter
;

 -- Lieferant
ALTER TABLE lieferant
ADD Vertretung_fuer int,
ADD FOREIGN KEY(Vertretung_fuer) REFERENCES lieferant
;

 -- Koch
ALTER TABLE koch
ADD Vertretung_fuer int,
ADD FOREIGN KEY(Vertretung_fuer) REFERENCES koch
;

 -- Lieferzone
ALTER TABLE lieferzone
ADD Zustaendiger_Fahrer int,
ADD FOREIGN KEY(Zustaendiger_Fahrer) REFERENCES lieferant
;

 -- Bestellung
ALTER TABLE bestellung
ADD zubereitet_von int,
ADD ausgeliefert_von int,
ADD erteilt_von int,
ADD FOREIGN KEY(zubereitet_von) REFERENCES koch,
ADD FOREIGN KEY(ausgeliefert_von) REFERENCES lieferant,
ADD FOREIGN KEY(erteilt_von) REFERENCES kunde
;

 -- Telefonnummern_Mitarbeiter
ALTER TABLE telefonnummern_mitarbeiter
ADD Besitzer_M int,
ADD FOREIGN KEY(Besitzer_M) REFERENCES mitarbeiter
;

 -- Telefonnummern_Kunden
ALTER TABLE telefonnummern_kunden
ADD Besitzer_K int,
ADD FOREIGN KEY(Besitzer_K) REFERENCES kunde
;

 -- besteht_aus
ALTER TABLE besteht_aus
ADD FOREIGN KEY(BestellNummer) REFERENCES bestellung,
ADD FOREIGN KEY(ArtikelNummer) REFERENCES artikel
;

 -- ist_belegt_mit
ALTER TABLE ist_belegt_mit
ADD FOREIGN KEY(ArtikelNummer) REFERENCES artikel,
ADD FOREIGN KEY(ZutatenNummer) REFERENCES zutat
;

----------------------------------------------------------------------------------

/*
 * Fill tables with data
 */

INSERT INTO mitarbeiter 
VALUES (1, 'Paul', 'Müller', Null, '28.01.1975','m', '28.05.2014','DBA',61000,'EDM1',NULL),
       (2, 'Rita', 'Schulze', 'Klein', '12.03.1981','w', '01.07.2016','Analy',48000,'EDM3',5),
       (3, 'Claudia', 'Franz', Null, '07.02.1986','w', '1.10.2017','Test',40000,'EDM2',6),
       (4, 'Karin', 'Schwarz', 'Breithans', '13.10.1978','w', '1.10.2011',default,56000,'EDM3',5),
       (5, 'Werner', 'Meier', Null, '20.03.1968','m', '01.02.2010','Analy',80000,'EDM3',NULL),
       (6, 'Klaus', 'Brecht', Null, '28.01.1977','m', '1.6.2011','PL',65000,'EDM2',Null),
       (7, 'Florian', 'Habrecht', Null, '28.01.1985','m', '1.9.2017','Test',46000,'EDM2',6),
       (8, 'Edith', 'Franz', 'Schmid', '17.03.1982','w', '1.3.2015',NULL,38000,'EDM1',6),
       (9, 'Manfred', 'Klein', Null, '28.01.1990','m', '1.12.2018',NULL,32000,'EDM2',5),
       (10,'Paul', 'Kunze', Null, '28.01.1975','m', '1.9.2014',NULL,55000,'EDM1',NULL)
;