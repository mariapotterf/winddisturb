

# Investigate the windtjrows outputs
# create polots of stand structure behaviour over years 
# in total 10 stands
# investigate the wind and no wind scenarios: 
# subset the standid from the no wind scenarios - 
# likely have different number of columns  

# wind happened: 

# 1 – wind occurrence in 2066 
# 2 – wind occurrence in 2046 & 2081 
# 3 - wind occurrence in 2046, 2066 & 2091

# 2020/02/23 - new data with updates BA and Volume: "rslt_withoutCC_WIND_V2_all.csv"

# ---------------------

# 
rm(list = ls())


library(ggplot2)
library(dplyr)
library(tidyr)
library(rgdal)


# Set working directory
setwd("U:/projects/2019_windthrowModel/Janita/outSimulated")

df.wind <- read.csv("rslt_withoutCC_WIND_V2_all.csv", sep = ";")  #  previous: rslt_withoutCC_WIND_all.csv

#df.wind <- read.csv("rslt_withoutCC_WIND_all.csv", sep = ";")  
df.no.w <- read.csv("rsl_without_MV_Korsnas.csv", sep = ";")  # without == climate change is not included


# Read all stands geometry:
stands.all = readOGR(dsn = getwd(),
                    layer = "MV_Korsnas")

# Get the standid of uqinue stands:
# subset the shapefiles - only 10 stands
stands.wind <- unique(df.wind$id)


# Subset only geometry selected stands
stands10 <- subset(stands.all, standid %in% stands.wind )


# Plot stand geometry
windows()
plot(stands.all)
plot(stands10, add = T, col = "red")

# Get to know the datasets:

# How many stands are there?
unique(df.wind$id)  # 10 stands
unique(df.no.w$id)  # 297 stands

# How many managament regimes?
unique(df.wind$regime)  # 22
unique(df.no.w$regime)  # 22

# [1] SA         BAUwoT_m20 CCF_1      CCF_2      BAU_m5     CCF_3      BAU       
# [8] BAUwGTR    BAUwoT     CCF_4      BAU_5      BAU_10     BAUwoT_10  BAU_15    
# [15] BAU_30     BAUwT      BAUwT_GTR  BAUwT_m5   BAUwT_5    BAUwT_10   BAUwT_15  
# [22] BAUwT_30  

dim(df.wind)
dim(df.no.w)


range(df.wind$year)  # 2016-2011: 95 yrs
range(df.no.w$year)  # 2016-2011: 95 yrs

# Check what columns are different??
setdiff(names(df.wind), names(df.no.w))

#[1] "Carb_flux_nat_wd_nrg"        "Carbon_flux_natural_rm_wind"


# CHeck the number of wind scenarios:
unique(df.wind$gpkg)

length(unique(df.wind$gpkg))



# Add the new columns to the no wind scenario
df.no.w$Carb_flux_nat_wd_nrg <- NA
df.no.w$Carbon_flux_natural_rm_wind <- NA


# Seems that there are differences in input data???
# ==================================================
length(unique(df.no.w$id))
length(unique(df.no.w$AREA ))
nrow(df.no.w)



# geometry stands.all has 302 unique stands
# but df.no.w has only 297, and only 275 unique AREA????






# subset the stands from whole Korsnas dataset (no wind scenario)
sub.df.no.w <-
  df.no.w %>% 
  filter(id %in% stands.wind) 



# Add indication of wind regime to NO wind and 2x wind scenario
df.wind.out <-
  df.wind %>% 
  separate(gpkg, c("gpkg", "windFreq"), "s_") %>% # !!!!! because multiple _ _  was used in the name, need restructre the string back!!
  mutate(gpkg = replace(gpkg, gpkg == "MV_Korsna", "MV_Korsnas")) 

# ad the noWind factor to NO wind scenario
sub.df.no.w$windFreq <- "noWind"

# Reorder the dataframe columns into the same order
sub.df.no.w <- sub.df.no.w[names(df.wind.out)]



# Check how many regimes are by every stand id???
# i.e. execuletd by eaevry stand???
table(df.wind.out$id, df.wind.out$regime)





# Merge dataframes together 
# --------------------------
df<- rbind(sub.df.no.w, df.wind.out)

str(df)


# Subset data only for BAU
df.wind.bau <- subset(df, regime == "BAU")
df.wind.sa <- subset(df, regime == "SA")



