#####
#
# Load SIMO simulated output .db and create .csv files for further analysis
# 2020-02-27
#
#####



# READ ME !!!
# 
# To create the .csv output from the .db table, only `Main`` script needs to be run.
# Other scripts in this project as `structure_SIMO_XXX` are executed within this script.

# TO START:

# Put all .db data into one folder 'inputFolder'
# Define the path to the inputFolder, i.e. 'inputFolder = "U:/project/myInput"

# Create new folder to store outputs
# Define the path to output folder to store output files: outputFolder = ""

# If want to use your project directory instead, simply 
# uncomment: inFolder = path, outputFolder = paste0(path, "/", output)



rm(list = ls())  # remove all files in memory

library(dplyr)



### Set the working path to this R-project
path <- paste0(getwd(),"/")

# this allows to store the input databases outsie of project
inputFolder = "U:/projects/2019_windthrowModel/Janita/input"   
outputFolder = "U:/projects/2019_windthrowModel/Janita/output"  

# !!!
#inFolder = path
#outputFolder = paste0(path, "/", output)


### SDEfine the parameters to be loaded
# specify which one:  "CC45"        climate change with RCP scenraio 4.5 
#                     "CC45_SA"     RCP 4.5 and set aside without deadwood extraction (no other management regimes!)
#                     "CC85"        climate change with RCP scenario 8.5 
#                     "CC85_SA"     RCP 8.5 and set aside without deadwood extraction (no other management regimes!)
#                     "without"     no climate change
#                     "without_SA"  no climate change and set aside without deadwood extraction (no other management regimes!)


sim_variant <-  "without" #"CC45"  


### Define the names of the databases (SIMO-output for 10 watersheds) that will be imported
# It is used in the skripts "structure_SIMO_rslDB_FBE.R" and "loadDB.R"
# Read all data in the input folder that end on '.db' 
db_names <- list.files(inputFolder,
                       pattern = ".db$")


#Remove the ending ".db" from the list
db_names <- gsub("_rsu.db", "", db_names)

#db_names <- c("MV_Hartola", 
              # "MV_Kitee", 
              # "MV_Korsnas",
              # "MV_Parikkala",
              # "MV_Pori",
              # "MV_Pyhtaa",
              # "MV_Raasepori",
              # "MV_Simo",
              # "MV_Vaala",
              # "MV_Voyri")


### load some parameter
# Management regimes and their abbreviation, they are merged to the data by the branching group (script loadDB.R)
regime <- read.csv(paste0(path, "params/regimes.csv"), sep = ",", stringsAsFactors = FALSE)


### Restructure the SQL database. 
# The query creates a table called UNIT, which contains indicators over time and under management regimes
#
# !!! Only needed if the DB is loaded for the first time (this may take some time):     "first_load = TRUE"
# !!! For the downloaded watershed data this is already done:                           "first_load = FALSE"


first_load = TRUE #FALSE


### the following lines do not need any changes ###
if(first_load == TRUE){

  # If one of the follwing simulation variants is read ...
  if(sim_variant %in% c("CC45", "CC85", "without")) {
    
    # Run the script with the SQL query for all management regimes
    source(paste0(path, "structure_SIMO_rslDB_FBE.R"))  
  
    } else {
    
      # Otherwise, run the script witht the SQL query for Set aside without deadwood extraction (...SA)
      # This needs a different SQL query, since the database does not contain harvest information
      source(paste0(path, "structure_SIMO_rslDB_SA.R")) # Query 
      
      }

}
###


### Import the restructured SIMO data (from UNIT table) in the R-environment
# It gives a single dataframe for each database named by "rsl_db_names.csv" AND an overall dataframe called "rslt_all.csv"
# Select columns that should be importat from the SQL table UNIT (created before by script structure_SIMO_rslDB)
# An overview on all available SIMO outcomes can be found under: params/Overview_outcomes_SIMO.xlsx

columns <-  paste0("id,
                   year,
                   branch,
                   branch_desc,
                   branching_group,
                   Age,
                   area,
                   cash_flow,
                   V_total_deadwood,
                   BA,
                   V,
                   N,
                   H_dom,
                   D_gm,
                   Harvested_V,
                   Biomass,
                   income_biomass,
                   CARBON_STORAGE")


### !!! CSV files are stored unter output
#
# If data/columns have already been loaded and saved as csv file  under ../output:                csv_exist = TRUE
# If data is loaded for the first time OR "new columns have to be loaded" (takes some time):     csv_exits = FALSE 

# Create vcsv file and export it to output folder
source(paste0(path, "loadDB.R")) 

print("Csv exported. You can load it by 'read.csv()' function")






