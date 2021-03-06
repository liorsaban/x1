#In the next paragraph there is a code that creates
#a new folder in "c:" called "L_E_SAVEHERE".
#You must run the code until this paragraph (#~>)
#save the Attached csv file in this folder  
#If there is a folder with this name on your computer
#it will not be deleted,
#but the graphs generated by this code will be saved in this folder
######################################################################

#Install packages
#install.packages(dplyr)
#install.packages("fastmatch")
#install.packages("gridExtra")
#install.packages(data.table)
#install.packages("tidyverse")

#Libraries
library(dplyr)
library(fastmatch)
library(data.table)
library(RColorBrewer)
library(ggplot2)
library(gridExtra)
library(grid)
library(gtable)
######################################################################

#creating a new folder for data & outpot
dir="C:/L_E_SAVEHERE"
if (!dir.exists(dir)){
  dir.create(dir)
} else {
  print("Dir already exists!")
}
#~>#~>#~>#~>#~>#~>#~>#~>#~>#~>#~>#~>#~>#~>#~>#~>#~>#~>#~>#~>#~>#~>

#Reading the csv file To create the Research database.
#!!!! store the Attached csv file in "C:/L_E_SAVEHERE" !!!

municipal_data_15=read.csv("C:/L_E_SAVEHERE/municipal_data_15.csv")
######################################################################

#Creating a database that contains only Settlement  
municipal_data_big=municipal_data_15
x=as.numeric(fmatch("total_entities_council_2015",names(municipal_data_big)))
municipal_data_big[,x][is.na(municipal_data_big[,x])]=0
municipal_data_big=municipal_data_big[-which(municipal_data_big$total_entities_council_2015>0), ]
rm(x)
######################################################################

#Create a new variable containing the standard deviation for the various land uses
#Using the 'apply' function requires the column numbers of the variables
#Create a vector containing the column numbers using dplyr & fmatch
colnames_uses_land= colnames(municipal_data_big %>% dplyr:: select(ends_with("pct_of_all_area_jurisdiction")))
colnumbers_uses_land=fmatch(colnames_uses_land,names(municipal_data_big))
#Setting the variable "uses_land_sd"
municipal_data_big$uses_land_sd=apply(municipal_data_big[,colnumbers_uses_land], 1, sd,na.rm=TRUE)
municipal_data_big=municipal_data_big[with(municipal_data_big,order(-uses_land_sd)),]
municipal_data_big$uses_land_sd=c(1:201)
rm(colnumbers_uses_land)
######################################################################

#Re-rating the indexes (Better adjustment to the research question)
#"distance_tel_aviv"&"index_peripheral" Were adjusted
municipal_data_big=municipal_data_big[with(municipal_data_big,order(-index_compact_2006_rating_from_1_to_197_1_compact_most)),]
fmatch("fingerprint",names(municipal_data_big))
municipal_data_big$index_compact_2006_rating_from_1_to_197_1_compact_most=c(1:201)
######################################################################
#subseting the database so it contains only 50 most population Settlement  
municipal_data_big=municipal_data_big[with(municipal_data_big,order(-total_population_end_2015_1000s)),]
municipal_data_big=municipal_data_big[1:50,]

#Delete columns without information
emptycols=colSums(is.na(municipal_data_big))==nrow(municipal_data_big)
municipal_data_big=municipal_data_big[!emptycols]
rm(emptycols)

