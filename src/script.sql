CREATE IF NOT EXISTS DATABASE data_immo

CREATE TABLE Plan(
    NumPlan int PRIMARY KEY,
)

CREATE TABLE Section(
    Section varchar(255) NOT NULL,
    PrefixeSection float,
    NumPlan int,
    FOREIGN KEY (NumPlan) REFERENCES Plan(NumPlan)
)

CREATE TABLE NatureCulture(
    CodeNature varchar(255) PRIMARY KEY,
    Libelle varchar(255),
)

CREATE TABLE Volume(
    NumVolume int PRIMARY KEY,
    NbLots int,
    Section varchar(255),
    CodeNature varchar(255),
    FOREIGN KEY (Section) REFERENCES Section(Section)
    FOREIGN KEY (CodeNature) REFERENCES NatureCulture(CodeNature)
)

CREATE TABLE Lot(
    IdLot int PRIMARY KEY AUTOINCREMENT,
    SurfaceLot int,
    NumVolume int,
    FOREIGN KEY (NumVolume) REFERENCES Volume(NumVolume)
)

CREATE TABLE Commune(
    CodeCommune int PRIMARY KEY,
    Nom varchar(255),
    CodePostal int(5)
)

CREATE TABLE Voie(
    CodeVoie int PRIMARY KEY,
    Voie varchar(255),
    TypeVoie varchar(255)
)

CREATE TABLE AdresseLogement(
    IdAdresse int PRIMARY KEY AUTOINCREMENT,
    NumVoie int,
    BTQ char,
    CodeVoie int,
    CodeCommune int,
    FOREIGN KEY(CodeVoie) REFERENCES Voie(CodeVoie),
    FOREIGN KEY (CodeCommune) REFERENCES Commune(CodeCommune)
)

CREATE TABLE IF NOT EXISTS Logement(
    IdLogement int PRIMARY KEY AUTOINCREMENT,
    ValeurFonciere int,
    TypeLocal varchar(255),
    SurfaceBatie int,
    SurfaceTerrain int,
    NbPieces int
)

CREATE TABLE AdresseAssoc(
    IdLogement int,
    IdAdresse int,
    FOREIGN KEY (IdLogement) REFERENCES Logement(IdLogement),
    FOREIGN KEY (IdAdresse) REFERENCES Adresse(IdAdresse)
)

CREATE TABLE Mutation(
    IdMutation int PRIMARY KEY AUTOINCREMENT,
    DateMutation date,
)

CREATE TABLE MutationAssoc(
    IdMutation int,
    IdLogement int,
    FOREIGN KEY (IdLogement) REFERENCES Logement(IdLogement),
    FOREIGN KEY (IdMutation) REFERENCES Mutation(IdMutation)
)

LOAD DATA INFILE '../data/voie.csv' INTO TABLE Voie;
LOAD DATA INFILE '../data/commune.csv' INTO TABLE Commune;
LOAD DATA INFILE '../data/adresse_logement.csv' INTO TABLE AdresseLogement;
LOAD DATA INFILE '../data/logement.csv' INTO TABLE Logement;
LOAD DATA INFILE '../data/addresse_assoc.csv' INTO TABLE AdresseAssoc;
LOAD DATA INFILE '../data/mutation.csv' INTO TABLE Mutation;
LOAD DATA INFILE '../data/mutation_assoc.csv' INTO TABLE MutationAssoc;
