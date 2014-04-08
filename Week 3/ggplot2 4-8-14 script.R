#clear workspace
rm(list=ls())

##REVIEW
#install ggplot2 Tools->Install packages
#load package
library(ggplot2)

#view datasets
head(diamonds)
head(mtcars)

###qplot basics
qplot(clarity,data=diamonds,fill=cut,geom="bar")
#colors represent diferent cuts (fill)
#geom specifies type of graph; bar (histogram) is default for categorical y variables

#histogram is also default for continuous y
qplot(carat,data=diamonds)
#unless you specify x variable
qplot(carat, price, data=diamonds)

##PICKING UP FROM PAGE 5
###histogram
qplot(carat,data=diamonds,geom="histogram")
#qplot(variable, data=data, geom="type of plot")

###can change binwidth
qplot(carat,data=diamonds,geom="histogram",binwidth=0.1)
qplot(carat,data=diamonds,geom="histogram",binwidth=0.01)

###combine several types of plot
##wt=weight in tons
qplot(wt,mpg,data=mtcars,geom=c("point","smooth"))
qplot(wt,mpg,data=mtcars,geom=c("smooth","point"))
#how are these two different

###Smoothing
#smooth for each cylinder
#cyl= cylinder
qplot(wt,mpg,data=mtcars,color=factor(cyl),geom=c("point","smooth"))

####smooth plot options
qplot(wt,mpg,data=mtcars,geom=c("point","smooth"))

#remove standard error
qplot(wt,mpg,data=mtcars,geom=c("point","smooth"),se=FALSE)

#make line more or less wiggly
qplot(wt,mpg,data=mtcars,geom=c("point","smooth"),span=0.6)#more wiggly
qplot(wt,mpg,data=mtcars,geom=c("point","smooth"),span=0.8)
qplot(wt,mpg,data=mtcars,geom=c("point","smooth"),span=1)#less wiggly

#using linear modeling
qplot(wt,mpg,data=mtcars,geom=c("point","smooth"),method="lm")

#can also specificy the formula yourself
library(splines)
qplot(wt,mpg,data=mtcars,geom=c("point","smooth"),method="lm",formula=y~ns(x,5))#the higher the number, the more wavy

###flipping axes
#separate by cylinder
qplot(mpg,wt,data=mtcars,facets=cyl~.,geom=c("point","smooth"))
#flip axes after calculating summary statistics
qplot(mpg,wt,data=mtcars,facets=cyl~.,geom=c("point","smooth"))+coord_flip()
#flip axes before calculating summary statistics
qplot(wt,mpg,data=mtcars,facets=cyl~.,geom=c("point","smooth"))

###Saving and updating plot
#save plot in variable
p.tmp<-qplot(factor(cyl),wt,data=mtcars,geom="boxplot")
#name of plot<- qplot (x, y, data=data, geom=type of plot)
p.tmp

#change data
t.mtcars<-mtcars
mtcars<-transform(mtcars,wt=wt^2)

#update plot
p.tmp #original
p.tmp%+%mtcars #transformed
#can toggle back and forth

#reset mtcars
mtcars<-t.mtcars
rm(t.mtcars) #remove this item from workspace

#plot info
summary(p.tmp)
#Faceting has to do with putting multiple figures in a panel
#facet_null() means there is a single figure in that panel

#save plot in R workspace
#first check where the file will save
getwd()
#change if necessary
setwd("C:/Users/Melissa/Dropbox/GitHub/2014-Spring/Week 3")
save(p.tmp,file="temp.rData")
#You can open this workspace in a later session and call plot p.tmp

#save as image file
ggsave(file="test.pdf")
ggsave(file="test.jpeg",dpi=72)
ggsave(file="test.svg",plot=p.tmp,width=10,height=5)
#can open svg files with web browser; svg devices: Cairo and RSgvDevice

###Using ggplot()
###Add layers without changing original plot
p.tmp2<-ggplot(mtcars,aes(mpg,wt,colour=factor(cyl)))
#name of plot<-ggplot(data, aesthetic(y, x,), facotr to overlay with color)
p.tmp2
#Cannot display yet- no layers

#add layers
p.tmp2+layer(geom="point")
p.tmp2+layer(geom="point")+layer(geom="line")
p.tmp2+geom_point() #shortcut

#can use this language in qplot too
qplot(mpg,wt,data=mtcars,color=factor(cyl),geom="point")+geom_line()
qplot(mpg,wt,data=mtcars,color=factor(cyl),geom=c("point","line"))

#add a mapping layer
head(mtcars)
p.tmp2+geom_point()
p.tmp2+geom_point()+geom_point(aes(y=disp))#Now shows both weight and dispplacement on y-axis
#arguments for aes x= and y=
##{{}}How to add an a y-axis to other side of plot
#aes can match traditional terms for plotting (like pch and cex) to ggplot names

#This changes current plot format instead of adding to it 
p.tmp2+geom_point(color="darkblue")
p.tmp2+geom_point(aes(color="darkblue"))#?

###what if too many data points make it hard to read the plot?
#generate dataset
t.df<-data.frame(x=rnorm(2000),y=rnorm(2000))
#rnorm generates random numbers. 2000 specifies how many random numbers you generate. You can also specify the mean and sd. rnorm(n, mean = 0, sd = 1)
head(t.df)
p.norm<-ggplot(t.df,aes(x,y))
p.norm+geom_point()
#change to hollow
p.norm+geom_point(shape=1)
#use periods instead
p.norm+geom_point(shape=".")# you can put any symbol in here
p.norm+geom_point(alpha=.5)#makes transparent, changed code a bit
p.norm+geom_point(alpha=.1)#changes transparency of fill color
p.norm+geom_point(color="blue",alpha=.5)

#Pick up at top of Pg 8 next time
