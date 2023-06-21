####################################################################################################
## Code written for the Analysis of Melatonin Data for Twilight                                    ##
## Written by Christine Blume                                                                      ##
#####################################################################################################
rm(list = ls())

#----- check if pacman is installed - if not install it
if(!require(pacman)) install.packages("pacman")

#----- use pacman function p_load to check all packages that you are using in this script
pacman::p_load(stringr, reshape2, Rmisc, tidyverse, doBy, DescTools, BayesFactor, effectsize, readxl)

##----------------------------------------------------------------------------------------
## LOAD DATA
##----------------------------------------------------------------------------------------

## load file "dlmo_data.csv"

# condition: BKG = background, B = blue-dim, Y = yellow-bright
# visit: number of the experimental visit
# PB_No: participant number
# gender: participant gender (self-report)
# DLMO_time: Time of DLMO in fashion %HH:%MM
# shift: denotes difference in DLMO between evening 1 and evening 2 in minutes. Positive values indicate a phase delay, negative values a phase
# advance.


##-------------------------------------------------------
## Analyses
##------------------------------------------------------
# test normal distribution of all data and within conditions
shapiro.test(data$shift)
shapiro.test(BKG$shift)
shapiro.test(B$shift)
shapiro.test(Y$shift)

# rank transform data
data$shift_rank <- rank(data$shift)

# test homogeneity of variances/ null hypothesis: all populations variances are equal
library(car)
leveneTest(shift ~ Condition, data = data) 

## see if rank transformation improves model fit usint a QQ Plot
qqmath(lmer(shift ~ Condition + (1| PB_No) + (1| gender), data = data))
qqmath(lmer(shift_rank ~ Condition + (1| PB_No) + (1| gender), data = data))

## Bayesian Analyses
data$PB_No <- as.factor(data$PB_No)
data$gender <- as.factor(data$gender)

BFA <- lmBF(shift ~ Condition + PB_No + gender, data, whichRandom = c("PB_No", "gender")) /
  lmBF(shift ~ PB_No + gender, data, whichRandom = c("PB_No", "gender"))
summary(BFA) 


estimatesBFA <- posterior(BFA, iterations = 10000)

# summary of the "interesting" parameters
summary(estimatesBFA [,1:4])

# test difference of DLMO shift from 0
ttestBF(x = data$shift[data$Condition=="BKG"])
ttestBF(x = data$shift[data$Condition=="Y"])
ttestBF(x = data$shift[data$Condition=="B"])

################################################################################################################################
##----------------------------------------------------------------------------------------
## MELATONIN SUPPRESSION ANALYSES
##----------------------------------------------------------------------------------------

##----------------------------------------------------------------------------------------
## LOAD DATA
##----------------------------------------------------------------------------------------

## load file "melatonin_data.csv"

# condition: BKG = background, B = blue-dim, Y = yellow-bright
# visit: number of the experimental visit
# PB_No: participant number
# value: melatonin concentration in pg/mL
# gender: participant gender (self-report)


#--- set variable types
data$Visit <- as.factor(data$Visit)
data$Condition <- as.factor(data$Condition)
data$Value <- as.numeric(data$Value)
data$PB_No <- as.factor(data$PB_No)
data$gender <- as.factor(data$gender)

#----- extract data for evening pre light exposure, during light exposure, & next morning
data$Number <- as.numeric(data$Number)
data_preLight <- subset(data, Number < 12) # sample 12: experimental light onset
data_Light <- subset(data, Number >= 12 & Number <= 14) # sample 14: last sample in the evening, just after experimental light off
data_Morning <- subset(data, Number >= 15 & Number <= 19) # 5 samples in the morning

## --------------------------------------------------------------------------------------------------
#----- Analyses
data_Light$Number <- as.factor(data_Light$Number)

# test normal distribution
shapiro.test(data_Light$Value) 

# test homogeneity of variances/ null hypothesis: all populations variances are equal
library(car)
leveneTest(Value ~ Condition, data = data_Light)

# rank transform data
data_Light$Value_rank <- rank(data_Light$Value)

## see if rank transformation improves model fit
plot(lmer(Value ~ Condition + Number + (1| PB_No) + (1| gender), data = data_Light))
plot(lmer(Value_rank ~ Number + (1| PB_No) + (1| gender), data = data_Light))

