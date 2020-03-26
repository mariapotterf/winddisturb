

# Investigate the windtrows outputs
# create plots of stand structure behaviour over years 
# in total 10 stands
# investigate the wind and no wind scenarios: 
# subset the standid from the no wind scenarios - 
# likely have different number of columns  

# wind happened: 

# 1 – wind occurrence in 2066 
# 2 – wind occurrence in 2046 & 2081 
# 3 - wind occurrence in 2046, 2066 & 2091

# 2020/02/23 - new data with updates BA and Volume: "rslt_withoutCC_WIND_V2_all.csv"
# 2020/02/26 - new data for Pori

# ---------------------

# 
rm(list = ls())


library(ggplot2)
library(dplyr)
library(tidyr)
library(rgdal)
library(ggpubr)


# Set working directory
# setwd("U:/projects/2019_windthrowModel/Janita/outSimulated")
setwd("U:/projects/2019_windthrowModel/wind_1_cPouta")



# 2020/03/06 - Korsnas
#df.wind <- read.csv("rsl_wind_Korsnas_all_20200306.csv",  sep = ";") 
#df.no.w <- read.csv("rsl_without_MV_Korsnas.csv", sep = ";")


# 2020/03/26
# Test wind_1 from C poutas
# splitted data by the dbs by 15 stands
df.wind <- read.csv("rsl_without_Korsnas_all.csv",  sep = ";") 


# Read all stands geometry:
#stands.all = readOGR(dsn = getwd(),
 #                   layer = "MV_Korsnas")

# Get the standid of uqinue stands:
# subset the shapefiles - only 10 stands
#stands.wind <- unique(df.wind$id)


# Subset only geometry selected stands
# stands10 <- subset(stands.all, standid %in% stands.wind )


# Plot stand geometry
#windows()
#plot(stands.all)
#plot(stands10, add = T, col = "red")

# Get to know the datasets:

# How many stands are there?
unique(df.wind$id)  # 10 stands
unique(df.no.w$id)  # 207 stands

# How many managament regimes?
unique(df.wind$regime)  # 22
unique(df.no.w$regime)  # 22

# !!!! there is SA and "SA_DWextract" regimes!! now I will consider them as same regime

range(df.wind$year)  # 2016-2111: 95 yrs
range(df.no.w$year)  # 2016-2111: 95 yrs

# Check what columns are different??
setdiff(names(df.wind), names(df.no.w))

#[1] "Carb_flux_nat_wd_nrg"        "Carbon_flux_natural_rm_wind"


# Differences in regimes?? comare a & b, b & a - lead to different elements
setdiff(unique(df.no.w$regime), unique(df.wind$regime))

setdiff(unique(df.wind$regime), unique(df.no.w$regime))

# CHeck the number of wind scenarios:
unique(df.wind$gpkg)

# "SA_DWextract"
length(unique(df.wind$gpkg))
# "SA"

# Add the new columns to the no wind scenario
df.no.w$Carb_flux_nat_wd_nrg <- NA
df.no.w$Carbon_flux_natural_rm_wind <- NA


# Add indication of wind regime to NO wind and 2x wind scenario
df.wind.out <-
  df.wind %>% 
  separate(gpkg, c("gpkg", "windFreq"), "s_") %>% # !!!!! because multiple _ _  was used in the name, need restructre the string back!!
  mutate(gpkg = replace(gpkg, gpkg == "MV_Korsna", "MV_Korsnas")) 


# Subset the same stands from the no wind scenario
sub.df.no.w <- subset(df.no.w, id %in% unique(df.wind.out$id))

#ad the noWind factor to NO wind scenario
sub.df.no.w$windFreq <- "noWind"


# Reorder the dataframe columns into the same order
sub.df.no.w <- sub.df.no.w[names(df.wind.out)]


# Change the sub.df.no.w "SA_DWextract" to "SA"
sub.df.no.w$regime <- plyr::revalue(sub.df.no.w$regime, c("SA_DWextract"="SA"))


# Check how many regimes are by every stand id???
# i.e. execuletd by eaevry stand???
table(df.wind.out$id, df.wind.out$regime)

table(sub.df.no.w$id, sub.df.no.w$regime)



# Merge dataframes together 
# --------------------------
df<- rbind(sub.df.no.w, df.wind.out)  # SA and SA_DWextract are merged together!!!

df$id<- as.factor(df$id)



# Subset data only for BAU
df.bau <- subset(df, regime == "BAU")
df.ccf1 <- subset(df, regime == "CCF_1")
df.sa <- subset(df, regime == "SA_DWextract")



# Understand how do the wind and no wind scenarios differ between in BA, volume etc??
# ---------------------
windows()

my.theme = 
  theme(axis.text.x = element_text(angle = 90)) + 
  #theme_light() +
  theme(# panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "white", colour = "black"), 
    axis.line = element_line(colour = "black"))


# Indicate years of windthrows:   
wind.yrs = c(2046, 2066, 2081, 2091)

addLines = geom_vline(xintercept = c(wind.yrs), 
                      linetype="dashed", 
                      color = c("grey","green4", "turquoise3", "purple"),
                      size=0.7) 



# Investigate whole dataset:

# panel.grid.major = element_blank()
ggplot(df, 
       aes(x = year,
           y = H_dom,
           color = id,
           group = id)) +                 # check BA = basal area???
  geom_line() +               # the lines overlap each other: have the same BA under two wind regimes
  
  facet_grid(~ windFreq) +
  #addLines +
  my.theme


my.stand = "12469142" #   "12469153" 

# panel.grid.major = element_blank()
ggplot(subset(df.ccf1, id == my.stand), 
       aes(x = year,
           y = V, #BA,#V_total_deadwood,#BA,
           color = id,
           group = id)) +                 # check BA = basal area???
  geom_line() +               # the lines overlap each other: have the same BA under two wind regimes
  geom_vline(xintercept = c(wind.yrs), 
             linetype="dashed", 
             #color = c("grey","green4", "turquoise3", "purple"),
             size=0.7) +
  facet_grid(~ windFreq) +
  my.theme






# panel.grid.major = element_blank()
ggplot(subset(df.sa, id == my.stand), 
       aes(x = year,
           y = H_dom, # V, #BA,#V_total_deadwood,#BA,
           color = id,
           group = id)) +                 # check BA = basal area???
  geom_line() +               # the lines overlap each other: have the same BA under two wind regimes
  geom_vline(xintercept = c(wind.yrs), 
             linetype="dashed", 
             #color = c("grey","green4", "turquoise3", "purple"),
             size=0.7) +
  facet_grid(~ windFreq) +
  my.theme






