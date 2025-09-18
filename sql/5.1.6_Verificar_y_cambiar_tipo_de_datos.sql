--Intento de casteo de streams
SELECT CAST(streams AS INT64) AS streams_limpio
FROM `proyecto-2-laboratoria-470122.spotify_2023.step3_track_in_spotify`;
--Pero se ejecuta como error porque hay un valor string


--Valor string que aparece en STREAMS
SELECT *
FROM `proyecto-2-laboratoria-470122.spotify_2023.step3_track_in_spotify`
WHERE NOT REGEXP_CONTAINS(streams, r'^[0-9]+$');