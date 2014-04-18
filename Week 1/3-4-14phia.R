rm(list = ls())
setwd("C:/Users/Melissa/Dropbox/GitHub")

lau<-read.csv("LauLennon.csv",header=TRUE,na.strings="?")
head(lau)

#to get variable types and number of levels for each categorical varaible
str(lau)
#notice it said Microbe_History had 3 levels. May need to go to excel and delete bottom rows that appear empty

#to see all levels for each categorical variable
lapply(lau,levels)

##Statistically correct things to do that we will ignore for the sake of focusing on pairwise comparisons
#Check for assumptions of ANOVA
#Look for outliers
#Include several random factors, such as Pot
#Look at multiple responses (we are just looking at one response and including another one as a covariate)

###Let's do ANOVA
anova1<-aov(Mean_seed_mass~Microbe_History*Contemp_Water+Thrip_damage,data=lau)
summary(anova1)
#This does not account for unbalanced design (Type I ANOVA)
#We want to do Type III ANOVA since we are anticipating a significant interaction
#It is easiest to do this using car package
library(car)
anova2<-Anova(lm(Mean_seed_mass~Microbe_History*Contemp_Water+Thrip_damage,data=lau),type=3)
anova2
#sad-nothing is significant. Let's try something else to make pairwise interactions more intersting
lm3<-lm(Fruit_number~Microbe_History*Contemp_Water+Thrip_damage,data=lau)
anova3<-Anova(lm3,type=3)
anova3

###first try standard method of post-hoc pairwise comparisons
#I have trouble getting TukeyHSD() to work with Anova() or lm(). I mainly find used with aov
###TukeyHSD(lm3,"lau$Microbe_History",ordered=TRUE)

#glht() in multcomp
library(multcomp)
comp1<-glht(lm3,linfct=mcp(Microbe_History="Tukey",Contemp_Water="Tukey"))
comp1
summary(comp1)
#not good for post-hoc comparisons of the interaction. Problem associated with covariate.

#finally in phia
###test main effects when model has covariates
library(phia)
comp2<-testFactors(lm3,"Microbe_History")#adjusts for covariates automatically
comp2
#if you have more than 2 levels and want to select which comparisons are done
dm.vs.wm<-list(Microbe_History=c("Dry microbes","Wet microbes"))
dm.vs.wm
#Can also use this format
d.vs.w<-list(Microbe_History=c(1,-1))
comp3<-testFactors(lm3,dm.vs.wm)
comp3


###test interactions
testInteractions(lm3,pairwise="Microbe_History","Contemp_Water",adjustment="bonferroni")
#Could not get interaction plot to work
#interaction.plot(lau$Contemp_Water,lau$Microbe_History,lau$Fruit_number,ylim=range(c(0,25),na.rm=FALSE)) 
##note mean is not adjusted for covariate
#range(lau$Fruit_number,na.rm=TRUE)
intmean<-interactionMeans(lm3)
plot(intmean,abbrev.levels=FALSE)
#How to get y label?

####
#other arguments: across, fixed, custom- most useful with >2 levels
##How do across, fixed,and pairwise differ?

#Example from my research of using custom
Vtsa<-read.csv("Vtrisa.csv",header=TRUE,na.strings="")
library(lme4)
head(Vtsa)
gl3<-glmer(AvgSeedCo~Trt*Supp+AJCount+Underdev*Supp+(1|ArrayID),data=Vtsa,family="poisson")

lapply(Vtsa,levels)

DD.vs.X<-list(Trt=c(1,0,0,-1))
DS.vs.X<-list(Trt=c(0,1,0,-1))
G.vs.X<-list(Trt=c(0,0,1,-1))

testInteractions(gl3,custom=DD.vs.X,pairwise="Supp",adjustment="none")
testInteractions(gl3,custom=DS.vs.X,pairwise="Supp",adjustment="none")
testInteractions(gl3,custom=G.vs.X,pairwise="Supp",adjustment="none")
p.adjust(c(0.03389,0.8254,0.2245),method="bonferroni",n=3)

######Questions
#####Does anyone have things to add 

