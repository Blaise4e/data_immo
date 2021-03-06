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

-- Prix moyen du mètre carré d’une maison en Île-de-France
SELECT round(AVG(Mutation.ValeurFonciere / logement.SurfaceBatie),2) AS PrixM2
FROM Mutation
JOIN Logement ON Logement.IdLogement = Mutation.IdLogement
JOIN AdresseLogement ON AdresseLogement.IdAdresse = Logement.IdAdresse
JOIN Commune ON Commune.CodeCommune = AdresseLogement.CodeCommune
WHERE TypeLocal LIKE 'Maison' AND LEFT(Commune.CodePostal, 2) 
LIKE "75" OR "77" OR "78" OR "91" OR "92" OR "93" OR "94" OR "95"

-- Liste des 10 appartements les plus chers avec le département et le nombre de mètres carrés
SELECT Logement.IdLogement, Mutation.ValeurFonciere as Prix, LEFT(CodePostal, 2) AS Dep, SurfaceBatie 
FROM Mutation
JOIN Logement ON Logement.IdLogement = Mutation.IdLogement
JOIN AdresseLogement ON AdresseLogement.IdAdresse = Logement.IdAdresse
JOIN Commune ON Commune.CodeCommune = AdresseLogement.CodeCommune
ORDER BY Prix DESC
LIMIT 10;

-- Taux d’évolution du nombre de ventes entre le premier et le second trimestre de 2020
SELECT DISTINCT((
    SELECT COUNT(IdMutation) FROM Mutation
    WHERE DateMutation BETWEEN '2020-04-01' AND '2020-06-30'
    
) - (
    SELECT COUNT(IdMutation) FROM Mutation
    WHERE DateMutation BETWEEN '2020-01-01' AND '2020-03-31'
)) / (
    SELECT COUNT(IdMutation) FROM Mutation
    WHERE DateMutation BETWEEN '2020-01-01' AND '2020-03-31'
) * 100 AS Taux
FROM Mutation;

-- Liste des communes où le nombre de ventes a augmenté d'au moins 20% entre le premier et
-- le second trimestre de 2020
SELECT * FROM (
    SELECT Commune.CodeCommune as ville, COUNT(IdMutation) AS Nb FROM Commune
    JOIN AdresseLogement ON AdresseLogement.CodeCommune = Commune.CodeCommune
    JOIN Logement ON Logement.IdAdresse = AdresseLogement.IdAdresse
    JOIN Mutation ON Mutation.IdLogement = Logement.IdLogement
    WHERE DateMutation BETWEEN '2020-04-01' AND '2020-06-30'
    GROUP BY ville) AS trimestre1
JOIN (
    SELECT Commune.CodeCommune as ville, COUNT(IdMutation) AS Nb FROM Commune
    JOIN AdresseLogement ON AdresseLogement.CodeCommune = Commune.CodeCommune
    JOIN Logement ON Logement.IdAdresse = AdresseLogement.IdAdresse
    JOIN Mutation ON Mutation.IdLogement = Logement.IdLogement
    WHERE DateMutation BETWEEN '2020-01-01' AND '2020-03-31'
    GROUP BY ville) AS trimestre2
ON trimestre1.ville = trimestre2.ville
WHERE trimestre2.Nb / trimestre2.Nb > 1.2;

-- Différence en pourcentage du prix au mètre carré entre un appartement de 2 pièces et un
-- appartement de 3 pièces

SELECT DISTINCT((
    SELECT ROUND(AVG(Mutation.ValeurFonciere / logement.SurfaceBatie),2) FROM Mutation
    JOIN Logement ON Logement.IdLogement = Mutation.IdLogement
    WHERE Logement.TypeLocal = 'Appartement'
    AND Logement.NbPieces = 3
) - (
    SELECT ROUND(AVG(Mutation.ValeurFonciere / logement.SurfaceBatie),2) FROM Mutation
    JOIN Logement ON Logement.IdLogement = Mutation.IdLogement
    WHERE Logement.TypeLocal = 'Appartement'
    AND Logement.NbPieces = 2
)) / (
    SELECT ROUND(AVG(Mutation.ValeurFonciere / logement.SurfaceBatie),2) FROM Mutation
    JOIN Logement ON Logement.IdLogement = Mutation.IdLogement
    WHERE Logement.TypeLocal = 'Appartement'
    AND Logement.NbPieces = 3
) * 100 AS Difference
FROM Mutation;

-- Les moyennes de valeurs foncières pour le top 3 des communes des départements 6, 13, 33,
-- 59 et 69
SELECT Commune.Nom, AVG(Mutation.ValeurFonciere) AS PriceMean,
LEFT(Commune.CodePostal, 2) AS CodeDep
FROM Commune
JOIN AdresseLogement ON AdresseLogement.CodeCommune = Commune.CodeCommune
JOIN Logement ON Logement.IdAdresse = AdresseLogement.IdAdresse
JOIN Mutation ON Mutation.IdLogement = Logement.IdLogement
WHERE LEFT(Commune.CodePostal, 2) = '06'
GROUP BY Commune.Nom
ORDER BY PriceMean DESC LIMIT 3;

SELECT Commune.Nom, AVG(Mutation.ValeurFonciere) AS PriceMean,
LEFT(Commune.CodePostal, 2) AS CodeDep
FROM Commune
JOIN AdresseLogement ON AdresseLogement.CodeCommune = Commune.CodeCommune
JOIN Logement ON Logement.IdAdresse = AdresseLogement.IdAdresse
JOIN Mutation ON Mutation.IdLogement = Logement.IdLogement
WHERE LEFT(Commune.CodePostal, 2) = '13'
GROUP BY Commune.Nom
ORDER BY PriceMean DESC LIMIT 3;

SELECT Commune.Nom, AVG(Mutation.ValeurFonciere) AS PriceMean,
LEFT(Commune.CodePostal, 2) AS CodeDep
FROM Commune
JOIN AdresseLogement ON AdresseLogement.CodeCommune = Commune.CodeCommune
JOIN Logement ON Logement.IdAdresse = AdresseLogement.IdAdresse
JOIN Mutation ON Mutation.IdLogement = Logement.IdLogement
WHERE LEFT(Commune.CodePostal, 2) = '33'
GROUP BY Commune.Nom
ORDER BY PriceMean DESC LIMIT 3;

SELECT Commune.Nom, AVG(Mutation.ValeurFonciere) AS PriceMean,
LEFT(Commune.CodePostal, 2) AS CodeDep
FROM Commune
JOIN AdresseLogement ON AdresseLogement.CodeCommune = Commune.CodeCommune
JOIN Logement ON Logement.IdAdresse = AdresseLogement.IdAdresse
JOIN Mutation ON Mutation.IdLogement = Logement.IdLogement
WHERE LEFT(Commune.CodePostal, 2) = '59'
GROUP BY Commune.Nom
ORDER BY PriceMean DESC LIMIT 3;

SELECT Commune.Nom, AVG(Mutation.ValeurFonciere) AS PriceMean,
LEFT(Commune.CodePostal, 2) AS CodeDep
FROM Commune
JOIN AdresseLogement ON AdresseLogement.CodeCommune = Commune.CodeCommune
JOIN Logement ON Logement.IdAdresse = AdresseLogement.IdAdresse
JOIN Mutation ON Mutation.IdLogement = Logement.IdLogement
WHERE LEFT(Commune.CodePostal, 2) = '69'
GROUP BY Commune.Nom
ORDER BY PriceMean DESC LIMIT 3;