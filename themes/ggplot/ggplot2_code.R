# ggplot2_code.R
# 
# Sample code for R Data Cafe (ggplot2). 
# 
# Jonathan de Bruin & Tessa Pronk

### set up the environment
library(ggplot2)
library(dplyr)

# we are using the diamonds dataset in the ggplot package to 
head(diamonds)
str(diamonds)

# We are using a subset of 1000 random records of the diamonds dataset because
# the datasets has a large number of records.
diamonds <- diamonds[sample(nrow(diamonds), 1000),]


### PART 1: quickplot function

# histogram
hist(diamonds$price)
qplot(price, data=diamonds)
quickplot(price, data=diamonds)

# scatterplot
plot(diamonds$price, diamonds$carat)
qplot(price, carat, data=diamonds)

# group colors /shape
plot(diamonds$price, diamonds$carat, col=diamonds$color)
qplot(price, carat, data=diamonds, color=color)
qplot(price, carat, data=diamonds, shape=color)

# type of plot
qplot(price, carat, data=diamonds, geom = "point")
qplot(price, carat, data=diamonds, geom = c("point", "smooth"))

qplot(color, carat, data=diamonds)
qplot(color, carat, data=diamonds, geom = c("boxplot"))
qplot(color, carat, data=diamonds, geom = c("jitter"))

qplot(price, data=diamonds, geom = c("histogram"))
qplot(price, data=diamonds, geom = c("density"))

# facets 
qplot(price, carat, data=diamonds, facets=. ~ cut)
qplot(price, carat, data=diamonds, facets=cut ~ .)
qplot(price, carat, data=diamonds, facets=cut ~ color)

# title, mains and labs
qplot(price, carat, data=diamonds, 
      main = "Carat versus price", 
      xlab = "Price (in dollars)",
      xlim = c(0, 1000))


### PART 2: ggplot function

# ggplot
ggplot(diamonds)
ggplot(diamonds, mapping=aes(x=price, y=carat))
ggplot(diamonds, mapping=aes(x=price, y=carat)) + geom_point()
ggplot(diamonds, mapping=aes(x=price, y=carat, color=color)) + geom_point()

# what is aes? 
?aes

# Construct aesthetic mappings
# 
# Aesthetic mappings describe how variables in the data are mapped to visual
# properties (aesthetics) of geoms. Aesthetic mappings can be set in ggplot2 and
# in individual layers. Aesthetics supplied to ggplot() are used as defaults for
# every layer you can override them, or supply different aesthetics for each
# layer

# the following examples are the same 
ggplot(diamonds, mapping=aes(x=price, y=carat)) + geom_point()
ggplot(diamonds) + geom_point(mapping=aes(x=price, y=carat))

# The power of ggplot is the ability to use layers. In quickplot(), you can 
# specify multiple layers by using multiple value for the `geom` argument. In 
# ggplot, layers are different geom object like you see in the examples below.
ggplot(diamonds, mapping=aes(x=price, y=carat)) + geom_point() + geom_smooth()
ggplot(diamonds, mapping=aes(x=price, y=carat)) + geom_point() + geom_line() + geom_smooth() 

# In contrast with qplot, we can pass different parameters to each geom object. 
ggplot(diamonds, mapping=aes(x=price, y=carat)) + 
  geom_point() + 
  geom_smooth(method='loess', span=0.01) + 
  geom_smooth(method='loess', span=1, color='black') + 
  geom_smooth(method='loess', span=100) + 
  geom_smooth(method='gam', color='red')

# try to reproduce the above with qplot
qplot(price, carat, data=diamonds, geom = c("point", "smooth"), span=0.01)

# plot with layers with different data
ggplot(data = diamonds, mapping = aes(x = price, y = x*y*z)) + 
  geom_point(mapping=aes(color=color)) + 
  geom_smooth(data = filter(diamonds, color == "J"), method='lm', color='red') + 
  geom_smooth(data = filter(diamonds, color == "F"), method='lm', span = 0.2) + 
  ylab("Volume x*y*z") + 
  ggtitle("Price versus color")

