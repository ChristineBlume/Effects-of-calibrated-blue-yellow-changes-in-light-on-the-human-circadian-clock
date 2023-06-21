#####################################################################################################
## Code written for the Analysis of Visual Comfort Data for Twilight                               ##
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

## load file "VisComf_data.csv"

# condition: BKG = background, B = blue-dim, Y = yellow-bright
# visit: number of the experimental visit
# PB_No: participant number
# gender: participant gender (self-report)
# VisComf_No: Number of assessment (14 in total, one with every melatonin sample)
# avg: averaged comfort score from the following 4 items: how pleasant/bright/glaring the light was and how pleasant the colour was
# brightness: brightness score

# set variable types
data$PB_No <- as.factor(data$PB_No)
data$condition <- as.factor(data$condition)

##-----------------------------------------------------
## STATISTICAL ANALYSES VISUAL COMFORT
##-----------------------------------------------------
data_preLE <- subset(data, VisComf_no < 12)
data_LE <- subset(data, VisComf_no > 11)
data_preLE$VisComf_no <- as.factor(data_preLE$VisComf_no)
data_LE$VisComf_no <- as.factor(data_LE$VisComf_no)

# test normal distribution
shapiro.test(data_preLE$avg) 
shapiro.test(data_LE$avg) 

# test homogeneity of variances/ null hypothesis: all populations variances are equal
library(car)
leveneTest(avg ~ condition, data = data_preLE) 
leveneTest(avg ~ condition, data = data_LE) 

# rank transform data
data_preLE$avg_rank <- rank(data_preLE$avg)
data_LE$avg_rank <- rank(data_LE$avg)

## see if rank transformation improves model fit
# Light Exposure
plot(lmer(avg ~ condition + VisComf_no + (1| PB_No) + (1| gender), data = data_LE))
plot(lmer(avg_rank ~ condition+VisComf_no + (1| PB_No) + (1| gender), data = data_LE))

qqmath(lmer(avg ~ condition+VisComf_no + (1| PB_No) + (1| gender), data = data_LE))
qqmath(lmer(avg_rank ~ condition+VisComf_no + (1| PB_No) + (1| gender), data = data_LE))

## -------- DURING LIGHT EXPOSURE
# condition effect
BFA <- lmBF(avg ~ condition + VisComf_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))/
  lmBF(avg ~ VisComf_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))
summary(BFA) 

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:4])


# time*condition effect
BFA <- lmBF(avg ~ condition:VisComf_no + condition + VisComf_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))/
  lmBF(avg ~ condition + VisComf_no + PB_No + gender, data_LE, whichRandom = c("PB_No", "gender"))
summary(BFA) 

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:5])


##---------------------------------------------------------------------------------------------------
##---------------------------------------------------------------------------------------------------
## -------- brightness PRIOR TO LIGHT EXPOSURE 
# test normal distribution
shapiro.test(data_preLE$brightness)

# test homogeneity of variances/ null hypothesis: all populations variances are equal
library(car)
leveneTest(brightness ~ condition, data = data_preLE) 

# rank transform data
data_preLE$brightness_rank <- rank(data_preLE$brightness)

## see if rank transformation improves model fit
# pre Light Exposure
plot(lmer(brightness ~ condition + VisComf_no + (1| PB_No) + (1| gender), data = data_preLE))
plot(lmer(brightness_rank ~ condition+VisComf_no + (1| PB_No) + (1| gender), data = data_preLE))

qqmath(lmer(brightness ~ condition+VisComf_no + (1| PB_No) + (1| gender), data = data_preLE))
qqmath(lmer(brightness_rank ~ condition+VisComf_no + (1| PB_No) + (1| gender), data = data_preLE))

## Analyses
# condition effect
BFA <- lmBF(brightness ~ condition + VisComf_no + PB_No + gender, data_preLE, whichRandom = c("PB_No", "gender"))/
  lmBF(brightness ~ VisComf_no + PB_No + gender, data_preLE, whichRandom = c("PB_No", "gender"))
summary(BFA) 

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:4])


        # --- follow-up tests
        data_BKG_Y <- subset(data_preLE, condition == "Y" | condition == "BKG")
        data_BKG_B <- subset(data_preLE, condition == "B" | condition == "BKG")
        data_B_Y <- subset(data_preLE, condition == "B"  | condition == "Y")
        
        # BKG vs. Y
        BFA <- lmBF(brightness ~ condition + VisComf_no + PB_No + gender, data_BKG_Y, whichRandom = c("PB_No", "gender"))/
          lmBF(brightness ~ VisComf_no + PB_No + gender, data_BKG_Y, whichRandom = c("PB_No", "gender"))
        summary(BFA) 
        
        
        # BKG vs. B
        BFA <- lmBF(brightness ~ condition + VisComf_no + PB_No + gender, data_BKG_B, whichRandom = c("PB_No", "gender"))/
          lmBF(brightness ~ VisComf_no + PB_No + gender, data_BKG_B, whichRandom = c("PB_No", "gender"))
        summary(BFA) 
        
        
        # Y vs. B
        BFA <- lmBF(brightness ~ condition + VisComf_no + PB_No + gender, data_B_Y, whichRandom = c("PB_No", "gender"))/
          lmBF(brightness ~ VisComf_no + PB_No + gender, data_B_Y, whichRandom = c("PB_No", "gender"))
        summary(BFA) 
        

# time x condition effect
BFA <- lmBF(brightness ~ condition:VisComf_no + condition + VisComf_no + PB_No + gender, data_preLE, whichRandom = c("PB_No", "gender"))/
  lmBF(brightness ~ condition + VisComf_no + PB_No + gender, data_preLE, whichRandom = c("PB_No", "gender"))
summary(BFA) 

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:5])