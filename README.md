# rebuilder

U.S. West Coast species (or stocks) where the spawning biomass is estimated to be below the Minimum Stock Size Threshold or are currently managed under a rebuilding plan need to provide quantitative population projections to determine the probability of rebuilding by specific years under alternative harvest strategies. These rebuilding projections are conducted using the "rebuilder" (aka "The Puntalizer") program, created by Dr. Andre Punt, for species management by the Pacific Fishery Management Council (PFMC). 

The rebuilder is designed to work with the rebuild.sso file created by Stock Synthesis when "#_Do_West_Coast_gfish_rebuilder_output" is set to 1 in the forecst.ss file. The rebuilder program produces a number of CSV files with the RES.CSV file containing the needed projection results. Additionally, an Echo.dat file is produced by the program to assist with troubleshooting if the executable fails to run with the rebuild.dat file provided.  

## What tools are available?

This package includes several resources for conducting and analyzing projections conducted by the rebuilder. A user manual that aligns with the latest version of the executable is available in the manual folder and the corresponding executable is available in the inst folder. There are helper functions in the R folder for processing rebuilder output and to create visualization.

## Version
The current version of the rebuilder executable is 3.12j modified in December 2021. Older versions of the rebuilder executable are available upon request (chantel.wetzel@noaa.gov). 

## Terms of reference for West Coast rebuilding plans

The Scientific and Statistical Committee of the PFMC provides guidance on how rebuilding projections should be conducted and what needs to be included in the rebulding plan. A draft version of the rebuilding Terms of Reference can be found online [here](https://www.pcouncil.org/documents/2022/02/e-8-attachment-5-draft-terms-of-reference-for-the-groundfish-rebuilding-analysis-for-2023-2024.pdf/).
