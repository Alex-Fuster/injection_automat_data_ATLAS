###########################################################################
# Injection of Lemming time-series into Atlas
# From 2005 to 2019 micro-mammals data provided by Beardsell et al. 2022
# Collected at Sirmilik National Park, Bylot Island (73° N; 80° W)
#
# December 2023
# Alexandre Fuster
###########################################################################

###################### NOTES ##############################################
# - Type échantillonnage: 
# - Effort d'échantillonnage: 

# units are Lemming density: ind/km2


file_name <- "../retrieved_datasets/timeseries/65/65_LPS_Densities_NestingSuccess.csv"

brut <- read.csv(file_name, sep=",")


brut$Year <- as.character(brut$Year)

data_timeseries <- brut |>
  #dplyr::select(c("Year", "nuits-piège", "nbr.peinte", "nbr.serpentine")) |>
  #dplyr::mutate(`Chrysemys picta` = ifelse(nbr.peinte > 0, nbr.peinte/`nuits-piège`, NA),
  # `Chelydra serpentina` = ifelse(nbr.serpentine > 0, nbr.serpentine/`nuits-piège`, nbr.serpentine)) |>
  dplyr::select(c("Year", "Lemming_density")) 



# 45°05’N; 72°25’W
geom <- data.frame(x = 73, y = 80)

dataset <- data.frame(
  original_source = "Beardsell et al. 2022",
  # org_dataset_id
  creator = "Beardsell et al. 2022",
  title = "A mechanistic model of functional response provides new insights into indirect interactions among arctic tundra prey",
  publisher = "Ecological Society of America",
  #keywords = c("Tortues, "Série-temporelle"),
  type_sampling = "",
  type_obs = "",
  # intellectual_rights
  license = "CC0 1.0 Universal",
  #owner = ,
  methods = "",
  open_data = TRUE,
  exhaustive = TRUE,
  direct_obs = TRUE,
  centroid = FALSE,
  doi = "https://doi.org/10.5061/dryad.8w9ghx3pf",
  citation = "Beardsell, Andréanne et al. (2022). A mechanistic model of functional response provides new insights into indirect interactions among arctic tundra prey [Dataset]. Dryad"
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
  dplyr::add_row(scientific_name = "Lemmus trimucronatus", rank = "species") |>
  dplyr::add_row(scientific_name = "Dicrostonyx groenlandicus", rank = "species") |>
  dplyr::mutate(scientific_name = stringr::str_to_sentence(scientific_name))

write.csv(taxa_obs, file = "../output_tables/timeseries/65_Beardsell2022/65_Beardsell2022_1_taxa_obs.csv", row.names = FALSE)

#--------------------------------------------------------------------------
# 4. Table public.time_series
#--------------------------------------------------------------------------
# Format data for time series as a list of data frames
time_series <- data_timeseries |>
  dplyr::mutate(taxon = "Lemmings") |>
  dplyr::mutate(taxon = stringr::str_to_sentence(taxon)) |>
  dplyr::rename(years = "Year") |>
  dplyr::mutate(unit = "individuals per km2")

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
  dplyr::rename(values = "Lemming_density") |>
  dplyr::summarise(
    years = toString(years),
    values = toString(values)) |>
  dplyr::relocate(taxon, years, values, unit, geom) |>
  dplyr::glimpse()

write.csv(time_series, file = "../output_tables/timeseries/65_Beardsell2022/65_Beardsell2022_1_time_series.csv", row.names = FALSE)
