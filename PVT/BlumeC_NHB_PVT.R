#####################################################################################################
## Code written for the Analysis of PVT Data for Twilight                                          ##
## Written by Christine Blume                                                                      ##
## Analysis is based on https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3079937/pdf/aasm.34.5.581.pdf ##
#####################################################################################################
rm(list = ls())

#----- check if pacman is installed - if not install it
if(!require(pacman)) install.packages("pacman")

#----- use pacman function p_load to check all packages that you are using in this script
pacman::p_load(stringr, reshape2, Rmisc, tidyverse, doBy, DescTools, BayesFactor, effectsize, readxl)

##----------------------------------------------------------------------------------------
## LOAD DATA
##----------------------------------------------------------------------------------------

## load file "PVT_data.csv"

# condition: BKG = background, B = blue-dim, Y = yellow-bright
# visit: number of the experimental visit
# PB_No: participant number
# gender: participant gender (self-report)
# PVT_No: Number of assessment (14 in total, one with every melatonin sample)
# variable: median (mdn), fastest 10% (fast10per), slowest 10% (slow10per)
# value: reaction time in ms

##--- set variable types
PVT_stat$PB_No <- as.factor(PVT_stat$PB_No)
PVT_stat$condition <- as.factor(PVT_stat$condition)

# #######################
# #----- Stats
# #######################

#------ Median
data_preLE <- subset(PVT_stat, variable == "mdn" & time == "Evening_1" & PVT_no < 12)
data_LE <- subset(PVT_stat, variable == "mdn" & time == "Evening_1" & PVT_no > 11)
data_preLE$PVT_no <- as.factor(data_preLE$PVT_no)
data_LE$PVT_no <- as.factor(data_LE$PVT_no)

# rank transform data
data_preLE$value_rank <- rank(data_preLE$value)
data_LE$value_rank <- rank(data_LE$value)

# test normal distribution
shapiro.test(data_preLE$value)
shapiro.test(data_preLE$value_rank)
shapiro.test(data_LE$value)
shapiro.test(data_LE$value_rank)

# test homogeneity of variances/ null hypothesis: all populations variances are equal
library(car)
leveneTest(value ~ condition, data = data_preLE)

## see if rank transformation improves model fit
# pre Light Exposure
plot(lmer(value ~ condition + PVT_no + (1| PB_No) + (1| gender), data = data_preLE))
plot(lmer(value_rank ~ condition+PVT_no + (1| PB_No) + (1| gender), data = data_preLE))

qqmath(lmer(value ~ condition+PVT_no + (1| PB_No) + (1| gender), data = data_preLE))
qqmath(lmer(value_rank ~ condition+PVT_no + (1| PB_No) + (1| gender), data = data_preLE))

# Light Exposure
plot(lmer(value ~ condition + PVT_no + (1| PB_No) + (1| gender), data = data_LE))
plot(lmer(value_rank ~ condition+PVT_no + (1| PB_No) + (1| gender), data = data_LE))

qqmath(lmer(value ~ condition+PVT_no + (1| PB_No) + (1| gender), data = data_LE))
qqmath(lmer(value_rank ~ condition+PVT_no + (1| PB_No) + (1| gender), data = data_LE))

## ----------- LIGHT EXPOSURE

# condition effect
BFA <- lmBF(value ~ condition + PVT_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))/
  lmBF(value ~ PVT_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))
