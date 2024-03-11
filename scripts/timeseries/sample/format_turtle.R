###########################################################################
# Injection of turtle time-series into Atlas
# From 2017-2022 micro-mammals data provided by Patrice Bourgault (UDS)
# Collected at l’île-du-marais de Ste-Catherine-de-Hatley
# 2015 à 2019 + 2023
# October 2023
# Benjamin Mercier
###########################################################################

###################### NOTES ##############################################
# - Type échantillonnage: piège verveux appâté de sardines.
# - Effort d'échantillonnage: 1 nuit-piège par 24h
###########################################################################

file_name <- "patrice_bourgault_data/turtle_time_series_bourgault/turtle_data.xlsx"

brut <- readxl::read_excel(file_name)

# Normalized per 1
data_timeseries <- brut |>
                   dplyr::select(c("année", "nuits-piège", "nbr.peinte", "nbr.serpentine")) |>
                   dplyr::mutate(`Chrysemys picta` = ifelse(nbr.peinte > 0, nbr.peinte/`nuits-piège`, NA),
                                 `Chelydra serpentina` = ifelse(nbr.serpentine > 0, nbr.serpentine/`nuits-piège`, nbr.serpentine)) |>
                   dplyr::select(c("année", "Chrysemys picta", "Chelydra serpentina")) |>
                   dplyr::group_by(année) |>
                   dplyr::summarise_all(list(sum))



# 45°16’14’’ N; 72°03’47’’ O
geom <- data.frame(x = 45.270556, y = -72.063056)

datasets <- data.frame(
    original_source = "Patrice Bourgault",
    # org_dataset_id
    creator = "Patrice Bourgault",
    title = "Inventaire de tortues",
    #publisher = ,
    #keywords = c("Tortues, "Série-temporelle"),
    type_sampling = "Piégeage par cage",
    type_obs = "human observation",
    # intellectual_rights
    license = "CC-BY 4.0",
    #owner = ,
    methods = "Piège verveux appâtés de sardines au même endroit à chaque année",
    open_data = FALSE,
    exhaustive = FALSE,
    direct_obs = TRUE,
    centroid = FALSE
    # citation
    #doi = ,
    #citation =
)

#--------------------------------------------------------------------------
# 3. taxa_obs
#--------------------------------------------------------------------------

taxa_obs <- data.frame(colnames(data_timeseries)) |>
             dplyr::rename(scientific_name = "colnames.data_timeseries.") |>
             dplyr::filter(scientific_name %in% c("Chrysemys picta", "Chelydra serpentina")) |>
             dplyr::mutate(scientific_name = stringr::str_to_sentence(scientific_name), rank = NA) |>
             dplyr::mutate(rank = "species")

write.csv(taxa_obs, file = "patrice_bourgault_data/turtle_time_series_bourgault/turtle_taxa_obs_public.csv", row.names = FALSE)

#--------------------------------------------------------------------------
# 4. Table public.time_series
#--------------------------------------------------------------------------
# Format data for time series as a list of data frames
time_series <- data_timeseries |>
                tidyr::pivot_longer(cols = c(`Chrysemys picta`, `Chelydra serpentina`),
                  names_to = "taxon", values_to = "values") |>
                dplyr::mutate(taxon = stringr::str_to_sentence(taxon)) |>
                dplyr::rename(years = "année") |>
                dplyr::mutate(unit = "Number of individuals per 1 trap-nights")

# Add geoms
time_series <- cbind(time_series, geom = rep(sf::st_as_text(sf::st_multipoint(as.matrix(geom))), nrow(time_series)))


# Convert array-like column to string format
array_to_string <- function(col, is_character = FALSE) {
    sapply(col, function(arr) {
        if (is_character) {
            paste0('\'{"', paste(arr, collapse = '","'), '"}\'')
        } else {
            paste0('{', paste(arr, collapse = ','), '}')
        }
    })
}

time_series <- time_series |>
    dplyr::group_by(geom, taxon, unit) |>
    dplyr::summarise(
        years = list(years),
        years = array_to_string(years),
        values = list(values),
        values = array_to_string(values)) |>
    dplyr::relocate(taxon, years, values, unit, geom) |>
    dplyr::glimpse()

write.csv(time_series, file = "patrice_bourgault_data/turtle_time_series_bourgault/turtle_time_series_public.csv", row.names = FALSE)
