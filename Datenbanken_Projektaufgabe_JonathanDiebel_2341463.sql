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
 * Delte tables if they already exist
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
   	Steuer-ID integer,
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

	PRIMARY KEY (Steuer-ID),
	CHECK (Gehalt >= 450  and Gehalt =< 3500) 
);	

-- Create the table "lieferant"
CREATE TABLE IF NOT EXISTS lieferant
 (
   	Steuer-ID integer,
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
    Fuehrerschein-ID char(11) NOT NULL,

	PRIMARY KEY (Steuer-ID),
	CHECK (Gehalt >= 450  and Gehalt =< 3500)
);

-- Create the table "koch"
CREATE TABLE IF NOT EXISTS koch
 (
   	Steuer-ID integer,
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

	PRIMARY KEY (Steuer-ID),
	CHECK (Gehalt >= 450  and Gehalt =< 4000),
    CHECK (Kuechenposten IN ('PZA', 'VIN', 'ABW', 'AZU'))
);

-- Create the table "lieferzone"
CREATE TABLE IF NOT EXISTS lieferzone
 (
    Zonen-Nummer int,
    Bezeichnung char(13),

	PRIMARY KEY (Zonen-Nummer),
    CHECK (Bezeichnung IN ('Biberach', 'Boeckingen', 'Frankenbach', 'Horkheim', 'Kirchhausen', 'Klingenberg', 'Neckargartach', 'Sontheim'))
);

-- Create the table "kunde"
CREATE TABLE IF NOT EXISTS kunde
 (
    Kunden-Nummer int,
    Vorname varchar,
    Nachname varchar NOT NULL,
    Strasse varchar NOT NULL,
    Hausnummer int NOT NULL,
    Postleitzahl int NOT NULL,
    Ort varchar NOT NULL,
    Email varchar,

	PRIMARY KEY (Kunden-Nummer)
);

-- Create the table "bestellung"
CREATE TABLE IF NOT EXISTS bestellung
 (
    Bestell-Nummer int,
    Zeitstempel datetime,
    Artikelanzahl int NOT NULL,
    Preis decimal NOT NULL,
    
	PRIMARY KEY (Bestell-Nummer)
);

-- Create the table "artikel"
CREATE TABLE IF NOT EXISTS artikel
 (
    Artikel-Nummer int,
    Kategorie char(9),
    Stueckpreis decimal,
    
	PRIMARY KEY (Artikel-Nummer),
    CHECK (Kategorie IN ('Speisen', 'Getraenke'))
);

-- Create the table "wein"
CREATE TABLE IF NOT EXISTS wein
 (
    Artikel-Nummer int,
    Kategorie char(9),
    Stueckpreis decimal,
    Jahrgang int,
    Rebsorte varchar,
    Vorrat int,
    
	PRIMARY KEY (Artikel-Nummer),
    CHECK (Kategorie IN ('Speisen', 'Getraenke')),
    CHECK (Jahrgang >= 1990 and Jahrgang =< date_part('year', CURRENT_DATE))
);

-- Create the table "pizza"
CREATE TABLE IF NOT EXISTS pizza
 (
    Artikel-Nummer int,
    Kategorie char(9),
    Stueckpreis decimal,
    Groesse char(6),
    
	PRIMARY KEY (Artikel-Nummer),
    CHECK (Kategorie IN ('Speisen', 'Getraenke')),
    CHECK (Groesse IN ('small', 'medium', 'large', 'family', 'party'))
);

-- Create the table "zutat"
CREATE TABLE IF NOT EXISTS zutat
 (
    Zutaten-Nummer int,
    Bezeichnung varchar,
    Hersteller varchar,
    vegetarisch? boolean NOT NULL,
    Vorrat int,
    
	PRIMARY KEY (Zutaten-Nummer)
);

-- Create the table "besteht_aus"
CREATE TABLE IF NOT EXISTS besteht_aus
 (
    Bestell-Nummer int,
    Artikel-Nummer int,
    
	PRIMARY KEY (Bestell-Nummer, Artikel-Nummer)
);

-- Create the table "ist_belegt_mit"
CREATE TABLE IF NOT EXISTS ist_belegt_mit
 (
    Artikel-Nummer int,
    Zutaten-Nummer int,
    
	PRIMARY KEY (Artikel-Nummer, Zutaten-Nummer)
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

;

 -- ist_belegt_mit
ALTER TABLE ist_belegt_mit

;




-- BEISPIEL: Arbeitet_an

ALTER TABLE  Arbeitet_an
ADD Constraint arbeitet_an_Leistung_nr_fkey FOREIGN KEY(Auftrag_Nr, Leistung_Nr) REFERENCES Leistung,
ADD FOREIGN KEY(Pers_Nr)  REFERENCES Mitarbeiter_Projekt
;