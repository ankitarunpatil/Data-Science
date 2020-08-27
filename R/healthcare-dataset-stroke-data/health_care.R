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

setwd=("D:/Data Analytics-527/Project/healthcare-dataset-stroke-data")
train_data = read.csv("train_2v.csv",header=T)
head(train_data)


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



#-------------------Nor sure what this is doing-----------------#
#Removing the customer ID column as we do not need the same for prediction of 
#smoke_final=smoke_final[ , -which(names(smoke_final) %in% c(""))]
#head(smoke_data)

  
#change the output variable to yes and no

smoke_final$stroke=as.factor(ifelse(smoke_final$stroke==1, 'YES', 'NO'))
summary(smoke_final$stroke)

# Hold out, splitting data into test and train

#Divide the data we have into training and test 
select.data = sample(1:nrow(smoke_final),0.7*nrow(smoke_final))
smoke_train=smoke_final[select.data,]
smoke_test=smoke_final[-select.data,]

#head(all_smoke_data)

head(smoke_test)




#Build the first model using all variables(logistic)
model1 = glm(stroke ~ ., data = smoke_train, family = binomial("logit"),maxit=100)
summary(model1) 
summary(smoke_train$stroke)
#smokw=$pred


#-------Predict not working----------------#
#predict

pred <- predict(model1,smoke_test)
pred
summary(pred)
smoke_test$pred <- pred

smoke_final.prob <- model1 %>% predict(smoke_test, type = "response")

predi = predict(model1, type="response", smoke_test)
#table(train.smoke_data$stroke,test.smoke_data$stroke_pred)
predi
summary(predi)


#confusion matrix needs factors as data
smoke_test$predi=as.factor(ifelse(smoke_test$predi==1, 'YES', 'NO'))

smoke_test$stroke =as.factor(ifelse(smoke_test$stroke==1, 'YES', 'NO'))

#smoke_train$stroke =as.factor(ifelse(smoke_test$stroke==1, 'YES', 'NO'))


#Confusion

confusionMatrix(smoke_test$pred,smoke_test$stroke)
smoke_test$stroke
smoke_test$pred

pred_smoke <- factor(ifelse(pred >= 0.50, "Yes", "No"))
actual_smoke <- factor(ifelse(test.smoke_data$stroke==1,"Yes","No"))
table(actual_smoke,pred_smoke)

confusionMatrix(actual_smoke,pred_smoke)

#---------------------------------------------#

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



m1<-knn(train=smoke_train, test=smoke_test, cl=smoke_train$stroke, k=13)
m1
summary(m1)


confusionMatrix(table(m1 ,smoke_test$stroke))
