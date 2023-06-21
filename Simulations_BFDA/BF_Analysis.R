###################################################################################
## Code written for Bayes Factor analysis for the "Twilight Study"               ##
##                                                                               ##
## Author:                                                             ##
##                                                                               ##
###################################################################################
rm(list = ls())

# --- set working directory
#p <- 
#setwd(p)

#----- check if pacman is installed - if not install it
if(!require(pacman)) install.packages("pacman")

#----- use pacman function p_load to check all packages that you are using in this script
pacman::p_load(BayesFactor)


####################################################################
#----- Step 1: Simulate some data.
# We are simulating the data for 16 subjects across three conditions here. 
# For demonstration purposes, we are simply simulating data that are not meaningful.
# The purpose is just to show the use of the BayesFactor package.
NSubjects <- 16
NConditions <- 3 
phaseShifts <- rnorm(NSubjects*NConditions, 0, 1)
participantID <- factor(rep(seq(1, NSubjects), NConditions))
condition <- c(rep(1, NSubjects), rep(2, NSubjects), rep(3, NSubjects))
condition <- factor(condition, levels=c(1, 2, 3), labels=c("Background", "+S-(L+M)", "-S+(L+M)"))
gender <- factor(c(rep(1, NSubjects/2), rep(2, NSubjects/2)), levels=c(1, 2), labels=c("Female", "Male"))

# Set it up in a dataframe
df <- data.frame(participantID, condition, phaseShifts, gender)

#----- Step 2: Run the Bayes Factor analysis
bf = anovaBF(phaseShifts ~ condition + participantID + gender, data = df, 
             whichRandom=c("participantID", "gender"))

#----- Step 3: Plot the BFs
plot(bf)