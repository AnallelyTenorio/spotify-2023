# Spotify-2023
Proyecto de curso SkillupData de Laboratoria
# Proyecto 02 — Spotify 2023 

Análisis exploratorio y validación de preguntas de negocio con **BigQuery** y **Looker Studio**.

> Equipo: Hemmy Luz Torres Ariza · Anallely Tenorio Sanchez

---

## 🔍 Objetivo

Explorar un dataset de canciones (Spotify 2023), identificar patrones y **responder preguntas de negocio**, entre ellas:

- ¿Canciones con mayor BPM tienen más streams?
- ¿Aparecer en más playlists implica más streams?

---

## 🧱 Estructura del repo

```sql
/cleaning
5.1.2_Identificar_valores_nulos.sql
5.1.3_Identificar_valores_duplicados.sql
5.1.4_Identificar_y_tratar_valores_atípicos_en variables_categóricas.sql
5.1.5_Identificar_y_tratar_valores_atípicos_en variables_numéricas.sql
5.1.6_Verificar_y_cambiar_tipo_de_datos.sql
5.1.7_Crear_nuevas_variables.sql
5.1.8_Unir_tablas.sql
5.1.9_Construir_tablas_auxiliares.sql
/analysis
5.2.7_Calcular_correlación_entre_variables.sql
/docs
Ficha Técnica 02 - Spotify 2023.pdf
/images
dashboard_kpis.png
corr_playlists_streams.png
README.md
```

---

## 🛠️ Herramientas

- BigQuery (SQL)
- Looker Studio (visualización)
- Google Docs
- (Opcional) Git / GitHub

---

## ▶️ Cómo reproducir (rápido)

1. Crea (o usa) un proyecto en **BigQuery** y sube las tablas originales:
   - `track_in_spotify`
   - `track_in_competition`
   - `track_technical_info`
2. Ejecuta los scripts de `/sql/cleaning` en orden.
3. Ejecuta los scripts de `/sql/analysis` para métricas, correlaciones y series de tiempo.
4. Conecta **Looker Studio** a la tabla final (por ej. `resumen_final_spotify`) y usa los gráficos del dashboard.

---

## 🧪 SQL clave (snippets)

> ⚠️ Ajusta `project.dataset` a tu entorno.

### 1) Asegurar tipo numérico en `streams`
```sql
CREATE OR REPLACE TABLE `project.dataset.step2_track_in_spotify` AS
SELECT
  track_id,
  SAFE_CAST(streams AS INT64) AS streams,
  in_spotify_playlists,
  in_apple_playlists,
  in_deezer_playlists,
  released_year
FROM `project.dataset.track_in_spotify`;



