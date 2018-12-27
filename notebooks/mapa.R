options(scipen=10000)
source("models/hazard_index_houseward/aux.R")
source("../utils.R")

# Obtención de las claves del top 20 del ranking de INFORM

inform <- tbl(con, dbplyr::in_schema('models','inform_index_municipios')) %>%
  dplyr::select(cve_muni,ranking,amenazas_y_exposicion,gp_inundac,fenomeno_hidrometeorologico) %>% 
  filter(gp_inundac==100) %>% retrieve_result()

cves <- inform$cve_muni[1:20]

# Obtención de las georreferencias de los hogares de los 20 municipios obtenidos

cuis <- tbl(con, dbplyr::in_schema('raw','cuis_historico_domicilio')) %>% 
  dplyr::select(llave_hogar_h,cve_muni,longitud,latitud) %>%
  mutate(cve_muni=as.character(cve_muni),latitud=as.numeric(latitud),longitud=as.numeric(longitud)) %>% 
  filter(cve_muni %in% cves) 

# Obtención de los indicadores de carencias de los hogares de los 20 municipios obtenidos
sifode <- tbl(con, dbplyr::in_schema('raw','sifode_domicilio')) %>% 
  dplyr::select(llave_hogar_h,ic_rezedu_1,ic_asalud,ic_ss,ic_cv,ic_sbv,ic_ali,pob_lbm,pob_lb)  


domicilios <- left_join(cuis,sifode,by='llave_hogar_h') %>% 
  dplyr::select(-c(llave_hogar_h,longitud,latitud)) %>% 
  group_by(cve_muni,ic_rezedu_1,ic_asalud,ic_ss,ic_cv,ic_sbv,ic_ali,pob_lbm,pob_lb) %>%
  summarise(n=n()) %>% collect()


# Distribución de carencias para los 20 municipios

par(mfrow=c(2,4))
barplot(table(domicilios$ic_rezedu_1), main = "Rezago educativo",col ="gray",xlab="Presenta o no",ylab="Número de hogares")
barplot(table(domicilios$ic_asalud), main = "Acceso a servicios de salud",col ="gray",xlab="Presenta o no",ylab="Número de hogares")
barplot(table(domicilios$ic_ss), main = " Acceso a seguridad social",col ="gray",xlab="Presenta o no",ylab="Número de hogares")
barplot(table(domicilios$ic_cv), main = "Calidad y espacios de la vivienda",col ="gray",xlab="Presenta o no",ylab="Número de hogares")
barplot(table(domicilios$ic_sbv), main = "Servicios básicos en la vivienda",col ="gray",xlab="Presenta o no",ylab="Número de hogares")
barplot(table(domicilios$ic_ali), main = "Acceso a alimentación",col ="gray",xlab="Presenta o no",ylab="Número de hogares")
barplot(table(domicilios$pob_lb), main = "Línea de bienestar",col ="gray",xlab="Presenta o no",ylab="Número de hogares")
barplot(table(domicilios$pob_lbm), main = "Línea de bienestar mínimo",col ="gray",xlab="Presenta o no",ylab="Número de hogares")

# Distribución de carencias para Santa María Chilchotla

mun <- domicilios[domicilios$cve_muni==20406,]
par(mfrow=c(2,4))
barplot(table(mun$ic_rezedu_1),main = "Rezago educativo",col ="gray",xlab="Presenta o no",ylab="Número de hogares")
barplot(table(mun$ic_asalud), main = "Acceso a servicios de salud",col ="gray",xlab="Presenta o no",ylab="Número de hogares")
barplot(table(mun$ic_ss), main = "Acceso a seguridad social",col ="gray",xlab="Presenta o no",ylab="Número de hogares")
barplot(table(mun$ic_cv), main = "Calidad y espcios de la vivienda",col ="gray",xlab="Presenta o no",ylab="Número de hogares")
barplot(table(mun$ic_sbv), main = "Servicios básicos en la vivienda",col ="gray",xlab="Presenta o no",ylab="Número de hogares")
barplot(table(mun$ic_ali), main = "Acceso a alimentación",col ="gray",xlab="Presenta o no",ylab="Número de hogares")
barplot(table(mun$pob_lb), main = "Línea de bienestar",col ="gray",xlab="Presenta o no",ylab="Número de hogares")
barplot(table(mun$pob_lbm), main = "Línea de bienestar mínimo",col ="gray",xlab="Presenta o no",ylab="Número de hogares")

# Creación de mapas de identificación

lat_cuenca_min <- 16+55/60
lat_cuenca_max <- 19+3/60
long_cuenca_min <- -97+48/60
long_cuenca_max <- -94+40/60

# Identificación de hogares y flujos dentro de la cuenca y transformación a geometrías

ubic <- cuis %>% 
  filter(lat_cuenca_min < latitud, latitud< lat_cuenca_max,long_cuenca_min<longitud,longitud<long_cuenca_max) %>% collect() %>% drop_na()

hogares_mun <- left_join(ubic,vul,by='llave_hogar_h') %>% drop_na()

hogares <- data.frame(longitud=ubic$longitud,latitud=ubic$latitud)
hogares_points <- st_as_sf(x = hogares, 
                           coords = c("longitud", "latitud"),
                           crs = "+proj=longlat +datum=WGS84")
puntos <- st_transform(hogares_points, crs = 4326)


flujos <- readOGR(dsn = "/home/alicia/889463129554_s", layer = "RH28Ad_hl")
flujos2 <- readOGR(dsn = "/home/alicia/889463129530_s", layer = "RH28Ac_hl")
flujos1_points <- st_as_sf(flujos, c('longitud', 'latitud'))
flujos2_points <- st_as_sf(flujos2, c('longitud', 'latitud'))

plot(flujos)
plot(flujos2)

lineas <- st_transform(flujos1_points$geometry, crs = 4326)
lineas2 <- st_transform(flujos2_points$geometry, crs = 4326)

# Obtención de distancias de cada hogar a cada flujo

distance_matrix <- st_distance(puntos,lineas)
distance_matrix2 <- st_distance(puntos,lineas2)
distancias <- apply(distance_matrix, 1, mean)

# Clasificación de hogares

cercanas <- which(distancias < quantile(distancias, 0.11))
riesgosos <- hogares[cercanas,] %>%
  mutate(zona=rep("Riesgo alto",n()))
media <- which(distancias < quantile(distancias, 0.60) & distancias > quantile(distancias, 0.11))
riesgo_medio <- hogares[media,] %>%
  mutate(zona=rep("Riesgo medio",n()))
lejanas <- which(distancias < quantile(distancias, 1) & distancias > quantile(distancias, 0.60))
sin_riesgo <- hogares[lejanas,] %>%
  mutate(zona=rep("Riesgo bajo",n()))

hogares_cuenca <- rbind(riesgosos,riesgo_medio) %>% rbind(sin_riesgo)
hogares_riesgo <- st_as_sf(x = hogares_cuenca, 
                           coords = c("longitud", "latitud"),
                           crs = "+proj=longlat +datum=WGS84")

# Visualización

mapview(hogares_riesgo,map.types = c("OpenStreetMap.DE"), zcol="zona", legend = TRUE,burst = TRUE)