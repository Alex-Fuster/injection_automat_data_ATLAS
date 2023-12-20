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

data_timeseries <- brut |>
  #dplyr::select(c("Year", "nuits-piège", "nbr.peinte", "nbr.serpentine")) |>
  #dplyr::mutate(`Chrysemys picta` = ifelse(nbr.peinte > 0, nbr.peinte/`nuits-piège`, NA),
  # `Chelydra serpentina` = ifelse(nbr.serpentine > 0, nbr.serpentine/`nuits-piège`, nbr.serpentine)) |>
  dplyr::select(c("Year", "OID")) |>
  dplyr::group_by(Year) |>
  dplyr::summarise(count = dplyr::n())



# 45°16’14’’ N; 72°03’47’’ O
geom <- data.frame(x = 45.29951, y = -73.0113) # note this is only one of the sites. The dataset has different coordinates for each site.

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
  dplyr::add_row(scientific_name = "Ixodes scapularis", rank = "species") |>
  dplyr::mutate(scientific_name = stringr::str_to_sentence(scientific_name))


write.csv(taxa_obs, file = "output_tables/20_Leo2016/20_Leo2016_taxa_obs.csv", row.names = FALSE)

#--------------------------------------------------------------------------
# 4. Table public.time_series
#--------------------------------------------------------------------------
# Format data for time series as a list of data frames
time_series <- data_timeseries |>
  dplyr::mutate(taxon = "Ixodes scapularis") |>
  dplyr::mutate(taxon = stringr::str_to_sentence(taxon)) |>
  dplyr::rename(years = "Year") |>
  dplyr::mutate(unit = "Number of individuals captured")

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

write.csv(time_series, file = "output_tables/20_Leo2016/20_Leo2016_time_series.csv", row.names = FALSE)
