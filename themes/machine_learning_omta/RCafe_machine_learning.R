require(data.table)
require(caret)
require(doParallel)

#setwd()
dt = fread('https://cla.stratominer.com/DATA/demoData/MLRcafe.txt')
analyticalVariables = names(dt)[8:47]
dt = na.omit(dt, cols=analyticalVariables)
trainingClasses = unique(dt$Class)
trainingClasses = c('POSITIVE', 'NEGATIVE', 'Hec')
trainTest = dt[Class%in%trainingClasses]

samplingRecords = 1000
trainTest = trainTest[,.SD[sample(.N,samplingRecords, replace=FALSE)], by = Class]
trainTest = droplevels(trainTest[Class%in%trainingClasses])

trainingSize = trainTest[,.N] # number of records
set.seed(1234)

# splitting into test and train set
trainingPercentage = 80
sampling = sample.int(trainingSize, ceiling((trainingPercentage/100)*trainingSize)) # 80% vs. 20%
trainData = trainTest[sampling]
testData = trainTest[-sampling]
rm(trainTest)

cores = parallel::detectCores()-1
cluster = makeCluster(cores) # convention to leave 1 core for OS
registerDoParallel(cluster)

fitControl = trainControl(method="cv", number=2, classProbs=TRUE, search = "random", savePredictions = TRUE, allowParallel = TRUE, verboseIter = TRUE) #
classificationModel = try(train(x=trainData[,analyticalVariables, with=FALSE], y=as.factor(trainData[['Class']]), method='parRF', preProcess = c('scale', 'center', 'corr'), ntree = 128, tuneLength=3, trControl= fitControl, verbose = TRUE))
stopCluster(cluster)
registerDoSEQ()	

print(classificationModel)

variableImportance=data.frame(varImp(classificationModel)$importance)
variableImportance$Overall = apply(variableImportance, 1, median) # calculate importance over all classes
variableImportance$Variables=row.names(variableImportance)
variableImportance = variableImportance[,c('Overall', 'Variables')]
names(variableImportance)=c('Importance', 'Variables')
variableImportance=variableImportance[order(variableImportance$Importance),]
variableImportance$id = 1:nrow(variableImportance)

varImpPlot=ggplot(variableImportance, aes(as.numeric(id), as.numeric(Importance), label=Variables)) 
varImpPlot=varImpPlot+geom_point(size = 3, shape=21, fill="#000000", colour="#000000")
varImpPlot=varImpPlot+geom_line(size = 0.5, colour="#000000", linetype=1)
varImpPlot=varImpPlot+geom_text(size=3, vjust=-1.5, check_overlap = TRUE)
varImpPlot=varImpPlot+coord_cartesian()
varImpPlot=varImpPlot+ggtitle("Feature Importance")
varImpPlot=varImpPlot+labs(x = "")
varImpPlot=varImpPlot+xlab("Factors/Variables")
varImpPlot=varImpPlot+ylab("Importance")
varImpPlot=varImpPlot+theme_bw(base_size = 12, base_family = "")
varImpPlot=varImpPlot+theme(legend.position="top", legend.background = element_rect(colour = "black"), plot.title = element_text(size = rel(1.5), colour = "black"), axis.text.y  = element_text(size=rel(1.5)), axis.text.x  = element_text(angle=90, vjust=0.5, size=rel(1.5)), panel.background = element_rect(fill = "white"), panel.grid.major = element_line(colour = "grey40"), panel.grid.minor = element_blank())
print(varImpPlot)


testData$Classification=NULL
testData = data.table(testData, predict(classificationModel, testData[,analyticalVariables, with=F], decision.values=FALSE, type='prob'))
testData[,'Classification':=predict(classificationModel, testData[,analyticalVariables, with=F], decision.values=FALSE, type='raw')]

testData[['pred']]=predict(classificationModel, testData[,analyticalVariables, with=FALSE], decision.values=FALSE)
testData[['Class']] = factor(testData[['Class']])
confusionMatrix = confusionMatrix(data = testData[['pred']], reference = testData[['Class']])
print(confusionMatrix)

modeNoNA = function(x) {
  ux = unique(x[which(!is.na(x))])
  ux[which.max(tabulate(match(x, ux)))]
}

# calculate median or mode per column
calculateMeanWell = function(x) {
  CLASS = class(x)
  acceptedClasses = c('numeric', 'integer') 
  if (CLASS%in%acceptedClasses) {
    x = mean(as.numeric(x), na.rm = TRUE)
  } else {
    x = modeNoNA(x)[1]
    #x = x[!is.na(x)][1]
  }
  return(x)
}

testData = testData[,lapply(.SD, calculateMeanWell), by=wellLocation]
p = ggplot(testData, aes(CellNum, MorphologyV3CellTotalIntenCh2))
p = p + geom_point(aes(color=Classification))
print(p)

rs = dt
rs[,'Classification':=predict(classificationModel, rs[,analyticalVariables, with=F], decision.values=FALSE, type='raw')]
rs = rs[,lapply(.SD, calculateMeanWell), by=wellLocation]
p = ggplot(rs, aes(MorphologyV3CellNeighborAvgDistCh1, MorphologyV3CellTotalIntenCh2))
p = p + geom_point(aes(color=Classification))
print(p)