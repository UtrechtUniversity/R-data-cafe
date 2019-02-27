
##Installing the library and loading

#install.packages("pheatmap")
library(pheatmap)
#install.packages("tidyverse")
library(readr)
library(ggplot2)
library(tidyr)

## Load the data
cellphone <- read_delim("cellphone.csv",delim=",")
cellphone <- column_to_rownames(cellphone,"X1")

## Make a default heatmap in base R
png(filename="heatmap0.png",width=1500,height=750,res=130)
heatmap(as.matrix(cellphone))
dev.off()

## Make a heatmap with pheatmap
png(filename="heatmap1.png",width=1500,height=750,res=130)
pheatmap(cellphone)
dev.off()

## Do not cluster the columns (time)
png(filename="heatmap2.png",width=1500,height=750,res=130)
pheatmap(cellphone, 
         cluster_cols=F)
dev.off()

## Use a different clustering method
png(filename="heatmap3.png",width=1500,height=750,res=130)
pheatmap(cellphone, 
         cluster_cols=F, 
         clustering_method = "single")
dev.off()

## Change the color scheme
png(filename="heatmap4.png",width=1500,height=750,res=130)
k <- colorRampPalette(c("white","gold","firebrick","mediumpurple4"))(100)
pheatmap(cellphone, 
         cluster_cols=F, 
         color=k)
dev.off()

## Change the borders to white
png(filename="heatmap5.png",width=1500,height=750,res=130)
pheatmap(cellphone, 
         cluster_cols=F, 
         color=k, 
         border_color = "white")
dev.off()

## Remove borders altogether
png(filename="heatmap6.png",width=1500,height=750,res=130)
pheatmap(cellphone, 
         cluster_cols=F, 
         color=k, 
         border_color = NA)
dev.off()

## Plot a heatmap with modified data (log(x+1))
png(filename="heatmap7.png",width=1500,height=750,res=130)
cellphone_log <- log(cellphone+1)
pheatmap(cellphone_log, 
         cluster_cols=F,
         color=k,
         border_color=NA)
dev.off()

## Instead of clustering, sort the rows by average pickups
png(filename="heatmap8.png",width=1500,height=750,res=130)
cellphone_log_sort <- cellphone_log[sort(rowMeans(cellphone),index.return=T)$ix,]
pheatmap(cellphone_log_sort, 
         cluster_rows=F,
         cluster_cols=F,
         color=k,
         border_color=NA)
dev.off()

## Label the data with categories
# Here you should probably load a data frame, but we don't have that
# Generate a data frame that labels time blocks with 'sleep' and 'eat'
df <- data.frame(sleep = c(rep("yes",8),rep("no",16)),
                eat = c(rep("no",8),"yes",rep("no",4),"yes",rep("no",4),"yes",rep("no",2),"yes",rep("no",2)))
rownames(df) <- colnames(cellphone)

png(filename="heatmap9.png",width=1500,height=750,res=130)
pheatmap(cellphone,
         cluster_cols=F,
         annotation_col=df)
dev.off()


## Making a heatmap using ggplot and tidyverse
# ggplot requires a long format tidy data frame
cellphone_tidy <- cellphone
cellphone_tidy$names <- row.names(cellphone)
cellphone_tidy <- gather(cellphone_tidy, key="timepoint",value="pickups",-names)

# the time slots should be in order; they are now alphabetized
# instead, make a factor and order the factor levels to the same order as the column names
# in the orginal cellphone data frame
cellphone_tidy$timepoint <- factor(
  cellphone_tidy$timepoint,
  levels=colnames(cellphone))

# generate the heatmap using tidyverse
p <- ggplot(cellphone_tidy,aes(x=timepoint,y=names,fill=pickups)) +
  geom_tile()

ggsave(p,filename="heatmap10.png")
