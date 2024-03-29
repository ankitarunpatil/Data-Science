#Install packages
install.packages("tidyverse") 
install.packages("MASS")
install.packages("car")
install.packages("e1071")
install.packages("caret")
install.packages("cowplot")
install.packages("caTools")
install.packages("pROC")
install.packages("ggcorrplot")
#install.packages("ggplot2") --In tidyverse
install.packages("class")
install.packages("Hmisc")
install.packages("sjPlot")
install.packages("PRROC")
install.packages("Metrics")
install.packages("class")

#Library
#Libraries
library(class)
library(tidyverse) 
library(MASS)
library(car)
library(e1071)
library(caret)
library(cowplot)
library(caTools)
library(pROC)
library(ggcorrplot)
#library(ggplot2)
library(dummies)
library(plyr)
library(dplyr)
library(class)
library(Hmisc)
library(sjPlot)
library(PRROC)
library(klaR)
library(Metrics)

setwd("D:/Data Analytics-527/project/healthcare-dataset-stroke-data/")
train_data = read.csv("train_2v.csv",header=T)


#Check if there are any missing values in the columns
na_count=sapply(train_data, function(y) sum(length(which(is.na(y)))))
na_count=data.frame(na_count)
na_count

str(train_data)

(train_data$stroke)


#Data Preprocessing

#We find that there are 11 missing values for the TotalCharges column
#Replace those missing valyes with the mean value
train_data$bmi=ifelse(is.na(train_data$bmi),ave(train_data$bmi,FUN = function(x) mean(x,na.rm = TRUE)),train_data$bmi)

str(train_data)

sum(is.na(train_data))
#smoke_data = [ train_data$id %in% train_data$id & train_data$smoking_status != "", ]

smoke_data = train_data[ train_data$id %in% train_data$id & train_data$smoking_status != "", ]
str(smoke_data)


na.omit(smoke_data$smoking_status)


#Removing the customer ID column as we do not need the same for prediction of 
smoke_data=smoke_data[ , -which(names(smoke_data) %in% c("id"))]
head(smoke_data)


#yes no conversion for visualisation
smoke_data$hypertension=as.factor(ifelse(smoke_data$hypertension==1, 'YES', 'NO'))
summary(smoke_data$hypertension)

smoke_data$heart_disease=as.factor(ifelse(smoke_data$heart_disease==1, 'YES', 'NO'))
summary(smoke_data$heart_disease)

smoke_data$stroke=as.factor(ifelse(smoke_data$stroke==1, 'YES', 'NO'))
summary(smoke_data$stroke)

head(smoke_data)

#Drawing bar plots
countgender=table(smoke_data$gender,smoke_data$stroke)
barplot(countgender, main="Gender vs STroke", xlab="STroke Yes or No", col=c("darkblue","red"),legend=rownames(countgender))


#draw all the plots similarly

#Plot for bmi
ggplot(smoke_data, aes(y= bmi, x = "", fill = stroke)) + 
  geom_boxplot()+ 
  theme_bw()+
  xlab(" ")


ggplot(smoke_data, aes(y= avg_glucose_level, x = "", fill = stroke)) + 
  geom_boxplot()+ 
  theme_bw()+
  xlab(" ")



#ANOVA testing for TotalCharges and Churn similarly do for all
#Anova plot
#Null Hypothesis:Mean of the Total Charges when Churn is Yes and when Churn is No is the same.
#Alternate Hypothesis: Means of the total charges for the 2 churn possibilities are different.
#Assume alpha=0.5
#Anova plot
ggplot(telco, aes(y= tenure, x = Churn, fill = TotalCharges)) + 
  geom_boxplot()+ 
  theme_bw()+
  xlab(" ")
#Performing analysis with Anova
TotalCharges =telco$TotalCharges
Churn=telco$Churn
anovatt=lm(TotalCharges~Churn)
summary(anovatt)
#Conclusion:HEre CHurcnNo is taken as the base. Comparing ChurnYes to ChurnNo, the pvalue is less than alpha.
#Therefore we can reject the null hypothesis that the means of the Total charges are the same. 
#There is significant difference in the means of total charges

#boxplot(smoke_data$bmi)

# Now you can assign the outlier values into a vector

#outliers <- boxplot(smoke_data$bmi, plot=FALSE)$out

# Check the results

#print(outliers)

# First you need find in which rows the outliers are


#data preprocessing

#NOrmalising the data

#dealing with numerical variables

head(smoke_data)
smoke_num = smoke_data[,c(2,8,9)]
head(smoke_num)


#Dealing with numerical variables
#telco_num=telco1[,c(5,18,19)]
#head(telco_num)
#telco_num=data.frame(sapply(telco_num, as.numeric))
#head(telco_num)

#Normalization function
norm=function(n) {
  return((n-min(n))/(max(n)-min(n)))
}

#normalize
smoke_num$age=norm(smoke_num$age)
smoke_num$avg_glucose_level = norm(smoke_num$avg_glucose_level)
smoke_num$bmi=norm(smoke_num$bmi)

