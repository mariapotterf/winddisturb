#####
#
# Import SIMO Results (SQLite-Databases) in R environment 
# and save a dataframe in folder /output
# CB
# 2019-07-12
#
#####



## load libraries
library(RSQLite)
library(tidyr)
library(dplyr)



# Variant 1: create a single dataframe for each SQL Database (selected columns of table UNIT)
# Dataframes are given the names of the DB and column "test" is added with the name of the DB

# Declare the variables that will not change furing For loop
# when set within for loop, they will repeat which will lower calculation speed

# Filter those stands that caused errors during the simulation with SIMO
# import csv file that contains the error stands

error_stands <- read.csv(paste0(path, "params/errors_watersheds.csv"), 
                         sep = ",", header = TRUE, 
                         stringsAsFactors = FALSE)
error_stands$id <- as.character(error_stands$id)


for (name in db_names){
  
  
  # Define connection path
  db_names_path = paste(inputFolder, paste0(name, "_rsu.db"), sep = "/")
  con <- dbConnect(dbDriver("SQLite"), dbname = db_names_path)
  
  # Create query
  rsl  <- dbGetQuery( con, paste0("select ", columns, " from UNIT"))
  rsl$gpkg <- name
  dbDisconnect(con)
  
  ### Add the abbreviation of the regimes
  rsl <- rsl %>% 
    left_join(regime, by = "branching_group", all.x = TRUE)
  
  
  rsl <- rsl %>%
    anti_join(error_stands, by = c("id", "gpkg"))
  
  
  ### Rename set aside scenario if it considers deadwood extraction
  if(sim_variant %in% c("CC45", "CC85", "without")) {
    
   rsl <- rsl %>% mutate(regime = ifelse(regime %in% "SA", "SA_DWextract", regime))
    
  }
  
  outcsvName = paste0("rsl_", name, ".csv")
  write.table(rsl, paste(outputFolder, outcsvName, sep = "/"), sep = ";", row.names = F, col.names = TRUE)
  
  assign( paste("rsl", name, sep="_"), rsl) # unclear role of this??
  
}


# Variant 2: create one huge dataframe combining all SQL databases (selected columns of table UNIT)
# Different DBs are indicated by an additional column "test"

rslt <- NULL

for (name in db_names){
   
  # Define connection path
  db_names_path = paste(inputFolder, paste0(name, "_rsu.db"), sep = "/")
  con <- dbConnect(dbDriver("SQLite"), dbname = db_names_path)
  
  # Define query
  rsl  <- dbGetQuery( con, paste0("select ", columns, " from UNIT"))
  rsl$gpkg <- name
  dbDisconnect(con)
  rslt <- rbind(rslt, rsl)
  
}  

### Add the abbreviation of the regimes
rslt <- rslt %>% 
  left_join(regime, by= "branching_group", all.X = TRUE)


### Rename set aside scenario if it considers deadwood extraction
if(sim_variant %in% c("CC45", "CC85", "without")) {
  
  rslt <- rslt %>% mutate(regime = ifelse(regime %in% "SA", "SA_DWextract", regime))
  
}


rslt <- rslt %>%
  anti_join(error_stands, by = c("id", "gpkg"))

### write table
#write.table(rslt, paste0(path, "output/rslt_", sim_variant, "_all.csv" ), sep = ";", row.names = F, col.names = TRUE)
outcsvName = paste0("rsl_",sim_variant, "_all", ".csv")
write.table(rsl, paste(outputFolder, outcsvName, sep = "/"), sep = ";", row.names = F, col.names = TRUE)




##################################################################
##################################################################



# # First extraction of wind simulated Korsnas data for MSc
# 
# sim_variant <- "without_SA"
# db_names <- c("MV_Korsnas_Wind_1") #  , "MV_Korsnas_Wind_2", "rsu_example2"
# 
# 
# columns <-  paste0("id,
#                    year,
#                    branch,
#                    branch_desc,
#                    branching_group,
#                    Age,
#                    area,
#                    cash_flow,
#                    V_total_deadwood,
#                    BA,
#                    V,
#                    N,
#                    H_dom,
#                    D_gm,
#                    Harvested_V,
#                    Biomass,
#                    income_biomass,
#                    CARBON_STORAGE")
#                     
# 
#                     # Harvested_V_log,
#                     # Harvested_V_log_under_bark,
#                     # Harvested_V_pulp,
#                     # Harvested_V_pulp_under_bark
#                     # V_log,   
#                     # H_gm,
#                     # SINCE_DRAINAGE,
#                     # DRAINAGE_STATUS,
#                     # regen_age,
#                     # SINCE_DRAINAGE_ORIG,
#                     # V_pulp,
#                     # SOIL_CLASS
#                     # Carb_flux_nat_wd_nrg,
#                     # Carbon_flux_natural_rm_wind")
# 
# 
# 
# rslt <- NULL
# 
# for (name in db_names){
#   con <- dbConnect(dbDriver("SQLite"), dbname = paste0(path,"input_data/without_SA_5_stands/simulated_", sim_variant, "_" , name, ".db"))
#   rsl  <- dbGetQuery( con, paste0("select ", columns, " from UNIT"))
#   rsl$gpkg <- name
#   dbDisconnect(con)
#   rslt <- rbind(rslt, rsl)
#   rm(con, rsl)
# }
# 
# rslt <- rslt %>%
#   left_join(regime, by= "branching_group", all.X = TRUE)
# 
# ### write table
# write.table(rslt, paste0(path, "output/rsl_without_SA_MV_Kitee.csv" ), sep = ";", row.names = F, col.names = TRUE)
# 
# rslt <- read.csv(paste0(path, "output/rsl_without_SA_MV_Kitee.csv" ), sep = ";", header = TRUE, stringsAsFactors = FALSE)




# ##################################################################
# ##################################################################
# 
# 
# ##### Getting all Colnames from a SQL querry
#
#
# # was used to create List of SIMO output -> What indicators can be calculate for ES
# 
# con <- conConnect(dbDriver("SQLite"), dbname = paste0(path,"input_data/test/simulated_without_rsu_example2.db"))
# rsl  <- dbGetQuery(con, 'select * from UNIT')
# dbDisconnect(con)
# 
# colnames_without <- colnames(rsl)
# noquote(colnames_without)
# write.table(colnames_FBE, paste0(path,"temp/colnames_FBE.csv"), row.names = FALSE)
# 
# 
# onlyinCC <- colnames_CC45[!colnames_CC45 %in% colnames_without]
