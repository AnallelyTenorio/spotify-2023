--Correlación global streams y total_playlists
WITH base AS (
 SELECT
   streams        AS streams_num,
   total_playlists AS total_playlists_num
 FROM `proyecto-2-laboratoria-470122.spotify_2023.resumen_final_spotify`
 WHERE streams IS NOT NULL AND total_playlists IS NOT NULL
)
SELECT
 CORR(streams_num, total_playlists_num)                AS r,
 POW(CORR(streams_num, total_playlists_num), 2)        AS r2,
 COUNT(*)                                              AS n,
 AVG(streams_num)                                      AS media_streams,
 AVG(total_playlists_num)                              AS media_playlists
FROM base;

--Correlaccion streams y danceability
WITH base AS (
 SELECT
   streams AS streams_num,
   `danceability_pct` AS danceability
 FROM `proyecto-2-laboratoria-470122.spotify_2023.resumen_final_spotify`
 WHERE streams IS NOT NULL AND `danceability_pct` IS NOT NULL
)
SELECT
 CORR(streams_num, base.danceability)                AS r,
 POW(CORR(streams_num, base.danceability), 2)        AS r2,
 COUNT(*)                                              AS n,
 AVG(streams_num)                                      AS media_streams,
 AVG(base.danceability)                              AS media_danceability
FROM base;

--Correlación streams y bpm
WITH base AS (
SELECT
  streams AS streams_num,
  bpm AS bpm
FROM `proyecto-2-laboratoria-470122.spotify_2023.resumen_final_spotify`
WHERE streams IS NOT NULL AND bpm IS NOT NULL
)
SELECT
CORR(streams_num, base.bpm)                AS r,
POW(CORR(streams_num, base.bpm), 2)        AS r2,
COUNT(*)                                              AS n,
AVG(streams_num)                                      AS media_streams,
AVG(base.bpm)                              AS media_bpm
FROM base;
