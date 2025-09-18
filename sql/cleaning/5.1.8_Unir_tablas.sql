--VIEW SPOTIFY CLEAN
CREATE OR REPLACE VIEW `proyecto-2-laboratoria-470122.spotify_2023.v_spotify_clean` AS
SELECT *
FROM `proyecto-2-laboratoria-470122.spotify_2023.step4_track_in_spotify`;


--VIEW COMPETITION CLEAN
CREATE OR REPLACE VIEW `bright-raceway-469723-g7.spotify_2023.v_competition_clean` AS
SELECT *
FROM `bright-raceway-469723-g7.spotify_2023.step2_track_in_competition`;


--VIEW TECHNICAL CLEAN
CREATE OR REPLACE VIEW `bright-raceway-469723-g7.spotify_2023.v_technical_clean` AS
SELECT *
FROM `bright-raceway-469723-g7.spotify_2023.step1_track_technical_info`;


--VIEW RELEASED DATE
CREATE OR REPLACE VIEW `bright-raceway-469723-g7.spotify_2023.v_released_date` AS
SELECT *
FROM `bright-raceway-469723-g7.spotify_2023.released_date`;


--VIEW TOTAL PLAYLIST
CREATE OR REPLACE VIEW `bright-raceway-469723-g7.spotify_2023.v_total_playlists` AS
SELECT
track_id,
total_playlists,
FROM `bright-raceway-469723-g7.spotify_2023.total_playlists`;

--- CREANDO RESUMEN_SPOTIFY USANDO LEFT JOINS
CREATE OR REPLACE VIEW `proyecto-2-laboratoria-470122.spotify_2023.resumen_spotify` AS
SELECT
  t.*,
  c.* EXCEPT(track_id),
  te.* EXCEPT(track_id),
  r.* EXCEPT(track_id),
  tp.* EXCEPT(track_id)
FROM `proyecto-2-laboratoria-470122.spotify_2023.v_spotify_clean` AS t
LEFT JOIN `proyecto-2-laboratoria-470122.spotify_2023.v_competition_clean` AS c
  ON t.track_id = c.track_id
LEFT JOIN `proyecto-2-laboratoria-470122.spotify_2023.v_technical_clean` AS te
  ON t.track_id = te.track_id
LEFT JOIN `proyecto-2-laboratoria-470122.spotify_2023.v_released_date` AS r
  ON t.track_id = r.track_id
LEFT JOIN `proyecto-2-laboratoria-470122.spotify_2023.v_total_playlists` AS tp
  ON t.track_id = tp.track_id;  


--CREAR TABLA FINAL: resumen_final_spotify
CREATE OR REPLACE TABLE `proyecto-2-laboratoria-470122.spotify_2023.resumen_final_spotify`
CLUSTER BY track_id AS
SELECT
  t.track_id,
  t.track_name,
  t.artist_s__name,
  t.streams,               
  t.in_spotify_playlists,
  t.in_spotify_charts,
  t.artist_count,
  t.released_year, t.released_month, t.released_day,
  r.released_date,
  tp.total_playlists,

  -- Competition
  c.in_apple_playlists, c.in_apple_charts,
  c.in_deezer_playlists, c.in_deezer_charts,
  c.in_shazam_charts,

  -- Technical
  te.bpm, te.`key`, te.mode,
  te.`danceability_%` AS danceability_pct, te.`valence_%` AS valence_pct, te.`energy_%` AS energy_pct,
  te.`acousticness_%` AS acousticness_pct, te.`instrumentalness_%` AS instrumentalness_pct,
  te.`liveness_%` AS liveness_pct, te.`speechiness_%` AS speechiness_pct
FROM `proyecto-2-laboratoria-470122.spotify_2023.v_spotify_clean` t
LEFT JOIN `proyecto-2-laboratoria-470122.spotify_2023.v_competition_clean` c USING (track_id)
LEFT JOIN `proyecto-2-laboratoria-470122.spotify_2023.v_technical_clean`   te USING (track_id)
LEFT JOIN `proyecto-2-laboratoria-470122.spotify_2023.v_released_date`     r USING (track_id)
LEFT JOIN `proyecto-2-laboratoria-470122.spotify_2023.v_total_playlists`   tp USING (track_id);