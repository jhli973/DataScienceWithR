
##Preprocessing with principle components analysis
```
library(caret); library(kernlab); data(spam)
inTrain <- createdataPartition(y=spam$type, p=0.75, list=FALSE)

training <- spam[inTrain,]
testing <- spam[-inTrain,]

m <- abs(cor(training[,-58]))
diag(m) <- 0
which(m > 0.8, arr.ind=T)
```
**Correlated predictors**
```
names(spam)[c(34, 32)]

plot(spam[,34], spam[,32])
```
**Basic PCA idea**
+ We might not need every predictor
+ A weighted combination of predictors might be better
+ Pick a combination to capture the "most information" possible
+ Benefits
  + Reduced number of predictors
  + Reduced noise due to averaging

**Rotate the plot to see which way captures the most information**
x = 0.71 x num415 + 0.71 x num857
y = 0.71 x num415 - 0.71 x num857
```
X <- 0.71*training$num415 + 0.71*training$num857
Y <- 0.71*training$num415 - 0.71*training857
plot(X,Y)
```

**Principle**
+ Find a new set of multivariate varaibles that are uncorrelated and explain as much variance as possible
+ If you put all the variables together in one matrix, find the best matrix created with fewer variables (lower rank) that explains the original data

The first goal is statistical and the second goal is data compression.

**Related solutions - PCA/SVD**
SVD (singular value decomposition)
if X is a matrix with each variable in a column and each observation in a row the SVD is a "matrix decomposition"

X = UDV^T^

Where the columns of U are orthogonal

PCA
Equals to the right singular values if you first scale (subtract the mean, divide by the standard deviation) the variables.

**Principle components in R -prcomp** - allow you deal with more than two variables
```
smallSpam <- spam[, c(34,32)]
prComp <- prcomp(smallSpam)
plot(prComp$X[,1], prComp$X[,2])

prComp$rotation

typeColor <- ((spam$type=="spam")*1 + 1)
prComp <- prcomp(log10(spam[,-58] + 1))
plot(prComp$X[,1], prComp$X[,2], col=typeColor, xlab="PC1", ylab="PC2")

#PCA with caret
preProc <- preProcess(log10(spam[,-58]+1), method="pca",pcaComp=2)
spamPC <- predict(preProc, log10(spam[,-58]+1))
plot(spamPC[,1], spamPC[,2], col=typeColor)

preProc <- preProcess(log10(training[,-58]+1), method="pca",pcaComp=2)
trainPC <- predict(preProc, log10(training[,-58]+1))
modelFit <- train(training$type ~ ., method="glm", data=trainPC)

testPC <- predict(preProc, log10(tesing[,-58]+1))
confusionMatrix(testing$type, predict(modelFit, testPC))

# Alternative
modelFit <- train(training$type ~ ., method="glm", preProcess="pca", data=training)
confusionMatrix(testing$type, predict(modelFit, testing))
```

**Final thoughts on PCs**
+ Most useful for linear-type models
+ Can make it harder to interpret predictors
+ Watch out for outliers
  + Transform first(with logs/Box Cox)
  + Plot predictors to identify problems


##Predicting with regression
Pros:
 + Easy to implement and intepret
Cons:
 + Often poor performance in nonlinear settings

**Example: Old faithful eruptions**
```
library(caret); data(faithful); set.seed(333)
inTrain <- createDataPartition(y=faithful$waiting, p=0.5, list=FALSE)

trainFaith <- faithfull[inTrain, ]
testFaith <- faithful[-inTrain, ]
head(trainFaith)
plot(trainFaith$waiting, trainFaith$eruptions, pch=19, col="blue", xlab="Waiting", ylab="Duration")

# Fit a linear model
lm1 <- lm(eruptions ~ waiting, data=trainFaith)
summary(lm1)

par(mfrow=c(1,2))
plot(trainFaith$waiting, trainFaith$eruptions, pch=19, col="blue", xlab="Waiting", ylab="Duration")
lines(trainFaith$waiting, lm1$fitted, lwd=3)
plot(testFaith$waiting, testFaith$eruptions, pch=19, col="blue", xlab="Waiting", ylab="Duration")
ines(trainFaith$waiting, predict(lm1, newdata=testFaith), lwd=3)

coef(lm1)[1] + coef(lm1)[2]*80

newdata <- data.frame(waiting=80)
predict(lm1, newdata)

# Calculate RMSE on training
sqrt(sum(lm1$fitted-trainFaith$eruptions)^2))

# Calculate RMSE on test
sqrt(sum(predict(lm1, newdata=testFaith)-testFaith$eruptions)^2))

# Add prediction intervals
pred1 <- predict(lm1, newdata=testFaith, interval="prediction")
ord <- order(testFaith$waiting)
plot(testFaithwaiting, testFaith$eruptions, pch=19, col="blue")
matlines(testFaith$waiting[ord], pred1[ord,], type="l",
col=c(1,2,2), lty=c(1,1,1), lwd=3)

# Predict with caret
modFit <- train(eruptions ~ waiting, data=trainFaith, metho="lm")
summary(modFit$finalModel)
```
##Predicting with regression Multiple Covariates

