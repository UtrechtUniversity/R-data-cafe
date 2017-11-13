############################################################################################
# This is a training module for making tables during the R data cafe, Utrecht University
# Based on the 'Gebruik-R cursus' 2013 van Jan van Kassteele and Maarten Schipper, RIVM
# Try to work out the excercises, ask for help if you get stuck!
# source is the package ISwR, which contains a dataset for strokes in Estland
###############################################################################


# Read a comma separated dataset with write.csv
read.csv('data/mtcars.csv')

# EXCERCISE: Try to read the dataset data/mtcars2.csv. Do this by changing the
# "sep" argument of the read.csv function.


# there is a built-in function in R to read such files. 
read.csv2(mtcars, 'data/mtcars2.csv')

# EXCERCISE: Now try to save the files under a different name, but in the same
# format. see help(write.table)

# reading xlsx files is easy. However, it can be hard to install the xlsx package. 
library("xlsx")

# EXCERCISE: read the data/mtcars.xlsx


# EXCERCISE: read the second tab of the data/mtcars.xlsx file (see the help)


# the package 'haven' can be used to read SAS (.sas7bdat) and SPSS (.sav) files. 
library("haven")

# for SAS:
read_sas('data/mtcars.sas7bdat')

# EXCERCISE: read the mtcars.sav and the mtcars.sas7dbat files


#################################################################################
# End of this training module 
###############################################################################################
