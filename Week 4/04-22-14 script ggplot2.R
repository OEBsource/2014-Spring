rm(list=ls())
###Review
library(ggplot2)
head(diamonds)
head(mtcars)

#scatterplot with qplot()
#Format:#qplot(x,y,data=your data)
qplot(mpg,wt,data=mtcars)

#scatterplot with ggplot()
#Format: ggplot(data,aes(x,y))+geom_point()
#geom_point()specifies that you want a scatter plot. 
#+geom_point() is a layer. You can add additional layers as we will see later today.
ggplot(diamonds,aes(carat,price))+geom_point()

#bar plot with ggplot
#Format: ggplot(data,aes(variable)+geom_bar()
ggplot(diamonds, aes(clarity)) + geom_bar()# Plot will be histogram in this case because we did not specify both x and  y variables
#specify fill variable
ggplot(diamonds, aes(clarity, fill=cut)) + geom_bar()
#What if you want the value of another variable on the y-axis instead of frequency
ggplot(diamonds, aes(clarity,weight=price)) + geom_bar()#Now y-axis represents total carats in each category
#What if you want to graph average price by clarity?
library(plyr)
d<-ddply(diamonds,"clarity",summarize,meanPrice=mean(price))
d
#(see 3/11 script for description of ddply and summarize)
ggplot(d,aes(clarity,weight=meanPrice))+geom_bar()

###Questions from last time
#How do you change color scheme of a bar graph?
#We will get to this in more detail through the tutorial,but here are the basics:
#Default color scheme is rainbow
ggplot(diamonds, aes(clarity, fill=cut)) + geom_bar()
#different colors: use scale_fill_brewer(palette="")
ggplot(diamonds,aes(clarity,fill=cut))+geom_bar()+scale_fill_brewer(palette="Set1")
ggplot(diamonds,aes(clarity,fill=cut))+geom_bar()+scale_fill_brewer(palette="Spectral")
# see more palette options at http://novyden.blogspot.com/2013/09/how-to-expand-color-palette-with-ggplot.html
# you view palette options like this:
RColorBrewer::display.brewer.all()#Select zoom plots window to see clearly

#How do you change color scheme of scatterplot?
#Default
ggplot(mtcars,aes(mpg,wt,colour=factor(cyl)))+geom_point()
#Use scale_color_brewer(palette="")
ggplot(mtcars,aes(mpg,wt,colour=factor(cyl)))+geom_point()+scale_color_brewer(palette="Set3")

#How do you change the order of factors in a stacked histogram?
ggplot(diamonds, aes(clarity, fill=cut)) + geom_bar()
#How are levels currently ordered?
levels(diamonds$cut)
#copy diamonds
diamonds2<-diamonds
#Reverse the order of levels
diamonds2$cut<-factor(diamonds2$cut,level=rev(levels(diamonds2$cut)))
#Try the plot again
ggplot(diamonds2, aes(clarity, fill=cut)) + geom_bar()
#customize order
diamonds3<-diamonds
diamonds3$cut<-factor(diamonds3$cut,levels=c("Premium", "Ideal","Very Good", "Good", "Fair"))
ggplot(diamonds3, aes(clarity, fill=cut)) + geom_bar()

#Is adding error bars easier in ggplot2 than using arrows() for barplot()
#For fun!From Paul Sievert's Biostats class
#Creating a table of means and SE

install.packages("plotrix")
library(plotrix)
install.packages("ggplot2")
library(ggplot2)

str(curdies)

#making means and SE
(meanS<-tapply(curdies $S4DUGES, curdies $SEASON,mean,na.rm=TRUE))
(seS<-tapply(curdies $S4DUGES, curdies $SEASON,std.error,na.rm=TRUE))

#creating this labels for plot
season<-factor(c('Summer','Winter'))

#Here I am taking the means and se to create confidence intervals, in this limits thing
limits <- aes(ymax = meanS + seS, ymin= meanS - seS)

#Here I am creating a plot, just the bars of means first, per season
p<-qplot(season,meanS, geom='bar', stat="identity", fill = I("grey50")) 

p

#Making error bars, from limits and adding to p
p + geom_errorbar(limits, width=0.25)


#changing ggplot2 theme
theme_set(theme_bw())

p + geom_errorbar(limits, width=0.25)

#back to other one
theme_set(theme_grey())
#For fun!
#standard error
#Creating a table of means and SE

install.packages("plotrix")
library(plotrix)
install.packages("ggplot2")
library(ggplot2)

str(curdies)

#making means and SE
(meanS<-tapply(curdies $S4DUGES, curdies $SEASON,mean,na.rm=TRUE))
(seS<-tapply(curdies $S4DUGES, curdies $SEASON,std.error,na.rm=TRUE))

#creating this labels for plot
season<-factor(c('Summer','Winter'))

