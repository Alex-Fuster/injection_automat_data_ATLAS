###########################################################################
# Injection of Ixodes scapularis time-series into Atlas
# From 2011 to 2014 Black-legged ticks data provided by Leo et al. 2016
# Collected at lowlands of the St Lawrence surrounding the city of Montreal (45.29951 N,	-73.0113 W)
# between 2011 and 2014
# December 2023
# Alexandre Fuster
###########################################################################

###################### NOTES ##############################################
# - Type échantillonnage: dragging a 1 m2 of white cloth across the ground on 90 m transects, with stop checks performed every 10 m. The transects were replicated 12 times across each sample site.
# - Effort d'échantillonnage: summer months of July and August.
###########################################################################

file_name <- "retrieved_datasets/20/20_FINAL_Leo et al_JH_Electronic Supplementary Material 2.xlsx"

brut <- readxl::read_excel(file_name)


# we split the dataset to produce a timeseries from each sampling site.
# because all the process is going to be the same for each site, I just run a function for each site

generate_timeseries_tables <- function(data, long, lat) {
  
  data_timeseries <- data |>
    #dplyr::select(c("Year", "nuits-piège", "nbr.peinte", "nbr.serpentine")) |>
    #dplyr::mutate(`Chrysemys picta` = ifelse(nbr.peinte > 0, nbr.peinte/`nuits-piège`, NA),
    # `Chelydra serpentina` = ifelse(nbr.serpentine > 0, nbr.serpentine/`nuits-piège`, nbr.serpentine)) |>
    dplyr::select(c("Year", "OID")) |>
    dplyr::group_by(Year) |>
    dplyr::summarise(count = dplyr::n())
  
  geom <- data.frame(x = long, y = lat) # note this is only one of the sites. The dataset has different coordinates for each site.
  
  dataset <- data.frame(
    original_source = "Leo et al. 2016",
    # org_dataset_id
    creator = "Leo et al. 2016",
    title = "The genetic signature of range expansion in a disease vector - the black-legged tick",
    publisher = "Oxford University Press",
    keywords = c("disease vector", "genetic turnover", "population genetics", "zoonotic disease emergence"),
    type_sampling = "dragging a 1 m2 of white cloth across the ground",
    type_obs = "human observation",
    # intellectual_rights
    license = "CC0 1.0 Universal",
    #owner = ,
    methods = "During summer months of July and August, dragging a 1 m2 of white cloth across the ground on 90 m transects, with stop checks performed every 10 m. The transects were replicated 12 times across each sample site",
    open_data = TRUE,
    exhaustive = TRUE,
    direct_obs = TRUE,
    centroid = FALSE,
    doi = "https://doi.org/10.5061/dryad.2n5h6",
    citation = "Leo, Sarah S.T.; Gonzalez, Andrew; Millien, Virginie (2016). Data from: The genetic signature of range expansion in a disease vector - the black-legged tick [Dataset]. Dryad"
  )
  
  
  taxa_obs <- data.frame(scientific_name = character(), rank = character())
  
  # Add a new row
  taxa_obs <- taxa_obs |>
    dplyr::add_row(scientific_name = "Ixodes scapularis", rank = "species") |>
    dplyr::mutate(scientific_name = stringr::str_to_sentence(scientific_name))
  
  time_series <- data_timeseries |>
    dplyr::mutate(taxon = "Ixodes scapularis") |>
    dplyr::mutate(taxon = stringr::str_to_sentence(taxon)) |>
    dplyr::rename(years = "Year") |>
    dplyr::mutate(unit = "Number of individuals captured")
  
  # Add geoms
  time_series <- cbind(time_series, geom = rep(sf::st_as_text(sf::st_multipoint(as.matrix(geom))), nrow(time_series)))
  
  time_series <- time_series |>
    dplyr::group_by(geom, taxon, unit) |>
    dplyr::rename(values = "count") |>
    dplyr::summarise(
      years = toString(years),
      values = toString(values)) |>
    dplyr::relocate(taxon, years, values, unit, geom) |>
    dplyr::glimpse()
  
  results <- list(dataset, taxa_obs, time_series)
  
  return(results)
  
}


# let's see the different location codes. We will compute a time series table for each.
# the table taxa_obs is the same for all.

unique(brut$`Location Code`) #"BMF" "DV"  "HR"  "HV"  "LP"  "LS"  "MSB" "NO"  "SdV" "SE"  "SF"  "SJ"  "SV"


# --------- Run for the site BMF

brut_1 <- brut[which(brut$`Location Code` == "BMF"), ]

results_1 <- generate_timeseries_tables(data = brut_1, long = brut_1$Latitude, lat = brut_1$Longitude)

dataset_1 <- results_1[[1]]
taxa_obs <- results_1[[2]]
time_series_1 <- results_1[[3]]

write.csv(taxa_obs_1, file = "output_tables/20_Leo2016/20_Leo2016_taxa_obs.csv", row.names = FALSE)
write.csv(time_series_1, file = "output_tables/20_Leo2016/20_Leo2016_time_series1.csv", row.names = FALSE)



# --------- Run for the site DV

brut_2 <- brut[which(brut$`Location Code` == "DV"), ]

results_2 <- generate_timeseries_tables(data = brut_2, long = brut_2$Latitude, lat = brut_2$Longitude)