#subseting the database so it contains only the research variables
my_vars_names=c("fingerprint",
                "age_avg_of_transportation_private_years_2015",
                "balance_immigration_total_2015",
                "beginning_construction_area_residential_1000s_m2_2015",
                "beginning_construction_number_flats_2015",
                "beginning_of_paving_roads_new_enlargement_repairing_of_roads_length_km_2015",
                "cars_private_total_2015",
                "deaths_2015",
                "density_population_area_build_residential_person_per_km3_2013",
                "index_peripheral_2004_rating_by_ingredients_rating_closeness_to_border_district_tel_aviv_from_1_to_252_1_farthest_most",
                "expenses_of_municipality_for_activities_pct_change_real_2015_vs_2014",
                "income_avg_monthly_of_freelancers_in_2014_nis",
                "incoming_from_places_other_total_2015",
                "index_compact_2006_rating_from_1_to_197_1_compact_most",
                "index_peripheral_2004_rating_by_ingredients_rating_index_accessibility_potential_from_1_to_252_1_accessibility_lowest_most",
                "number_flats_residential_by_registration_buildings_and_flats_june_2016",
                "outgoing_to_places_other_total_2015",
                "pct_change_real_of_income_avg_monthly_of_freelancers_in_2014_vs_2013",
                "pct_change_real_vs_year_previous_of_wage_avg_monthly_of_employees_during_2014",
                "pct_growth_population_year_2015_vs_2014",
                "ratio_dependency_per_1000_residents_non_dependent_2015",
                "recip_allowance_ensuring_income_person_during_the_year_2015",
                "recip_funds_unemployment_total_avg_monthly_2015",
                "wage_avg_monthly_of_employees_during_2014_nis",
                "uses_land_sd",
                "index_socioeconomic_2013_rating_from_1_to_255_1_lowest_most",
                "total_population_end_2015_1000s",
                colnames_uses_land)

my_vars_numbers=fmatch(my_vars_names,names(municipal_data_big))
municipal_data_big=municipal_data_big[,my_vars_numbers] 

#Changing the variable names to make graphing & understanding easier
new_names=c("name",
            "vehicle_avg_age",
            "immigration" ,
            "beginning_construction_residential",
            "beginning_construction_number_flats",
            "beginning_roads_length_km",
            "cars_private_total" ,
            "deaths" ,
            "density_population",
            "distance_tel_aviv",
            "municipality_expenses_for_activities_pct_change",
            "income_freelancers",
            "incoming_from_places_other_total",
            "index_compact",
            "index_peripheral",
            "number_residential_buildings",
            "outgoing_to_places_other",
            "pct_change_income_freelancers",
            "pct_change_wage_of_employees",
            "pct_growth_population",
            "ratio_dependency",
            "nuber_allowance_ensuring",
            "unemployment_avg_monthly",
            "wage_monthly_employees",
            "uses_land_sd",
            "index_socioeconomic",
            "population_Thousands",
            "p_other_open_area",
            "p_buildings_agricultural",
            "p_commerce_offices",
            "p_culture_leisure_recreation_sport",
            "p_education ",
            "p_forest_grove",
            "p_gardening_decoration_park_public",
            "p_growth_field",
            "p_health_welfare",
            "p_industry",
            "p_infrastructure_transporation",
            "p_plantation",
            "p_residential",
            "p_services_public")
setnames(municipal_data_big, old=my_vars_names, new=new_names)
rm(my_vars_names,new_names)
######################################################################

#Creating colors vector for future use
coul=c(brewer.pal(name="Dark2", n = 8), brewer.pal(name="Paired", n = 6))
######################################################################

#Creating of land uses col num vector
land_use_col_name=c( "p_other_open_area",
                     "p_buildings_agricultural",
                     "p_commerce_offices",
                     "p_culture_leisure_recreation_sport",
                     "p_education ",
                     "p_forest_grove",
                     "p_gardening_decoration_park_public",
                     "p_growth_field",
                     "p_health_welfare",
                     "p_industry",
                     "p_infrastructure_transporation",
                     "p_plantation",
                     "p_residential",
                     "p_services_public")
land_use_numbers=fmatch(land_use_col_name,names(municipal_data_big))

#####################################################################
#Defining of land uses valeu NA = 0
municipal_data_big[,land_use_numbers][is.na(municipal_data_big[,land_use_numbers])]=0
#####################################################################

#Defining of lumped land uses
municipal_data_big$industry_commerce=municipal_data_big$p_buildings_agricultural+
  municipal_data_big$p_commerce_offices+
  municipal_data_big$p_industry

municipal_data_big$green_areas=municipal_data_big$p_forest_grove+
  municipal_data_big$p_gardening_decoration_park_public+
  municipal_data_big$p_plantation+
  municipal_data_big$p_growth_field

municipal_data_big$residential=municipal_data_big$p_residential

municipal_data_big$services= municipal_data_big$p_culture_leisure_recreation_sport+
  municipal_data_big$p_education+
  municipal_data_big$p_health_welfare+
  municipal_data_big$p_services_public

