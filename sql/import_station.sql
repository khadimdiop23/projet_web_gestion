
INSERT OR REPLACE INTO station (id, nom, commune, latitude, longitude) VALUES
(1, 'Gare Centre', 'Rouen', 49.4431, 1.0993),
(2, 'Hotel de Ville', 'Rouen', 49.4425, 1.1001),
(3, 'Universite', 'Mont-Saint-Aignan', 49.4580, 1.0683);
INSERT OR REPLACE INTO station (id, nom, commune, latitude, longitude) VALUES
(4, 'Saint-Sever', 'Rouen', 49.4400, 1.0900),
(5, 'Palais de Justice', 'Rouen', 49.4415, 1.0950),
(6, 'Beauvoisine', 'Rouen', 49.4450, 1.0850);

SELECT 'Import terminé' as message;
SELECT COUNT(*) as nombre_stations FROM station;