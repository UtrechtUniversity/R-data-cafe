############################################################################################
# This is a training module for making tables during the R data cafe, Utrecht University 4 September 2017
# Based on the 'Gebruik-R cursus' 2013 van Jan van Kassteele and Maarten Schipper (RIVM)
# Try to work out the excercises, ask for help if you get stuck!
# Source is the package ISwR, which contains a dataset for strokes in Estland
###############################################################################

install.packages("ISwR") # you only have to do this the first time 
library(ISwR)
# The dataset is already loaded with the library. You can work on it right away.


### EXCERCISE: get to know the dataset. It's name is 'stroke'. Use dim(), str(), head().  

# Now the dgn column is the 'diagnose'. How many patients are in each diagnose? We use table().
with(stroke, table(dgn))

# could also have said:
table(stroke$dgn)

# now check how many patients of each diagnose have diabetes Yes/No. This is the column 'diab'
with(stroke, table(dgn, diab))

### EXERCISE: do the number add up to what you saw in number of rows with dim()? How is it possible? 

### EXERCISE: Extend the table function above with an extra parameter: 'useNA'. Check the ‘help’ window in Rstudio how to do it.

### EXERCISE: see how many patients with each diagnose were Male/Female

### EXERCISE: now extend the table function: how many of the patients with which diagnose had diabetes and male/female?

# This can become difficult to interpret, especially with more splits to characteristics.
# You can use the function ftable to make it 'flat' again.

stroke3D <- with (stroke, table(dgn, diab, sex))
ftable(stroke3D)

# And you can manipulate the variables in rows and columns too
ftable(stroke3D, row.vars="dgn", col.vars=c("diab", "sex"))

F3D <- ftable(stroke3D, row.vars="dgn", col.vars=c("diab", "sex"))

# Show the relative numbers in the table with prop.table()
round(prop.table(F3D),digits=2)

### EXERCISE: what does 'round()' do? What happens if you omit this?

#################################################################################
# End of this training module 
###############################################################################################
