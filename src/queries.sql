USE data_immo;

-- Nombre total d’appartements vendus au 1er semestre 2020 (1759)
SELECT COUNT(Logement.IdLogement)
FROM Logement
JOIN Mutation ON Mutation.IdLogement = logement.IdLogement
WHERE DateMutation BETWEEN "2020-01-01" AND "2020-06-30"
AND mutation.typemutation LIKE 'Vente%';

-- Proportion des ventes d’appartements par le nombre de pièces
SELECT logement.NbPieces, COUNT(Logement.IdLogement) AS NbLogement
FROM Logement
JOIN Mutation ON Mutation.IdLogement = Logement.IdLogement
WHERE mutation.typemutation LIKE 'Vente%'
GROUP BY Logement.nbpieces;

-- Liste des 10 départements où le prix du mètre carré est le plus élevé
SELECT LEFT(Commune.CodePostal, 2) AS CodeDep, ROUND(AVG(Mutation.ValeurFonciere / Logement.SurfaceBatie), 2) AS PrixM2
FROM Commune
JOIN AdresseLogement ON AdresseLogement.CodeCommune = Commune.CodeCommune
JOIN Logement ON Logement.IdAdresse = AdresseLogement.IdAdresse
JOIN Mutation ON Mutation.IdLogement = Logement.IdLogement
GROUP BY CodeDep
ORDER BY PrixM2 DESC
LIMIT 10;

