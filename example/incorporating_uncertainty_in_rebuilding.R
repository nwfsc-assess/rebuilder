
# Set the working directory where runs are located
rebuild_dir = "C:/rebuilding_folder"

# Create a rebuilding that incorporates uncertainity around R0
# make a table of the 3 states of nature with information about each one
# Code stolen from 2011 yelloweye rockfish rebuilder analysis
statetable <- data.frame(
  iR0 = rep(NA, 3), 
  R0 = rep(NA, 3), 
  dir = rep(NA, 3), 
  weight = rep(NA, 3),
  weight_frac=rep(NA, 3))

st_dir <- file.path(rebuild_dir, "states_of_nature")
n <- 1
for(iR0 in 1:length(dir(st_dir))){
    mydir <- file.path(st_dir, dir(st_dir)[iR0])
    # set index and text for steepness
    statetable$iR0[n] <- iR0
    statetable$R0[n] <- c("mle","high", "low")[iR0]
    # set directory where files are located
    statetable$dir[n] <- mydir
    # set weighting of 1, 2, or 4
    statetable$weight[n] <- c(2, 1, 1)[iR0]
    statetable$weight_frac[n] <- c(0.50, 0.25, 0.25)[iR0]
    n <- n + 1
}

rebuildblend <- NULL
for(i in 1:nrow(statetable)){
  # read rebuild.sso from directories
  rebuildlines <- readLines(paste(statetable$dir[i],"/rebuild.sso",sep=""))
  # take only final section of this file
  # (because file doesn't get deleted when model is rerun and may contain out-of-date values)
  rebuildlines <- rebuildlines[max(1+grep("in maximization mode",rebuildlines)):length(rebuildlines)]
  # print first line to confirm that it looks like some numbers
  print(rebuildlines[1])
  for(j in 1:statetable$weight[i]){
  	header <- c(paste("# values from ",statetable$dir[i],sep=""),
  	            paste("# this is state of nature ",i," out of ",3," (in no particular order)",sep=""),
  	            paste("# and parameter set number ", j, " out of ", statetable$weight[i], sep=""))
  	# can only have 1 header line, must collapse header into 1 line
  	header <- paste(header, collapse=" ")
  	# concatenate new header and lines to existing stuff
  	rebuildblend <- c(rebuildblend, header, rebuildlines)  	
  }
}

# write resulting file
writeLines(rebuildblend, file.path(rebuild_dir, "rebuildblend.sso")))

setwd(file.path(rebuild_dir, 'states_of_nature'))
dirs <- dir()
states <- r4ss::SSgetoutput(dirvec = paste(getwd(), dirs, sep = "/"), getcovar = FALSE)
summaries <- r4ss::SSsummarize(states)

# Double check that the rebuildblend file appears to have the correct values from the state of nature models
a1 <- unique(sort(as.numeric(substring(rebuildblend[grep("#R0", rebuildblend, fixed = TRUE) + 1], 1, 3))))
# a2 is subset of summaries of 9 models with 1916 recruitment (first year after equilbrium for yelloweye)
a2 <- floor(sort(as.numeric(summaries$recruits[summaries$recruits$Yr==1914,1:3])))
# difference between sorted, unique values to check for something out of place
a1 - a2