# Understand how do the wind and no wind scenarios differ between in BA, volume etc??
# ---------------------
windows()

addLines = geom_vline(xintercept = c(wind.yrs), linetype="dotted", 
                      color = "grey", size=1) 

my.theme = 
  theme(axis.text.x = element_text(angle = 90)) + 
  theme_light()

ggplot(subset(df.wind.bau, id == "12469490"), 
       aes(x = year,
           y = BA,
           color = windFreq,
           group = windFreq)) +                 # check BA = basal area???
   geom_line() +               # the lines overlap each other: have the same BA under two wind regimes
  addLines +
  my.theme


# Indicate years of windthrows:   
wind.yrs = c(2046, 2066, 2081, 2091)



ggplot(subset(df.wind.sa, id == "12469490"), 
       aes(x = year,
           y = BA,
           color = windFreq,
           group = windFreq)) +                 # check BA = basal area???
  geom_line() +               # the lines overlap each other: have the same BA under two wind regimes
  addLines +
  my.theme



ggplot(subset(df.wind.sa, id == "12469490"), 
       aes(x = year,
           y = Age,
           color = windFreq,
           group = windFreq)) +                 # check BA = basal area???
  geom_line() +               # the lines overlap each other: have the same BA under two wind regimes
  addLines +
  my.theme






# very little differences between the wind scenarios, but there are some
ggplot(df.wind.bau, 
       aes(x = year,
           y = BA,
           color = windFreq,
           group = windFreq)) +                 # check BA = basal area???
  geom_line() +
  facet_grid(.~id) +
  addLines +
  my.theme


# maybe larger differences between individual management regimes??
ggplot(subset(df, id == "12469490" & regime == "BAU"),  # df 
       aes(x = year,
           y = Age,
           color = windFreq,
           group = windFreq)) +                 # check BA = basal area???
  geom_line() +
  geom_vline(xintercept = c(wind.yrs), linetype="dotted", 
             color = "grey", size=1) +
  facet_grid(windFreq~id) +
  my.theme



# It seems that BA differs between the regimes at first year???
df.current<- subset(df, year == 2016 & regime == "SA", select = c("id", "gpkg", "BA", "V", "Carbon_flux_natural_rm_wind", "windFreq", "regime"))


# the stands 12469490, 12469491, 12469563 has different BA, V in noWind and wind scenarios. Why?? Heck other parametes, 
# maybe just the colums were switched??
subset(df, year == 2016 & regime == "SA" & id == "12469490")

# The aga has multiple parameters!!!  # stand 12469488 has the same BA values, will it have the same age??
subset(df, year == 2016 & regime == "SA" & id == "12469488")    


# =============================
# Check 
# =============================
# 

# Are the differences between noWind and Wind in Age, BA, V,... consistent between two wind input data?
# -   YES, why NoWind and Wind input data differs??

# why the BRANCH description is missing??
# -  seems to miss from both NO wind and Wind??


unique(df$branch)
unique(df$branch_desc)
unique(df$branching_group)





# CHeck the values of BA, V by wind regime??
df.current %>% 
  arrange(id)

length(unique(df.current$BA))

# no differences

# check age:
ggplot(df, 
       aes(x = year,
           y = Age,
           color = windFreq,
           group = windFreq)) +                 
  geom_line() +
  facet_grid(regime~id) +
  my.theme

# Age varies in CCF

# Kyle indicated changes in Carb_flux_nat_wd_nrg

# subset by vector of management regimes:
unique(df$regime)



regimes.sub <- c("SA", "BAU", "CCF_3") # , "BAUwGTR", "BAUwoT"



ggplot(subset(df, regime %in% regimes.sub), 
       aes(x = year,
           y = Age, # 
           color = windFreq,
           group = windFreq)) +                 
  geom_line() +
  facet_grid(regime~id) +
  my.theme


# having strange output, very linear; however changes at indicated dates


ggplot(df.wind, 
       aes(x = year,
           y = Carbon_flux_natural_rm_wind,
           color = windFreq,
           group = windFreq)) +                 
  geom_line() +
  facet_grid(regime~id) +
  my.theme


# Check the initial stand age:

ggplot(subset(df, year == 2016),  
       aes(x = Age)) +
  geom_histogram() + facet_grid(.~id)


ggplot(subset(df, year == 2111),  
       aes(x = Age)) +
  geom_histogram() + facet_grid(.~id)


# CHeck the age by stands and classes:

subset(df, year == 2016)$Age
