USE data_immo;

-- Nombre total d’appartements vendus au 1er semestre 2020 (1759)
SELECT COUNT(Logement.IdLogement)
FROM Logement
JOIN MutationAssoc ON mutationassoc.IdLogement = Logement.IdLogement
JOIN Mutation ON Mutation.IdMutation = MutationAssoc.IdMutation
WHERE DateMutation BETWEEN "2020-01-01" AND "2020-06-30"
AND mutation.typemutation LIKE 'Vente%'

-- Proportion des ventes d’appartements par le nombre de pièces
USE data_immo;

SELECT logement.NbPieces, COUNT(Logement.IdLogement) AS NbLogement
FROM Logement
JOIN MutationAssoc ON MutationAssoc.IdLogement = Logement.IdLogement
JOIN Mutation ON Mutation.IdMutation = MutationAssoc.IdMutation
WHERE mutation.typemutation LIKE 'Vente%'
GROUP BY Logement.nbpieces

-- Liste des 10 départements où le prix du mètre carré est le plus élevé
USE data_immo;

SELECT LEFT(Commune.CodePostal, 2) AS CodeDep, round(AVG(Mutation.ValeurFonciere / logement.SurfaceBatie), 2) AS PrixM2
FROM Commune
JOIN AdresseLogement ON AdresseLogement.CodeCommune = Commune.CodeCommune
JOIN AdresseAssoc ON AdresseAssoc.IdAdresse = AdresseLogement.IdAdresse 
JOIN Logement ON Logement.IdLogement = AdresseAssoc.IdLogement 
JOIN MutationAssoc ON MutationAssoc.IdLogement = Logement.IdLogement
JOIN Mutation ON Mutation.IdMutation = MutationAssoc.IdMutation 
GROUP BY CodeDep
ORDER BY PrixM2 DESC
LIMIT 10

-- Prix moyen du mètre carré d’une maison en Île-de-France

USE data_immo;

SELECT round(AVG(Mutation.ValeurFonciere / logement.SurfaceBatie),2) AS PrixM2
FROM Mutation
JOIN MutationAssoc ON MutationAssoc.IdMutation = Mutation.IdMutation
JOIN Logement ON Logement.IdLogement = MutationAssoc.IdLogement
JOIN AdresseAssoc ON AdresseAssoc.IdLogement = Logement.IdLogement
JOIN AdresseLogement ON AdresseLogement.IdAdresse = AdresseAssoc.IdAdresse
JOIN Commune ON Commune.CodeCommune = AdresseLogement.CodeCommune
WHERE TypeLocal LIKE 'Maison' AND LEFT(Commune.CodePostal, 2) 
LIKE "75" OR "77" OR "78" OR "91" OR "92" OR "93" OR "94" OR "95" 

-- Liste des 10 appartements les plus chers avec le département et le nombre de mètres carrés

USE data_immo;

SELECT DISTINCT Logement.IdLogement, Mutation.ValeurFonciere AS Prix, LEFT(Commune.CodePostal, 2) AS Department, logement.SurfaceBatie AS M2
FROM Commune
JOIN AdresseLogement ON AdresseLogement.CodeCommune = Commune.CodeCommune
JOIN AdresseAssoc ON AdresseAssoc.IdAdresse = AdresseLogement.IdAdresse 
JOIN Logement ON Logement.IdLogement = AdresseAssoc.IdLogement 
JOIN MutationAssoc ON MutationAssoc.IdLogement = Logement.IdLogement
JOIN Mutation ON Mutation.IdMutation = MutationAssoc.IdMutation
WHERE TypeLocal = 'Appartement'
ORDER BY Mutation.ValeurFonciere DESC
LIMIT 10

