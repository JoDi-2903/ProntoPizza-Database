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

INSERT INTO lieferant
VALUES (11, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', 'Führerschein', 3),
       (12, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', 'Führerschein', 3),
       (13, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', 'Führerschein', 3),
       (14, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', 'Führerschein', 3),
       (15, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', 'Führerschein', 3),
       (16, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', 'Führerschein', 3),
       (17, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', 'Führerschein', 3),
       (18, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', 'Führerschein', 3),
       (19, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', 'Führerschein', 3),
       (110, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', 'Führerschein', 3)
;

INSERT INTO koch
VALUES (21, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', '', 3),
       (22, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', '', 3),
       (23, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', '', 3),
       (24, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', '', 3),
       (25, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', '', 3),
       (26, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', '', 3),
       (27, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE ', 'BIC', '', 3)
;

INSERT INTO lieferzone
VALUES (10, 'Biberach', 1),
       (20, 'Boeckingen', 1),
       (30, 'Frankenbach', 1),
       (40, 'Horkheim', 1),
       (50, 'Kirchhausen', 1),
       (60, 'Klingenberg', 1),
       (70, 'Neckargartach', 1),
       (80, 'Sontheim', 1)      
;

INSERT INTO kunde
VALUES (1, 'Vorname', 'Nachname', 'Straße', 15, 74172, 'Ort', 'email'),
       (2, 'Vorname', 'Nachname', 'Straße', 15, 74172, 'Ort', 'email'),
       (3, 'Vorname', 'Nachname', 'Straße', 15, 74172, 'Ort', 'email'),
       (4, 'Vorname', 'Nachname', 'Straße', 15, 74172, 'Ort', 'email'),
       (5, 'Vorname', 'Nachname', 'Straße', 15, 74172, 'Ort', 'email'),
       (6, 'Vorname', 'Nachname', 'Straße', 15, 74172, 'Ort', 'email'),
       (7, 'Vorname', 'Nachname', 'Straße', 15, 74172, 'Ort', 'email'),
       (8, 'Vorname', 'Nachname', 'Straße', 15, 74172, 'Ort', 'email'),
       (9, 'Vorname', 'Nachname', 'Straße', 15, 74172, 'Ort', 'email'),
       (10, 'Vorname', 'Nachname', 'Straße', 15, 74172, 'Ort', 'email'),
       (11, 'Vorname', 'Nachname', 'Straße', 15, 74172, 'Ort', 'email')
;

INSERT INTO bestellung
VALUES (79274, '2020-11-11 12:30', 10, 12.50, 1, 1, 1),
       (45156, '2020-11-11 12:30', 10, 12.50, 1, 1, 1),
       (85383, '2020-11-11 12:30', 10, 12.50, 1, 1, 1),
       (48852, '2020-11-11 12:30', 10, 12.50, 1, 1, 1),
       (90749, '2020-11-11 12:30', 10, 12.50, 1, 1, 1),
       (73397, '2020-11-11 12:30', 10, 12.50, 1, 1, 1)
;

INSERT INTO wein
VALUES (3967, 'Getraenke', 14.80, 12.50, 2015, 'Trollinger', 15),
       (3598, 'Getraenke', 14.80, 12.50, 2015, 'Trollinger', 15),
       (1634, 'Getraenke', 14.80, 12.50, 2015, 'Trollinger', 15),
       (5592, 'Getraenke', 14.80, 12.50, 2015, 'Trollinger', 15),
       (7091, 'Getraenke', 14.80, 12.50, 2015, 'Trollinger', 15),
       (1431, 'Getraenke', 14.80, 12.50, 2015, 'Trollinger', 15),
       (3826, 'Getraenke', 14.80, 12.50, 2015, 'Trollinger', 15),
       (6684, 'Getraenke', 14.80, 12.50, 2015, 'Trollinger', 15),
       (7859, 'Getraenke', 14.80, 12.50, 2015, 'Trollinger', 15),
       (8489, 'Getraenke', 14.80, 12.50, 2015, 'Trollinger', 15),
;

INSERT INTO pizza
VALUES (375, 'Speisen', 14.80, 'small'),
       (815, 'Speisen', 14.80, 'small'),
       (278, 'Speisen', 14.80, 'small'),
       (253, 'Speisen', 14.80, 'small'),
       (107, 'Speisen', 14.80, 'small'),
       (814, 'Speisen', 14.80, 'small'),
       (204, 'Speisen', 14.80, 'small'),
       (569, 'Speisen', 14.80, 'small'),
       (433, 'Speisen', 14.80, 'small'),
       (319, 'Speisen', 14.80, 'small'),
       (567, 'Speisen', 14.80, 'small')
;

INSERT INTO zutat
VALUES (1, 'Salami', 'Wiltmann', false, 38),
       (2, 'Ei', 'Geflügelhof Herrmann', true, 15),
       (3, 'Schinken', 'Rügenwalder Mühle', false, 35),
       (4, 'Artischocken', 'Horeca', true, 17),
       (5, 'Ananas', 'ja!', true, 14),
       (6, 'Champignons', 'Bonduelle', true, 23),
       (7, 'Mais', 'Bonduelle', true, 33),
       (8, 'Mozzarella', 'Galbani', true, 10),
       (9, 'Paprika', 'Veronic', true, 18),
       (10, 'Thunfisch', 'Saupiquet', false, 6),
       (11, 'Oliven', 'Dittmann', true, 29),
       (12, 'Zwiebeln', 'Bauernhof Maaßen', true, 42),
       (13, 'Gyros', 'Eridanous', false, 20),
       (14, 'Lachs', 'Top Mare', false, 8),
       (15, 'Jalapenos', 'Kühne', true, 32)
;

INSERT INTO besteht_aus
VALUES (1, 2),
       (1, 2),
       (1, 2),
       (1, 2),
       (1, 2),
       (1, 2)
;

INSERT INTO ist_belegt_mit
VALUES (1, 2),
       (1, 2),
       (1, 2),
       (1, 2),
       (1, 2),
       (1, 2)
;

INSERT INTO telefonnummern_mitarbeiter
VALUES ('+49 176 123456', 'mobil', 1),
       ('+49 152 28817386', 'mobil', 1),
       ('+49 152 54599371', 'mobil', 1),
       ('+49 172 9968532', 'mobil', 1),
       ('+49 172 9980752', 'mobil', 1),
       ('07066 91750', 'festnetz', 1),
       ('07131 81680', 'festnetz', 1),
       ('07131 62967', 'festnetz', 1),
       ('07066 06685', 'festnetz', 1),
       ('07132 62781', 'festnetz', 1),
       ('07141 78 99 57', 'fax', 1)
;

INSERT INTO telefonnummern_kunden
VALUES ('+49 174 9464308', 'mobil', 1),
       ('+49 174 9091317', 'mobil', 1),
       ('+49 172 9973185', 'mobil', 1),
       ('+49 171 3920054', 'mobil', 1),
       ('+49 171 3920084', 'mobil', 1),
       ('+49 176 040694', 'mobil', 1),
       ('09852 24854', 'festnetz', 1),
       ('07132 19206', 'festnetz', 1),
       ('07066 79669', 'festnetz', 1),
       ('09852 49094', 'festnetz', 1),
       ('07132 57565', 'festnetz', 1),
       ('07066 23857', 'festnetz', 1),
       ('06261 80 69 82', 'fax', 1),
       ('07261 65 65 66', 'fax', 1)
;

----------------------------------------------------------------------------------

/*
 * Create deletion rules
 */