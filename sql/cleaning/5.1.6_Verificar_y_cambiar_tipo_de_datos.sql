--Intento de casteo de streams
SELECT CAST(streams AS INT64) AS streams_limpio
FROM `proyecto-2-laboratoria-470122.spotify_2023.step3_track_in_spotify`;
--Pero se ejecuta como error porque hay un valor string


--Valor string que aparece en STREAMS
SELECT *
FROM `proyecto-2-laboratoria-470122.spotify_2023.step3_track_in_spotify`
WHERE NOT REGEXP_CONTAINS(streams, r'^[0-9]+$');

----DATA CLEANING----
-- Castear streams y marcar el outlier de texto
CREATE OR REPLACE TABLE `proyecto-2-laboratoria-470122.spotify_2023.step4_track_in_spotify` AS
SELECT
  t.track_id,
  t.track_name,
  t.artist_s__name,
  t.artist_count,
  t.released_year,
  t.released_month,
  t.released_day,
  -- si NO es numérico (con comas), queda NULL
  SAFE_CAST(REPLACE(t.streams, ',', '') AS INT64) AS streams,
  -- flag para rastrear el caso problemático
  NOT REGEXP_CONTAINS(t.streams, r'^[0-9,]+$') AS streams_invalid,
  t.in_spotify_playlists,
  t.in_spotify_charts
FROM `proyecto-2-laboratoria-470122.spotify_2023.step3_track_in_spotify` t;

-- ¿Cuántos inválidos quedaron?
SELECT COUNTIF(streams_invalid) AS invalidos
FROM `proyecto-2-laboratoria-470122.spotify_2023.step4_track_in_spotify`;

-- Ver el registro marcado
SELECT *
FROM `proyecto-2-laboratoria-470122.spotify_2023.step4_track_in_spotify`
WHERE streams_invalid = TRUE;