head(smoke_num)

# categorial

smoke_cat = smoke_data[,-c(2,8,9)]
head(smoke_cat)

#dealing with categorical

smoke_cat=data.frame(sapply(smoke_cat,function(x) data.frame(model.matrix(~x-1,data =smoke_cat))[,-1]))
head(smoke_cat)

smoke_final = cbind(smoke_num,smoke_cat)
head(smoke_final)

summary(smoke_final$stroke)

#smoke_final$stroke=as.factor(ifelse(smoke_final$stroke==1, 'YES', 'NO'))
#summary(smoke_final$stroke)
#summary(smoke_final)
#head(smoke_final)



require(caTools)
set.seed(101) 
sample = sample.split(smoke_final$stroke, SplitRatio = .75)
train = subset(smoke_final, sample == TRUE)
test  = subset(smoke_final, sample == FALSE)

summary(train)
summary(test)
#data(mtcars)



install.packages("ROSE")
library(ROSE)



train <- ROSE(stroke ~ ., data = train, seed = 1)$data
test <- ROSE(stroke ~ ., data = test, seed = 1)$data
## 75% of the sample size
#smp_size <- floor(0.75 * nrow(smoke_final$stroke))

## set the seed to make your partition reproducible
#set.seed(123)
#train_ind <- sample(seq_len(nrow(smoke_final)), size = smp_size)

#train <- smoke_final[train_ind, ]
#test <- smoke_final[-train_ind, ]

#str(train)
#str(test)

#set.seed(88)
#split <- sample.split(smoke_final$stroke, SplitRatio = 0.75)
#summary(split)
#get training and test data
#dresstrain <- subset(smoke_final$stroke, split)
#dresstest <- subset(smoke_final, !=(split))

#str(dresstrain)
#str(dresstest)

#logistic regression model
#model <- glm (stroke ~ ., data = train, family = "binomial")

#summary(model)



#confusionMatrix(model,test$stroke)

#str(model)

#predict1 <- predict(model, test, type = 'response')

#predict <- predict(model, type = 'response')

#table(test$stroke, predict1 > 0.5)
#str(predict1)
#head(predict)
#summary(predict)
#tapply(predict1, test$stroke, mean)
#table(train$stroke, predict > 0.5)

#predict=as.numeric(predict>0.5, 'YES', 'NO')
#str(predict)

#predict1=as.numeric(predict1>0.5, 'YES', 'NO')
#str(predict1)
#head(predict1)

#test$stroke
#predict1

#predict1 =as.factor(ifelse(predict==1,'Yes','No'))
#str(predict1)
#str(predict)
#head(predict1)

#train$stroke =as.factor(ifelse(train$stroke==1,'Yes','No'))
#str(train$stroke)
#head(train$stroke)
#confusionMatrix(predict1,reference=test$stroke)
#str(stroke)

#str(predict1)
#str(train$stroke)
#levels(predict1) <- list("No" = "1", "Yes" = "2")
#str(predict1)


#confusionMatrix(data = predict1, reference = test$stroke)

#confusionMatrix(table(predict1 ,test$stroke))
#predict1
#str(predict1)
#str(test$stroke)

#ROCR Curve
library(ROCR)
ROCRpred <- prediction(predict, train$stroke)
ROCRperf <- performance(ROCRpred, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE, text.adj = c(-0.2,1.7))


#ROCRpred1 <- prediction(predict, test$stroke)
#ROCRperf1 <- performance(ROCRpred1, 'tpr','fpr')
#plot(ROCRperf1, colorize = TRUE, text.adj = c(-0.2,1.7))

#confusion matrix


#table(dresstrain$Recommended, predict > 0.5)





#confusion matrix needs factors as data
#predict=factor(ifelse(predict==1, 'YES', 'NO'))
#head(predict)
#str(predict)
#summary(predict)

#train$stroke =factor(ifelse(train$stroke==1, 'YES', 'NO'))
#head(train$stroke)

#smoke_train$stroke =as.factor(ifelse(smoke_test$stroke==1, 'YES', 'NO'))


#Confusion

#str(smoke_test$pred)
#str(smoke_test$stroke)

#confusionMatrix(prd,train$stroke)
#smoke_test$stroke
#smoke_test$pred

#pred_smoke <- factor(ifelse(predict >= 0.50, "Yes", "No"))
#str(pred_smoke)
#actual_smoke <- factor(ifelse(test.smoke_data$stroke==1,"Yes","No"))
#table(actual_smoke,pred_smoke)

#confusionMatrix(table(model,predict))
#str(train$stroke)
#str(predict)














#-------------------Nor sure what this is doing-----------------#
#Removing the customer ID column as we do not need the same for prediction of 
#smoke_final=smoke_final[ , -which(names(smoke_final) %in% c(""))]
#head(smoke_data)


#change the output variable to yes and no

smoke_final$stroke=as.factor(ifelse(smoke_final$stroke==1, 'YES', 'NO'))
summary(smoke_final$stroke)
summary(smoke_final)
head(smoke_final)
# Hold out, splitting data into test and train

