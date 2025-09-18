# Spotify-2023
Proyecto de curso SkillupData de Laboratoria
# Proyecto 02 — Spotify 2023 

Análisis exploratorio y validación de preguntas de negocio con **BigQuery** y **Looker Studio**.

> Equipo: Hemmy Luz Torres Ariza · Anallely Tenorio Sanchez

---

## 🔍 Objetivo

Explorar un dataset de canciones (Spotify 2023), identificar patrones y **responder preguntas de negocio**, entre ellas:

- ¿Canciones con mayor BPM (beats per minute) tienen más streams?
- ¿Aparecer en más playlists implica más streams?

---

## 🧱 Estructura del repo

```sql
/data
spotify_2023.zip
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

## 🧪 SQL clave

> ⚠️ Ajusta `project.dataset` a tu entorno.


---

## 🔎 Consultas SQL ejecutadas
Las queries se encuentran en la carpeta [`sql/`](./sql).  
Ejemplos:

```sql
-- 5.1.2 Identificar valores nulos
SELECT COUNT(*) 
FROM `spotify_2023.track_in_spotify`
WHERE streams IS NULL;
```
```sql
-- 5.2.7 Calcular correlación entre variables
SELECT
  CORR(streams, total_playlists) AS corr_streams_playlists
FROM `spotify_2023.resumen_final_spotify`;
```


---

## 📊 Resultados (resumen)

Total canciones: 949

Total artistas: 645

### 🔹 Preguntas de negocio

#### ¿Canciones con mayor BPM tienen más streams?

Correlación: r = -0.0002 → relación nula.

Conclusión: el BPM no predice el éxito, aunque tempos moderados (101–120 BPM) muestran mejor desempeño típico.

#### ¿Aparecer en más playlists implica más streams?

Correlación: r = 0.78 → relación positiva fuerte.

Conclusión: la visibilidad en playlists es un factor clave asociado al éxito de una canción.

Distribuciones sesgadas a la derecha: pocas canciones muy exitosas elevan los promedios.

Crecimiento en streams y lanzamientos a partir de 2000, pico en 2022.

Ver detalles y narrativa en docs/Ficha Técnica 02 - Spotify 2023.pdf

## 📑 Documentación

Ficha Técnica del Proyecto: 
https://docs.google.com/document/d/1f4G5z0jAPMUIbowk3cKmcQJf33i5id-uNS5O2FvHvBw/edit?usp=sharing

Dashboard en Looker Studio: 
https://lookerstudio.google.com/reporting/2404a7fa-511a-4456-abbc-2d78719c743b

<img width="1371" height="712" alt="image" src="https://github.com/user-attachments/assets/7e828fd6-e401-453d-8894-8e0c388c6507" />
<img width="1372" height="747" alt="image" src="https://github.com/user-attachments/assets/ab7a371a-5fe9-4da0-8269-bffb5858de6d" />
<img width="1370" height="482" alt="image" src="https://github.com/user-attachments/assets/788734de-f9d2-4a75-9f5c-791ef87b8eb3" />
<img width="1372" height="410" alt="image" src="https://github.com/user-attachments/assets/c7c315ee-d08e-4580-bba8-32489b7c6435" />



## 📄 Créditos

Equipo: Hemmy Luz Torres Ariza · Anallely Tenorio Sanchez

Dataset: Spotify 2023 (material de curso)




