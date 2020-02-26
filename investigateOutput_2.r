

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
setwd("U:/projects/2019_windthrowModel/Janita/outSimulated")


#df.wind <- read.csv("rslt_withoutCC_WIND_all.csv", sep = ";")  
#df.no.w <- read.csv("rsl_without_MV_Korsnas.csv", sep = ";")  # without == climate change is not included

#df.wind <- read.csv("rslt_withoutCC_WIND_V2_all.csv", sep = ";")  #  previous: rslt_withoutCC_WIND_all.csv
#df.no.w <- read.csv("rslt_withoutnoWind_rsu_kyle_all.csv", sep = ";")  # without == climate change is not included


# 2020/02/26 - Pori dataset
df.wind <- read.csv("rslt_withoutCC_WIND_Pori_all.csv",  sep = ";") 
df.no.w <- read.csv( "rsl_without_MV_Pori.csv", sep = ";") 


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
unique(df.wind$id)  # 207 stands
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


# Differences in regimes??
setdiff(unique(df.no.w$regime), unique(df.wind$regime))


# CHeck the number of wind scenarios:
unique(df.wind$gpkg)

length(unique(df.wind$gpkg))


# Add the new columns to the no wind scenario
df.no.w$Carb_flux_nat_wd_nrg <- NA
df.no.w$Carbon_flux_natural_rm_wind <- NA



# Add indication of wind regime to NO wind and 2x wind scenario
df.wind.out <-
  df.wind %>% 
  separate(gpkg, c("gpkg", "windFreq"), "i_") %>% # !!!!! because multiple _ _  was used in the name, need restructre the string back!!
  mutate(gpkg = replace(gpkg, gpkg == "MV_Por", "MV_Pori")) 


# Subset the same stands from the no wind scenario
sub.df.no.w <- subset(df.no.w, id %in% unique(df.wind.out$id))

#ad the noWind factor to NO wind scenario
sub.df.no.w$windFreq <- "noWind"

# Reorder the dataframe columns into the same order
sub.df.no.w <- sub.df.no.w[names(df.wind.out)]



# Check how many regimes are by every stand id???
# i.e. execuletd by eaevry stand???
table(df.wind.out$id, df.wind.out$regime)

table(sub.df.no.w$id, sub.df.no.w$regime)



# Merge dataframes together 
# --------------------------
df<- rbind(sub.df.no.w, df.wind.out)  # SA and SA_DWextract are merged together!!!




# Subset data only for BAU
df.bau <- subset(df, regime == "BAU")
df.ccf1 <- subset(df, regime == "CCF_1")
df.sa <- subset(df, regime == "SA")



# Understand how do the wind and no wind scenarios differ between in BA, volume etc??
# ---------------------
windows()

# Indicate years of windthrows:   
wind.yrs = c(2046, 2066, 2081, 2091)

addLines = geom_vline(xintercept = c(wind.yrs), 
                      linetype="dashed", 
                      color = c("grey","green4", "turquoise3", "purple"),
                      size=0.7) 

my.theme = 
  theme(axis.text.x = element_text(angle = 90)) + 
  #theme_light() +
  theme(# panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "white", colour = "black"), 
        axis.line = element_line(colour = "black"))
  
# panel.grid.major = element_blank()
ggplot(df.bau, 
       aes(x = year,
           y = V_total_deadwood,#BA,
           color = windFreq,
           group = windFreq)) +                 # check BA = basal area???
  geom_line() +               # the lines overlap each other: have the same BA under two wind regimes
  addLines +
  facet_grid(~ windFreq) +
  my.theme







ggplot(subset(df.bau, id == "12469490"), 
       aes(x = year,
           y = V_total_deadwood,#BA,
           color = windFreq,
           group = windFreq)) +                 # check BA = basal area???
   geom_line() +               # the lines overlap each other: have the same BA under two wind regimes
  addLines +
  my.theme



ggplot(subset(df.sa, id == "12469490"), 
       aes(x = year,
           y = BA,
           color = windFreq,
           group = windFreq)) +                 # check BA = basal area???
  geom_line() +               # the lines overlap each other: have the same BA under two wind regimes
  addLines +
  my.theme



# Total Deadwood
# V_total_deadwood
ggplot(subset(df.sa, id == "12469490"), 
       aes(x = year,
           y = V_total_deadwood,
           color = windFreq,
           group = windFreq)) +                 # check BA = basal area???
  geom_line() +               # the lines overlap each other: have the same BA under two wind regimes
  addLines +
  my.theme


windows()
ggplot(subset(df.sa, id == "12469490"), 
       aes(x = year,
           y = Age,
           color = windFreq,
           group = windFreq)) +                 # check BA = basal area???
  geom_line() +               # the lines overlap each other: have the same BA under two wind regimes
  addLines +
  my.theme






