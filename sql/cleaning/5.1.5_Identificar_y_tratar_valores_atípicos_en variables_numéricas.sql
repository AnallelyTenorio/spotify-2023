-- track_tecnical_info
WITH unp AS (
  SELECT * FROM `proyecto-2-laboratoria-470122.spotify_2023.step1_track_tecnical_info`
  UNPIVOT(val FOR metric IN (bpm, `danceability_%`, `valence_%`, `energy_%`,
                             `acousticness_%`, `instrumentalness_%`, `liveness_%`, `speechiness_%`))
)
SELECT metric, MIN(val) AS min_value, MAX(val) AS max_value, AVG(val) AS avg_value
FROM unp GROUP BY metric;

-- track_in_spotify (sin streams)
WITH unp AS (
  SELECT * FROM `proyecto-2-laboratoria-470122.spotify_2023.step3_track_in_spotify`
  UNPIVOT(val FOR metric IN (artist_count, released_year, released_month,
                             released_day, in_spotify_playlists, in_spotify_charts))
)
SELECT metric, MIN(val) AS min_value, MAX(val) AS max_value, AVG(val) AS avg_value
FROM unp GROUP BY metric;

-- track_in_competition
WITH unp AS (
  SELECT * FROM `proyecto-2-laboratoria-470122.spotify_2023.step2_track_in_competition`
  UNPIVOT(val FOR metric IN (in_apple_playlists, in_apple_charts,
                             in_deezer_playlists, in_deezer_charts, in_shazam_charts))
)
SELECT metric, MIN(val) AS min_value, MAX(val) AS max_value, AVG(val) AS avg_value
FROM unp GROUP BY metric;

--track_in_spotify(con streams casteado en paso 5.1.6)
WITH unp AS (
  SELECT * FROM `proyecto-2-laboratoria-470122.spotify_2023.step4_track_in_spotify`
  UNPIVOT(val FOR metric IN (artist_count, released_year, released_month,
                             released_day, in_spotify_playlists, in_spotify_charts,streams))
)
SELECT metric, MIN(val) AS min_value, MAX(val) AS max_value, AVG(val) AS avg_value
FROM unp GROUP BY metric;
