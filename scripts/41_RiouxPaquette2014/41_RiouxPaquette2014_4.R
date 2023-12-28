###########################################################################
# Injection of Tachycineta bicolor males time-series into ATLAS
# From 2005 to 2011, bird data provided by Rioux Paquette et al. 2014
# Collected at southern Québec, Canada (45.30N, 72.50W)
# 
# December 2023
# Alexandre Fuster
###########################################################################

###################### NOTES ##############################################
# - Type échantillonnage: monitoring nest-boxes
# - Effort d'échantillonnage: From 2005 to 2011, 400 nest-boxes distributed among 40 farms (10 per farm) over an area of approximately 10 200 km2 were visited every 2 days throughout the breeding season (April to August).
###########################################################################


file_name <- "retrieved_datasets/41/41_maledata.xls"

brut <- read_excel(file_name, skip = 13)

brut$Year <- as.character(brut$year)

data_timeseries <- brut |>
  #dplyr::select(c("Year", "nuits-piège", "nbr.peinte", "nbr.serpentine")) |>
  #dplyr::mutate(`Chrysemys picta` = ifelse(nbr.peinte > 0, nbr.peinte/`nuits-piège`, NA),
  # `Chelydra serpentina` = ifelse(nbr.serpentine > 0, nbr.serpentine/`nuits-piège`, nbr.serpentine)) |>
  dplyr::select(c("Year", "maleID")) |>
  dplyr::group_by(Year) |>
  dplyr::summarise(count = dplyr::n())



# Coordinates were not given in the article. Based on a map given by another article describing the same system (*) I choosed the center of the map (Fig 1).
# *(https://cdnsciencepub.com/doi/full/10.1139/cjz-2017-0229?casa_token=XN9pN0kfeJwAAAAA%3AOfeHA-Tg4mA4amWjgzEggGUDMMpaora5hnTvcHNotXCNvdZyDjLiNqX3c-ByG_vRLoPQY-bQtnY)

geom <- data.frame(x = 45.30, y = -72.50)

dataset <- data.frame(
  original_source = "Rioux Paquette et al. 2014",
  # org_dataset_id
  creator = "Rioux Paquette et al. 2014",
  title = "Severe recent decrease of adult body mass in a declining insectivorous bird population",
  publisher = "The Royal Society",
  #keywords = c("Tortues, "Série-temporelle"),
  type_sampling = "Nest-boxes",
  type_obs = "human observation",
  # intellectual_rights
  license = "CC0 1.0 Universal",
  #owner = ,
  methods = "From 2005 to 2011, 400 nest-boxes distributed among 40 farms 
(10 per farm) over an area of approximately 10 200 km2 were 
visited every 2 days throughout the breeding season (April to August)",
open_data = TRUE,
exhaustive = TRUE,
direct_obs = TRUE,
centroid = FALSE,
doi = "https://doi.org/10.5061/dryad.67t23",
citation = "Rioux Paquette, Sébastien; Pelletier, Fanie; Garant, Dany; Bélisle, Marc (2014). Data from: Severe recent decrease of adult body mass in a declining insectivorous bird population [Dataset]. Dryad"
)






#--------------------------------------------------------------------------
# 3. taxa_obs
#--------------------------------------------------------------------------

#taxa_obs <- data.frame(colnames(data_timeseries)) |>
# dplyr::mutate(scientific_name = "Tamias striatus") |>
# dplyr::filter(scientific_name %in% c("Chrysemys picta", "Chelydra serpentina")) |>
# dplyr::mutate(scientific_name = stringr::str_to_sentence(scientific_name), rank = NA) |>
# dplyr::mutate(rank = "species") |>
# dplyr::select(c("scientific_name", "rank"))

taxa_obs <- data.frame(scientific_name = character(), rank = character())

# Add a new row
taxa_obs <- taxa_obs |>
  dplyr::add_row(scientific_name = "Tachycineta bicolor", rank = "species") |>
  dplyr::mutate(scientific_name = stringr::str_to_sentence(scientific_name))

write.csv(taxa_obs, file = "output_tables/41_RiouxPaquette2014/41_RiouxPaquette2014_1_taxa_obs.csv", row.names = FALSE)

#--------------------------------------------------------------------------
# 4. Table public.time_series
#--------------------------------------------------------------------------


# Format data for time series as a list of data frames
time_series <- data_timeseries |>
  dplyr::mutate(taxon = "Tachycineta bicolor") |>
  dplyr::mutate(taxon = stringr::str_to_sentence(taxon)) |>
  dplyr::rename(years = "Year") |>
  dplyr::mutate(unit = "Number of males captured in the nesting period")

# Add geoms
time_series <- cbind(time_series, geom = rep(sf::st_as_text(sf::st_multipoint(as.matrix(geom))), nrow(time_series)))


# Convert array-like column to string format
#array_to_string <- function(col, is_character = FALSE) {
# sapply(col, function(arr) {
#  if (is_character) {
#   paste0('\'{"', paste(arr, collapse = '","'), '"}\'')
#} else {
# paste0('{', paste(arr, collapse = ','), '}')
#}
#  })
#}


time_series <- time_series |>
  dplyr::group_by(geom, taxon, unit) |>
  dplyr::rename(values = "count") |>
  dplyr::summarise(
    years = toString(years),
    values = toString(values)) |>
  dplyr::relocate(taxon, years, values, unit, geom) |>
  dplyr::glimpse()

write.csv(time_series, file = "output_tables/41_RiouxPaquette2014/41_RiouxPaquette2014_4_time_series.csv", row.names = FALSE)