# very little differences between the wind scenarios, but there are some
ggplot(df.bau, 
       aes(x = year,
           y = BA,
           color = windFreq,
           group = windFreq)) +                 # check BA = basal area???
  geom_line() +
  facet_grid(windFreq~id) +
  #addLines #+
  my.theme



ggplot(df.ccf1, 
       aes(x = year,
           y = BA,
           color = windFreq,
           group = windFreq)) +                 # check BA = basal area???
  geom_line() +
  facet_grid(windFreq~id) +
  #addLines #+
  my.theme






# maybe larger differences between individual management regimes??
ggplot(subset(df, id == "12469490" & regime == "BAU"),  # df 
       aes(x = year,
           y = V_total_deadwood,
           color = windFreq,
           group = windFreq)) +                 # check BA = basal area???
  geom_line() +
  geom_vline(xintercept = c(wind.yrs), linetype="dotted", 
             color = "grey", size=1) +
  facet_grid(windFreq~id) +
  my.theme



# Create 4 plots to export



# --------------------------------------


# H, V, deadwood, carbon
sa<- ggplot(subset(df, id == "12469152" & regime == "SA"),  # df 
       aes(x = year,
           y = V_total_deadwood,
           color = windFreq,
           group = windFreq)) +                 # check BA = basal area???
  geom_line(lwd = 1) +
  addLines +
  my.theme



H_dom_CCF<- ggplot(subset(df, id == "12469152" & regime == "CCF_1"),  # df 
            aes(x = year,
                y = H_dom,
                color = windFreq,
                group = windFreq)) +                 # check BA = basal area???
  geom_line(lwd = 1) +
  addLines +
  my.theme



volume <- ggplot(subset(df, id == "12469152" & regime == "CCF_1"),  # df 
                   aes(x = year,
                       y = V,
                       color = windFreq,
                       group = windFreq)) +                 # check BA = basal area???
  geom_line(lwd = 1) +
  addLines +
  my.theme



carb <- ggplot(subset(df, id == "12469152" & regime == "SA"),  # df 
                 aes(x = year,
                     y = Carbon_flux_natural_rm_wind,
                     color = windFreq,
                     group = windFreq)) +                 # check BA = basal area???
  geom_line(lwd = 1) +
  addLines +
  my.theme



# Export 4 plots
ggarrange(sa, H_dom_CCF, volume, carb,
          labels = c("SA deadwood - OK", "H CCF_1 - too height??", "Volume_CCF_1 - high??", "Carbon SA - linear?"),
          hjust = -0.3, 
          vjust = 1.5,
          ncol = 2, nrow = 2,
          common.legend = TRUE, legend = "right")













# It seems that BA differs between the regimes at first year???
df.current<- subset(df, year == 2016 & regime == "SA", 
                    select = c("id", "gpkg", "BA", "V", "Carbon_flux_natural_rm_wind", "windFreq", "regime", "AREA"))


# the stands 12469490, 12469491, 12469563 has different BA, V in noWind and wind scenarios. Why?? Heck other parametes, 
# maybe just the colums were switched??
subset(df, year == 2016 & regime == "SA" & id == "12469490")

# The aga has multiple parameters!!!  # stand 12469488 has the same BA values, will it have the same age??
subset(df, year == 2016 & regime == "SA" & id == "12469488")    




# CHeck the values of BA, V by wind regime??
df.current %>% 
  arrange(id)

length(unique(df.current$BA))

# no differences

# check age:
ggplot(df, 
       aes(x = year,
           y = V_total_deadwood, #Age,
           color = windFreq,
           group = windFreq)) +                 
  geom_line() +
  facet_grid(regime~id) +
  my.theme

# Age varies in CCF

# How much timber is damaged in each wind??
# should be equal to V_total_deadwood?
# ==========================================


# CHeck tommorow!!

#df %>% 
#  group_by(id, regime) #%>% 
 # dplyr::mutate(V.lag = round(V - lag(V = 0),2))
# mutate does not work



# subset by vector of management regimes:
unique(df$regime)



regimes.sub <- c("SA", "BAU", "CCF_1", "BAUwGTR") # , "BAUwGTR", "BAUwoT"



ggplot(subset(df, regime %in% regimes.sub), 
       aes(x = year,
           y = Carbon_flux_natural_rm_wind, #Harvested_V,#N, #V, #BA, #V_total_deadwood, # 
           color = windFreq,
           group = windFreq)) +                 
  geom_line() +
  facet_grid(regime~id) +
  my.theme


windows()
ggplot(subset(df, regime %in% regimes.sub), 
       aes(x = year,
           y = V_total_deadwood, #CARBON_STORAGE,#Biomass,#V_total_deadwood, #H_dom, #D_gm, #H_dom, #BA, #V_total_deadwood, # 
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
