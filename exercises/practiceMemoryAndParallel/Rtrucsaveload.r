##########################################################
# R trick: Handling large files or computation
# Based on material of Exp-R course 2013 
# By Jan van de Kassteele en Maarten Schipper
# Handed out at the R data cafe 2017
# By Tessa Pronk (UB) and Jonathan de Bruin (ITS)
##########################################################

# PART 1: Enhancing Memory 

# The error: 'cannot allocate vector of size' indicates a shortage of memory 
# We make a large object containing 500.000.000 nubers, by randomly generating these with 'sample()'.
new<-(sample(1000,50000000,replace=TRUE))
object.size(new)

# With memory.size() jou check how much Mb memory the current R session uses.
memory.size()

# Empty this by removing (rm()))objects.
rm(list=objects())

# Is the use of memory smaller now?  
memory.size()

# No! You also have to dispose the objects. You do that with 'Garbage Collect'
gc()
memory.size()

# You can enhance the size of the memory a bit.
memory.limit()
memory.limit(size=4095)

# Done!
memory.limit()

# PART 2: Enhance your calculation speed 

# We are going to paralellize the 'sample()' example from above.
library(parallel)
# How many cores do you have at your disposal?
detectCores()

# Set up a cluster.
cl<-makeCluster(4)
# Do the calculations on the cluster now. We had 500.000.000 numers. And 4 clusters.
# So every cluster is assigned 125.000.000 numbers to generate by sample(). 
new2<-clusterCall(cl,sample, x=1000, size=12500000, replace=TRUE )
# The output is now four lists of length 125000000. 
# Was the calculation faster than originally?
# Add to get a single object again.
str(new2)
str(unlist(new2))

# Stop the cluster once finished.
stopCluster(cl)

rm(list=objects())
gc()

# PART 3: Reading and writing of large files 

# Reading large files is time consuming.
# Save() wil store your file in binary, comprimising it and making it smaller. 
# With load() jou can load the smaller file and work with it.

# make a large file
new3<-sample(1000,500000,replace=TRUE)  
new3matrix<-matrix(new3,nrow=500,ncol=1000)

object.size(new3matrix)

# Save and load again as binary file: 
save(new3matrix,file="newmatrixbinary")
load("newmatrixbinary")

# Write data to a file:
write.table(new3matrix,file = "newmatrixtxt.txt")
getwd()

# Have a look at the files you stored. 
getwd() # this is the folder you should open in your file browser.
# The .txt file that you saved with 'write.table' is much bigger than the 'save' file!!

###########################################################################
# End R trick
############################################################################

