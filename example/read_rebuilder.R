# Load packages
library(reshape2)
library(ggplot2)

# Set the working directory where rebuilding runs are located
rebuild_dir = "C:/rebuilding_folder"

# Read in specific rebuilding runs
# Example 3 runs with folders named: "spr", "spr_high", "spr_fine_step" 
run <- c("spr", "spr_high", "spr_fine_step")

# Read the rebuilder results for each run and put all runs into a list
reb <- list()
for(a in 1:length(run)){
	# get_values function is located in the rebuilder package
	reb[[a]]  <- get_values(rebuild_dir = file.path(rebuild_dir, run[[a]]))	
}

# This function currently works to create figures but could be used with 
# some additional refinement using the do_project_plots function in the rebuilder
# package.
do_project_plots(
	dirn = reb[[1]]$loc, 
	fileN = "RES.CSV",
	ncols = 200,
	Outlines = c(2, 2),
	OutlineMulti = c(2,3),
	pdf = TRUE)


# Here is some modified code that does the cummalative figures in a nice way using 
# reshape2::melt and ggplot2::ggplot

for (a in 1:length(run)){
	x = reb[[a]]

	#Probability Plots
	probs_gg <-reshape2::melt(data = x$prob_matrix[,2:ncol(x$prob_matrix)])
	colnames(probs_gg)<-c("Year", "Scenario", "Prob")
	probs_gg[,"Year"] = rep(x$prob_matrix[,1], length(2:ncol(x$prob_matrix)))
	find = which(probs_gg$Prob <= 1.0 & probs_gg$Year <= (x$tmax + 3*x$mean_gen))
	ggplot2::ggplot(probs_gg[find,], aes(x = Year,y = Prob, color = Scenario)) + 
			geom_line(lwd = 1.5) + ylab("Probability Relative Spawning Output > 40% Spawning Output")
	ggplot2::ggsave(file.path(x$loc, paste0("rebuilding_probability.png")), width = 10, height = 7)
	
	#Catches
	acl_gg <- reshape2::melt(x$acl_matrix[,2:ncol(x$acl_matrix)])
	colnames(acl_gg)<-c("Year", "Scenario", "Catch")
	acl_gg[,"Year"] = rep(x$acl_matrix[,1], length(2:ncol(x$acl_matrix)))
	find = which(acl_gg$Year > 2023 & acl_gg$Year <= (x$tmax + 3*x$mean_gen))
	ggplot2::ggplot(acl_gg[find,], aes(x = Year, y = Catch, color = Scenario)) + 
			geom_line(lwd = 1.5) + ylab("Catches (mt)")
	ggplot2::ggsave(file.path(x$loc, paste0("rebuilding_acl.png")), width = 10, height = 7)
		
	#Spawning output
	sb_gg <- reshape2::melt(x$ssb_matrix[,2:ncol(x$ssb_matrix)])
	colnames(sb_gg)<-c("Year","Scenario","SB")
	sb_gg[,"Year"] = rep(x$ssb_matrix[,1], length(2:ncol(x$ssb_matrix)))
	find = which(sb_gg$Year > 2023 & sb_gg$Year <= (x$tmax + 3*x$mean_gen))
	ggplot2::ggplot(sb_gg[find,], aes(x = Year, y = SB, color = Scenario)) + 
			geom_line(lwd = 1.5) + ylab("Spawning output")
	ggplot2::ggsave(file.path(x$loc, paste0("rebuilding_ssb.png")), width = 10, height = 7)


	#Spawning output relative to the target
	sb_gg <- reshape2::melt(x$relativeb_matrix[,2:ncol(x$relativeb_matrix)])
	colnames(sb_gg)<-c("Year","Scenario","SB")
	sb_gg[,"Year"] = rep(x$relativeb_matrix[,1], length(2:ncol(x$relativeb_matrix)))
	find = which(sb_gg$Year > 2023 & sb_gg$Year <= (x$tmax + 3*x$mean_gen))
	ggplot2::ggplot(sb_gg[find,], aes(x = Year, y = SB, color = Scenario)) + 
			geom_line(lwd = 1.5) + 
			geom_hline(yintercept=1, linetype="dashed", color = "grey", size=1) + 
			ylab("Spawning output relative to 40% spawning output")
	ggplot2::ggsave(file.path(x$loc, paste0("rebuilding_relative_sb.png")), width = 10, height = 7)

}
