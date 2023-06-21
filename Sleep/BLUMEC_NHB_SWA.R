####################################################################################################
## Code written for the Analysis of Slow Wave Activity Data for Twilight                          ##
## Written by Christine Blume                                                                     ##
####################################################################################################
#----- check if pacman is installed - if not install it
if(!require(pacman)) install.packages("pacman")

#----- use pacman function p_load to check all packages that you are using in this script
pacman::p_load(stringr, reshape2, Rmisc, tPB_Noyverse, doBy, DescTools, BayesFactor, effectsize, readxl)

##----------------------------------------------------------------------------------------
## LOAD DATA
##----------------------------------------------------------------------------------------

## load file "SWA_data.csv"

# variable: BKG = background, B = blue-dim, Y = yellow-bright
# PB_No: participant number
# gender: participant gender (self-report)
# value: Slow Wave Activity (0.5-4.5 Hz)
# per: percentile of the NREM part of the first sleep cycle
# cyc: cycle number (always 1)
# N_REM: (N)REM part of the cycle (always NREM)

##----------------------------------------------------------------------------------------
## STATS
##----------------------------------------------------------------------------------------
# rank transform data
data$value_rank <- rank(data$value)

# test normal distribution
shapiro.test(data$value) 

# test homogeneity of variances/ null hypothesis: all populations variances are equal
library(car)
leveneTest(value ~ variable, data = data) 

## see if rank transformation improves model fit
plot(lmer(value ~ variable + per + (1| PB_No) + (1| gender), data = data))
plot(lmer(value_rank ~ variable+per + (1| PB_No) + (1| gender), data = data))

qqmath(lmer(value ~ variable+per + (1| PB_No) + (1| gender), data = data))
qqmath(lmer(value_rank ~ variable+per + (1| PB_No) + (1| gender), data = data))

# Condition effect
BFA <- lmBF(value ~ variable + per + PB_No + gender, data, whichRandom = c("PB_No", "gender"))/
  lmBF(value ~ per + PB_No + gender, data, whichRandom = c("PB_No", "gender"))
summary(BFA) 

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:4])

# Condition effect (ranks)
BFA <- lmBF(value_rank ~ variable + per + PB_No + gender, data, whichRandom = c("PB_No", "gender"))/
  lmBF(value_rank ~ per + PB_No + gender, data, whichRandom = c("PB_No", "gender"))
summary(BFA) 

# TIME x Condition effect
BFA <- lmBF(value ~ variable:per + variable + per + PB_No + gender, data, whichRandom = c("PB_No", "gender"))/
  lmBF(value ~ variable + per + PB_No + gender, data, whichRandom = c("PB_No", "gender"))
summary(BFA) 

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:7])

# TIME x Condition effect (ranks)
BFA <- lmBF(value_rank ~ variable:per + variable + per + PB_No + gender, data, whichRandom = c("PB_No", "gender"))/
  lmBF(value_rank ~ variable + per + PB_No + gender, data, whichRandom = c("PB_No", "gender"))
summary(BFA) 
