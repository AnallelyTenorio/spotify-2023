--Identificar ids duplicados
SELECT 
COUNT(*) AS total_filas,
COUNT(DISTINCT track_id) AS ids_unicos,
COUNT(*)-COUNT(DISTINCT track_id) AS filas_duplicadas_por_id,
 FROM `proyecto-2-laboratoria-470122.spotify_2023.track_in_spotify`;

 --Otra manera de checar duplicados
 SELECT
  track_id,
  COUNT(*) AS veces
FROM `proyecto-2-laboratoria-470122.spotify_2023.track_in_spotify`
GROUP BY track_id
HAVING COUNT(*) > 1
ORDER BY veces DESC, track_id;
--No hay valores duplicados en track_id

--Duplicados por track_name y artist_s__name
SELECT *
FROM (
  SELECT
    t.*,
    COUNT(*) OVER (PARTITION BY track_name, artist_s__name) AS cnt
  FROM `proyecto-2-laboratoria-470122.spotify_2023.track_in_spotify` AS t
)
WHERE cnt > 1
ORDER BY track_name, artist_s__name;

--04 registros duplicados (track_name y artist_name)
SELECT
  s.track_id,
  s.track_name,
  s.artist_s__name,
  s.streams,
  s.in_spotify_playlists,
  s.in_spotify_charts,
  c.in_apple_playlists,
  c.in_apple_charts,
  c.in_deezer_playlists,
  c.in_deezer_charts,
  c.in_shazam_charts
FROM `proyecto-2-laboratoria-470122.spotify_2023.track_in_spotify` s
JOIN `proyecto-2-laboratoria-470122.spotify_2023.track_in_competition` c
  ON s.track_id = c.track_id
WHERE s.track_id IN (
    SELECT track_id
    FROM (
      SELECT track_id,
             COUNT(*) OVER (PARTITION BY track_name, artist_s__name) AS cnt
      FROM `proyecto-2-laboratoria-470122.spotify_2023.track_in_spotify`
    )
    WHERE cnt > 1
)
ORDER BY s.track_name, s.artist_s__name;

--Tratamiento
---Identificación:
---De la revisión de los casos se ve que los diferentes ID corresponden a versiones distitntas de la misma canción (lanzamineto en diferentes fechas o diferentes realeses: single, y luego EP o album).
--Diferencia en streams:
--En algunos casos, las versiones acumulan cantidades distintas de streams porque se consumieron de manera independiente.En otros casos, los streams son iguales o muy similares porque la plataforma puede consolidar
--Criterio final:
---En ese sentido se mantendrá el ID con mayores streams o más antiguo.
---Por otro lado en la bd IN COMPETITION se mantendrá el ID seleccionado en bd IN SPOTIFY pero se le asignará el valor máximo para representar mejor la presencia de la cancnion en la competencia.
----------------------------------------------------------------------------------------------------------------------


-- 02. IDENTIFICAR DUPLICADOS - track_technical_info


--Identificar ids duplicados
SELECT 
COUNT(*) AS total_filas,
COUNT(DISTINCT track_id) AS ids_unicos,
COUNT(*)-COUNT(DISTINCT track_id) AS filas_duplicadas_por_id,
 FROM `proyecto-2-laboratoria-470122.spotify_2023.track_tecnical_info`;

--Otra manera de validar duplicados
 SELECT
  track_id,
  COUNT(*) AS veces
FROM `proyecto-2-laboratoria-470122.spotify_2023.track_tecnical_info`
GROUP BY track_id
HAVING COUNT(*) > 1
ORDER BY veces DESC, track_id;
--No hay valores duplicados en track_id


## 03. IDENTIFICAR DUPLICADOS - track_in_competition


--Checar si hay ids duplicados
SELECT 
COUNT(*) AS total_filas,
COUNT(DISTINCT track_id) AS ids_unicos,
COUNT(*)-COUNT(DISTINCT track_id) AS filas_duplicadas_por_id,
 FROM `proyecto-2-laboratoria-470122.spotify_2023.track_in_competition` ;

--Otra manera de checar
 SELECT
  track_id,
  COUNT(*) AS veces
FROM `proyecto-2-laboratoria-470122.spotify_2023.track_in_competition`
GROUP BY track_id
HAVING COUNT(*) > 1
ORDER BY veces DESC, track_id;
--No hay valores duplicados en track_id


