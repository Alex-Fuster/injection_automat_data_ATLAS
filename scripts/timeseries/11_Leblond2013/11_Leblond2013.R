###########################################################################
# Injection of Rangifer tarandus time-series into Atlas
# From 1999 to 2011 mammals data provided by Leblond et al. 2013
# Laurentides Wildlife Reserve ( 47°45′00″N ; 71°15′00″W) and Grands-Jardins National Park of Québec (47°41′N 70°51′W)
#
# December 2023
# Alexandre Fuster
###########################################################################

###################### NOTES ##############################################
# - Type échantillonnage: VHF telemetry from 1999-2000, and GPS telemetry from 2004-2011
# - Effort d'échantillonnage:  1 year VHF telemetry or 8 years GPS data for each individual
###########################################################################

file_name <- "../retrieved_datasets/timeseries/11/11_Table_Data.xlsx"

brut <- readxl::read_excel(file_name)

# Normalized per 1 ----------------------- !

brut$Year <- as.character(brut$Year)

data_timeseries <- brut |>
  #dplyr::select(c("Year", "nuits-piège", "nbr.peinte", "nbr.serpentine")) |>
  #dplyr::mutate(`Chrysemys picta` = ifelse(nbr.peinte > 0, nbr.peinte/`nuits-piège`, NA),
  # `Chelydra serpentina` = ifelse(nbr.serpentine > 0, nbr.serpentine/`nuits-piège`, nbr.serpentine)) |>
  dplyr::select(c("Year", "Individual")) |>
  dplyr::group_by(Year) |>
  dplyr::summarise(count = dplyr::n())




geom <- data.frame(x = 47.4500, y = -71.1500) # only at Laurentides Wildlife Reserve 

dataset <- data.frame(
  original_source = "Leblond et al. 2013",
  # org_dataset_id
  creator = "Leblond et al. 2013",
  title = "Impacts of human disturbance on large prey species: do behavioral reactions translate to fitness consequences?",
  publisher = "PLOS",
  #keywords = c("Tortues, "Série-temporelle"),
  type_sampling = "VHF telemetry, GPS",
  type_obs = "Telemetry",
  # intellectual_rights
  license = "CC0 1.0 Universal",
  #owner = ,
  methods = "For 8 consecutive years, 59 individuals were monitored using GPS telemetry, and 28 for 1 year using Very High Frequency telemtry",
  open_data = TRUE,
  exhaustive = TRUE,
  direct_obs = TRUE,
  centroid = FALSE,
  doi = "https://doi.org/10.5061/dryad.1cc4v",
  citation = "Leblond, Mathieu; Dussault, Christian; Ouellet, Jean-Pierre (2013). Data from: Impacts of human disturbance on large prey species: do behavioral reactions translate to fitness consequences? [Dataset]. Dryad"
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
  dplyr::add_row(scientific_name = "Rangifer tarandus", rank = "species") |>
  dplyr::mutate(scientific_name = stringr::str_to_sentence(scientific_name))

write.csv(taxa_obs, file = "../output_tables/timeseries/11_Leblond2013/11_Leblond2013_taxa_obs.csv", row.names = FALSE)

#--------------------------------------------------------------------------
# 4. Table public.time_series
#--------------------------------------------------------------------------
# Format data for time series as a list of data frames
time_series <- data_timeseries |>
  dplyr::mutate(taxon = "Rangifer tarandus") |>
  dplyr::mutate(taxon = stringr::str_to_sentence(taxon)) |>
  dplyr::rename(years = "Year") |>
  dplyr::mutate(unit = "Individual transmitting GPS signal")

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

write.csv(time_series, file = "../output_tables/timeseries/11_Leblond2013/11_Leblond2013_time_series.csv", row.names = FALSE)
