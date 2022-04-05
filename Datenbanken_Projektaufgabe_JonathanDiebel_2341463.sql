/* 
 * DHBW Stuttgart | Datenbanken 1 | Semester 4
 * ********************************************
 * Autor:            Jonathan Diebel
 * Matrikelnummer:   2341463
 * Erstelldatum:     31.03.2022
 * Letzte Änderung:  05.04.2022
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
   	SteuerID bigint,
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
   	SteuerID bigint,
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
   	SteuerID bigint,
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
    AnzahlSpeisen int NOT NULL,
    AnzahlGetraenke int NOT NULL,
    Preis decimal NOT NULL,
    
	PRIMARY KEY (BestellNummer),
    CHECK (AnzahlSpeisen + AnzahlGetraenke > 0),
    CHECK (AnzahlSpeisen BETWEEN 0 AND 10)
);

-- Create the table "artikel"
CREATE TABLE IF NOT EXISTS artikel
 (
    ArtikelNummer int,
    Kategorie char(9),
    Stueckpreis decimal NOT NULL,
    
	PRIMARY KEY (ArtikelNummer),
    CHECK (Kategorie IN ('Speisen', 'Getraenke'))
);

-- Create the table "wein"
CREATE TABLE IF NOT EXISTS wein
 (
    ArtikelNummer int,
    Kategorie char(9),
    Stueckpreis decimal NOT NULL,
    Jahrgang int,
    Rebsorte varchar,
    Vorrat int,
    
	PRIMARY KEY (ArtikelNummer),
    CHECK (Kategorie IN ('Speisen', 'Getraenke')),
    CHECK (Jahrgang BETWEEN 2005 AND date_part('year', CURRENT_DATE))
);

-- Create the table "pizza"
CREATE TABLE IF NOT EXISTS pizza
 (
    ArtikelNummer int,
    Kategorie char(9),
    Bezeichnung varchar,
    Zutatenanzahl int,
    Stueckpreis decimal NOT NULL,
    Groesse char(5) default 'large',
    
	PRIMARY KEY (ArtikelNummer),
    CHECK (Kategorie IN ('Speisen', 'Getraenke')),
    CHECK (Zutatenanzahl BETWEEN 2 AND 7),
    CHECK (Groesse IN ('small', 'large', 'family', 'party'))
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
ADD Vertretung_fuer bigint,
ADD FOREIGN KEY(Vertretung_fuer) REFERENCES mitarbeiter
;

 -- Lieferant
ALTER TABLE lieferant
ADD Vertretung_fuer bigint,
ADD FOREIGN KEY(Vertretung_fuer) REFERENCES lieferant
;

 -- Koch
ALTER TABLE koch
ADD Vertretung_fuer bigint,
ADD FOREIGN KEY(Vertretung_fuer) REFERENCES koch
;

 -- Lieferzone
ALTER TABLE lieferzone
ADD Zustaendiger_Fahrer bigint,
ADD FOREIGN KEY(Zustaendiger_Fahrer) REFERENCES lieferant
;

 -- Bestellung
ALTER TABLE bestellung
ADD zubereitet_von bigint,
ADD ausgeliefert_von bigint,
ADD erteilt_von int,
ADD FOREIGN KEY(zubereitet_von) REFERENCES koch,
ADD FOREIGN KEY(ausgeliefert_von) REFERENCES lieferant,
ADD FOREIGN KEY(erteilt_von) REFERENCES kunde
;

 -- Telefonnummern_Mitarbeiter
ALTER TABLE telefonnummern_mitarbeiter
ADD Besitzer_M bigint,
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
ADD FOREIGN KEY(ArtikelNummer) REFERENCES pizza,
ADD FOREIGN KEY(ZutatenNummer) REFERENCES zutat
;

----------------------------------------------------------------------------------

/*
 * Fill tables with data
 */

