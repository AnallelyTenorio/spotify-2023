--Espacios al inicio o al final
--artist_name si hay 
SELECT DISTINCT artist_s__name
 FROM `proyecto-2-laboratoria-470122.spotify_2023.track_in_spotify` 
 WHERE artist_s__name LIKE ' %' OR artist_s__name LIKE '% ';
--track_name no hay
 SELECT DISTINCT track_name
 FROM `proyecto-2-laboratoria-470122.spotify_2023.track_in_spotify` 
 WHERE track_name LIKE ' %' OR track_name LIKE '% ';

 --Limpiar espacios
SELECT TRIM(artist_s__name) AS artist_s__name_limpio
FROM `proyecto-2-laboratoria-470122.spotify_2023.track_in_spotify`;
