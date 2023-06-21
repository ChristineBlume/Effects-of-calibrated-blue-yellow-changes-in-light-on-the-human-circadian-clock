#####################################################################################################
## Code written for the Analysis of KSS Data for Twilight                                          ##
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

## load file "KSS_data.csv"

# condition: BKG = background, B = blue-dim, Y = yellow-bright
# appointment: number of the experimental visit
# PB_No: participant number
# gender: participant gender (self-report)
# KSS_No: number if KSS (i.e., 14 in total, one with every Melatonin sample)
# KSS_value: value participants indicated on the KSS

# -- set variable types
data$PB_No <- as.factor(data$PB_No)
data$condition <- as.factor(data$condition)
data$time <- as.factor(data$time)
data$gender <- as.factor(data$gender)


#######################
#----- Plots & Stats
#######################

## --- STATS
# reduce data
data$KSS_no <- as.numeric(data$KSS_no)
data_E1_LE <- subset(data, time == "Evening_1" & KSS_no > 11)
data_E1_preLE <- subset(data, time == "Evening_1" & KSS_no < 12)
data$KSS_no <- as.factor(data$KSS_no)

# test normal distribution
shapiro.test(data_E1_LE$KSS_value) 
shapiro.test(data_E1_preLE$KSS_value)

# test homogeneity of variances/ null hypothesis: all populations variances are equal
library(car)
leveneTest(KSS_value ~ condition, data = data_E1_LE) 
leveneTest(KSS_value ~ condition, data = data_E1_preLE) 

# rank transform data
data_E1_LE$KSS_value_rank <- rank(data_E1_LE$KSS_value)
data_E1_preLE$KSS_value_rank <- rank(data_E1_preLE$KSS_value)

## see if rank transformation improves model fit
# pre Light Exposure
plot(lmer(KSS_value ~ condition + KSS_no + (1| PB_No) + (1| gender), data = data_E1_preLE))
plot(lmer(KSS_value_rank ~ condition+KSS_no + (1| PB_No) + (1| gender), data = data_E1_preLE))

qqmath(lmer(KSS_value ~ condition+KSS_no + (1| PB_No) + (1| gender), data = data_E1_preLE))
qqmath(lmer(KSS_value_rank ~ condition+KSS_no + (1| PB_No) + (1| gender), data = data_E1_preLE))

# Light Exposure
plot(lmer(KSS_value ~ condition + KSS_no + (1| PB_No) + (1| gender), data = data_E1_LE))
plot(lmer(KSS_value_rank ~ condition+KSS_no + (1| PB_No) + (1| gender), data = data_E1_LE))

qqmath(lmer(KSS_value ~ condition+KSS_no + (1| PB_No) + (1| gender), data = data_E1_LE))
qqmath(lmer(KSS_value_rank ~ condition+KSS_no + (1| PB_No) + (1| gender), data = data_E1_LE))


## ----- During LE
# -- factor condition
BFA <- lmBF(KSS_value ~ condition + KSS_no + PB_No + gender, data_E1_LE, whichRandom = c("PB_No", "gender")) /
  lmBF(KSS_value ~ KSS_no + PB_No + gender, data_E1_LE, whichRandom = c("PB_No", "gender"))
summary(BFA) 
BFA_interpret(BFA)

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:4])

# -- factor condition - rank-based
BFA <- lmBF(KSS_value_rank ~ condition + KSS_no + PB_No + gender, data_E1_LE, whichRandom = c("PB_No", "gender")) /
  lmBF(KSS_value_rank ~ KSS_no + PB_No + gender, data_E1_LE, whichRandom = c("PB_No", "gender"))
summary(BFA) 
BFA_interpret(BFA)

# -- adding time * condition interaction
BFA <- lmBF(KSS_value ~ condition:KSS_no + condition + KSS_no + PB_No + gender, data_E1_LE, whichRandom = c("PB_No", "gender")) /
  lmBF(KSS_value ~ condition + KSS_no + PB_No + gender, data_E1_LE, whichRandom = c("PB_No", "gender"))
summary(BFA) 
BFA_interpret(BFA)

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:6])

# -- adding time * condition interaction / rank-based
BFA <- lmBF(KSS_value_rank ~ condition:KSS_no + condition + KSS_no + PB_No + gender, data_E1_LE, whichRandom = c("PB_No", "gender")) /
  lmBF(KSS_value_rank ~ condition + KSS_no + PB_No + gender, data_E1_LE, whichRandom = c("PB_No", "gender"))
summary(BFA) 
BFA_interpret(BFA)

##-------------------------------------------------------------------------------------------------------------
## ----- Prior to LE
# stats
BFA <- lmBF(KSS_value ~ condition + KSS_no + PB_No + gender, data_E1_preLE, whichRandom = c("PB_No", "gender")) /
  lmBF(KSS_value ~ KSS_no + PB_No + gender, data_E1_preLE, whichRandom = c("PB_No", "gender"))
summary(BFA) # 
BFA_interpret(BFA)

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:4])

      # --- follow-up tests
      data_E1_BKG_Y <- subset(data_E1_preLE, condition == "Y" | condition == "BKG")
      data_E1_BKG_B <- subset(data_E1_preLE, condition == "B" | condition == "BKG")
      data_E1_B_Y <- subset(data_E1_preLE, condition == "B"  | condition == "Y")
      
      # BKG vs. Y
      # BFA <- ttestBF(x = data_E1$KSS_value[data_E1$condition=="BKG"], y = data_E1$KSS_value[data_E1$condition=="Y"], paired=TRUE)
      BFA <- lmBF(KSS_value ~ condition + KSS_no + PB_No + gender, data_E1_BKG_Y, whichRandom = c("PB_No", "gender")) /
        lmBF(KSS_value ~ KSS_no + PB_No + gender, data_E1_BKG_Y, whichRandom = c("PB_No", "gender"))
      summary(BFA) 
      BFA_interpret(BFA)
      
      # BKG vs. B
      BFA <- lmBF(KSS_value ~ condition + KSS_no + PB_No + gender, data_E1_BKG_B, whichRandom = c("PB_No", "gender")) /
        lmBF(KSS_value ~ KSS_no + PB_No + gender, data_E1_BKG_B, whichRandom = c("PB_No", "gender"))
      summary(BFA) 
      BFA_interpret(BFA)
      
      # B vs. Y
      BFA <- lmBF(KSS_value ~ condition + KSS_no + PB_No + gender, data_E1_B_Y, whichRandom = c("PB_No", "gender")) /
        lmBF(KSS_value ~ KSS_no + PB_No + gender, data_E1_B_Y, whichRandom = c("PB_No", "gender"))
      summary(BFA) 
      BFA_interpret(BFA)
      
# --  time * condition interaction
BFA <- lmBF(KSS_value ~ condition:KSS_no + condition + KSS_no + PB_No + gender, data_E1_preLE, whichRandom = c("PB_No", "gender")) /
  lmBF(KSS_value ~ condition + KSS_no + PB_No + gender, data_E1_preLE, whichRandom = c("PB_No", "gender"))
summary(BFA)
BFA_interpret(BFA)

estimatesBFA <- posterior(BFA, iterations = 10000)
summary(estimatesBFA [,1:5])