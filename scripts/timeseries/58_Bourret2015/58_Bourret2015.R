###########################################################################
# Injection of Tachycineta bicolor females time-series into ATLAS
# From 2005 to 2011, bird data provided by Bourret et al. 2015
# Collected at southern Québec, Canada (45.30N, 72.50W)
#
# December 2023
# Alexandre Fuster
###########################################################################

###################### NOTES ##############################################
# - # - Type échantillonnage: monitoring nest-boxes
# - Effort d'échantillonnage: From 2005 to 2011, 400 nest-boxes distributed among 40 farms (10 per farm) over an area of approximately 10 200 km2 were visited every 2 days throughout the breeding season (April to August).
###########################################################################

file_name <- "../retrieved_datasets/timeseries/58/58_DeterminantPOP.csv"

brut <- read.csv(file_name, sep=";")


# the measure is density: % occupied nest boxes

# We compute a time-series for each farm

brut$Year <- as.character(brut$YEAR)


data_timeseries <- brut |>
  #dplyr::select(c("Year", "nuits-piège", "nbr.peinte", "nbr.serpentine")) |>
  #dplyr::mutate(`Chrysemys picta` = ifelse(nbr.peinte > 0, nbr.peinte/`nuits-piège`, NA),
  # `Chelydra serpentina` = ifelse(nbr.serpentine > 0, nbr.serpentine/`nuits-piège`, nbr.serpentine)) |>
  dplyr::select(c("YEAR", "DENSITY"))  |>
  dplyr::group_by(YEAR) |>
  dplyr::summarize(DENSITY = sum(DENSITY))



# 45°05’N; 72°25’W
geom <- data.frame(x = brut$LAT[1], y = brut$LONG[1]) # I just take the coordinates of one of the farms. We might want to take the centroid [!]

dataset <- data.frame(
  original_source = "Bourret et al. 2015",
  # org_dataset_id
  creator = "Bourret et al. 2015",
  title = "Multidimensional environmental influences on timing of breeding in a tree swallow population facing climate change",
  publisher = "WILEY",
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
  doi = "https://doi.org/10.5061/dryad.87jb3",
  citation = "Bourret, Audrey; Bélisle, Marc; Pelletier, Fanie; Garant, Dany (2015). Data from: Multidimensional environmental influences on timing of breeding in a tree swallow population facing climate change [Dataset]. Dryad."
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

write.csv(taxa_obs, file = "../output_tables/timeseries/58_Bourret2015/58_Bourret2015_taxa_obs.csv", row.names = FALSE)

#--------------------------------------------------------------------------
# 4. Table public.time_series
#--------------------------------------------------------------------------
# Format data for time series as a list of data frames
time_series <- data_timeseries |>
  dplyr::mutate(taxon = "Tachycineta bicolor") |>
  dplyr::mutate(taxon = stringr::str_to_sentence(taxon)) |>
  dplyr::rename(years = "YEAR") |>
  dplyr::mutate(unit = "% of occupied nest-boxes - visited every 2 days throughout the breeding season (April to August)")

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
  dplyr::rename(values = "DENSITY") |>
  dplyr::summarise(
    years = toString(years),
    values = toString(values)) |>
  dplyr::relocate(taxon, years, values, unit, geom) |>
  dplyr::glimpse()

write.csv(time_series, file = "../output_tables/timeseries/58_Bourret2015/58_Bourret2015_time_series.csv", row.names = FALSE)
