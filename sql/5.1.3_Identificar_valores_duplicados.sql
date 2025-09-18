--Identificar ids duplicados
SELECT 
COUNT(*) AS total_filas,
COUNT(DISTINCT track_id) AS ids_unicos,
COUNT(*)-COUNT(DISTINCT track_id) AS filas_duplicadas_por_id,
 FROM `proyecto-2-laboratoria-470122.spotify_2023.track_in_spotify`;