#Here I am taking the means and se to create confidence intervals, in this limits thing
limits <- aes(ymax = meanS + seS, ymin= meanS - seS)

#Here I am creating a plot, just the bars of means first, per season
p<-qplot(season,meanS, geom='bar', stat="identity", fill = I("grey50")) 

p

#Making error bars, from limits and adding to p
p + geom_errorbar(limits, width=0.25)
#changing ggplot2 theme
theme_set(theme_bw())
p + geom_errorbar(limits, width=0.25)
#back to other one
theme_set(theme_grey())

###Continuing from Pg 8
##Using facets- this specifies how many panels will be in your figure
#default plot
qplot(mpg,wt,data=mtcars,geom="point")
#Make a separate graph for each cylinder
qplot(mpg,wt,data=mtcars,facets=.~cyl,geom="point")
#Make a separate graph for each combination of gear and cylinder
qplot(mpg,wt,data=mtcars,facets=gear~cyl,geom="point")

##facet_wrap/facet_grid
#Make the same graph of mpg and wt by cylinder with ggplot()
p.tmp<-ggplot(mtcars,aes(mpg,wt))+geom_point()
p.tmp
p.tmp+facet_wrap(~cyl)
#Change how panels are arranged by specifying the number of columns
p.tmp+facet_wrap(~cyl)+facet_wrap(~cyl,ncol=3)#this is the default
p.tmp+facet_wrap(~cyl)+facet_wrap(~cyl,ncol=1)
#facet_wrap is not good if there are too many panels
p.tmp+facet_wrap(gear~cyl)#numbers at top of plot specify gear, cylinder
p.tmp+facet_wrap(cyl~gear)#numbers at top of plot specify cylinder, gear
p.tmp+facet_wrap(~cyl+gear)#get the same plot this way
#You can use facet_grid instead
p.tmp+facet_grid(gear~cyl)

##controlling scales in facets 
#default:scale="fixed"; this means that range of x- and y-axes are the same for each plot
p.tmp+facet_wrap(~cyl,scales="fixed")
#change range of each axis to fit data for that plot
p.tmp+facet_wrap(~cyl,scales="free")
#change range of only x-axis to fit data for that plot
p.tmp+facet_wrap(~cyl,scales="free_x")
#change range of only y-axis to fit data for that plot
p.tmp+facet_wrap(~cyl,scales="free_y")
#can do this with facet_grid
p.tmp + facet_grid(gear~cyl, scales="fixed")
p.tmp + facet_grid(gear~cyl, scales="free_x")
#make space proportional to mpg scale
p.tmp + facet_grid(gear~cyl, scales="free_x", space="free")

##changing colors- we already saw how to use different color schemes. What if we want to manually specify colors
#Review of changing color schemes
p.tmp1<-qplot(cut,data=diamonds,geom="bar",fill=cut)
p.tmp1+scale_fill_brewer(palette="Paired")

#viewing colors
#view color names, note you can refer to colors in R with numbers or names. See #http://research.stowers-institute.org/efg/R/Color/Chart/ for more info.
colors()
#see plots with different colors, will need to zoom in
# You will see text in the console describing how to view different color neighborhoods
demo("colors")#press enter/return in console to flip through graphs
#plot colors in a particular neighborhood
#Format: plotCol(nearRcolor("color name","type of color space",dist=#),nrow=number of rows)
#higher values for dist means that you want to include more distantly related colors
plotCol(nearRcolor("#7fc6bc","rgb",dist=50),nrow=3)

#manually specifying colors
levels(diamonds$cut)
p.tmp1+scale_fill_manual(values=c("#7fc6bc","#083642","#b1df01","#cdef9c","#466b5d"))
#Melissa could not get below script to work. It seems uncecessary though. 
p.tmp1 + scale_fill_manual("Color-Matching", c("Fair"="#78ac07", "Good"="#5b99d4","Ideal"="#ff9900", "Very Good"="#5d6778", "Premium"="#da0027", "Not used"="#452354"))

#We stopped in the middle of Pg 8 at "changing text". 
#Laura will lead at next and final meeting of the semester (5/6). She may want to continue with the tutorial or use her own material. 

###Melissa's questions (Either SOURCE members can answer during the meeting, or Melissa will look up next time)
#How do you add an a y-axis to other side of this plot?
p.tmp2<-ggplot(mtcars,aes(mpg,wt,colour=factor(cyl)))
p.tmp2+geom_point()+geom_point(aes(y=disp))

#How do you label that different cylinders and gears are graphed in this plot?
qplot(mpg,wt,data=mtcars,facets=gear~cyl,geom="point")

#How do you put more spaces in between panels in this graph?
qplot(mpg,wt,data=mtcars,facets=gear~cyl,geom="point")