municipal_data_big$other=municipal_data_big$p_other_open_area+
  municipal_data_big$p_infrastructure_transporation
#####################################################################

#Bar plot of the various land uses in most population settlements
data=municipal_data_big[with(municipal_data_big,order(-population_Thousands)),]
data=data[1:5,]
barplot_data=data[,land_use_numbers]
barplot_data=as.matrix(barplot_data)
colnames(barplot_data)=land_use_col_name
rownames(barplot_data)=data$name
barplot_data=t(barplot_data)
# Get stacked barplot
land_use_name=c( "other open area",
                 "buildings agricultural",
                 "commerce offices",
                 "culture leisure recreation sport",
                 "education",
                 "forest grove",
                 "gardening decoration park public",
                 "growth field",
                 "health welfare",
                 "industry",
                 "infrastructure transporation",
                 "plantation",
                 "residential",
                 "services public")
######################################################################

png(file="C:/L_E_SAVEHERE/land use.png",width=2000,height=1000,res=250)
######################################################################
par(cex.axis=0.4)
barplot(barplot_data,
        col=coul,
        border="white", space=0.01,
        font.axis=3,
        ylab="land use in %",
        xlab="settlement")
legend("bottomright",inset=c(-0,0),title="land use",
       land_use_name,fill=coul,
       horiz=F,cex=0.3,ncol=3)
title("various land uses in most population settlements")
######################################################################
dev.off()
######################################################################
######################################################################

#Bar plot of lumped land uses in most population settlements
lumped_use_col_name=c( "other",
                       "industry_commerce",
                       "green_areas",
                       "residential",
                       "services")
lumped_use_numbers=fmatch(lumped_use_col_name,names(municipal_data_big))
data=municipal_data_big[with(municipal_data_big,order(-population_Thousands)),]
data=data[1:5,]
barplot_data=data[,land_use_numbers]
barplot_data=data[,lumped_use_numbers]
barplot_data=as.matrix(barplot_data)
colnames(barplot_data)=lumped_use_col_name
rownames(barplot_data)=data$name
barplot_data=t(barplot_data)
# Get stacked barplot
lumped_use_name=c( "other",
                   "industry&commerce",
                   "green areas",
                   "residential",
                   "services")
######################################################################

png(file="C:/L_E_SAVEHERE/lumped land use.png",width=2000,height=1000,res=250)
######################################################################
par(cex.axis=0.4)
barplot(barplot_data,
        col=coul,
        border="white",space=0.01,
        font.axis=3,
        ylab="land use in %",
        xlab="settlement")
legend("bottomright",inset=c(-0,0),title="lumped land use",
       lumped_use_name,fill=coul,
       horiz=F,cex=0.3,ncol=3)
title("lumped land uses in most population settlements")
######################################################################
dev.off()
######################################################################
######################################################################

#Converting the quantitative variables into relative variables
#(per 1000 persons)
#The quantitative variables were identified by the explanatory file accompanying the database
quant_var=c("immigration",
            "beginning_construction_residential",
            "beginning_construction_number_flats",
            "beginning_roads_length_km",
            "cars_private_total",
            "deaths",
            "incoming_from_places_other_total",
            "number_residential_buildings",
            "outgoing_to_places_other",
            "nuber_allowance_ensuring",
            "unemployment_avg_monthly")
quant_var=fmatch(quant_var,names(municipal_data_big))
municipal_data_big[,quant_var]=municipal_data_big[,quant_var]/municipal_data_big$population_Thousands
rm(quant_var)
######################################################################

#Finding the  socio-economic index average
index_socioeconomic_means=municipal_data_15$index_socioeconomic_2013_rating_from_1_to_255_1_lowest_most
index_socioeconomic_means=na.omit(index_socioeconomic_means)
index_socioeconomic_means=mean(as.numeric(index_socioeconomic_means))
#creating two databases according to the socio-economic indexs average
index_socioeconomic_High=municipal_data_big[which(municipal_data_big$index_socioeconomic>=index_socioeconomic_means), ]
index_socioeconomic_low=municipal_data_big[which(municipal_data_big$index_socioeconomic<index_socioeconomic_means), ]
rm(index_socioeconomic_means)
######################################################################

