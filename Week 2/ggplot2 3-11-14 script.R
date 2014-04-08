##Benefits of ggplot2 over traditional plotting:

#clear workspace
rm(list=ls())

#install ggplot2 Tools->Install packages
#load package
library(ggplot2)

#view datasets
#diamonds dataset is in ggplot2
head(diamonds)
#mtcars dataset is built into R
head(mtcars)
#you can also access datasets here: http://vincentarelbundock.github.io/Rdatasets/datasets.html

###qplot vs ggplot
#histograms
qplot(clarity, data=diamonds, fill=cut, geom="bar")
ggplot(diamonds, aes(clarity,fill=cut))+geom_bar()

###how to use qplot
#scatterplot
qplot(wt,mpg,data=mtcars)
#compare to traditional scatterplot
plot(mpg~wt,data=mtcars)

qplot(log(wt),mpg-10,data=mtcars)
plot(mpg-10~log(wt),data=mtcars)

qplot(wt,mpg,data=mtcars,color=qsec)

qplot(wt,mpg,data=mtcars,color=qsec,size=3)
qplot(wt,mpg,data=mtcars,color=qsec,size=I(3))

qplot(wt,mpg,data=mtcars,alpha=qsec)

head(mtcars)
qplot(wt,mpg,data=mtcars,color=cyl)
qplot(wt,mpg,data=mtcars,color=factor(cyl))

#Alternative ways to get this graph
levels(mtcars$cyl)#this command does not work initially
is.factor(mtcars$cyl)#so cyl is continuous
is.numeric(mtcars$cyl) # it is numeric

#Make new dataset with cyl as factor (This method is most simple)
mtcars2<-mtcars
mtcars2$cyl<-as.factor(mtcars2$cyl)
is.factor(mtcars2$cyl)
qplot(wt,mpg,data=mtcars2,color=cyl)

#Make new dataset with cyl as factor (This method is most appropriate for changing multiple factors at once)
mtcars3<-mtcars
head(mtcars)
for(i in 2)mtcars3[,i]<-factor(mtcars[,i])
is.factor(mtcars3$cyl)
qplot(wt,mpg,data=mtcars3,color=cyl)

#change cyl to character
fix(mtcars)
qplot(wt,mpg,data=mtcars2,color=cyl)

# use different aesthetic mappings
qplot(wt,mpg,data=mtcars,shape=factor(cyl))
qplot(wt,mpg,data=mtcars,size=qsec)

# combine mappings 
qplot(wt,mpg,data=mtcars,size=qsec,color=factor(carb))
qplot(wt,mpg,data=mtcars,size=qsec,color=factor(carb),shape=I(1))
qplot(wt,mpg,data=mtcars,size=qsec,shape=factor(cyl),geom="point")
#geom describes the type of graph, "point" is default. Try "smooth"
qplot(wt,mpg,data=mtcars,size=qsec,shape=factor(cyl),geom="smooth")
qplot(wt,mpg,data=mtcars,size=factor(cyl),geom="point")

#barplot
qplot(factor(cyl), data=mtcars, geom="bar")
qplot(factor(cyl), data=mtcars, geom="bar") + coord_flip()
qplot(factor(cyl), data=mtcars, geom="bar", fill=factor(cyl))
qplot(factor(cyl), data=mtcars, geom="bar", color=factor(cyl))

qplot(factor(cyl), data=mtcars, geom="bar", fill=factor(gear))

head(diamonds)
qplot(clarity, data=diamonds, geom="bar", fill=cut, position="stack")
qplot(clarity, data=diamonds, geom="bar", fill=cut, position="dodge")
qplot(clarity, data=diamonds, geom="bar", fill=cut, position="fill")
qplot(clarity, data=diamonds, geom="bar", fill=cut, position="identity")
#what does position=identity do? #In this case it either puts different color categories on top of each other or in front of one another
qplot(clarity, data=diamonds, geom="bar", fill=color, position="stack")
qplot(clarity, data=diamonds, geom="bar", fill=color, position="identity")
#
qplot(clarity, data=diamonds, geom="freqpoly", group=cut, color=cut, position="identity")
qplot(clarity, data=diamonds, geom="freqpoly", group=cut, color=cut, position="stack")

#Using pre-calculated tables or weights 
table(diamonds$cut)
library(plyr)
t.table<-ddply(diamonds,c("clarity","cut"),"nrow")
#nrow is number in each category
head(t.table)

qplot(cut,nrow,data=t.table,geom="bar",stat="identity")
#stat=identity means that the bars represent the values of the data. geom="bar" by default uses stat=bin which represents the height of each bar equal to the number of cases in each group
qplot(cut,nrow,data=t.table,geom="bar",stat="identity")
qplot(cut,nrow,data=t.table,geom="bar",stat="identity",fill=clarity)


qplot(cut, data=diamonds, geom="bar", weight=carat)
#In this case the height of the bars do not represent frequency but the total number of carats in each category
qplot(cut, data=diamonds, geom="bar", weight=carat, ylab="carat")

#using ddply (split data.frame in subframes and apply functions)
head(diamonds)
ddply(diamonds, "cut","nrow")
ddply(diamonds, c("cut", "clarity"), "nrow")
ddply(diamonds,"cut",summarize,meanDepth=mean(depth))
ddply(diamonds,"cut",summarize,lower=quantile(depth,0.25,na.rm=TRUE),median=median(depth,na.rm=TRUE),upper=quantile(depth,0.75,na.rm=TRUE))
#summarize can be used as a separate function to create a new dataframe with summary statistics
summarize(diamonds, meanDepth=mean(depth))
#combined with ddply, summarize applies the function to separate groups, similar to aggregate

t.function <- function(x,y){
  z = sum(x) / sum(x+y)
  return(z)}

ddply(diamonds,"cut",summarize,custom=t.function(depth,price))
ddply(diamonds,"cut",summarize,custom=sum(depth)/sum(depth+price))

##Next meeting 4/8
#address any questions
#finish this pdf
#alternatives: book chapter on qplot, go through examples in documentation

##More resources
#http://ggplot2.org/