--*****************************Data cleaning*******************************
--QUERY PARA MANTENER VALOR ÚNICO Y PASARLO A NUEVA TABLA
--en bd in spotify
CREATE OR REPLACE TABLE `proyecto-2-laboratoria-470122.spotify_2023.step1_track_in_spotify` AS
-- 0) Base + convertir streams a número para ordenar correctamente
WITH base AS (
 SELECT
   track_id,
   track_name,
   artist_s__name,
   artist_count,
   released_year,
   released_month,
   released_day,
   streams,
   -- quita comas y castea; si algo no convierte queda NULL
   SAFE_CAST(REPLACE(streams, ',', '') AS INT64) AS streams_num,
   in_spotify_playlists,
   in_spotify_charts
 FROM `proyecto-2-laboratoria-470122.spotify_2023.track_in_spotify`
),
-- 1) Grupos duplicados por (track_name, artist_s__name)
dup AS (
 SELECT
   track_name,
   artist_s__name,
   COUNT(*) AS cnt
 FROM base
 GROUP BY track_name, artist_s__name
 HAVING COUNT(*) > 1
),
-- 2) Agregar máximos de playlists/charts por combinación (para consolidar)
agg AS (
 SELECT
   track_name,
   artist_s__name,
   MAX(in_spotify_playlists) AS in_spotify_playlists,
   MAX(in_spotify_charts)    AS in_spotify_charts
 FROM base
 GROUP BY track_name, artist_s__name
),
-- 3) Rankear dentro de cada duplicado: más streams primero
--    (si empata, desempata por fecha más antigua; luego por track_id)
ranked AS (
 SELECT
   b.*,
   ROW_NUMBER() OVER (
     PARTITION BY b.track_name, b.artist_s__name
     ORDER BY
       b.streams_num DESC,                   -- más streams primero
       b.released_year, b.released_month, b.released_day,  -- más antiguo primero
       b.track_id                            -- desempate estable
   ) AS rn
 FROM base b
 JOIN dup  d USING (track_name, artist_s__name)
)
-- 4) Resultado final:
--    a) duplicados → mantener rn = 1 + pegar máximos de agg
--    b) no duplicados → pasan tal cual
SELECT
 r.track_id,
 r.track_name,
 r.artist_s__name,
 r.artist_count,
 r.released_year,
 r.released_month,
 r.released_day,
 r.streams,  -- mantenemos el original (string) por ahora; castearemos en 5.1.6
 a.in_spotify_playlists,
 a.in_spotify_charts
FROM ranked r
JOIN agg a USING (track_name, artist_s__name)
WHERE rn = 1
UNION ALL
SELECT
 b.track_id,
 b.track_name,
 b.artist_s__name,
 b.artist_count,
 b.released_year,
 b.released_month,
 b.released_day,
 b.streams,
 b.in_spotify_playlists,
 b.in_spotify_charts
FROM base b
LEFT JOIN dup d USING (track_name, artist_s__name)
WHERE d.track_name IS NULL;


--VER REGISTROS UNICOS
SELECT *
FROM `proyecto-2-laboratoria-470122.spotify_2023.step1_track_in_spotify`
WHERE track_id in ("7173596","5675634","4967469","4586215");


--Agrupar datos de canciones duplicadas en track_in_competition
CREATE OR REPLACE TABLE `proyecto-2-laboratoria-470122.spotify_2023.step2_track_in_competition` AS
-- 1) IDs conservados por combinación track_name + artist_s__name (según Spotify limpio)
WITH kept AS (
 SELECT
   track_id AS kept_id,
   track_name,
   artist_s__name
 FROM `proyecto-2-laboratoria-470122.spotify_2023.step1_track_in_spotify`
),
-- 2) IDs originales por combinación (del Spotify original para construir el mapeo)
orig AS (
 SELECT
   track_id AS orig_id,
   track_name,
   artist_s__name
 FROM `proyecto-2-laboratoria-470122.spotify_2023.track_in_spotify`
),
-- 3) Mapeo: cada ID original → ID conservado
id_map AS (
 SELECT
   o.orig_id,
   k.kept_id
 FROM orig o
 JOIN kept k
   USING (track_name, artist_s__name)
),
-- 4) Parte consolidada: agrupa Competition por el ID conservado con MAX en métricas
agg_comp AS (
 SELECT
   m.kept_id AS track_id,
   MAX(c.in_apple_playlists) AS in_apple_playlists,
   MAX(c.in_apple_charts)    AS in_apple_charts,
   MAX(c.in_deezer_playlists) AS in_deezer_playlists,
   MAX(c.in_deezer_charts)    AS in_deezer_charts,
   MAX(c.in_shazam_charts)    AS in_shazam_charts
 FROM `proyecto-2-laboratoria-470122.spotify_2023.step1_track_in_competition` c
 JOIN id_map m
   ON c.track_id = m.orig_id
 GROUP BY track_id
),
-- 5) Resto: registros de Competition que no pertenecen a ningún grupo duplicado
untouched AS (
 SELECT c.*
 FROM `proyecto-2-laboratoria-470122.spotify_2023.step1_track_in_competition` c
 LEFT JOIN id_map m
   ON c.track_id = m.orig_id
 WHERE m.orig_id IS NULL
)
-- 6) Resultado final
SELECT * FROM agg_comp
UNION ALL
SELECT * FROM untouched;


--Ver si todos los registros son unicos
SELECT track_id, COUNT(*) AS veces
FROM `proyecto-2-laboratoria-470122.spotify_2023.step2_track_in_competition`
GROUP BY track_id
HAVING COUNT(*) > 1;


--Ver registros unicos
SELECT *
FROM `proyecto-2-laboratoria-470122.spotify_2023.step2_track_in_competition`
WHERE track_id in ("7173596","5675634","4967469","4586215");



--IDs consolidados
WITH id_map AS (
 SELECT
   o.track_id AS orig_id,
   k.track_id AS kept_id
 FROM `proyecto-2-laboratoria-470122.spotify_2023.track_in_spotify` o
 JOIN `proyecto-2-laboratoria-470122.spotify_2023.step1_track_in_spotify` k
   USING (track_name, artist_s__name)
)
SELECT
 COUNT(DISTINCT orig_id) AS ids_originales_en_grupos,
 COUNT(DISTINCT kept_id) AS ids_conservados
FROM id_map;