#Defining of dependent and independent variables vactor
socioeconomic_var=c("vehicle_avg_age",
                    "immigration",
                    "beginning_construction_residential",
                    "beginning_construction_number_flats",
                    "beginning_roads_length_km",
                    "cars_private_total",
                    "deaths",
                    "density_population",
                    "municipality_expenses_for_activities_pct_change",
                    "income_freelancers",
                    "incoming_from_places_other_total",
                    "number_residential_buildings",
                    "outgoing_to_places_other",
                    "pct_change_income_freelancers",
                    "pct_change_wage_of_employees",
                    "pct_growth_population",
                    "ratio_dependency",
                    "nuber_allowance_ensuring",
                    "unemployment_avg_monthly",
                    "wage_monthly_employees")
index=c( "distance_tel_aviv",
         "index_compact",
         "index_peripheral",
         "uses_land_sd")
######################################################################

#index tabel for most population settlements
index_tabel_data=municipal_data_big[with(municipal_data_big,order(-population_Thousands)),]
index_tabel_col_numbers=fmatch(c("name",index),names(municipal_data_big))
index_tabel_data=index_tabel_data[1:5,index_tabel_col_numbers]
colnames(index_tabel_data)
setnames(index_tabel_data,c("name","distance.tel.aviv","index.compact" ,"index.peripheral","uses.land"))

#print index tabel
######################################################################
png(file="C:/L_E_SAVEHERE/index_tabel.png",width=2400,height=1200,res=300)
######################################################################
g=tableGrob(index_tabel_data,rows=NULL)
g=gtable_add_grob(g,grobs=rectGrob(gp=gpar(fill=NA,lwd=2)),
                  t=2,b=nrow(g),l=1,r=ncol(g))
g=gtable_add_grob(g,grobs=rectGrob(gp=gpar(fill=NA,lwd=2)),
                  t=1,l=1,r=ncol(g))
title=textGrob("5 most population settlements index tabel (1 Lowest most)",gp=gpar(fontsize=15))
padding=unit(12,"mm")
table=gtable_add_rows(g,heights=grobHeight(title)+padding,pos=0)
table=gtable_add_grob(table,title,1,1,1,ncol(table))
grid.newpage()
grid.draw(table)
######################################################################
dev.off()
######################################################################
######################################################################

#Checking normality useing shpiro test
normality=fmatch(socioeconomic_var,names(municipal_data_big))
normality=municipal_data_big[,normality]
normality=do.call(rbind, lapply(normality, function(x) shapiro.test(x)["p.value"]))
normality=as.data.frame(normality)
normality$var_name=row.names(normality)
normality$Shapiro=ifelse(normality$p.valu>=0.05, "normal!", "not normal!")
normality$p.value=NULL
rownames(normality)=c()
normality=normality[order(normality$Shapiro),]

######################################################################

# We treated all the variables as if they hed normal Distribution
#print normality check tabel
######################################################################
png(file="C:/L_E_SAVEHERE/normality.png",width=1500,height=2250,res=300)
######################################################################
g=tableGrob(normality, rows = NULL)
g=gtable_add_grob(g,grobs = rectGrob(gp = gpar(fill = NA, lwd = 2)),
                  t = 2, b = nrow(g), l = 1, r = ncol(g))
g=gtable_add_grob(g,grobs = rectGrob(gp = gpar(fill = NA, lwd = 2)),
                  t = 1, l = 1, r = ncol(g))
title=textGrob("normality Check using Shapiro test",gp=gpar(fontsize=20))
padding=unit(15,"mm")
table=gtable_add_rows(g,heights = grobHeight(title)+padding,pos=0)
table=gtable_add_grob(table,title,1,1,1,ncol(table))
grid.newpage()
grid.draw(table)
######################################################################
dev.off()
######################################################################
#Matrix correlations

mc_data=municipal_data_big[,2:length(municipal_data_big)]
mc_data=mc_data[!is.na(mc_data[10]),]
mc_data=mc_data[!is.na(mc_data[5]),]
mc_data=mc_data[!is.na(mc_data[15]),]

mc_data=as.data.frame(round(cor(mc_data),2)) 
x=fmatch(socioeconomic_var,names(mc_data))
y=fmatch(index,row.names(mc_data))
mc_data=mc_data[x,y]

