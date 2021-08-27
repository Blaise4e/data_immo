CREATE if not exists DATABASE 

SELECT COUNT Logement.IdLogement
FROM Logement 
JOIN Mutation ON Mutation.IdLogement = Logement.IdLogement
WHERE DateMutation BETWEEN 01/01/2020 AND 30/06/2020