Example: Wage data
```
library(ISLR); library(ggplot2); library(caret)
data(Wage)
Wage <- subset(Wage, select=-c(logwage))
sumary(Wage)

inTrain <- createDataPartition(y=Wage$wage, p=0.7, list=FALSE)
training <- Wage[inTrain,]
testing <- Wage[-inTrain,]
```
**Feature plot**
```
featurePlot(x=training[,c("age", "education", "jobclass")],
            y = training$wage, plot="pairs")

qplot(age, wage, data=training)
qplot(age, wage, colour=jobclass,data=training)
```
**Fit a linear model**
```
modFit <- train(wage ~ age + jobclass + education, method="lm", data=training)
finMod <- modFit$finalModel
print(modFit)
```
**Diagnostics**
```
plot(finMod, 1, pch=19, cex=0.5, col="#00000010")

# Color by variables not used in the model
qplot(finMod$fitted, finMod$residuals, colour=race, data=training)

# Plot by index - missing data
plot(finMod$residuals, pch=19)

# plot predicted value vs actual value
pred <- predict(modFit, testing)
qplot(wage, pred, colour=year, data=testing)

# Predict with all covariates
modFitAll <- train(wage ~ ., data=training, method="lm")
pred <- predict(modFitAll, testing)
qplot(wage, pred, data=testing)
```


##Quiz 2
```
install.packages("AppliedPredictiveModeling")
install.packages("caret")
install.packages("Hmisc")
library(AppliedPredictiveModeling)
library(Hmisc)
library(caret)
data(concrete)

set.seed(1000)

inTrain=createDataPartition(mixtures$CompressiveStrength,p=3/4)[[1]]
head(inTrain)

training=mixtures[inTrain,]
testing=mixtures[-inTrain,]
summary(training)

z=cut2(mixtures$Age, g=4)
plot(mixtures$CompressiveStrength,pch=19, col=z)

hist(mixtures$Superplasticizer)

set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[inTrain,]
testing = adData[-inTrain,]


preProc <-preProcess(training[,c( "IL_11","IL_13","IL_16","IL_17E","IL_1alpha","IL_3","IL_4","IL_5","IL_6","IL_6_Receptor","IL_7","IL_8"  )], method='pca', thresh=0.90)
pcaPC = predict(preProc, training[,c( "IL_11","IL_13","IL_16","IL_17E","IL_1alpha","IL_3","IL_4","IL_5","IL_6","IL_6_Receptor","IL_7","IL_8"  )])
names(pcaPC)

#predict with PCA
preProc <-preProcess(training[,c( "IL_11","IL_13","IL_16","IL_17E","IL_1alpha","IL_3","IL_4","IL_5","IL_6","IL_6_Receptor","IL_7","IL_8"  )], method='pca', thresh=0.80)
trainPC <- predict(preProc, training[,c( "IL_11","IL_13","IL_16","IL_17E","IL_1alpha","IL_3","IL_4","IL_5","IL_6","IL_6_Receptor","IL_7","IL_8"  )])

modFitPC <- train(training$diagnosis ~ ., method="glm", data=trainPC)
testPC <- predict(preProc, testing[,c( "IL_11","IL_13","IL_16","IL_17E","IL_1alpha","IL_3"                             ,"IL_4","IL_5","IL_6","IL_6_Receptor","IL_7","IL_8"  )])
confusionMatrix(testing$diagnosis, predict(modFitPC, testPC))

modFit <- train(training$diagnosis ~ IL_11+IL_13+IL_16+IL_17E+IL_1alpha+IL_3+IL_4+IL_5+IL_6+IL_6_Receptor+IL_7+IL_8, method="glm", data=training)
testPred <- predict(modFit, testing[,c( "IL_11","IL_13","IL_16","IL_17E","IL_1alpha","IL_3"                             ,"IL_4","IL_5","IL_6","IL_6_Receptor","IL_7","IL_8"  )])
confusionMatrix(testing$diagnosis,testPred)
```

##Predicting with trees

**Basic algorithm**
+ Start with all variables in one group
+ Find the variables/split that best seperates the outcomes
+ Divide the data into two groups ("leaves") on that split ("Node")
+ Within each split, find the best variables/split that separates the outcomes
+ Continue until the groups are too small or sufficiently "pure"

**Measures of impurity**
+ Misclassification Error:   1 - Phatmk(m)
  0 -- perfect purity ; 0.5 -- no purity

+ Gini index: 
  0 -- perfect purity ; 0.5 -- no purity

+ Deviance/information gain:
  0 -- perfect purity ; 1 -- no purity

![](C:\Users\jli\Documents\MyNotes\Notes\spark\machineLearning2.png)

**Example: Iris data**
```
data(iris); library(ggplot2)
names(iris)
table(iris$Species)

inTrain <- createDataPartition(y=iris$Species, p=0.7, list=FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]
dim(training); dim(testing)

qplot(Petal.Width, Sepal.Width, colout=Species, data=training)

library(caret)
modFit <- train(Species ~., method="rpart", data=training)
print(modFit$finalModel)

# Plot tree
plot(modFit$finalModel, uniform=TRUE, main="Classification Tree")
text(modFit$finalModel, use.n=TRUE, all=TRUE, cex=.8)

# Prettier plots
library(rattle)
fancyRpartPlot(modFit$finalModel)

predict(modFit, newdata=testing)
```

**Notes**
+ Classification trees are non-linear models
  + They use interactions between variables
  + Data transformations may be less important (monotone transformations)
  + Trees can also be used for regression problems
  + R packages for tree building
    + in caret package: party, rpart
    + tree

## Bagging - short for bootstrap aggregating
**Basic idea:**
1. Resample cases and recalculate predictions
2. Average or majority vote

**Notes:**
+ Get similar bias
+ Reduced variance
+ More useful for non-linear functions