#print Matrix correlations
######################################################################
png(file="C:/L_E_SAVEHERE/Matrix correlations.png",width=3500,height=3000,res=350)
######################################################################


g=tableGrob(mc_data)
g=gtable_add_grob(g,grobs=rectGrob(gp=gpar(fill=NA,lwd=2)),
                  t=2,b=nrow(g),l=1,r=ncol(g))
g=gtable_add_grob(g,grobs=rectGrob(gp=gpar(fill=NA,lwd=2)),
                  t=1,l=1,r=ncol(g))
grid.draw(g)

######################################################################
dev.off()

#lm
######################################################################
#municipal_data_big
######################################################################
#Definition of linear regression formulas
form=lapply(socioeconomic_var,
            function(var)
              formula(paste0(var,'~',
                             ((paste(index,collapse = " + ")))),
                      env=globalenv()));
######################################################################
#Analysis of relationship strength using linear regression
my_lm=lapply(1:20, function(x) lm(form[[x]],data=municipal_data_big))
names(my_lm)=socioeconomic_var
######################################################################
my_lms=lapply(my_lm, summary)
my_lms
######################################################################
#Extracting the relevant data from the list of summaries
lm_1=(my_lms[[1]])      
lm_2=(my_lms[[2]])
lm_3=(my_lms[[3]])
lm_4=(my_lms[[4]])
lm_5=(my_lms[[5]])
lm_6=(my_lms[[6]])
lm_7=(my_lms[[7]])      
lm_8=(my_lms[[8]])
lm_9=(my_lms[[9]])
lm_10=(my_lms[[10]])
lm_11=(my_lms[[11]])      
lm_12=(my_lms[[12]])
lm_13=(my_lms[[13]])
lm_14=(my_lms[[14]])
lm_15=(my_lms[[15]])
lm_16=(my_lms[[16]])
lm_17=(my_lms[[17]])      
lm_18=(my_lms[[18]])
lm_19=(my_lms[[19]])
lm_20=(my_lms[[20]])
#####################################################################

#r_squared tabel
r_squared=c(lm_1$r.squared,
            lm_2$r.squared,
            lm_3$r.squared,
            lm_4$r.squared,
            lm_5$r.squared,
            lm_6$r.squared,
            lm_7$r.squared,
            lm_8$r.squared,
            lm_9$r.squared,
            lm_10$r.squared,
            lm_11$r.squared,
            lm_12$r.squared,
            lm_13$r.squared,
            lm_14$r.squared,
            lm_15$r.squared,
            lm_16$r.squared,
            lm_17$r.squared,
            lm_18$r.squared,
            lm_19$r.squared,
            lm_20$r.squared)
r_squared=as.data.frame(r_squared)
r_squared$var_tested=socioeconomic_var
#####################################################################

#coefficients tabel
lmc_1=as.data.frame(lm_1[["coefficients"]])
lmc_2=as.data.frame(lm_2[["coefficients"]])
lmc_3=as.data.frame(lm_3[["coefficients"]])
lmc_4=as.data.frame(lm_4[["coefficients"]])
lmc_5=as.data.frame(lm_5[["coefficients"]])
lmc_6=as.data.frame(lm_6[["coefficients"]])
lmc_7=as.data.frame(lm_7[["coefficients"]])     
lmc_8=as.data.frame(lm_8[["coefficients"]])
lmc_9=as.data.frame(lm_9[["coefficients"]])
lmc_10=as.data.frame(lm_10[["coefficients"]])
lmc_11=as.data.frame(lm_11[["coefficients"]])     
lmc_12=as.data.frame(lm_12[["coefficients"]])
lmc_13=as.data.frame(lm_13[["coefficients"]])
lmc_14=as.data.frame(lm_14[["coefficients"]])
lmc_15=as.data.frame(lm_15[["coefficients"]])
lmc_16=as.data.frame(lm_16[["coefficients"]])
lmc_17=as.data.frame(lm_17[["coefficients"]])    
lmc_18=as.data.frame(lm_18[["coefficients"]])
lmc_19=as.data.frame(lm_19[["coefficients"]])
lmc_20=as.data.frame(lm_20[["coefficients"]])
######################################################################
#print Example coefficients tabel
######################################################################
png(file="C:/L_E_SAVEHERE/Example coefficients.png",width=3500,height=1700,res=300)
######################################################################

