# Formatting data of retrieved datasets from automated search algorythims for injection into ATLAS

Temporary repository to process the retrieved datasets from automated search algorythms to inject them into the ATLAS database

**Naming guide:**  "ID_name_tablename"

-> ID: ID given by column "ID" in **df_repository.xlsx**.

-> name: name given by us to the dataset (e.g. Leblond2013)

-> tablename: name of the table in ATLAS that the data refers to (e.g. taxa_obs)


**df_repository.xlsx** is the raw list and metadata of retrieved datasets. It contains the column "ID" indicating the ID for each dataset, which is used for naming the files in "retrieved_datasets" folder.

Folder **retrieved_datasets** contains all the files for each dataset. Each file name contains the ID of its the dataset, followed by its original name.

Folder **scripts** contains an script per dataset to process the data and produce the tables to inject in ATLAS, stored in the folder **ouptut_tables**.