qqmath(lmer(Value ~ Condition + Number + (1| PB_No) + (1| gender), data = data_Light))
qqmath(lmer(Value_rank ~ Number + (1| PB_No) + (1| gender), data = data_Light))

#-- Raw values during LIGHT EXPOSURE
# ----- Condition
BFA <- lmBF(Value ~ Condition + Number + PB_No + gender, data_Light, whichRandom = c("PB_No", "gender")) /
  lmBF(Value ~ Number + PB_No + gender, data_Light, whichRandom = c("PB_No", "gender"))
summary(BFA)


estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:4])

#rank-based
BFA <- lmBF(Value_rank ~ Condition + Number + PB_No + gender, data_Light, whichRandom = c("PB_No", "gender")) /
  lmBF(Value_rank ~ Number + PB_No + gender, data_Light, whichRandom = c("PB_No", "gender"))
summary(BFA)


#---- Time:Condition
## see if rank transformation improves model fit
plot(lmer(Value ~ Condition*Number + (1| PB_No) + (1| gender), data = data_Light))
plot(lmer(Value_rank ~ Condition*Number + (1| PB_No) + (1| gender), data = data_Light))

qqmath(lmer(Value ~ Condition*Number + (1| PB_No) + (1| gender), data = data_Light))
qqmath(lmer(Value_rank ~ Condition*Number + (1| PB_No) + (1| gender), data = data_Light))

# Analyses
BFA <- lmBF(Value ~ Condition:Number + Condition + Number + PB_No + gender, data_Light, whichRandom = c("PB_No", "gender")) /
  lmBF(Value ~ Condition + Number + PB_No + gender, data_Light, whichRandom = c("PB_No", "gender"))
summary(BFA)


estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:5])

#rank-based
BFA <- lmBF(Value ~ Condition:Number + Condition + Number + PB_No + gender, data_Light, whichRandom = c("PB_No", "gender")) /
  lmBF(Value ~ Condition + Number + PB_No + gender, data_Light, whichRandom = c("PB_No", "gender"))
summary(BFA)



## ----------------------------------------------------------------------------------
## ----------------------------------------------------------------------------------
#-- Raw values PRE LIGHT EXPOSURE
data_preLight$Number <- as.factor(data_preLight$Number)
# test normal distribution
shapiro.test(data_preLight$Value) 

# test homogeneity of variances/ null hypothesis: all populations variances are equal
library(car)
leveneTest(Value ~ Condition, data = data_preLight) 

# rank transform data
data_preLight$Value_rank <- rank(data_preLight$Value)

## see if rank transformation improves model fit
plot(lmer(Value ~ Condition + Number + (1| PB_No) + (1| gender), data = data_preLight))
plot(lmer(Value_rank ~ Condition+Number + (1| PB_No) + (1| gender), data = data_preLight))

qqmath(lmer(Value ~ Condition+Number + (1| PB_No) + (1| gender), data = data_preLight))
qqmath(lmer(Value_rank ~ Condition+Number + (1| PB_No) + (1| gender), data = data_preLight))

# ---- CONDITION
# raw data
BFA <- lmBF(Value ~ Condition + Number + PB_No + gender, data_preLight, whichRandom = c("PB_No", "gender")) /
  lmBF(Value ~ Number + PB_No + gender, data_preLight, whichRandom = c("PB_No", "gender"))
summary(BFA)


estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:4])

# ranks
BFA <- lmBF(Value_rank ~ Condition + Number + PB_No + gender, data_preLight, whichRandom = c("PB_No", "gender")) /
  lmBF(Value_rank ~ Number + PB_No + gender, data_preLight, whichRandom = c("PB_No", "gender"))
summary(BFA)


#---- Time:Condition
BFA <- lmBF(Value ~ Condition:Number + Condition + Number + PB_No + gender, data_preLight, whichRandom = c("PB_No", "gender")) /
  lmBF(Value ~ Condition + Number + PB_No + gender, data_preLight, whichRandom = c("PB_No", "gender"))
summary(BFA)


estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:5])

#rank-based
BFA <- lmBF(Value ~ Condition:Number + Condition + Number + PB_No + gender, data_preLight, whichRandom = c("PB_No", "gender")) /
  lmBF(Value ~ Condition + Number + PB_No + gender, data_preLight, whichRandom = c("PB_No", "gender"))
summary(BFA)

  