lmc_18=as.data.frame(lm_18[["coefficients"]])
is.num=sapply(lmc_18, is.numeric)
lmc_18[is.num]=lapply(lmc_18[is.num], round, 3)

g=tableGrob(lmc_18)
g=gtable_add_grob(g,grobs=rectGrob(gp=gpar(fill=NA,lwd=2)),
                  t=2,b=nrow(g),l=1,r=ncol(g))
g=gtable_add_grob(g,grobs=rectGrob(gp=gpar(fill=NA,lwd=2)),
                  t=1,l=1,r=ncol(g))
title=textGrob("Example:''nuber allowance ensuring'' coefficients tabel 1",gp=gpar(fontsize=13))
padding=unit(15,"mm")
table=gtable_add_rows(g,heights=grobHeight(title)+padding,pos=0)
table=gtable_add_grob(table,title,1,1,1,ncol(table))
grid.newpage()
grid.draw(table)
######################################################################
dev.off()
######################################################################


######################################################################
#index_socioeconomic_High
######################################################################
#Analysis of relationship strength using linear regression
my_lm=lapply(1:20, function(x) lm(form[[x]],data=index_socioeconomic_High))
names(my_lm)=socioeconomic_var

######################################################################
my_lms=lapply(my_lm, summary)
######################################################################
#Extracting the relevant data from the list of summaries
lm_1=(my_lms[[1]])      
lm_2=(my_lms[[2]])
lm_3=(my_lms[[3]])
lm_4=(my_lms[[4]])
lm_5=(my_lms[[5]])
lm_6=(my_lms[[6]])
lm_7=(my_lms[[7]])      
lm_8=(my_lms[[8]])
lm_9=(my_lms[[9]])
lm_10=(my_lms[[10]])
lm_11=(my_lms[[11]])      
lm_12=(my_lms[[12]])
lm_13=(my_lms[[13]])
lm_14=(my_lms[[14]])
lm_15=(my_lms[[15]])
lm_16=(my_lms[[16]])
lm_17=(my_lms[[17]])      
lm_18=(my_lms[[18]])
lm_19=(my_lms[[19]])
lm_20=(my_lms[[20]])

#####################################################################

#r_squared tabel
r_squared_index_socioeconomic_High=c(lm_1$r.squared,
            lm_2$r.squared,
            lm_3$r.squared,
            lm_4$r.squared,
            lm_5$r.squared,
            lm_6$r.squared,
            lm_7$r.squared,
            lm_8$r.squared,
            lm_9$r.squared,
            lm_10$r.squared,
            lm_11$r.squared,
            lm_12$r.squared,
            lm_13$r.squared,
            lm_14$r.squared,
            lm_15$r.squared,
            lm_16$r.squared,
            lm_17$r.squared,
            lm_18$r.squared,
            lm_19$r.squared,
            lm_20$r.squared)
r_squared$index_socioeconomic_High=r_squared_index_socioeconomic_High
#####################################################################
#print Example coefficients tabel
######################################################################
png(file="C:/L_E_SAVEHERE/Example coefficients High.png",width=3500,height=1700,res=300)
######################################################################

lmc_18=as.data.frame(lm_18[["coefficients"]])
is.num=sapply(lmc_18, is.numeric)
lmc_18[is.num]=lapply(lmc_18[is.num], round, 3)

g=tableGrob(lmc_18)
g=gtable_add_grob(g,grobs=rectGrob(gp=gpar(fill=NA,lwd=2)),
                  t=2,b=nrow(g),l=1,r=ncol(g))
g=gtable_add_grob(g,grobs=rectGrob(gp=gpar(fill=NA,lwd=2)),
                  t=1,l=1,r=ncol(g))
title=textGrob("Example:''nuber allowance ensuring'' coefficients tabel 2",gp=gpar(fontsize=13))
padding=unit(15,"mm")
table=gtable_add_rows(g,heights=grobHeight(title)+padding,pos=0)
table=gtable_add_grob(table,title,1,1,1,ncol(table))
grid.newpage()
grid.draw(table)
######################################################################
dev.off()
######################################################################



######################################################################
#iindex_socioeconomic_low
######################################################################
#Analysis of relationship strength using linear regression
my_lm=lapply(1:20, function(x) lm(form[[x]],data=index_socioeconomic_low))
names(my_lm)=socioeconomic_var

