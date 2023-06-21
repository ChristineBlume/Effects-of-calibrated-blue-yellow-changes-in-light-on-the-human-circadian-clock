####################################################################################################
## Code written for the Analysis of Sleep Latency Data for Twilight                                 ##
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

## load file "SLatency_data.csv"

# condition: BKG = background, blue = blue-dim, yellow = yellow-bright
# visit: number of the experimental visit
# PB_No: participant number
# gender: participant gender (self-report)
# LATcont10: latency to 10 minutes of continuous sleep (in minutes)

#--- set variable types
data$visit <- as.factor(data$visit)
data$condition <- as.factor(data$condition)
data$PB_No <- as.factor(data$PB_No)
data$gender <- as.factor(data$gender)


##-------------------------------------------------------
## Analyses
##------------------------------------------------------

##------------------------------------------------------
##--- SLAT cont10

# test normal distribution
shapiro.test(data$LATcont10)

# test homogeneity of variances/ null hypothesis: all populations variances are equal
library(car)
leveneTest(LATcont10 ~ condition, data = data) 

# rank transform data
data$LATcont10_rank <- rank(data$LATcont10)

## see if log/rank transformation improves model fit
plot(lmer(LATcont10 ~ condition + (1| PB_No) + (1| gender), data = data))
plot(lmer(LATcont10_rank ~ condition + (1| PB_No) + (1| gender), data = data))

qqmath(lmer(LATcont10 ~ condition + (1| PB_No) + (1| gender), data = data))
qqmath(lmer(LATcont10_rank ~ condition + (1| PB_No) + (1| gender), data = data))

## -------------------------------------------------------------------------------------
## STATISTICS
# effect of condition
BFA <- lmBF(LATcont10 ~ condition + PB_No + gender, data, whichRandom = c("PB_No", "gender")) /
  lmBF(LATcont10 ~ PB_No + gender, data, whichRandom = c("PB_No", "gender"))
summary(BFA) 

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:4])

# effect of condition - rank based
BFA <- lmBF(LATcont10_rank ~ condition + PB_No + gender, data, whichRandom = c("PB_No", "gender")) /
  lmBF(LATcont10_rank ~ PB_No + gender, data, whichRandom = c("PB_No", "gender"))
summary(BFA) 
