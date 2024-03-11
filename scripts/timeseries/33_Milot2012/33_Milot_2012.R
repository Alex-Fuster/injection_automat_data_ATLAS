###########################################################################
# Injection of Salmo salar time-series into Atlas
# From 2002 to 2005 fish data provided by Milot et al. 2012
# Collected at St. Lawrence estuary (47°67′N; 70°16′W)
#
# December 2023
# Alexandre Fuster
###########################################################################

###################### NOTES ##############################################
# - Type échantillonnage: fry born in the river were randomly sampled using electrofishing over a stretch starting from the dam and ending 35 km upstream
# - Effort d'échantillonnage: During the summers of 2003, 2004, and 2005 and before the stocking of hatchery-born fry each year, fry born in the river were randomly sampled using electrofishing over a stretch starting from the dam and ending 35 km upstream
###########################################################################

# we read an edited version of the original .txt file. This version do not contain the first line, which was a description of the dataset.
# The data contains the number of fry and spawing individuals captured each year. 
# In the first line describing the data, it is given the correspondence of each code of individuals, 
# which are ordered this way: spawners 2002 - fry 2003 - spawners 2003 - fry 2004 - spawners 2004 - fry 2005 - Tadoussac hatchery breeders

file_name <- "../retrieved_datasets/timeseries/33/33_MILOTEVA2012DATA_editedAF.txt"

brut <- read.table(file_name)

# The first colum is the code per individual. In the code, the letters correspond to one of the groups indicate above.
# We identify all rows of each group - by noting the last individual of the group - based on the order indicated above.

# SSMB2152 <- spawners 2002
# SSEB30342 <- fry 2003
# SSMB3013 <- spawners 2003
# SSEB41573 <- fry 2004
# SSMB4121 <- spawners 2004
# SSEB51297 <- fry 2005

brut$V1[1:(which(brut$V1 ==  "SSMB2152"))] <- "spawners_2002"

brut$V1[(which(brut$V1 ==  "spawners_2002")[length(which(brut$V1 ==  "spawners_2002"))]+1):(which(brut$V1 ==  "SSEB30342"))] <- "fry_2003"

brut$V1[(which(brut$V1 ==  "fry_2003")[length(which(brut$V1 ==  "fry_2003"))]+1):(which(brut$V1 ==  "SSMB3013"))] <- "spawners_2003"

brut$V1[(which(brut$V1 ==  "spawners_2003")[length(which(brut$V1 ==  "spawners_2003"))]+1):(which(brut$V1 ==  "SSEB41573"))] <- "fry_2004"

brut$V1[(which(brut$V1 ==  "fry_2004")[length(which(brut$V1 ==  "fry_2004"))]+1):(which(brut$V1 ==  "SSMB4121"))] <- "spawners_2004"

brut$V1[(which(brut$V1 ==  "spawners_2004")[length(which(brut$V1 ==  "spawners_2004"))]+1):(which(brut$V1 ==  "SSEB51297"))] <- "fry_2005"

brut$V1[(which(brut$V1 ==  "fry_2005")[length(which(brut$V1 ==  "fry_2005"))]+1):(which(brut$V1 ==  "SSGB0127"))] <- "hatchery_breeders"


# we can discard the last rows corresponding to Tadoussac hatchery breeders

brut <- brut[-which(brut$V1 == "hatchery_breeders"),]

# now we create a new column with the year

brut$Year <- as.numeric(gsub("[^0-9]", "", brut$V1))


brut$Year <- as.character(brut$Year)

data_timeseries <- brut |>
  #dplyr::select(c("Year", "nuits-piège", "nbr.peinte", "nbr.serpentine")) |>
  #dplyr::mutate(`Chrysemys picta` = ifelse(nbr.peinte > 0, nbr.peinte/`nuits-piège`, NA),
  # `Chelydra serpentina` = ifelse(nbr.serpentine > 0, nbr.serpentine/`nuits-piège`, nbr.serpentine)) |>
  dplyr::select(c("Year", "V1")) |>
  dplyr::group_by(Year) |>
  dplyr::summarise(count = dplyr::n())



# 47°67′N; 70°16′W
geom <- data.frame(x = 47.67, y = -70.16)

dataset <- data.frame(
  original_source = "Milot et al. 2012",
  # org_dataset_id
  creator = "Milot et al. 2012",
  title = "Reduced fitness of Atlantic salmon released in the wild after one generation of captive-breeding",
  publisher = "Wiley",
  #keywords = c("Tortues, "Série-temporelle"),
  type_sampling = "electrofishing",
  type_obs = "human observation",
  # intellectual_rights
  license = "CC0 1.0 Universal",
  #owner = ,
  methods = "During the summers of 2003, 2004, and 2005 and before the stocking of hatchery-born fry each year, fry born in the river were randomly sampled using electrofishing over a stretch starting from the dam and ending 35 km upstream",
  open_data = TRUE,
  exhaustive = TRUE,
  direct_obs = TRUE,
  centroid = FALSE,
  doi = "https://doi.org/10.5061/dryad.4k739",
  citation = "Milot, Emmanuel et al. (2012). Data from: Reduced fitness of Atlantic salmon released in the wild after one generation of captive-breeding [Dataset]. Dryad."
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
  dplyr::add_row(scientific_name = "Salmo salar", rank = "species") |>
  dplyr::mutate(scientific_name = stringr::str_to_sentence(scientific_name))

write.csv(taxa_obs, file = "../output_tables/timeseries/33_Milot2012/33_Milot2012_taxa_obs.csv", row.names = FALSE)

#--------------------------------------------------------------------------
# 4. Table public.time_series
#--------------------------------------------------------------------------
# Format data for time series as a list of data frames
time_series <- data_timeseries |>
  dplyr::mutate(taxon = "Salmo salar") |>
  dplyr::mutate(taxon = stringr::str_to_sentence(taxon)) |>
  dplyr::rename(years = "Year") |>
  dplyr::mutate(unit = "Number of individuals captured with electrofishing each year")

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

write.csv(time_series, file = "../output_tables/timeseries/33_Milot2012/33_Milot2012_time_series.csv", row.names = FALSE)
