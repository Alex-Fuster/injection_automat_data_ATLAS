This README.txt file was generated on 2021-09-10 by Marc J. Mazerolle



GENERAL INFORMATION

Title of Dataset: 
Data for the detection of the boreal chorus frog (Pseudacris maculata) using environmental DNA and call surveys at 180 ponds sampled in 2017-2018 in southeastern Québec, Canada.


Author Information
Principal Investigator Contact Information
Name:
Marc J. Mazerolle

Institution:
Université Laval

Address:
Département des sciences du bois et de la forêt, 2405 rue de la Terrasse, Université Laval, Québec, Québec G1V 0A6, Canada

Email:
marc.mazerolle@sbf.ulaval.ca


Dates of data collection:
2017-05-16 -- 2017-06-19
2018-04-20 -- 2018-06-08


Geographic location of data collection:
Montérégie, Québec, Canada 


Information about funding sources that supported the collection of the data: 
Fondation de la Faune du Québec



SHARING/ACCESS INFORMATION
Links to publications that cite or use the data: 
Dubois-Gagnon, M.-P., Bernatchez, L., Bélisle, M., Dubois, Y., Mazerolle, M. J. 2021. Distribution of the boreal chorus frog (Pseudacris maculata) in an urban environment using environmental DNA. Environmental DNA.


Recommended citation for this dataset: 
Mazerolle, M. J., Dubois-Gagnon, M.-P., Bernatchez, L., Bélisle, M., Dubois, Y. (2021) Data for the detection of the boreal chorus frog (Pseudacris maculata) using environmental DNA and call surveys at 180 ponds sampled in 2017-2018 in southeastern Québec, Canada. 



DATA & FILE OVERVIEW
File List: 
README.txt (this file):
metadata of the data files

detectData180eDNA.csv:
Data for the first and second visits conducted to sample eDNA of the boreal chorus frog (Pseudacris maculata) used to estimate site occupancy by the species at 180 sites sampled in 2017-2018 in southeastern Québec, Canada

siteCovariateData180eDNA.csv:
Habitat and landscape variables of 180 sites sampled in 2017--2018 for the boreal chorus frog (Pseudacris maculata) used to estimate site occupancy by the species in southeastern Québec, Canada

detectData-eDNA-Acoustic.csv:
Detection data for the 63 sites sampled with eDNA and call surveys to detect the boreal chorus frog (Pseudacris maculata) in 2018 in southeastern Québec, Canada


Relationship between files: 
Data in files detectData180eDNA.csv and siteCovariateData180eDNA.csv are used for the analysis of the distribution of the boreal chorus frog (Pseudacris maculata) relative to pond and landscape-level variables based on eDNA data collected during the breeding season of the species.

Data in files detectData-eDNA-Acoustic.csv and siteCovariateData180eDNA.csv are used to compare the efficiency of eDNA vs call surveys to detect boreal chorus frogs (Pseudacris maculata) during the breeding season.



METHODOLOGICAL INFORMATION
Description of methods used for collection of data: 
Full description of the data collection protocol and the extraction of genetic information are presented in Dubois-Gagnon et al. 2021:
Dubois-Gagnon, M.-P., Bernatchez, L., Bélisle, M., Dubois, Y., Mazerolle, M. J. 2021. Distribution of the boreal chorus frog (Pseudacris maculata) in an urban environment using environmental DNA. Environmental DNA.



DATA-SPECIFIC INFORMATION FOR: detectData180eDNA.csv
Number of variables:
7

Number of rows:
201

Variable List: 
PondID:  unique identifier for pond sampled
Detect1: detection data from first visit at site sampled for boreal chorus frog  with eDNA (0=not detected, 1=detected)
Detect2: detection data from second visit at site sampled for boreal chorus frog  with eDNA (0=not detected, 1=detected)
Snowday1:  sampling date of first visit to pond, expressed as number of days since snowmelt
Snowday2:  sampling date of second visit to pond, expressed as number of days since snowmelt
Volume1:  total volume of water sampled during first visit, expressed as liters
Volume2:  total volume of water sampled during first visit, expressed as liters

Missing data codes: 
blank space



DATA-SPECIFIC INFORMATION FOR: siteCovariateData180eDNA.csv
Number of variables:
27

Number of rows:
201

Variable List: 
PondID:  unique identifier for pond sampled
Year:  year of sampling
Hist.presence:  binary variable indicating whether the site had been known to be occupied by the species at least once between 2004 and 2016
Veg1:  PCA scores of vegetation cover data on first axis 
Dry:  binary variable indicating whether pond dried up completely during the summer (0=no, 1=yes)
Dist.road:  distance between pond and closest road, expressed in m
Dist.anthropic:  distance between pond and closest anthropic area, expressed in m
Wetland.cover200:  proportion of wetland area within buffer of 200 m around pond
Forest.cover200:  proportion of forest area within buffer of 200 m around pond
Open.habitat.cover200:  proportion of open area within buffer of 200 m around pond
Anthropic.cover200:  proportion of anthropic area within buffer of 200 m around pond
Road.density200:  density of roads within buffer of 200 m around pond, expressed in m/ha
Wetland.cover500:  proportion of wetland area within buffer of 500 m around pond
Forest.cover500:  proportion of forest area within buffer of 500 m around pond
Open.habitat.cover500:  proportion of open area within buffer of 500 m around pond
Anthropic.cover500:  proportion of anthropic area within buffer of 500 m around pond
Road.density500:  density of roads within buffer of 500 m around pond, expressed in m/ha
Wetland.cover1000:  proportion of wetland area within buffer of 1000 m around pond
Forest.cover1000:  proportion of forest area within buffer of 1000 m around pond
Open.habitat.cover1000:  proportion of open area within buffer of 1000 m around pond
Anthropic.cover1000:  proportion of anthropic area within buffer of 1000 m around pond
Road.density1000:  density of roads within buffer of 1000 m around pond, expressed in m/ha
Wetland.cover1500:  proportion of wetland area within buffer of 1500 m around pond
Forest.cover1500:  proportion of forest area within buffer of 1500 m around pond
Open.habitat.cover1500:  proportion of open area within buffer of 1500 m around pond
Anthropic.cover1500:  proportion of anthropic area within buffer of 1500 m around pond
Road.density1500:  density of roads within buffer of 1500 m around pond, expressed in m/ha


Missing data codes: 
blank space



DATA-SPECIFIC INFORMATION FOR: detectData-eDNA-Acoustic.csv
Number of variables:
4

Number of rows:
64

Variable List: 
PondID:  unique identifier for pond sampled
eDNA: detection data from visit at site sampled for boreal chorus frog using eDNA (0=not detected, 1=detected)
Acoustic: detection data from visit site sampled for boreal chorus frog using call surveys (0=not detected, 1=detected)
Snowday:  sampling date of visit to pond during which both sampling methods were used, expressed as number of days since snowmelt


Missing data codes: 
blank space

