DROP DATABASE data_immo;
CREATE DATABASE IF NOT EXISTS data_immo;

USE data_immo;

CREATE TABLE IF NOT EXISTS Plan(
    NumPlan varchar(255) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS Section(
    Section varchar(255) NOT NULL,
    PrefixeSection float,
    NumPlan int,
    FOREIGN KEY (NumPlan) REFERENCES Plan(NumPlan)
);

CREATE TABLE IF NOT EXISTS NatureCulture(
    CodeNature varchar(255) PRIMARY KEY,
    Libelle varchar(255)
);

CREATE TABLE IF NOT EXISTS Volume(
    NumVolume varchar(255) PRIMARY KEY,
    NbLots int,
    Section varchar(255),
    CodeNature varchar(255),
    FOREIGN KEY (Section) REFERENCES Section(Section),
    FOREIGN KEY (CodeNature) REFERENCES NatureCulture(CodeNature)
);

CREATE TABLE IF NOT EXISTS Lot(
    IdLot varchar(255) PRIMARY KEY,
    SurfaceLot int,
    NumVolume int,
    FOREIGN KEY (NumVolume) REFERENCES Volume(NumVolume)
);

CREATE TABLE IF NOT EXISTS Commune(
    CodeCommune int PRIMARY KEY,
    Nom varchar(255),
    CodePostal varchar(5)
);

CREATE TABLE IF NOT EXISTS Voie(
    IdVoie int PRIMARY KEY,
    Voie varchar(255),
    TypeVoie varchar(255)
);

CREATE TABLE IF NOT EXISTS AdresseLogement(
    IdAdresse int PRIMARY KEY,
    NumVoie int,
    BTQ char,
    IdVoie int,
    CodeCommune int,
    FOREIGN KEY(IdVoie) REFERENCES Voie(IdVoie),
    FOREIGN KEY (CodeCommune) REFERENCES Commune(CodeCommune)
);

CREATE TABLE IF NOT EXISTS Logement(
    IdLogement int PRIMARY KEY,
    TypeLocal varchar(255),
    SurfaceBatie int,
    SurfaceTerrain int,
    NbPieces int,
    IdAdresse int,
    FOREIGN KEY (IdAdresse) REFERENCES AdresseLogement(IdAdresse)
);

CREATE TABLE IF NOT EXISTS Mutation(
    IdMutation int PRIMARY KEY,
    DateMutation date,
    ValeurFonciere int,
    TypeMutation varchar(255),
    IdLogement int,
    FOREIGN KEY (IdLogement) REFERENCES Logement(IdLogement)
);

DELETE FROM Voie;
DELETE FROM Commune;
DELETE FROM AdresseLogement;
DELETE FROM Logement;
DELETE FROM Mutation;

LOAD DATA INFILE 'C:/Users/simplon/Ecole_IA/data_immo/data/CURATED/voie.csv' IGNORE INTO TABLE Voie
COLUMNS TERMINATED BY ',' IGNORE 1 LINES;
LOAD DATA INFILE 'C:/Users/simplon/Ecole_IA/data_immo/data/CURATED/commune.csv' IGNORE INTO TABLE Commune
COLUMNS TERMINATED BY ',' IGNORE 1 LINES;
LOAD DATA INFILE 'C:/Users/simplon/Ecole_IA/data_immo/data/CURATED/adresse_logement.csv' IGNORE INTO TABLE AdresseLogement
COLUMNS TERMINATED BY ',' IGNORE 1 LINES;
LOAD DATA INFILE 'C:/Users/simplon/Ecole_IA/data_immo/data/CURATED/logement.csv' IGNORE INTO TABLE Logement
COLUMNS TERMINATED BY ',' IGNORE 1 LINES;
LOAD DATA INFILE 'C:/Users/simplon/Ecole_IA/data_immo/data/CURATED/mutation.csv' IGNORE INTO TABLE Mutation
COLUMNS TERMINATED BY ',' IGNORE 1 LINES;