INSERT INTO lieferant
VALUES (101, 'Paul', 'Müller', 'Lerchenstraße', 42, 74172, 'Neckarsulm', 'paulmuell28@gmail.com', 450, 'DE02120300000000202051', 'BYLADEM1001', 'B072RRE2I55', 110),
       (102, 'Ute', 'Fuerst', 'Rosenstrasse', 87, 74235, 'Erlenbach', 'UteFuerst@einrot.com', 2300, 'DE02500105170137075030', 'INGDDEFF', 'B3KX7HE7908', 101,
       (103, 'Marcel', 'Friedman', 'Lerchenstraße', 42, 74189, 'Weinsberg', 'marcfried_77@hotmail.com', 1200, 'DE02100500000054540402', 'BELADEBE', 'S3Z3I1W7406', 102),
       (104, 'Lisa', 'Drechsler', 'Boxhagenerstraße', 44, 74223, 'Flein', 'LisaDrechsler@cuvox.de', 450, 'DE02300209000106531065', 'CMCIDEDD', 'P5383237889', 103),
       (105, 'Barbara', 'Frey', 'Alter Wall', 14, 74226, 'Nordheim', 'BarbaraFrey@cuvox.de', 450, 'DE02200505501015871393', 'HASPDEHH', 'Y2R191S8425', 104),
       (106, 'Lisa', 'Goldschmidt', 'Grolmanstraße', 11, 74081, 'Heilbronn', 'Lisa.G@einrot.com', 2300, 'DE02100100100006820101', 'PBNKDEFF', 'H52P483DB47', 105),
       (107, 'Kristin', 'Nacht', 'Landsberger Allee', 94, 74211, 'Leingarten', 'Kristin.Nacht@web.de', 1200, 'DE02300606010002474689', 'DAAEDEDD', 'G84D8025V15', 106),
       (108, 'Erik', 'Beike', 'Bleibtreustrasse', 56, 74074, 'Heilbronn', 'Expromen92@gmail.com', 450, 'DE02600501010002034304', 'SOLADEST600', 'X7V3239S540', 107),
       (109, 'Thorsten', 'Müller', 'Langenhorner Chaussee', 47, 74189, 'Weinsberg', 'ThorstenHoffmail@gmx.com', 2300, 'DE02700202700010108669', 'HYVEDEMM', 'D891906H612', 108),
       (110, 'Tim', 'Glockner', 'Kurfürstenstraße', 27, 74235, 'Erlenbach', 'TimGlockner@einrot.com', 1200, 'DE02700100800030876808', 'PBNKDEFF', 'C5025OP7095', 109)
;

INSERT INTO koch
VALUES (201, 'Marcel', 'Baecker', 'Paderborner Strasse', 119, 74078, 'Heilbronn', 'Marcel.Baecker@web.de', 2400, 'DE02370502990000684712', 'COKSDE33', 'PZA', 205),
       (202, 'Artemia', 'Trevisano', 'Burgstraße', 2, 74172, 'Neckarsulm', 'Artemia79@gmail.com', 1300, 'DE88100900001234567892', 'BEVODEBB', 'PZA', 201),
       (203, 'Lisandro', 'Calabresi', 'Mozartstraße', 15, 74078, 'Heilbronn', 'Calabresi_Lisandro@hotmail.com', 1900, 'DE02701500000000594937', 'SSKMDEMM', 'VIN', 207),
       (204, 'Prisca', 'Marcelo', 'Hans-Grade-Allee', 33, 74235, 'Erlenbach', 'Marcelo_P@gmail.com', 2400, 'DE43500105175367834115', 'HASPDEHH', 'PZA', 202),
       (205, 'Virgilia', 'Gallo', 'Scharnweberstrasse', 97, 74223, 'Flein', 'Shomblue@gallo.it', 1300, 'DE77500105175183492181', 'PBNKDEFF', 'PZA', 204),
       (206, 'Patrick', 'Konig', 'Marseiller Strasse', 72, 74074, 'Heilbronn', 'P.Konig@gmx.de', 850, 'DE38500105177284374464', 'HEISDE66XXX', 'AZU', NULL),
       (207, 'Luca', 'Stark', 'Hedemannstasse', 23, 74226, 'Nordheim', 'Luca.Stark@protonmail.ch', 1900, 'DE35500105175458146691', 'SOLADEST600', 'VIN', 203)
;

INSERT INTO lieferzone
VALUES (10, 'Boeckingen-Heilbronn-Neckargartach', 102),
       (20, 'Biberach-Frankenbach-Kirchhausen', 109),
       (30, 'Horkheim-Klingenberg-Sontheim', 106)
;

INSERT INTO kunde
VALUES (1, 'Juliane', 'Kortig', 'Graf-Adolf-Straße', 67, 74078, 'Heilbronn', 'Biberach', 'Iteriabittem75@protonmail.com'),
       (2, 'Christian', 'Neumann', 'Hausbrucher Kehre', 32, 74076, 'Heilbronn', 'Heilbronn', 'ChristianNeumann@gmail.com'),
       (3, 'Christine', 'Hertz', 'Eulenheckerweg', 20, 74078, 'Heilbronn', 'Frankenbach', 'Christa.Herz@aol.de'),
       (4, 'Bernhard', 'Leis', 'Beethovenstraße', 15, 74074, 'Heilbronn', 'Sontheim', 'B.Leis@KabelBW.de'),
       (5, 'Dominik', 'Kohler', 'Genslerstraße', 35, 74072, 'Heilbronn', 'Heilbronn', 'Priet1983@gmx.de'),
       (6, 'Klaudia', 'Schultz', 'Prüfeninger Straße', 4, 74078, 'Heilbronn', 'Neckargartach', 'claudia44@web.de'),
       (7, 'Ilas', 'Senuysal', 'Marktstraße', 14, 74081, 'Heilbronn', 'Klingenberg', 'sen-shinigami@hotmail.com'),
       (8, 'Uwe', 'Peters', 'Steinleweg', 86, 74078, 'Heilbronn', 'Biberach', 'uwe@peters.de'),
       (9, 'Dirk', 'Holtzmann', 'Meinekestraße', 84, 74078, 'Heilbronn', 'Kirchhausen', 'dirk-ho-72@rethink.com'),
       (10, 'Frank', 'Fleischer', 'Bleibtreustrasse', 71, 74081, 'Heilbronn', 'Horkheim', 'Frank@metzgerei-fleischer.de'),
       (11, 'Nicole', 'Krüger', 'Schwingereiweg', 57, 74080, 'Heilbronn', 'Böckingen', 'ni.krueger@aol.de')
;

INSERT INTO bestellung
VALUES (79274, '2022-04-08 17:24:39', 2, 0, 14.10, 204, 102, 2),
       (45156, '2022-04-08 18:05:34', 10, 3, 111.94, 201, 102, 6),
       (85383, '2022-04-08 18:31:25', 1, 2, 34.89, 206, 109, 9),
       (48852, '2022-04-08 18:48:35', 3, 1, 50.00, 204, 106, 10),
       (90749, '2022-04-08 19:12:52', 0, 5, 52.08, 207, 109, 8),
       (73397, '2022-04-08 19:19:57', 4, 2, 47.88, 201, 106, 4)
;

INSERT INTO wein
VALUES (3967, 'Getraenke', 7.39, 2019, 'Chardonnay', 42),
       (3598, 'Getraenke', 21.90, 2017, 'Corvina', 82),
       (1634, 'Getraenke', 8.59, 2019, 'Nerello Mascalese', 77),
       (5592, 'Getraenke', 6.99, 2021, 'Fiano', 124),
       (7091, 'Getraenke', 19.95, 2020, 'Montepulciano', 92),
       (1431, 'Getraenke', 7.40, 2021, 'Sangiovese', 63),
       (3826, 'Getraenke', 8.80, 2015, 'Nerello Mascalese', 24),
       (6684, 'Getraenke', 9.99, 2013, 'Gaglioppo', 12),
       (7859, 'Getraenke', 14.25, 2017, 'Canaiolo', 40),
       (8489, 'Getraenke', 18.80, 2012, 'Sauvignon Blanc', 8)
;

INSERT INTO pizza
VALUES (372, 'Speisen', 'Margherita', 2, 6.80, 'large'),
       (192, 'Speisen', 'Salami', 3, 7.50, 'large'),
       (272, 'Speisen', 'Schinken', 3, 7.50, 'large'),
       (252, 'Speisen', 'Marche', 4, 8.60, 'large'),
       (812, 'Speisen', 'Fantasia', 4, 7.80, 'large'),
       (202, 'Speisen', 'Hawaii', 4, 7.90, 'large'),
       (442, 'Speisen', 'Capricciosa', 5, 8.10, 'large'),
       (432, 'Speisen', 'Quattro Stagioni', 7, 9.20, 'large'),
       (312, 'Speisen', 'Bella Capri', 8, 10.00, 'large'),
       (562, 'Speisen', 'Greca', 5, 8.10, 'large'),
       (371, 'Speisen', 'Margherita', 2, 5.30, 'small'),
       (191, 'Speisen', 'Salami', 3, 6.00, 'small'),
       (271, 'Speisen', 'Schinken', 3, 6.00, 'small'),
       (373, 'Speisen', 'Margherita', 2, 15.50, 'family'),
       (193, 'Speisen', 'Salami', 3, 16.50, 'family'),
       (273, 'Speisen', 'Schinken', 3, 16.50, 'family'),
       (374, 'Speisen', 'Margherita', 2, 19.00, 'party'),
       (194, 'Speisen', 'Salami', 3, 20.50, 'party'),
       (274, 'Speisen', 'Schinken', 3, 20.50, 'party')
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
       (15, 'Jalapenos', 'Kühne', true, 32),
       (16, 'Tomatensoße', 'Pomito', true, 72),
       (17, 'Geriebener Käse', 'Finello', true, 51)
;

INSERT INTO besteht_aus
VALUES (79274, 442),
       (79274, 191),

       (45156, 202),
       (45156, 432),
       (45156, 442),
       (45156, 371),
       (45156, 252),
       (45156, 312),
       (45156, 191),
       (45156, 202),
       (45156, 432),
       (45156, 562),
       (45156, 1634),
       (45156, 3826),
       (45156, 7859),
       (85383, 194),
       (85383, 5592),
       (85383, 1431),
       (48852, 812),
       (48852, 373),
       (48852, 202),
       (48852, 8489),
       (90749, 3598),
       (90749, 5592),
       (90749, 5592),
       (90749, 3826),
       (90749, 1431),
       (73397, 812),
       (73397, 812),
       (73397, 442),
       (73397, 372),
       (73397, 6684),
       (73397, 3967)    
;

INSERT INTO ist_belegt_mit
VALUES (372, 16),
       (372, 8),
       (192, 16),
       (192, 17),
       (192, 1),
       (272, 16),
       (272, 17),
       (272, 3),
       (252, 16),
       (252, 17),
       (252, 10),
       (252, 12),
       (812, 16),
       (812, 17),
       (812, 6),
       (812, 3),
       (202, 16),
       (202, 17),
       (202, 5),
       (202, 3),
       (442, 16),
       (442, 17),
       (442, 9),
       (442, 3),
       (442, 1),
       (432, 16),
       (432, 17),
       (432, 4),
       (432, 6),
       (432, 9),
       (432, 3),
       (432, 1),
       (312, 16),
       (312, 17),
       (312, 4),
       (312, 6),
       (312, 3),
       (312, 1),
       (312, 11),
       (312, 2),
       (562, 16),
       (562, 17),
       (562, 13),
       (562, 15),
       (562, 7),
       (371, 16),
       (371, 8),
       (191, 16),
       (191, 17),
       (191, 1),
       (271, 16),
       (271, 17),
       (271, 3),
       (373, 16),
       (373, 8),
       (193, 16),
       (193, 17),
       (193, 1),
       (273, 16),
       (273, 17),
       (273, 3),
       (374, 16),
       (374, 8),
       (194, 16),
       (194, 17),
       (194, 1),
       (274, 16),
       (274, 17),
       (274, 3),
       
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
       ('+49 174 9091317', 'mobil', 2),
       ('+49 172 9973185', 'mobil', 4),
       ('+49 171 3920054', 'mobil', 5),
       ('+49 171 3920084', 'mobil', 8),
       ('+49 176 040694', 'mobil', 9),
       ('09852 24854', 'festnetz', 3),
       ('07132 19206', 'festnetz', 4),
       ('07066 79669', 'festnetz', 6),
       ('09852 49094', 'festnetz', 7),
       ('07132 57565', 'festnetz', 10),
       ('07066 23857', 'festnetz', 11),
       ('06261 80 69 82', 'fax', 6),
       ('07261 65 65 66', 'fax', 8)
;

----------------------------------------------------------------------------------

/*
 * Create deletion rules
 */