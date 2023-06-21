###################################################################################
## Code written for Bayes Factor Design Analysis "Twilight Study"                ##
##                                                                               ##
## Author: 	                                                                     ##
## Based on https://rawgit.com/nicebread/BFDA/master/package/doc/BFDA_manual.html##
##                                                                               ##
## this simulation has been calculated using version 0.5.0 (date: 05/06/20)      ##
## on a Windows 10 machine                                                       ##
###################################################################################
rm(list = ls())

# --- set working directory
#p <- 
#setwd(p)

#----- check if pacman is installed - if not install it
if(!require(pacman)) install.packages("pacman")

#----- use pacman function p_load to check all packages that you are using in this script
pacman::p_load(ggplot2, viridis, BayesFactor, devtools)

#----- install BFDA package from Github if necessary
if("nicebread/BFDA" %in% rownames(installed.packages()) == FALSE) {install_github("nicebread/BFDA", subdir="package")}
pacman::p_load(BFDA)

####################################################################
#----- Step 1a: Simulate H1 & H0 world
# As we do not know in advance whether H1 or H0 provide a better predictive performance of real world data, 
# we want to evaluate the performance of a design under both hypotheses. 
# Duration: approx. 20-25min per simulation on 7 cores

# ES.H1 = 0.8 # Cohen's d: smallest effect size of interest
# sim.H1 <- BFDA.sim(expected.ES=ES.H1, type="t.paired",
#                    prior=list("Cauchy",list(prior.location=0, prior.scale=sqrt(2)/2)), #default prior, equivalent to the BayesFactor package
#                    n.min=4, n.max=16, alternative="greater", design = "fixed.n", # if design = "fixed.n" only n.max will be considered
#                    boundary=Inf, B=10000,
#                    verbose=TRUE, cores=detectCores(all.tests = FALSE, logical = TRUE), stepsize = 1) # cores: add as many as you have
# 
# sim.H0 <- BFDA.sim(expected.ES=0, type="t.paired",
#                    prior=list("Cauchy",list(prior.location=0, prior.scale=sqrt(2)/2)), #default prior, equivalent to the BayesFactor package
#                    n.min=4, n.max=16, alternative="greater", design = "fixed.n",
#                    boundary=Inf, B=10000,
#                    verbose=TRUE, cores=detectCores(all.tests = FALSE, logical = TRUE), stepsize = 1) # cores: add as many as you have

#----- Step 1b: Load simulated data
# To avoid time-consuming simulations
load(paste(p, "BFDA_SimData_largeES.RData", sep = ""))

#----- Step 2: Analyze the simulations
# The results of the analysis show in how many percent of the simulated iterations (see the B in the BFDA.sim function) 
# the Bayes factor exceeded the upper or lower boundary, that is, in how many percent of the simualted iterations 
# "strong enough evidence" for H0 or H1 could be achieved.

BFDA.analyze(sim.H1, design="fixed", n=16, boundary=10)
BFDA.analyze(sim.H0, design="fixed", n=16, boundary=10)

#---- Step 3: Visualise the results
# The following function gives a graphic representation of the distribution of Bayes factors for a fixed-N design. 
# Bayes factors showing "strong enough" evidence (as defined by the boundary argument) in the right direction are shown in green, 
# Bayes factors showing "strong enough" evidence in the wrong direction are shown in red. 
# Inconclusive evidence is indicated in yellow color.

# prep plot
date <- Sys.Date()
savename = "BFDA_plot_largeES"
savename = paste(savename, date, sep = "")
png(paste(savename, ".png", sep = ""), res = 600, width = 20, height = 10, units = "cm") # open PNG file

evDens(BFDA.H1=sim.H1, BFDA.H0=sim.H0, n=16, boundary=c(1/10, 10), xlim=c(1/11, 31))

dev.off()
#---- Step 4: Sample size determination
# What sample size do you need to ensure, say, 80% probability that a study design finds an effect of size of 0.5, 
# that is, that at least 80% of resulting Bayes factors are equal or larger than the upper boundary (here: BF >= 10) 
# when the population effect size is d=0.2?

SSD(sim.H1, power=.80, boundary=c(1/10, 10), alpha = .05) #error, opened issue on Github on 05 06 20