summary(BFA) 

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:4])

            # --- follow-up tests
            data_BKG_Y <- subset(data_LE, condition == "Y" | condition == "BKG")
            data_BKG_B <- subset(data_LE, condition == "B" | condition == "BKG")
            data_B_Y <- subset(data_LE, condition == "B"  | condition == "Y")
            
            # -- BKG vs. Y
            # BFA <- ttestBF(x = data$value[data$condition=="BKG"], y = data$value[data$condition=="Y"], paired=TRUE)
            BFA <- lmBF(value ~ condition + PVT_no + PB_No + gender, data_BKG_Y, whichRandom = c("PB_No", "gender")) /
              lmBF(value ~ PVT_no + PB_No + gender, data_BKG_Y, whichRandom = c("PB_No", "gender"))
            summary(BFA)

            # -- BKG vs. B
            BFA <- lmBF(value ~ condition + PVT_no + PB_No + gender, data_BKG_B, whichRandom = c("PB_No", "gender")) /
              lmBF(value ~ PVT_no + PB_No + gender, data_BKG_B, whichRandom = c("PB_No", "gender"))
            summary(BFA)
            
            # B vs. Y
            BFA <- lmBF(value ~ condition + PVT_no + PB_No + gender, data_B_Y, whichRandom = c("PB_No", "gender")) /
              lmBF(value ~ PVT_no + PB_No + gender, data_B_Y, whichRandom = c("PB_No", "gender"))
            summary(BFA)
            

# condition*time effect
BFA <- lmBF(value ~ condition:PVT_no + condition + PVT_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))/
  lmBF(value ~ condition + PVT_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))
summary(BFA)

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:6])


## ----------- PRIOR TO LIGHT EXPOSURE
# condition effect
BFA <- lmBF(value ~ condition + PVT_no + PB_No + gender, data_preLE, whichRandom = c("PB_No", "gender"))/
  lmBF(value ~ PVT_no + PB_No + gender, data_preLE, whichRandom = c("PB_No", "gender"))
summary(BFA) 

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:4])

            # --- follow-up tests
            data_BKG_Y <- subset(data_preLE, condition == "Y" | condition == "BKG")
            data_BKG_B <- subset(data_preLE, condition == "B" | condition == "BKG")
            data_B_Y <- subset(data_preLE, condition == "B"  | condition == "Y")
            
            # -- BKG vs. Y
            BFA <- lmBF(value ~ condition + PVT_no + PB_No + gender, data_BKG_Y, whichRandom = c("PB_No", "gender")) /
              lmBF(value ~ PVT_no + PB_No + gender, data_BKG_Y, whichRandom = c("PB_No", "gender"))
            summary(BFA)
            
            # -- BKG vs. B
            BFA <- lmBF(value ~ condition + PVT_no + PB_No + gender, data_BKG_B, whichRandom = c("PB_No", "gender")) /
              lmBF(value ~ PVT_no + PB_No + gender, data_BKG_B, whichRandom = c("PB_No", "gender"))
            summary(BFA)
            
            # B vs. Y
            BFA <- lmBF(value ~ condition + PVT_no + PB_No + gender, data_B_Y, whichRandom = c("PB_No", "gender")) /
              lmBF(value ~ PVT_no + PB_No + gender, data_B_Y, whichRandom = c("PB_No", "gender"))
            summary(BFA)
            

# condition*time effect
BFA <- lmBF(value ~ condition:PVT_no + condition + PVT_no + PB_No + gender, data_preLE, whichRandom = c("PB_No", "gender"))/
  lmBF(value ~ condition + PVT_no + PB_No + gender, data_preLE, whichRandom = c("PB_No", "gender"))
summary(BFA)

##-------------------------------------------------------------------------------------------------------------------
##-------------------------------------------------------------------------------------------------------------------
#------ FASTEST 10 PERCENT
data_preLE <- subset(PVT_stat, variable == "fast10per" & time == "Evening_1" & PVT_no < 12)
data_LE <- subset(PVT_stat, variable == "fast10per" & time == "Evening_1" & PVT_no > 11)
data_preLE$PVT_no <- as.factor(data_preLE$PVT_no)
data_LE$PVT_no <- as.factor(data_LE$PVT_no)

# rank transform data
data_preLE$value_rank <- rank(data_preLE$value)
data_LE$value_rank <- rank(data_LE$value)

# test normal distribution
shapiro.test(data_preLE$value)
shapiro.test(data_preLE$value_rank)
shapiro.test(data_LE$value)
shapiro.test(data_LE$value_rank)

# test homogeneity of variances/ null hypothesis: all populations variances are equal
library(car)
leveneTest(value ~ condition, data = data_preLE) 

