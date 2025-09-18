--Calcula el número total de canciones de artistas solistas, es decir, cuando no hay otros artistas que hayan creado la canción juntos.
WITH solistas AS (
  SELECT *
  FROM `proyecto-2-laboratoria-470122.spotify_2023.resumen_spotify`
  WHERE artist_count = 1
),
canciones_artista AS (
  SELECT
  artist_s__name,
  COUNT(*) AS total_canciones
  FROM solistas
  GROUP BY artist_s__name
)
SELECT *
FROM canciones_artista
ORDER BY total_canciones DESC;

-- SOLISTAS: TABLA PRINCIPAL
-- CANCIONES_ARTISTAS: TABLA AUXILIAR
-- En total 302 artistas con canciones en solitario
WITH solistas AS (
  SELECT *
  FROM `proyecto-2-laboratoria-470122.spotify_2023.resumen_spotify`
  WHERE artist_count = 1
),
canciones_artista AS (
  SELECT
    artist_s__name,
    COUNT(*) AS total_canciones
  FROM solistas
  GROUP BY artist_s__name
)
SELECT artist_s__name, total_canciones
FROM canciones_artista

UNION ALL

SELECT 'TOTAL' AS artist_s__name, SUM(total_canciones)
FROM canciones_artista
ORDER BY total_canciones DESC;


-- el número total de canciones de artistas solistas es 583
