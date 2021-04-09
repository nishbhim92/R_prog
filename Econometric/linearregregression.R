# read the data
mydata<-read.csv("intro_auto.csv")
attach(mydata)
#Define variables
Y <- cbind(mpg)
X1 <- cbind(weight)
X <- cbind(weight,length,foreign)

#correlation among variables
cor(Y,X)
# plotting data on a scatter diagram

plot(Y~X1, data = mydata)

#simple linear regression
olsreg1 <- lm(Y~X1)
summary(olsreg1)
confint(olsreg1, level = 0.95)
anova(olsreg1)
#plotting regression line
abline(olsreg1)

#predicted values for dependent variables
Y1hat <- fitted(olsreg1)
summary(Y1hat)
plot(Y1hat~X1)

#Regression residuals
e1hat <- resid(olsreg1)
summary(e1hat)
plot(e1hat ~ X1)

#multiple linear regression
olsreg2 <- lm(Y~X)
summary(olsreg2)
confint(olsreg2, level = 0.95)
anova(olsreg2)

#predicted values for dependent variable
Yhat <- fitted(olsreg2)
summary(Yhat)

#regression residuals
ehat<- resid(olsreg2)
summary(ehat)