## see if rank transformation improves model fit
plot(lmer(value ~ condition + PVT_no + (1| PB_No) + (1| gender), data = data_LE))
plot(lmer(value_rank ~ condition+PVT_no + (1| PB_No) + (1| gender), data = data_LE))

qqmath(lmer(value ~ condition+PVT_no + (1| PB_No) + (1| gender), data = data_LE))
qqmath(lmer(value_rank ~ condition+PVT_no + (1| PB_No) + (1| gender), data = data_LE))


## ----------- LIGHT EXPOSURE
# condition effect
BFA <- lmBF(value ~ condition + PVT_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))/
  lmBF(value ~ PVT_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))
summary(BFA) 

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:4])

# condition*time effect
BFA <- lmBF(value ~ condition:PVT_no + condition + PVT_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))/
  lmBF(value ~ condition + PVT_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))
summary(BFA)

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:6])

##----------------------------------------------------------------
#------ SLOWEST 10 PERCENT
data_preLE <- subset(PVT_stat, variable == "slow10per" & time == "Evening_1" & PVT_no < 12)
data_LE <- subset(PVT_stat, variable == "slow10per" & time == "Evening_1" & PVT_no > 11)
data_preLE$PVT_no <- as.factor(data_preLE$PVT_no)
data_LE$PVT_no <- as.factor(data_LE$PVT_no)

# rank transform data
data_preLE$value_rank <- rank(data_preLE$value)
data_LE$value_rank <- rank(data_LE$value)

# test normal distribution
shapiro.test(data_preLE$value)
shapiro.test(data_preLE$value_rank)
shapiro.test(data_LE$value)
shapiro.test(data_LE$value_rank)

# test homogeneity of variances/ null hypothesis: all populations variances are equal
library(car)
leveneTest(value ~ condition, data = data_preLE) 

## see if rank transformation improves model fit
plot(lmer(value ~ condition + PVT_no + (1| PB_No) + (1| gender), data = data_LE))
plot(lmer(value_rank ~ condition+PVT_no + (1| PB_No) + (1| gender), data = data_LE))

qqmath(lmer(value ~ condition+PVT_no + (1| PB_No) + (1| gender), data = data_LE))
qqmath(lmer(value_rank ~ condition+PVT_no + (1| PB_No) + (1| gender), data = data_LE))

## ----------- LIGHT EXPOSURE

# condition effect
BFA <- lmBF(value ~ condition + PVT_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))/
  lmBF(value ~ PVT_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))
summary(BFA) 

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:4])

          # --- follow-up tests
          data_BKG_Y <- subset(data_LE, condition == "Y" | condition == "BKG")
          data_BKG_B <- subset(data_LE, condition == "B" | condition == "BKG")
          data_B_Y <- subset(data_LE, condition == "B"  | condition == "Y")
          
          # -- BKG vs. Y
          BFA <- lmBF(value ~ condition + PVT_no + PB_No + gender, data_BKG_Y, whichRandom = c("PB_No", "gender")) /
            lmBF(value ~ PVT_no + PB_No + gender, data_BKG_Y, whichRandom = c("PB_No", "gender"))
          summary(BFA)
          
          # -- BKG vs. B
          BFA <- lmBF(value ~ condition + PVT_no + PB_No + gender, data_BKG_B, whichRandom = c("PB_No", "gender")) /
            lmBF(value ~ PVT_no + PB_No + gender, data_BKG_B, whichRandom = c("PB_No", "gender"))
          summary(BFA)
          
          # B vs. Y
          BFA <- lmBF(value ~ condition + PVT_no + PB_No + gender, data_B_Y, whichRandom = c("PB_No", "gender")) /
            lmBF(value ~ PVT_no + PB_No + gender, data_B_Y, whichRandom = c("PB_No", "gender"))
          summary(BFA)

# condition*time effect
BFA <- lmBF(value ~ condition:PVT_no + condition + PVT_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))/
  lmBF(value ~ condition + PVT_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))
summary(BFA)

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:6])


