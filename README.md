# Houseward hazard identification

## Introducción

Cada año, miles de personas mueren a causa de fenómenos naturales: terremotos, huracanes, erupciones volcánicas, inundaciones; como resultado del cambio climático, las amenazas pueden presentarse con mayor incidencia. Aunque son inevitables y, en algunos casos también impredecibles, es importante tener un buen plan de gestión de desastres para evitar o disminuir daños que éstos pueden causar y lograr así una población más resiliente. En México, entre 2013 y 2017, tan solo ocurrieron 1 mil 407 fenómenos naturales perturbadores, de los cuales 1 mil 231 (87.5%) corresponden al tipo hidrometeorológico y 176 (12.5%) al tipo geológico (Auditoría Superior de la Federación - ASF).

Existen distintos esfuerzos por reducir la pobreza mediante la implementación de estrategias de protección social que disminuyen las vulnerabilidades de los hogares y apoyan a la construcción de resiliencia ante choques climático. El ejemplo claro es el Índice de Vulnerabilidad y Adaptación al Cambio Climático (IVACC), realizado por el gobierno de República Dominicana con el apoyo del PNUD, que  calcula la probabilidad de que un hogar sea vulnerable ante la ocurrencia de un fenómeno climático como huracanes, tormentas e inundaciones, dadas ciertas características socioeconómicas y geográficas del hogar y considera al 80% de la población (según el Censo de 2010).  

Con base en trabajos como éste, se construye una primer propuesta de índice de vulnerabilidad para las familias mexicanas. El objetivo de éste proyecto es encontrar los hogares con una vulnerabilidad mayor a la amenaza de inundación, ésta se hace considerando el indicador de 'Calidad y espacios de la vivienda', según CONEVAL y, posteriormente, su distancia a un foco de peligro (cuerpos y corrientes de agua). 

De esta forma, en la ocurrencia de una catástrofe, se da prioridad a los hogares más vulnerables, se optimizan los recursos y se evita perder las inversiones sociales. Además, en temas de política pública, permite  generar y retroalimentar sistemas de alerta temprana, ya sea para hacer recomendaciones personalizadas para la focalización de programas de prevención, investigación, monitoreo o educación para la reducción efectiva del riesgo.

## Avances
* Identificación de las viviendas con mayor riesgo de inundación dentro de los municipios en la Cuenca del Río Papaloapan según su el indicador sobre calidad de la vivienda y cercanía a focos de peligro. 

## Estructura
* eda: directorio que contiene gráficas de análisis exploratorio.
    - CarenciasTop25.jpg distribución de carencias en los 25 municipios con mayor riesgo.
    - CarenciasMun.jpg distribución de carencias en el municipio con mayor riesgo.
    - houseward_hazard_map.html ejemplo del mapa. Por seguridad, los datos no son compartidos.
* data: directorio que contiene archivos de texto utilizados u obtenidos en el análisis.
* models: directorio que corre el 'data pipeline' del repositorio de politica_preventiva.
* notebooks: directorio que contiene código que implementa algunos métodos planteados.
    - mapa.R script ubicación de hogares clasificados por nivel de riesgo (bajo, medio y alto).

## Requisitos

* R

Paquetes:

* tidyverse
* lubridate
* stringr
* mapview
* RColorBrewer
* dbrsocial
* dplyr
* sp
* sf
* rgdal

## Datos
* Ubicación georreferenciada y evaluación de carencias (CONEVAl) de cada hogar del Sistema de Focalización de Desarrollo (SIFODE), a través del Cuestionario Único de Información Socioeconómica (CUIS).
* Ranking y variables agregadas del índice INFORM.
    - Repositorio: https://github.com/plataformapreventiva/inform-mexico.git
* Mapas y georreferencias de la red hidrográfica del Sistema Nacional de Información Estadística y Geográfica (SNIEG) en el portal del Instituto Nacional de Estadística y Geografía (INEGI).
    - Bases correspondientes a la la Cuenca del Río Papaloapan que colindan con Santa María Chilchotla, Oaxaca (RH28Ac_hl, RH28Ad_hl).
http://www.beta.inegi.org.mx/temas/mapas/hidrografia/

## Siguientes pasos
* Tomar en cuenta otros factores que hacen un hogar vulnerable, como los aspectos económicos medidos a través del ingreso.
* Separar el análisis, según el tipo de materiales con los que está construída o los servicios básicos con los que cuenta.
* Replicar el proceso para el resto de los municipios del país y el resto de amenazas naturales. Para esto es necesario saber qué características o variables hacen más vulnerable un hogar frente a cada fenómeno.

## Referencias
* [1] PNUD/ONU Medio Ambiente. 2018. Índice de Vulnerabilidad ante Choques Climáticos: Lecciones aprendidas y sis- tematización del proceso de diseño y aplicación del IVACC en República Do- minicana. Ciudad de Panamá: Panamá.
http://www.do.undp.org/content/dam/dominican_republic/docs/medioambiente/publicaciones/pnud_do_IVACC%20RD.pdf
* [2] Blaikie, P., Cannon, T., Davis, I. & Wisner, B. (2003). At Risk. Natural hazards, people´s vulnerability and disasters. London: Routledge. 
* [3] Cartel de Inundaciones. CENAPRED. Sitio web: https://www.cenapred.gob.mx/es/Publicaciones/images/104-CARTELINUNDACIONES.JPG
* [4] Federación 1999. Serie Es mejor Prevenir… Folleto 1: La Prevención de los Desastres. Sitio web:
http://www.disaster.info.desastres.net/federacion/spa/folleto1.htm#t_2.
* [5] Hidrología de superficie y precipitaciones intensas 2005 en el estado de Veracruz. Sitio web: http://www.iingen.unam.mx/es-mx/Publicaciones/Libros/LibroInundaciones2005/06.pdf
* [6] Inundaciones. CENAPRED. Sitio web: https://www.cenapred.gob.mx/es/Publicaciones/archivos/3-FASCCULOINUNDACIONES.PDF
* [7] Indicadores de carencia social. CONEVAL. Sitio web: https://www.coneval.org.mx/Medicion/Paginas/Medición/Indicadores-de-carencia-social.aspx
* [8] Mapas hidrografía. INEGI. Sitio web: http://www.beta.inegi.org.mx/temas/mapas/hidrografia
* [9] Marin-Ferrer, M., Vernaccini, L. and Poljansek, K., (2017) Index for Risk Management INFORM Concept and Methodology Report — Version 2017, EUR 28655 EN, doi:10.2760/094023
* [10] Riesgo de inundaciones. Módulos Universitarios en ciencia del Desarrollo Sostenible (MOUDS).
Sitio web: http://www.desenvolupamentsostenible.org/es/los-riesgos-naturales/3-concepto-y-tipo-de-riesgo/3-7-riesgo-de-inundaciones/3-7-4-causas-que-provocan-las-inundaciones
