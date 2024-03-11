###########################################################################
# Injection of lemmings time-series into ATLAS
# From 2010 to 2019, micro-mammal data provided by Duchesne et al. 2021
# Collected at Qarlikturvik valley on Bylot Island (73°08′ N; 80°00′ W)
#
# December 2023
# Alexandre Fuster
###########################################################################

###################### NOTES ##############################################
# - Type échantillonnage: Trapping stations
# - Effort d'échantillonnage: live-trapping sessions in two 11-ha trapping grids (one in mesic and one in wetland habitats)
###########################################################################

file_name <- "../retrieved_datasets/timeseries/113/113_occurrence_nestingbirds.csv"

brut <- read.csv(file_name, sep=",")


# The measure is Annual lemming density (nb lemmings / ha) estimated with capture-recapture. For details of the method, see Fauteux et al. 2015.


brut$year <- as.character(brut$year)


data_timeseries <- brut |>
  #dplyr::select(c("Year", "nuits-piège", "nbr.peinte", "nbr.serpentine")) |>
  #dplyr::mutate(`Chrysemys picta` = ifelse(nbr.peinte > 0, nbr.peinte/`nuits-piège`, NA),
  # `Chelydra serpentina` = ifelse(nbr.serpentine > 0, nbr.serpentine/`nuits-piège`, nbr.serpentine)) |>
  dplyr::select(c("year", "lemmings"))  |>
  dplyr::group_by(year) |>
  dplyr::summarize(DENSITY = sum(lemmings))



#73°08′ N; 80°00′ W
geom <- data.frame(x = 73.08, y = 80.00) 

dataset <- data.frame(
  original_source = "Duchesne et al. 2021",
  # org_dataset_id
  creator = "Duchesne et al. 2021",
  title = "Variable strength of predator-mediated effects on species occurrence in an arctic terrestrial vertebrate community",
  publisher = "WILEY",
  #keywords = c("Tortues, "Série-temporelle"),
  type_sampling = "live-trapping stations",
  type_obs = "human observation",
  # intellectual_rights
  license = "CC0 1.0 Universal",
  #owner = ,
  methods = "Lemming density was estimated from 2010 to 2019 with live-trapping sessions in two 11-ha trapping grids (one in mesic and one in wetland habitats). ",
open_data = TRUE,
exhaustive = TRUE,
direct_obs = TRUE,
centroid = FALSE,
doi = " https://doi.org/10.5061/dryad.pg4f4qrpf",
citation = "Duchesne, Éliane et al. (2021). Variable strength of predator-mediated effects on species occurrence in an arctic terrestrial vertebrate community [Dataset]. Dryad"
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


write.csv(taxa_obs, file = "../output_tables/timeseries/113_Duchesne2021/113_Duchesne2021_taxa_obs.csv", row.names = FALSE)

#--------------------------------------------------------------------------
# 4. Table public.time_series
#--------------------------------------------------------------------------
# Format data for time series as a list of data frames
time_series <- data_timeseries |>
  dplyr::mutate(taxon = "Lemmings") |>
  dplyr::mutate(taxon = stringr::str_to_sentence(taxon)) |>
  dplyr::rename(years = "year") |>
  dplyr::mutate(unit = "Annual lemming density (nb lemmings / ha) estimated with capture-recapture")

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

write.csv(time_series, file = "../output_tables/timeseries/113_Duchesne2021/113_Duchesne2021_time_series.csv", row.names = FALSE)
