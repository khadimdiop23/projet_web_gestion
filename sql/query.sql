
SELECT 
    h.timestamp AS "Date et heure",
    TIME(h.timestamp) AS "Heure",
    l.nom AS "Ligne",
    l.type AS "Type",
    s.nom AS "Station"
FROM horaire h
JOIN ligne l ON h.ligne_id = l.id
JOIN station s ON h.station_id = s.id
WHERE s.nom = 'Gare Centre'
  AND h.timestamp > CURRENT_TIMESTAMP
ORDER BY h.timestamp ASC
LIMIT 5;


SELECT 
    s.id,
    s.nom,
    s.commune,
    COUNT(h.id) AS "Nombre de passages"
FROM station s
JOIN horaire h ON s.id = h.station_id
JOIN ligne l ON h.ligne_id = l.id
WHERE l.nom = 'T1'
GROUP BY s.id
ORDER BY s.nom;


SELECT 
    TIME(h.timestamp) AS "Heure",
    l.nom AS "Ligne",
    s.nom AS "Station",
    h.timestamp AS "Timestamp complet"
FROM horaire h
JOIN ligne l ON h.ligne_id = l.id
JOIN station s ON h.station_id = s.id
WHERE TIME(h.timestamp) BETWEEN '07:00:00' AND '09:00:00'
  AND DATE(h.timestamp) = DATE('now')
ORDER BY h.timestamp;
SELECT 
    s.nom AS "Station",
    s.commune AS "Commune",
    COUNT(h.id) AS "Nombre de passages"
FROM station s
JOIN horaire h ON s.id = h.station_id
GROUP BY s.id
ORDER BY COUNT(h.id) DESC
LIMIT 1;

SELECT 
    l.nom AS "Ligne",
    l.type AS "Type",
    COUNT(h.id) AS "Nombre de passages",
    COUNT(DISTINCT h.station_id) AS "Nombre de stations desservies"
FROM ligne l
LEFT JOIN horaire h ON l.id = h.ligne_id
GROUP BY l.id
ORDER BY COUNT(h.id) DESC;


SELECT 
    l.nom AS "Ligne",
    s.nom AS "Station",
    GROUP_CONCAT(TIME(h.timestamp), ', ') AS "Horaires"
FROM horaire h
JOIN ligne l ON h.ligne_id = l.id
JOIN station s ON h.station_id = s.id
WHERE DATE(h.timestamp) = DATE('now')
GROUP BY l.id, s.id
ORDER BY l.nom, s.nom;


SELECT 
    s.nom AS "Station",
    MIN(TIME(h.timestamp)) AS "Premier passage",
    MAX(TIME(h.timestamp)) AS "Dernier passage"
FROM station s
JOIN horaire h ON s.id = h.station_id
WHERE DATE(h.timestamp) = DATE('now')
GROUP BY s.id
ORDER BY s.nom;