###########################################################################
# Injection of Tamias striatus time-series into Atlas
# From 2012 to 2016 micro-mammals data provided by Gharnit et al. 2022
# Collected near Mansonville (45°05’N; 72°25’W)
#
# December 2023
# Alexandre Fuster
###########################################################################

###################### NOTES ##############################################
# - Type échantillonnage: linear trapping transects composed of Longworth traps
# - Effort d'échantillonnage: daily during the activity period of chipmunks from early May until early September every year
###########################################################################

file_name <- "retrieved_datasets/4/4_Data_exploration.csv"

brut <- read.csv(file_name, sep=";")

# Split the "date" column and extract the year
date_parts <- strsplit(as.character(brut$date), "/")
brut$Year <- sapply(date_parts, function(x) x[3])

# Normalized per 1 ----------------------- !

brut$Year <- as.character(brut$Year)

data_timeseries <- brut |>
  #dplyr::select(c("Year", "nuits-piège", "nbr.peinte", "nbr.serpentine")) |>
  #dplyr::mutate(`Chrysemys picta` = ifelse(nbr.peinte > 0, nbr.peinte/`nuits-piège`, NA),
               # `Chelydra serpentina` = ifelse(nbr.serpentine > 0, nbr.serpentine/`nuits-piège`, nbr.serpentine)) |>
  dplyr::select(c("Year", "id_chipmunk")) |>
  dplyr::group_by(Year) |>
  dplyr::summarise(count = dplyr::n())



# 45°05’N; 72°25’W
geom <- data.frame(x = 45.05, y = -72.25)

dataset <- data.frame(
  original_source = "Gharnit et al. 2022",
  # org_dataset_id
  creator = "Gharnit et al. 2022",
  title = "Exploration and diet specialization in eastern chipmunks - Québec - Canada",
  publisher = "University of Chicago Press",
  #keywords = c("Tortues, "Série-temporelle"),
  type_sampling = "Longworth traps",
  type_obs = "human observation",
  # intellectual_rights
  license = "CC0 1.0 Universal",
  #owner = ,
  methods = "every year, from early May until early September, linear trapping transects",
  open_data = TRUE,
  exhaustive = TRUE,
  direct_obs = TRUE,
  centroid = FALSE,
  doi = "https://doi.org/10.5061/dryad.0rxwdbs2c",
  citation = "Gharnit, Elouana; Dammhahn, Melanie; Garant, Dany; Réale, Denis (2022). Exploration and diet specialization in eastern chipmunks - Québec - Canada [Dataset]. Dryad."
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
  dplyr::add_row(scientific_name = "Tamias striatus", rank = "species") |>
  dplyr::mutate(scientific_name = stringr::str_to_sentence(scientific_name))

write.csv(taxa_obs, file = "output_tables/4_Gharnit2022/4_Gharnit2022_taxa_obs.csv", row.names = FALSE)

#--------------------------------------------------------------------------
# 4. Table public.time_series
#--------------------------------------------------------------------------
# Format data for time series as a list of data frames
time_series <- data_timeseries |>
  dplyr::mutate(taxon = "Tamias striatus") |>
  dplyr::mutate(taxon = stringr::str_to_sentence(taxon)) |>
  dplyr::rename(years = "Year") |>
  dplyr::mutate(unit = "Number of individuals captured in trapping transects each year")

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

write.csv(time_series, file = "output_tables/4_Gharnit2022/4_Gharnit2022_time_series.csv", row.names = FALSE)
