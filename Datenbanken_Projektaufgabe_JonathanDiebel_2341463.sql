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
    CHECK (Kuechenposten IN ('PZA', 'VIN', 'AZU'))
);

-- Create the table "lieferzone"
CREATE TABLE IF NOT EXISTS lieferzone
 (
    ZonenNummer int,
    Bezeichnung varchar NOT NULL,

	PRIMARY KEY (ZonenNummer)
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
    Stadtteil varchar NOT NULL,
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
VALUES (11, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 1200, 'DE02120300000000202051', 'BYLADEM1001', 'B072RRE2I55', 3),
       (12, 'Ute', 'Fuerst', 'Rosenstrasse', 87, 74235, 'Erlenbach', 'UteFuerst@einrot.com', 1200, 'DE02500105170137075030', 'INGDDEFF', 'B3KX7HE7908', 3),
       (13, 'Marcel', 'Friedman', 'Lerchenstraße', 42, 74189, 'Weinsberg', 'marcfried_77@hotmail.com', 1200, 'DE02100500000054540402', 'BELADEBE', 'S3Z3I1W7406', 3),
       (14, 'Lisa', 'Drechsler', 'Boxhagenerstraße', 44, 74223, 'Flein', 'LisaDrechsler@cuvox.de', 1200, 'DE02300209000106531065', 'CMCIDEDD', 'P5383237889', 3),
       (15, 'Barbara', 'Frey', 'Alter Wall', 14, 74226, 'Nordheim', 'BarbaraFrey@cuvox.de', 1200, 'DE02200505501015871393', 'HASPDEHH', 'Y2R191S8425', 3),
       (16, 'Lisa', 'Goldschmidt', 'Grolmanstraße', 11, 74081, 'Heilbronn', 'Lisa.G@einrot.com', 1200, 'DE02100100100006820101', 'PBNKDEFF', 'H52P483DB47', 3),
       (17, 'Kristin', 'Nacht', 'Landsberger Allee', 94, 74211, 'Leingarten', 'Kristin.Nacht@web.de', 1200, 'DE02300606010002474689', 'DAAEDEDD', 'G84D8025V15', 3),
       (18, 'Erik', 'Beike', 'Bleibtreustrasse', 56, 74074, 'Heilbronn', 'Expromen92@gmail.com', 1200, 'DE02600501010002034304', 'SOLADEST600', 'X7V3239S540', 3),
       (19, 'Thorsten', 'Müller', 'Langenhorner Chaussee', 47, 74189, 'Weinsberg', 'ThorstenHoffmail@gmx.com', 1200, 'DE02700202700010108669', 'HYVEDEMM', 'D891906H612', 3),
       (110, 'Tim', 'Glockner', 'Kurfürstenstraße', 27, 74235, 'Erlenbach', 'TimGlockner@einrot.com', 1200, 'DE02700100800030876808', 'PBNKDEFF', 'C5025OP7095', 3)
;

INSERT INTO koch
VALUES (21, 'Marcel', 'Baecker', 'Paderborner Strasse', 119, 74078, 'Heilbronn', 'Marcel.Baecker@web.de', 1200, 'DE02370502990000684712', 'COKSDE33', 'PZA', 3),
       (22, 'Artemia', 'Trevisano', 'Burgstraße', 2, 74172, 'Neckarsulm', 'Artemia79@gmail.com', 1200, 'DE88100900001234567892', 'BEVODEBB', 'PZA', 3),
       (23, 'Lisandro', 'Calabresi', 'Mozartstraße', 15, 74078, 'Heilbronn', 'Calabresi_Lisandro@hotmail.com', 1200, 'DE02701500000000594937', 'SSKMDEMM', 'VIN', 3),
       (24, 'Prisca', 'Marcelo', 'Hans-Grade-Allee', 33, 74235, 'Erlenbach', 'Marcelo_P@gmail.com', 1200, 'DE43500105175367834115', 'HASPDEHH', 'PZA', 3),
       (25, 'Virgilia', 'Gallo', 'Scharnweberstrasse', 97, 74223, 'Flein', 'Shomblue@gallo.it', 1200, 'DE77500105175183492181', 'PBNKDEFF', 'PZA', 3),
       (26, 'Patrick', 'Konig', 'Marseiller Strasse', 72, 74074, 'Heilbronn', 'P.Konig@gmx.de', 1200, 'DE38500105177284374464', 'HEISDE66XXX', 'AZU', 3),
       (27, 'Luca', 'Stark', 'Hedemannstasse', 23, 74226, 'Nordheim', 'Luca.Stark@protonmail.ch', 1200, 'DE35500105175458146691', 'SOLADEST600', 'VIN', 3)
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
VALUES (1, 'Juliane', 'Kortig', 'Graf-Adolf-Straße', 67, 74078, 'Heilbronn', 'Biberach', 'Iteriabittem75@protonmail.com'),
       (2, 'Christian', 'Neumann', 'Hausbrucher Kehre', 32, 74080, 'Heilbronn', 'Böckingen', 'ChristianNeumann@gmail.com'),
       (3, 'Christine', 'Hertz', 'Eulenheckerweg', 20, 74078, 'Heilbronn', 'Frankenbach', 'Christa.Herz@aol.de'),
       (4, 'Bernhard', 'Leis', 'Beethovenstraße', 15, 74074, 'Heilbronn', 'Sontheim', 'B.Leis@KabelBW.de'),
       (5, 'Dominik', 'Kohler', 'Genslerstraße', 35, 74081, 'Heilbronn', 'Sontheim', 'Priet1983@gmx.de'),
       (6, 'Klaudia', 'Schultz', 'Prüfeninger Straße', 4, 74078, 'Heilbronn', 'Neckargartach', 'claudia44@web.de'),
       (7, 'Ilas', 'Senuysal', 'Marktstraße', 14, 74081, 'Heilbronn', 'Klingenberg', 'sen-shinigami@hotmail.com'),
       (8, 'Uwe', 'Peters', 'Steinleweg', 86, 74078, 'Heilbronn', 'Biberach', 'uwe@peters.de'),
       (9, 'Dirk', 'Holtzmann', 'Meinekestraße', 84, 74078, 'Heilbronn', 'Kirchhausen', 'dirk-ho-72@rethink.com'),
       (10, 'Frank', 'Fleischer', 'Bleibtreustrasse', 71, 74081, 'Heilbronn', 'Horkheim', 'Frank@metzgerei-fleischer.de'),
       (11, 'Nicole', 'Krüger', 'Schwingereiweg', 57, 74080, 'Heilbronn', 'Böckingen', 'ni.krueger@aol.de')
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