
SELECT 
    h.timestamp as 'Date et heure',
    TIME(h.timestamp) as 'Heure',
    l.nom as 'Ligne',
    l.type as 'Type',
    s.nom as 'Station'
FROM horaire h
JOIN ligne l ON h.ligne_id = l.id
JOIN station s ON h.station_id = s.id
WHERE s.nom = 'Gare Centre'
    AND h.timestamp > CURRENT_TIMESTAMP
ORDER BY h.timestamp ASC
LIMIT 5;

SELECT DISTINCT
    s.id,
    s.nom,
    s.commune,
    COUNT(h.id) as 'Nombre de passages'
FROM station s
JOIN horaire h ON s.id = h.station_id
JOIN ligne l ON h.ligne_id = l.id
WHERE l.nom = 'T1'
GROUP BY s.id
ORDER BY s.nom;


SELECT 
    TIME(h.timestamp) as 'Heure',
    l.nom as 'Ligne',
    s.nom as 'Station',
    h.timestamp as 'Timestamp complet'
FROM horaire h
JOIN ligne l ON h.ligne_id = l.id
JOIN station s ON h.station_id = s.id
WHERE TIME(h.timestamp) BETWEEN '07:00:00' AND '09:00:00'
    AND DATE(h.timestamp) = DATE('now')
ORDER BY h.timestamp;


SELECT 
    s.nom as 'Station',
    s.commune as 'Commune',
    COUNT(h.id) as 'Nombre de passages'
FROM station s
JOIN horaire h ON s.id = h.station_id
GROUP BY s.id
ORDER BY COUNT(h.id) DESC
LIMIT 1;


SELECT 
    l.nom as 'Ligne',
    l.type as 'Type',
    COUNT(h.id) as 'Nombre de passages',
    COUNT(DISTINCT h.station_id) as 'Nombre de stations desservies'
FROM ligne l
LEFT JOIN horaire h ON l.id = h.ligne_id
GROUP BY l.id
ORDER BY COUNT(h.id) DESC;

SELECT 
    l.nom as 'Ligne',
    s.nom as 'Station',
    GROUP_CONCAT(TIME(h.timestamp), ', ') as 'Horaires'
FROM horaire h
JOIN ligne l ON h.ligne_id = l.id
JOIN station s ON h.station_id = s.id
WHERE DATE(h.timestamp) = DATE('now')
GROUP BY l.id, s.id
ORDER BY l.nom, s.nom;


SELECT 
    s.nom as 'Station',
    MIN(TIME(h.timestamp)) as 'Premier passage',
    MAX(TIME(h.timestamp)) as 'Dernier passage'
FROM station s
JOIN horaire h ON s.id = h.station_id
WHERE DATE(h.timestamp) = DATE('now')
GROUP BY s.id
ORDER BY s.nom;