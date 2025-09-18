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


--Mayusculas y minisculas
SELECT DISTINCT artist_s__name
FROM `proyecto-2-laboratoria-470122.spotify_2023.step1_track_in_spotify`
ORDER BY artist_s__name;

SELECT DISTINCT track_name
FROM `proyecto-2-laboratoria-470122.spotify_2023.step1_track_in_spotify`
ORDER BY track_name;


-- Detectar nombres con caracteres extraños en track_name (260 registros)
SELECT *
FROM `proyecto-2-laboratoria-470122.spotify_2023.step1_track_in_spotify`
WHERE REGEXP_CONTAINS(track_name, r'[^a-zA-Z0-9\sáéíóúüñ.,!?-]');


-- Detectar nombres con caracteres extraños en artist_name (62 registros)
SELECT *
FROM `proyecto-2-laboratoria-470122.spotify_2023.step1_track_in_spotify`
WHERE REGEXP_CONTAINS(artist_s__name, r'[^a-zA-Z0-9\sáéíóúüñ.,!?-]');


----------------Data cleaning----------------------

--Crear tabla con datos limpios
CREATE OR REPLACE TABLE `proyecto-2-laboratoria-470122.spotify_2023.step2_track_in_spotify` AS
WITH norm AS (
  SELECT
    track_id,
    REGEXP_REPLACE(track_name,     r"[’`´]", "'")  AS tn1,
    REGEXP_REPLACE(artist_s__name, r"[’`´]", "'")  AS ar1,
    streams,
    in_spotify_playlists,
    in_spotify_charts,
    artist_count,
    released_year,
    released_month,
    released_day
  FROM `proyecto-2-laboratoria-470122.spotify_2023.step1_track_in_spotify`
),
clean AS (
  SELECT
    track_id,
    -- quitar “�” y caracteres no permitidos
    REGEXP_REPLACE(REGEXP_REPLACE(tn1, r"�", ""), r"[^0-9\p{L}\p{M}\s.,!?'/&():+-]", " ") AS tn2,
    REGEXP_REPLACE(REGEXP_REPLACE(ar1, r"�", ""), r"[^0-9\p{L}\p{M}\s.,!?'/&():+-]", " ") AS ar2,
    streams,
    in_spotify_playlists,
    in_spotify_charts,
    artist_count,
    released_year,
    released_month,
    released_day
  FROM norm
),
collapse AS (
  SELECT
    track_id,
    -- limpiar espacios múltiples y TRIM
    TRIM(REGEXP_REPLACE(tn2, r"\s+", " ")) AS track_name_raw,
    TRIM(REGEXP_REPLACE(ar2, r"\s+", " ")) AS artist_name_raw,
    streams,
    in_spotify_playlists,
    in_spotify_charts,
    artist_count,
    released_year,
    released_month,
    released_day
  FROM clean
),
final AS (
  SELECT
    track_id,
    -- aplicar INITCAP para estandarizar
    INITCAP(track_name_raw)   AS track_name,
    INITCAP(artist_name_raw)  AS artist_s__name,
    streams,
    in_spotify_playlists,
    in_spotify_charts,
    artist_count,
    released_year,
    released_month,
    released_day
  FROM collapse
)
SELECT * FROM final;


----------------Revisar cambios--------------------
-- A) ¿Quedan caracteres fuera de whitelist?
SELECT COUNT(*) AS quedan_raros
FROM `proyecto-2-laboratoria-470122.spotify_2023.step2_track_in_spotify`
WHERE REGEXP_CONTAINS(track_name,     r"[^0-9\p{L}\p{M}\s.,!?'/&():+-]")
   OR REGEXP_CONTAINS(artist_s__name, r"[^0-9\p{L}\p{M}\s.,!?'/&():+-]");

-- B) ¿Hay valores vacíos después de la limpieza? (Aparecen 2)
SELECT
  SUM(CASE WHEN track_name = '' THEN 1 ELSE 0 END)     AS tracks_vacios,
  SUM(CASE WHEN artist_s__name = '' THEN 1 ELSE 0 END) AS artistas_vacios
FROM `proyecto-2-laboratoria-470122.spotify_2023.step2_track_in_spotify`;

-- C) Muestra algunos ejemplos de cambios
SELECT
  b.track_name      AS before_track,
  a.track_name      AS after_track,
  b.artist_s__name  AS before_artist,
  a.artist_s__name  AS after_artist
FROM `proyecto-2-laboratoria-470122.spotify_2023.step2_track_in_spotify` a
JOIN `proyecto-2-laboratoria-470122.spotify_2023.step1_track_in_spotify` b
  USING(track_id)
WHERE b.track_name <> a.track_name OR b.artist_s__name <> a.artist_s__name;

---Ver los vacios antes y despues de los cambios
SELECT
  a.track_id,
  b.track_name   AS original_track,
  a.track_name   AS cleaned_track,
  b.artist_s__name AS original_artist,
  a.artist_s__name AS cleaned_artist
FROM `proyecto-2-laboratoria-470122.spotify_2023.step2_track_in_spotify` a
JOIN `proyecto-2-laboratoria-470122.spotify_2023.step1_track_in_spotify` b
  USING (track_id)
WHERE a.track_name = '';

---Reemplazar vacios por desconocidos
CREATE OR REPLACE TABLE `proyecto-2-laboratoria-470122.spotify_2023.step3_track_in_spotify` AS
SELECT
  track_id,
  -- si está vacío → "DESCONOCIDO"
  CASE 
    WHEN track_name = '' THEN 'DESCONOCIDO' 
    ELSE track_name 
  END AS track_name,
  artist_s__name,
  streams,
  in_spotify_playlists,
  in_spotify_charts,
  artist_count,
    released_year,
    released_month,
    released_day
FROM `proyecto-2-laboratoria-470122.spotify_2023.step2_track_in_spotify`;

---Validar cambios 
-- ¿Todavía hay vacíos?
SELECT
  SUM(CASE WHEN track_name = '' THEN 1 ELSE 0 END) AS tracks_vacios,
  SUM(CASE WHEN artist_s__name = '' THEN 1 ELSE 0 END) AS artistas_vacios
FROM `proyecto-2-laboratoria-470122.spotify_2023.step3_track_in_spotify`;

-- Ver los registros reemplazados
SELECT *
FROM `proyecto-2-laboratoria-470122.spotify_2023.step3_track_in_spotify`
WHERE track_name = 'DESCONOCIDO';
