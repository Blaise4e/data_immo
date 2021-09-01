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
    CodeCommune varchar(255) PRIMARY KEY,
    Nom varchar(255),
    CodePostal varchar(5)
);

CREATE TABLE IF NOT EXISTS Voie(
    IdVoie varchar(255) PRIMARY KEY,
    Voie varchar(255),
    TypeVoie varchar(255)
);

CREATE TABLE IF NOT EXISTS AdresseLogement(
    IdAdresse varchar(255) PRIMARY KEY,
    NumVoie int,
    BTQ char,
    CodeVoie int,
    CodeCommune int,
    FOREIGN KEY(CodeVoie) REFERENCES Voie(CodeVoie),
    FOREIGN KEY (CodeCommune) REFERENCES Commune(CodeCommune)
);

CREATE TABLE IF NOT EXISTS Logement(
    IdLogement varchar(255) PRIMARY KEY,
    TypeLocal varchar(255),
    SurfaceBatie int,
    SurfaceTerrain int,
    NbPieces int
);

CREATE TABLE IF NOT EXISTS AdresseAssoc(
    IdLogement varchar(255),
    IdAdresse varchar(255),
    FOREIGN KEY (IdLogement) REFERENCES Logement(IdLogement),
    FOREIGN KEY (IdAdresse) REFERENCES Adresse(IdAdresse)
);

CREATE TABLE IF NOT EXISTS Mutation(
    IdMutation varchar(255) PRIMARY KEY,
    DateMutation date,
    ValeurFonciere int,
    TypeMutation varchar(255)
);

CREATE TABLE IF NOT EXISTS MutationAssoc(
    IdMutation varchar(255),
    IdLogement varchar(255),
    FOREIGN KEY (IdLogement) REFERENCES Logement(IdLogement),
    FOREIGN KEY (IdMutation) REFERENCES Mutation(IdMutation)
);
DELETE FROM Voie;
DELETE FROM Commune;
DELETE FROM AdresseLogement;
DELETE FROM Logement;
DELETE FROM AdresseAssoc;
DELETE FROM Mutation;
DELETE FROM MutationAssoc;

LOAD DATA INFILE 'C:/Users/simplon/Ecole_IA/data_immo/data/CURATED/voie.csv' IGNORE INTO TABLE Voie
COLUMNS TERMINATED BY ',' IGNORE 1 LINES;
LOAD DATA INFILE 'C:/Users/simplon/Ecole_IA/data_immo/data/CURATED/commune.csv' IGNORE INTO TABLE Commune
COLUMNS TERMINATED BY ',' IGNORE 1 LINES;
LOAD DATA INFILE 'C:/Users/simplon/Ecole_IA/data_immo/data/CURATED/adresse_logement.csv' IGNORE INTO TABLE AdresseLogement
COLUMNS TERMINATED BY ',' IGNORE 1 LINES;
LOAD DATA INFILE 'C:/Users/simplon/Ecole_IA/data_immo/data/CURATED/logement.csv' IGNORE INTO TABLE Logement
COLUMNS TERMINATED BY ',' IGNORE 1 LINES;
LOAD DATA INFILE 'C:/Users/simplon/Ecole_IA/data_immo/data/CURATED/adresse_assoc.csv' IGNORE INTO TABLE AdresseAssoc
COLUMNS TERMINATED BY ',' IGNORE 1 LINES;
LOAD DATA INFILE 'C:/Users/simplon/Ecole_IA/data_immo/data/CURATED/mutation.csv' IGNORE INTO TABLE Mutation
COLUMNS TERMINATED BY ',' IGNORE 1 LINES;
LOAD DATA INFILE 'C:/Users/simplon/Ecole_IA/data_immo/data/CURATED/mutation_assoc.csv' IGNORE INTO TABLE MutationAssoc
COLUMNS TERMINATED BY ',' IGNORE 1 LINES;