#Splitting the data
set.seed(123)
select.data = sample.split(smoke_final$stroke, SplitRatio = 0.7)
smoke_train = smoke_final[select.data,]
summary(smoke_train)
smoke_test = smoke_final[!(select.data),]
summary(smoke_test)

#Divide the data we have into training and test 
select.data = sample(1:nrow(smoke_final),0.7*nrow(smoke_final))
summary(select.data)
head(select.data)
smoke_train=smoke_final[select.data,]
smoke_test=smoke_final[-select.data,]

#head(all_smoke_data)

head(smoke_test$stroke)
head(select.data)

#smoke_test$stroke=as.numeric(ifelse(smoke_test$stroke=='YES', 1, 0))
#smoke_train$stroke=as.numeric(ifelse(smoke_train$stroke=='YES', 1, 0))

str(smoke_test)
str(smoke_train)

#Build the first model using all variables(logistic)
model1 = glm(stroke ~ ., data = smoke_train, family = binomial("logit"),maxit=100)
summary(model1) 
summary(smoke_train$stroke)
#smokw=$pred

vif(model1)
plotROC()
#predict

pred <- predict(model1,smoke_test)
pred
summary(pred)
smoke_test$pred <- pred
head(smoke_test$pred)
smoke_test$pred

#table(train.smoke_data$stroke,test.smoke_data$stroke_pred)


smoke_test$pred<-predict(model1, smoke_test, type="class")

#confusion matrix needs factors as data
smoke_test$pred=as.factor(ifelse(smoke_test$pred==1, 'YES', 'NO'))
head(smoke_test$pred)

smoke_test$stroke =as.factor(ifelse(smoke_test$stroke==1, 'YES', 'NO'))
head(smoke_test$stroke)

#smoke_train$stroke =as.factor(ifelse(smoke_test$stroke==1, 'YES', 'NO'))


#Confusion

str(smoke_test$pred)
str(smoke_test$stroke)

confusionMatrix(smoke_test$pred,smoke_test$stroke)
smoke_test$stroke
smoke_test$pred

pred_smoke <- factor(ifelse(pred >= 0.50, "Yes", "No"))
actual_smoke <- factor(ifelse(test.smoke_data$stroke==1,"Yes","No"))
table(actual_smoke,pred_smoke)

confusionMatrix(train$stroke,predict)
str(train$stroke)
str(predict)

#Anova testing



head(smoke_test)

#accuracy(smoke_test,model1)
#------------------Now KNN------------#

#pr <- knn(smoke_train,smoke_test,cl=dia_target,k=20)

sum(is.na(smoke_test))
sum(is.na(smoke_train))
summary(smoke_test)
str(smoke_train)
str(smoke_test)

smoke_test$stroke=as.numeric(ifelse(smoke_test$stroke=='YES', 1, 0))
smoke_train$stroke=as.numeric(ifelse(smoke_train$stroke=='YES', 1, 0))


# A 3-nearest neighbours model with no normalization
nn3 <- knn(stroketrain = smoke_train, test = smoke_test,cl = smoke_final$stroke, k=10)

nn3 <- knn(stroke ~ .,smoke_train,smoke_test,norm=FALSE,k=3)

## The resulting confusion matrix
table(testIris[,'Species'],nn3)

## Now a 5-nearest neighbours model with normalization
nn5 <- kNN(Species ~ .,trainIris,testIris,norm=TRUE,k=5)

## The resulting confusion matrix
table(testIris[,'Species'],nn5)


sum(is.na(test))
sum(is.na(train))
summary(test)
str(train)
str(test)

train
length(test)
length(train$stroke)
length(test$stroke)

#test$stroke=as.numeric(ifelse(test$stroke=='YES', 1, 0))
#train$stroke=as.numeric(ifelse(train$stroke=='YES', 1, 0))
#length(train$stroke)
#length(test$stroke)

summary(test$stroke)

m1<-knn(train=train, test=test, cl=train$stroke, k=3)
m1
summary(m1)
str(m1)
#ROC
str(test$stroke)

#fdata = factor(test$stroke)

str(fdata)
knn = factor(m1)
numfdata=as.numeric(m1)
numtest=as.numeric(test$stroke)


test$predicted = predict(numfdata,numtest,"prob")[,2]

levels(test$stroke) <- list("No" = "0", "Yes" = "1")


test$stroke=factor(ifelse(predict==1, 'YES', 'NO'))

confusionMatrix(table(m1 ,test$stroke))

str(m1)

str(test$stroke)  

predict2 <- predict(m1, test$stroke, type = 'response')

summary(predict2)

ROCRpred1 <- prediction(predict, train$stroke)
ROCRperf1 <- performance(ROCRpred1, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE, text.adj = c(-0.2,1.7))





m1<-knn(train=smoke_train, test=smoke_test, cl=smoke_train$stroke, k=13)
m1
summary(m1)


confusionMatrix(table(m1 ,smoke_test$stroke))




#bayes

#modelnb = train(train,test,'nb',trControl=trainControl(method='cv',number=10))
