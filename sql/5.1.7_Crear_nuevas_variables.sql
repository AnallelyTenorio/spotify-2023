---Crear tabla con nueva variable fecha de lanzamiento

CREATE OR REPLACE TABLE `proyecto-2-laboratoria-470122.spotify_2023.released_date` AS
SELECT
  s.track_id,
  SAFE.PARSE_DATE(
    '%Y-%m-%d',
    FORMAT('%04d-%02d-%02d', s.released_year, s.released_month, s.released_day)
  ) AS released_date
FROM `proyecto-2-laboratoria-470122.spotify_2023.step4_track_in_spotify` s;

--Numero de filas y cuántas fechas quedaron NULL (inválidas)
SELECT
  COUNT(*) AS n_filas,
  COUNTIF(released_date IS NULL) AS fechas_invalidas
FROM `proyecto-2-laboratoria-470122.spotify_2023.released_date`;

--Ver nueva tabla released_date
SELECT * FROM `proyecto-2-laboratoria-470122.spotify_2023.released_date`;

--Crear tabla con variable participación total en listas de reproduccion
CREATE OR REPLACE TABLE `proyecto-2-laboratoria-470122.spotify_2023.total_playlists` AS
SELECT
  s.track_id,
  s.in_spotify_playlists,
  c.in_apple_playlists,
  c.in_deezer_playlists,
  (COALESCE(s.in_spotify_playlists, 0)
   + COALESCE(c.in_apple_playlists, 0)
   + COALESCE(c.in_deezer_playlists, 0)) AS total_playlists
FROM `proyecto-2-laboratoria-470122.spotify_2023.step4_track_in_spotify` s
JOIN `proyecto-2-laboratoria-470122.spotify_2023.step2_track_in_competition` c
  USING (track_id);

--Numero filas y nulos en total_playlists (0)
SELECT
  COUNT(*) AS n_filas,
  COUNTIF(total_playlists IS NULL) AS total_playlists_nulls
FROM `proyecto-2-laboratoria-470122.spotify_2023.total_playlists`;

--Ver distribución rápida
SELECT
  MIN(total_playlists) AS min_tp,
  APPROX_QUANTILES(total_playlists, 2)[OFFSET(1)] AS mediana_tp,
  MAX(total_playlists) AS max_tp,
  AVG(total_playlists) AS avg_tp
FROM `proyecto-2-laboratoria-470122.spotify_2023.total_playlists`;

--Ver tabla total_playlists
SELECT * FROM `proyecto-2-laboratoria-470122.spotify_2023.total_playlists`;


