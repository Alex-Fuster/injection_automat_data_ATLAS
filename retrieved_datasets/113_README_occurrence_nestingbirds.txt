This README file was generated on 2021-05-12 by Éliane Duchesne


GENERAL INFORMATION

1. Author information

	Éliane Duchesne1,2*, Jean-François Lamarre1,2,3, Gilles Gauthier2,4, Dominique Berteaux1,2,5,6, Dominique Gravel2,6,7,8, Joël Bêty1,2,5,6*. 2021. Variable strength of predator-mediated effects on species occurrence in an arctic terrestrial vertebrate community. Ecography.

	1 Département de biologie, chimie et géographie, Université du Québec à Rimouski, Rimouski, G5L 3A1, Canada.
	2 Center for Northern Studies, Laval University, Quebec, G1V 0A6, Canada.
	3 Science and technology program, Polar Knowledge Canada, Cambridge Bay, Nunavut, X0B 0C0, Canada.
	4 Département de biologie, Université Laval, Quebec, G1V 0A6, Canada.
	5 Chaire de recherche du Canada en biodiversité nordique, Université du Québec à Rimouski, Rimouski, G5L 3A1, Canada
	6 Quebec Centre for Biodiversity Science, McGill University, Montreal, H3A 1B1, Canada.
	7 Département de biologie, Université de Sherbrooke, Sherbrooke, J1R 2R1, Canada.
	8 Chaire de recherche du Canada en écologie intégrative, Université de Sherbrooke, Sherbrooke, J1K 2R1, Canada.
	
	* Corresponding authors: eliane_duchesne@uqar.ca, joel_bety@uqar.ca

2. Geographic location of data collection: Sirmilik National Park, Bylot Island, Nunavut, Canada. 



DATA & FILE OVERVIEW

1. Data description: 

	This dataset contains the data used in each of the models presented in the article "Variable strength of predator-mediated effects on species occurrence in an arctic terrestrial vertebrate community" published in Ecography (doi: 10.1111/ecog.05760). These data are the processed values (as described in the methods section and supporting information of the article) used to model the effects of lemming density and distance to a goose colony on occurrence of various nesting birds. Mapped data is available in supporting information of the article.


	occurrence_nestingbirds.csv – This file includes the data used for modelling the probability of occurrence of nesting birds along a transect or in a suitable nesting zone as a function of lemming density and distance to the snow goose colony. The occurrence of each nesting bird species is modelled separately, using generalized linear mixed models. Data include presence/absence data of nesting birds in the sampled transects and suitable nesting zones. All transects and nesting zones are located in a study area of Bylot island south plain. In the models, the probability of occurrence of nesting birds along a transect or in a suitable nesting zone is a function of scaled distance to the goose colony (sdist_colony) and binomial lemming density (lemmingsHL).


2. Variables description: 

	- year - Sampling year
	- sampling_unit - Method used to sample nesting birds: transect or nesting_zone
	- sampling_unit_id - Unique id for each transect and nesting zone
	- species - Species for which probability of occurrence in a samplung unit can be modelled separately. The species names are four letter codes from the American Ornithologists Union (https://www.pwrc.usgs.gov/bbl/manual/speclist.cfm).
	- dist_colony - Distance between the sampling unit and the centroid of the goose colony (in km)
	- sdist_colony - Distance between the sampling unit and the centroid of the goose colony in km scaled with the standard deviation
	- lemmings - Annual lemming density (nb lemmings / ha) estimated with capture-recapture. For details of the method, see Fauteux et al. 2015.
	- lemmingsHL - Binomial lemming density (high or low). high >= 1.3 lemmings/ha, low <= 0.3 lemmings/ha.
	- pa - Presence = 1 or absence = 0 along the transect or in the nesting zone
	- inaccessible_nest_rlha - Zones containing an inaccessible nest cup. Used to exclude zones with inaccessible nest cups from models for rough-legged hawk (rlha). Y = contains at least one inaccessible nest cup, N = does not contain an inaccessible nest cup, NA = not applicable for other species.


Cited references:
Fauteux, D. et al. 2015. Seasonal demography of a cyclic lemming population in the Canadian Arctic. - J. Anim. Ecol. 84: 1412–1422.


Check out the open-access article (doi: 10.1111/ecog.05760) for details on the data collection, processing and analyses, or email us if you have a question. 
