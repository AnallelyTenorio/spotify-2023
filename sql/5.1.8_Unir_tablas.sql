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