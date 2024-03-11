###########################################################################
# Injection of diptera time-series into ATLAS
# From 2006 to 2016, insect data provided by Garrett 2022
# Collected at southern Québec, Canada (45.30N, 72.50W)
#
# December 2023
# Alexandre Fuster
###########################################################################

###################### NOTES ##############################################
# - # - Type échantillonnage: insect traps
# - Effort d'échantillonnage: From 2005 to 2011, two insect traps were placed among 40 farms (N = 80) over an area of approximately 10 200 km2. Traps were spaced at least 250 m apart along the central portion of Tachycineta bicolor nest box transects. Each year, the content of traps was collected every two days throughout each breeding season (April to August)
###########################################################################

file_name <- "../retrieved_datasets/timeseries/150/150_Diptera.csv"

brut <- read.csv(file_name, sep=",")


# the measure is insect biomass

# We compute a time-series for each farm

brut$Year <- as.character(brut$Year)


data_timeseries <- brut |>
  #dplyr::select(c("Year", "nuits-piège", "nbr.peinte", "nbr.serpentine")) |>
  #dplyr::mutate(`Chrysemys picta` = ifelse(nbr.peinte > 0, nbr.peinte/`nuits-piège`, NA),
  # `Chelydra serpentina` = ifelse(nbr.serpentine > 0, nbr.serpentine/`nuits-piège`, nbr.serpentine)) |>
  dplyr::select(c("Year", "Biomass"))  |>
  dplyr::group_by(Year) |>
  dplyr::summarize(Biomass = sum(Biomass))



# 45.30N, 72.50W
geom <- data.frame(x = 45.30, y = 72.50) # I just take the coordinates of one of the farms. We might want to take the centroid [!]

dataset <- data.frame(
  original_source = "Garrett 2022",
  # org_dataset_id
  creator = "Garrett 2022",
  title = "Data set for combined influence of food availability and agricultural intensification on a declining aerial insectivore",
  publisher = " Ecological Society of America (ESA)",
  #keywords = c("Tortues, "Série-temporelle"),
  type_sampling = " Insect traps and window/water-pan flight trap",
  type_obs = "human observation",
  # intellectual_rights
  license = "CC0 1.0 Universal",
  #owner = ,
  methods = "From 2005 to 2011, two insect traps were placed among 40 farms (N = 80) over an area of approximately 10 200 km2. Traps were spaced at least 250 m apart along the central portion of Tachycineta bicolor nest box transects. Each year, the content of traps was collected every two days throughout each breeding season (April to August)",
  open_data = TRUE,
  exhaustive = TRUE,
  direct_obs = TRUE,
  centroid = FALSE,
  doi = "https://doi.org/10.5061/dryad.xd2547dj8",
  citation = "Garrett, Daniel (2022). Data set for combined influence of food availability and agricultural intensification on a declining aerial insectivore [Dataset]. Dryad."
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
  dplyr::add_row(scientific_name = "Diptera", rank = "order") |>
  dplyr::mutate(scientific_name = stringr::str_to_sentence(scientific_name))

write.csv(taxa_obs, file = "../output_tables/timeseries/150_Garrett2022/150_Garrett2022_taxa_obs.csv", row.names = FALSE)

#--------------------------------------------------------------------------
# 4. Table public.time_series
#--------------------------------------------------------------------------
# Format data for time series as a list of data frames
time_series <- data_timeseries |>
  dplyr::mutate(taxon = "Diptera") |>
  dplyr::mutate(taxon = stringr::str_to_sentence(taxon)) |>
  dplyr::rename(years = "Year") |>
  dplyr::mutate(unit = "Biomass of trapped diptera")

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
  dplyr::rename(values = "Biomass") |>
  dplyr::summarise(
    years = toString(years),
    values = toString(values)) |>
  dplyr::relocate(taxon, years, values, unit, geom) |>
  dplyr::glimpse()

write.csv(time_series, file = "../output_tables/timeseries/150_Garrett2022/150_Garrett2022_time_series.csv", row.names = FALSE)
