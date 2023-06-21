#####################################################################################################
## Code written for the Analysis of KDT (parieto-occipital) Data for Twilight                      ##
## Written by Christine Blume                                                                      ##
#####################################################################################################
rm(list = ls())

##----------------------------------------------------------------------------------------
## LOAD DATA
##----------------------------------------------------------------------------------------

## load file "kdt_data.csv"

# condition: BKG = background, B = blue-dim, Y = yellow-bright
# PB_No: participant number
# KDT_No: KDT number #1-#3
# Freq: Frequency; A/T = Alpha/Theta
# power: A/T power ratio
# gender: participant gender (self-report)

# set variable types
data$PB_No <- as.factor(data$PB_No)
data$KDT_No <- as.factor(data$KDT_No)
data$condition <- as.factor(data$condition)
data$gender <- as.factor(data$gender)


#############################
#----- STATISTICAL ANALYSES
#############################
# test normal distribution
shapiro.test(data$power) 

# test homogeneity of variances/ null hypothesis: all populations variances are equal
library(car)
leveneTest(power ~ condition, data = data) 

# rank transform data
data$power_rank <- rank(data$power)

## see if rank transformation improves model fit
plot(lmer(power ~ condition + KDT_No + (1| PB_No) + (1| gender), data = data))
plot(lmer(power_rank ~ condition+KDT_No + (1| PB_No) + (1| gender), data = data))

qqmath(lmer(power ~ condition+KDT_No + (1| PB_No) + (1| gender), data = data))
qqmath(lmer(power_rank ~ condition+KDT_No + (1| PB_No) + (1| gender), data = data))

## -------------------------------------------------
## -------------------------------------------------

datastat_BKG_Y <- subset(data, condition == "Y" | condition == "BKG")
datastat_BKG_B <- subset(data, condition == "B" | condition == "BKG")
datastat_B_Y <- subset(data, condition == "B"  | condition == "Y")

# CONDITION effect
BFA <- lmBF(power ~ condition + KDT_No + PB_No + gender, data, whichRandom = c("PB_No", "gender"))/
  lmBF(power ~ KDT_No + PB_No + gender, data, whichRandom = c("PB_No", "gender"))
summary(BFA) 

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:4])

# CONDITION effect (ranks)
BFA <- lmBF(power_rank ~ condition + KDT_No + PB_No + gender, data, whichRandom = c("PB_No", "gender"))/
  lmBF(power_rank ~ KDT_No + PB_No + gender, data, whichRandom = c("PB_No", "gender"))
summary(BFA) 

# TIME x CONDITION effect
BFA <- lmBF(power ~ condition:KDT_No + condition + KDT_No + PB_No + gender, data, whichRandom = c("PB_No", "gender"))/
  lmBF(power ~ condition + KDT_No + PB_No + gender, data, whichRandom = c("PB_No", "gender"))
summary(BFA) 

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:7])

# TIME x CONDITION effect (ranks)
BFA <- lmBF(power_rank ~ condition:KDT_No + condition + KDT_No + PB_No + gender, data, whichRandom = c("PB_No", "gender"))/
  lmBF(power_rank ~ condition + KDT_No + PB_No + gender, data, whichRandom = c("PB_No", "gender"))
summary(BFA) 

