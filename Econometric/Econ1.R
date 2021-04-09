# read the data
mydata<-read.csv("intro_auto.csv")
attach(mydata)

#List the variables
names(mydata)

#show first lines of data
head(mydata) 
mydata[1:10,]

#Descriptive statistics
summary(mpg)
sd(mpg)
length(mpg)
summary(price)
sd(price)

#sort the data
sort(make)

#frequency tables
table(make)
table(make, foreign)

#correlation among variable
cor(price, mpg)

#t-test with a number
t.test(mpg,mu = 20)

#ANOVA equality of means of two groups 
#lm is for linear model
#dependent variable is mpg and groups are foreign and domestic given as factor
anova(lm(mpg ~factor(foreign)))

#OLS regression mpg is dependent variable and weight, length and foreign are independent variables
olsreg <- lm(mpg~weight+length+foreign)
summary(olsreg)
#plot 
plot(mpg ~ weight)
olsreg1 <- lm(mpg~weight)
abline(olsreg1)

#Redefining variables
Y <- cbind(mpg)
X <- cbind(weight,length,foreign)
summary(Y)
summary(X)
olsreg <- lm(Y~X)
summary(olsreg)