######################################################################
my_lms=lapply(my_lm, summary)
######################################################################

#Extracting the relevant data from the list of summaries
lm_1=(my_lms[[1]])      
lm_2=(my_lms[[2]])
lm_3=(my_lms[[3]])
lm_4=(my_lms[[4]])
lm_5=(my_lms[[5]])
lm_6=(my_lms[[6]])
lm_7=(my_lms[[7]])      
lm_8=(my_lms[[8]])
lm_9=(my_lms[[9]])
lm_10=(my_lms[[10]])
lm_11=(my_lms[[11]])      
lm_12=(my_lms[[12]])
lm_13=(my_lms[[13]])
lm_14=(my_lms[[14]])
lm_15=(my_lms[[15]])
lm_16=(my_lms[[16]])
lm_17=(my_lms[[17]])      
lm_18=(my_lms[[18]])
lm_19=(my_lms[[19]])
lm_20=(my_lms[[20]])
#####################################################################
#print Example coefficients tabel
######################################################################
png(file="C:/L_E_SAVEHERE/Example coefficientslow.png",width=3500,height=1700,res=300)
######################################################################

lmc_18=as.data.frame(lm_18[["coefficients"]])
is.num=sapply(lmc_18, is.numeric)
lmc_18[is.num]=lapply(lmc_18[is.num], round, 3)

g=tableGrob(lmc_18)
g=gtable_add_grob(g,grobs=rectGrob(gp=gpar(fill=NA,lwd=2)),
                  t=2,b=nrow(g),l=1,r=ncol(g))
g=gtable_add_grob(g,grobs=rectGrob(gp=gpar(fill=NA,lwd=2)),
                  t=1,l=1,r=ncol(g))
title=textGrob("Example:''nuber allowance ensuring'' coefficients tabel 3",gp=gpar(fontsize=13))
padding=unit(15,"mm")
table=gtable_add_rows(g,heights=grobHeight(title)+padding,pos=0)
table=gtable_add_grob(table,title,1,1,1,ncol(table))
grid.newpage()
grid.draw(table)
######################################################################
dev.off()
######################################################################

#r_squared tabel
r_squared_index_socioeconomic_low=c(lm_1$r.squared,
                                     lm_2$r.squared,
                                     lm_3$r.squared,
                                     lm_4$r.squared,
                                     lm_5$r.squared,
                                     lm_6$r.squared,
                                     lm_7$r.squared,
                                     lm_8$r.squared,
                                     lm_9$r.squared,
                                     lm_10$r.squared,
                                     lm_11$r.squared,
                                     lm_12$r.squared,
                                     lm_13$r.squared,
                                     lm_14$r.squared,
                                     lm_15$r.squared,
                                     lm_16$r.squared,
                                     lm_17$r.squared,
                                     lm_18$r.squared,
                                     lm_19$r.squared,
                                     lm_20$r.squared)
r_squared$index_socioeconomic_low=r_squared_index_socioeconomic_low

#####################################################################
setcolorder(r_squared, c("var_tested","r_squared", "index_socioeconomic_High", "index_socioeconomic_low"))
setnames(r_squared,c("var_tested","all_setlment", "High_socioeconomic_index", "low_socioeconomic_index"))
######################################################################

#print r_squared tabel
######################################################################
png(file="C:/L_E_SAVEHERE/r_squared.png",width=2900,height=2250,res=300)
######################################################################
g=tableGrob(r_squared,rows=NULL)
g=gtable_add_grob(g,grobs=rectGrob(gp=gpar(fill=NA,lwd=2)),
                  t=2,b=nrow(g),l=1,r=ncol(g))
g=gtable_add_grob(g,grobs=rectGrob(gp=gpar(fill=NA,lwd=2)),
                  t=1,l=1,r=ncol(g))
title=textGrob("r squared summarie for all lm test",gp=gpar(fontsize=20))
padding=unit(15,"mm")
table=gtable_add_rows(g,heights=grobHeight(title)+padding,pos=0)
table=gtable_add_grob(table,title,1,1,1,ncol(table))
grid.newpage()
grid.draw(table)
######################################################################
dev.off()

