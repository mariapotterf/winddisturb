#####
#
# Restructer the SIMO output in the SQLite database (final "UNIT" table)
# 
# !!! ONLY FOR SetAside simulations
# 
# 2020-02-19
#
#####


# Define the SQL queries:
# The following queries are based on a SQL-script from K. Eyvindson (see folder params)
#  -  SQL_Maiju.sql
# They create a final table "UNIT" in the SIMO output database. 
# Table UNIT contains the development of indicators over the time under the different management regimes.



## load libraries
library(RSQLite)



# Queries:
create_table_max_v <- 'CREATE TABLE max_v AS SELECT comp_unit.id AS id,
                       MAX(comp_unit.V) AS max_v FROM comp_unit GROUP BY comp_unit.id'


create_table_UNIT <-    'Create Table UNIT AS SELECT u.*,(select max(stratum.H_dom) From stratum where stratum.data_id = u.data_id) as H_dom, 
                        (select max(stratum.D_gm) From stratum where stratum.data_id = u.data_id) as D_gm, 
                        (select sum(stratum.N) From stratum where stratum.data_id = u.data_id and D_gm >40) as N_where_D_gt_40,
                        (select sum(stratum.N) From stratum where stratum.data_id = u.data_id and D_gm <=40 and D_gm > 35) as N_where_D_gt_35_lt_40,
                        (select sum(stratum.N) From stratum where stratum.data_id = u.data_id and D_gm <=35 and D_gm > 30) as N_where_D_gt_30_lt_35,
                        (select sum(stratum.V) From stratum where stratum.data_id = u.data_id and D_gm >40) as V_where_D_gt_40,
                        (select sum(stratum.V) From stratum where stratum.data_id = u.data_id and D_gm <=40 and D_gm > 35) as V_where_D_gt_35_lt_40,
                        (select sum(stratum.V) From stratum where stratum.data_id = u.data_id and D_gm <=35 and D_gm > 30) as V_where_D_gt_30_lt_35,
                        (select sum(stratum.V) From stratum where stratum.data_id = u.data_id and SP = 5) as V_populus,
                        (select sum(stratum.V) From stratum where stratum.data_id = u.data_id and SP = 6) as V_Alnus_incana,
                        (select sum(stratum.V) From stratum where stratum.data_id = u.data_id and SP = 7) as V_Alnus_glutinosa,
                        (select sum(stratum.V) From stratum where stratum.data_id = u.data_id and SP = 8) as V_o_coniferous,
                        (select sum(stratum.V) From stratum where stratum.data_id = u.data_id and SP = 9) as V_o_decidious,
                        l.data_date, b.branch, b.branch_desc, b.branching_group, 0 as income, 0 as cash_flow,  0 as clearcut, 0 as Harvested_V_log, 
                        0 as Harvested_V_pulp,  0 as Harvested_V,  m.max_v, 0 as income_log, 0 as income_pulp,
                        0 as income_log_change,  0 as income_pulp_change, 0 as income_biomass, 0 as Biomass
                        FROM comp_unit u, data_link l
                        left outer join branch_desc b on l.branch = b.branch and l.id = b.id 
                        cross join max_v m on l.id = m.id
                        WHERE u.data_id=l.data_id and max_v <1000
                        ORDER BY u.id, l.branch, l.data_date'


##### For each "db_names", defined in main.R ...


for (name in db_names){
  
  # Create connection 
  db_names_path = paste(inputFolder, paste0(name, "_rsu.db"), sep = "/")
  con <- dbConnect(dbDriver("SQLite"), dbname = db_names_path)
  
  # If the following tables already exist, for which the query is defined, remove them
  tab_to_delete <- c("OPERS2", "OPERS3", "max_v", "UNIT")
  
  for(i in tab_to_delete){
    if(dbExistsTable(con, i)) {dbRemoveTable(con, i)}
  }
  
  # Run the Queries and create the final table "UNIT", 
  # which contains the development of all stands and indicators under the simulated management regimes 
  query_to_run <- c(create_table_max_v, create_table_UNIT)
  
  for(i in query_to_run){
    dbExecute(con, i)
  }
  
  dbDisconnect(con)
  
  rm(query_to_run, tab_to_delete, con)
}

rm(create_table_max_v, create_table_UNIT)




