###########################################################################
# Injection of Tachycineta bicolor fledglings time-series into Atlas
# From 2004 to 2011 bird data provided by Carle-Pruneau et al. 2021
# Collected in southern Québec ()
#
# January 2024
# Alexandre Fuster
###########################################################################

###################### NOTES ##############################################
# - Type échantillonnage: monitoring nest-boxes
# - Effort d'échantillonnage: From 2005 to 2011, 400 nest-boxes distributed among 40 farms (10 per farm) over an area of approximately 10 200 km2 were monitored
###########################################################################

# Time series only for fledglings

file_name <- "retrieved_datasets/101/101_Local_recruit_brood.csv"

brut <- read.csv(file_name, sep=";")


brut$Year <- as.character(brut$year)

data_timeseries <- brut |>
  #dplyr::select(c("Year", "nuits-piège", "nbr.peinte", "nbr.serpentine")) |>
  #dplyr::mutate(`Chrysemys picta` = ifelse(nbr.peinte > 0, nbr.peinte/`nuits-piège`, NA),
  # `Chelydra serpentina` = ifelse(nbr.serpentine > 0, nbr.serpentine/`nuits-piège`, nbr.serpentine)) |>
  dplyr::select(c("year", "n_fledglings"))  |>
  dplyr::group_by(year) |>
  dplyr::summarize(abundance = sum(n_fledglings))



# 45°05’N; 72°25’W
geom <- data.frame(x = 45.36667, y = -72.9093)

dataset <- data.frame(
  original_source = "Carle-Pruneau et al. 2021",
  # org_dataset_id
  creator = "Carle-Pruneau et al. 2021",
  title = "Determinants of nest box local recruitment and natal dispersal in a declining bird population",
  publisher = "University of Chicago Press",
  #keywords = c("Tortues, "Série-temporelle"),
  type_sampling = "Longworth traps",
  type_obs = "human observation",
  # intellectual_rights
  license = "CC0 1.0 Universal",
  #owner = ,
  methods = "bird nest monitoring",
  open_data = TRUE,
  exhaustive = TRUE,
  direct_obs = TRUE,
  centroid = FALSE,
  doi = "https://doi.org/10.5061/dryad.mpg4f4r16",
  citation = "Carle-Pruneau, Esther; Garant, Dany; Bélisle, Marc; Pelletier, Fanie (2021). Determinants of nest box local recruitment and natal dispersal in a declining bird population [Dataset]. Dryad."
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

write.csv(taxa_obs, file = "output_tables/101_Carle-Pruneau2021/101_Carle-Pruneau2021_taxa_obs.csv", row.names = FALSE)

#--------------------------------------------------------------------------
# 4. Table public.time_series
#--------------------------------------------------------------------------
# Format data for time series as a list of data frames
time_series <- data_timeseries |>
  dplyr::mutate(taxon = "Tachycineta bicolor") |>
  dplyr::mutate(taxon = stringr::str_to_sentence(taxon)) |>
  dplyr::rename(years = "year") |>
  dplyr::mutate(unit = "Number of fledglings found in nesting boxes")

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
  dplyr::rename(values = "abundance") |>
  dplyr::summarise(
    years = toString(years),
    values = toString(values)) |>
  dplyr::relocate(taxon, years, values, unit, geom) |>
  dplyr::glimpse()

write.csv(time_series, file = "output_tables/101_Carle-Pruneau2021/101_Carle-Pruneau2021_time_series_1.csv", row.names = FALSE)
