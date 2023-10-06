library(tidyverse)
library(sf)

df_schools <- "C:\\Users\\Sven\\sciebo\\DAUR_Daten\\course_data\\school_data\\school_data.csv" %>% 
  read_csv()

df_SSI <- df_schools %>% 
  select(plz, school_ID, school_type, school_operation_key) %>% 
  filter(school_type == "02", school_operation_key == 1) %>% 
  left_join(
    "C:\\Users\\Sven\\sciebo\\DAUR_Daten\\course_data\\school_data\\2022_social_index.csv" %>% 
      read_csv2() %>% 
      select(school_ID = Schulnummer, SSI = Sozialindexstufe) %>% 
      filter(SSI > 0),
    by = "school_ID"
  ) %>% 
  left_join(
    "C:\\Users\\Sven\\sciebo\\DAUR_Daten\\course_data\\school_data\\plz_AGS.csv" %>% 
      read_csv(),
    by = "plz",
    multiple = "all"
  ) %>% 
  group_by(AGS) %>% 
  summarise(mean_SSI = mean(SSI, na.rm = T))
  

sf_AGS <- "C:\\Users\\Sven\\sciebo\\DAUR_Daten\\raw_data\\GEM_shp\\VG5000_GEM.shp" %>% 
  st_read() %>% 
  select(AGS)


df_SSI %>% 
  left_join(sf_AGS, by = "AGS") %>% 
  st_as_sf(crs = st_crs(sf_AGS)) %>% 
  st_write("SSI_per_AGS.geojson", delete_dsn = T)
  