dataset_2 <- results_2[[1]]
time_series_2 <- results_2[[3]]

write.csv(time_series_2, file = "output_tables/20_Leo2016/20_Leo2016_time_series2.csv", row.names = FALSE)



# --------- Run for the site HR

brut_3 <- brut[which(brut$`Location Code` == "HR"), ]

results_3 <- generate_timeseries_tables(data = brut_3, long = brut_3$Latitude, lat = brut_3$Longitude)

dataset_3 <- results_3[[1]]
time_series_3 <- results_3[[3]]


write.csv(time_series_3, file = "output_tables/20_Leo2016/20_Leo2016_time_series3.csv", row.names = FALSE)


# --------- Run for the site HV

brut_4 <- brut[which(brut$`Location Code` == "HV"), ]

results_4 <- generate_timeseries_tables(data = brut_4, long = brut_4$Latitude, lat = brut_4$Longitude)

dataset_4 <- results_4[[1]]
time_series_4 <- results_4[[3]]


write.csv(time_series_4, file = "output_tables/20_Leo2016/20_Leo2016_time_series4.csv", row.names = FALSE)


# --------- Run for the site LP

brut_5 <- brut[which(brut$`Location Code` == "LP"), ]

results_5 <- generate_timeseries_tables(data = brut_5, long = brut_5$Latitude, lat = brut_5$Longitude)

dataset_5 <- results_5[[1]]
time_series_5 <- results_5[[3]]

write.csv(time_series_5, file = "output_tables/20_Leo2016/20_Leo2016_time_series5.csv", row.names = FALSE)


# --------- Run for the site LS

brut_6 <- brut[which(brut$`Location Code` == "LS"), ]

results_6 <- generate_timeseries_tables(data = brut_6, long = brut_6$Latitude, lat = brut_6$Longitude)

dataset_6 <- results_6[[1]]
time_series_6 <- results_6[[3]]


write.csv(time_series_6, file = "output_tables/20_Leo2016/20_Leo2016_time_series6.csv", row.names = FALSE)




# --------- Run for the site MSB

brut_7 <- brut[which(brut$`Location Code` == "MSB"), ]

results_7 <- generate_timeseries_tables(data = brut_7, long = brut_7$Latitude, lat = brut_7$Longitude)

dataset_7 <- results_7[[1]]
time_series_7 <- results_7[[3]]

write.csv(time_series_7, file = "output_tables/20_Leo2016/20_Leo2016_time_series7.csv", row.names = FALSE)



# --------- Run for the site NO

brut_8 <- brut[which(brut$`Location Code` == "NO"), ]

results_8 <- generate_timeseries_tables(data = brut_8, long = brut_8$Latitude, lat = brut_8$Longitude)

dataset_8 <- results_8[[1]]
time_series_8 <- results_8[[3]]

write.csv(time_series_8, file = "output_tables/20_Leo2016/20_Leo2016_time_series8.csv", row.names = FALSE)



# --------- Run for the site SdV

brut_9 <- brut[which(brut$`Location Code` == "SdV"), ]

results_9 <- generate_timeseries_tables(data = brut_9, long = brut_9$Latitude, lat = brut_9$Longitude)

dataset_9 <- results_9[[1]]
time_series_9 <- results_9[[3]]

write.csv(time_series_9, file = "output_tables/20_Leo2016/20_Leo2016_time_series9.csv", row.names = FALSE)



# --------- Run for the site SE

brut_10 <- brut[which(brut$`Location Code` == "SE"), ]

results_10 <- generate_timeseries_tables(data = brut_10, long = brut_10$Latitude, lat = brut_10$Longitude)

dataset_10 <- results_10[[1]]
time_series_10 <- results_10[[3]]


write.csv(time_series_10, file = "output_tables/20_Leo2016/20_Leo2016_time_series10.csv", row.names = FALSE)



# --------- Run for the site SF

brut_11 <- brut[which(brut$`Location Code` == "SF"), ]

results_11 <- generate_timeseries_tables(data = brut_11, long = brut_11$Latitude, lat = brut_11$Longitude)

dataset_11 <- results_11[[1]]
time_series_11 <- results_11[[3]]


write.csv(time_series_11, file = "output_tables/20_Leo2016/20_Leo2016_time_series11.csv", row.names = FALSE)



# --------- Run for the site SJ

brut_12 <- brut[which(brut$`Location Code` == "SJ"), ]

results_12 <- generate_timeseries_tables(data = brut_12, long = brut_12$Latitude, lat = brut_12$Longitude)

dataset_12 <- results_12[[1]]
time_series_12 <- results_12[[3]]

write.csv(time_series_12, file = "output_tables/20_Leo2016/20_Leo2016_time_series12.csv", row.names = FALSE)



# --------- Run for the site SV

brut_13 <- brut[which(brut$`Location Code` == "SV"), ]

results_13 <- generate_timeseries_tables(data = brut_13, long = brut_13$Latitude, lat = brut_13$Longitude)

dataset_13 <- results_13[[1]]
time_series_13 <- results_13[[3]]


write.csv(time_series_13, file = "output_tables/20_Leo2016/20_Leo2016_time_series13.csv", row.names = FALSE)

