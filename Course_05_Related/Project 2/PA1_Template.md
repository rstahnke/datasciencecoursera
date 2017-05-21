
Please note that the various parts of the submission are numbered according to the submission commit requirements of the assignment.

1. Code for reading in the dataset and/or processing the data

Below is the code to read in the data and packages used:


```r
library("ggplot2")
library(reshape2)

## Read in the data
dat <- read.csv("activity.csv")
```

2.Histogram of the total number of steps taken each day

In order to generate the histogram of the total number of steps per day, the total number of steps per day has to be calculated first. To do this, I will melt the data into long form and then recast it to calculate the sum of steps per day.

First, the data is melted into long form:


```r
mdat <- melt(dat, id=c("date", "interval"))

## This is a glimpse of mdat
head(mdat)
```

```
##         date interval variable value
## 1 2012-10-01        0    steps    NA
## 2 2012-10-01        5    steps    NA
## 3 2012-10-01       10    steps    NA
## 4 2012-10-01       15    steps    NA
## 5 2012-10-01       20    steps    NA
## 6 2012-10-01       25    steps    NA
```

Then, the data is recast to calculate the sum of steps per day:


```r
cdat <- dcast(mdat, date~variable, sum)

## Glimpse of cdat
head(cdat)
```

```
##         date steps
## 1 2012-10-01    NA
## 2 2012-10-02   126
## 3 2012-10-03 11352
## 4 2012-10-04 12116
## 5 2012-10-05 13294
## 6 2012-10-06 15420
```

Finally, the histogram of steps per day is generated:


```r
with(cdat, hist(steps))
```

![](PA1_Template_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

3. Mean and median number of steps taken each day


```r
## Mean and median number of steps taken per day
summary(cdat$steps)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##      41    8841   10760   10770   13290   21190       8
```

Again, mean of the total # of steps per day = 10,770
median of the total # of steps per day = 10760

4. Time series plot of the average number of steps taken

To make a time series plot of the 5 minute interval (x) and the average number of steps taken averaged over all days (y), the long form data has to be recast again (NA's are not included in the calculations). 


```r
cdat_interval <- dcast(mdat, interval~variable, mean, na.rm=TRUE)
```

Here is the plot:


```r
with(cdat_interval, plot(interval, steps, xlab="Interval", ylab="Mean # of Steps", main="5-Minute Interval vs. Average # of Steps", type="l"))
```

![](PA1_Template_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

5. The 5-minute interval that, on average, contains the maximum number of steps

Using the cdat_interval data, which contains the average # of steps for each interval across all the days in the sample, find the row that contains the maximum value:


```r
# search cdat_interval and return row corresponding to the interval with 
# the maximum average number of steps
maxinterval <- cdat_interval[which(cdat_interval$steps == max(cdat_interval$steps)), ]
maxinterval  # Display the interval and maximum
```

```
##     interval    steps
## 104      835 206.1698
```

6. Code to describe and show a strategy for imputing missing data

First, here is the total number of missing values:


```r
sum(is.na(dat))
```

```
## [1] 2304
```

Any interval containing a missing value will be filled with the mean value of steps for that interval. The mean # of steps is available in column 2 in the cdat_interval data frame, and the interval is matched using column 1 of cdat_interval. The for loop below checks each observation to see if it is missing, and any NA's are replaced with the average value of the steps for that interval.


```r
for (i in 1:length(dat$steps)) {
	if (is.na(dat$steps[i]) ) {
		dat$steps[i] <- cdat_interval[which(cdat_interval[ ,1] == dat$interval[i]), 2]	
	}	
}
```

7. Histogram of the total number of steps taken each day after missing values are imputed

To make a histogram of the total number of steps per day, the dataset dat with the imputed values for the NA's must be melted and recast again. 


```r
mdat1 <- melt(dat, id=c("date", "interval"))
cdat1 <- dcast(mdat1, date~variable, sum)  
with(cdat1, hist(steps))  # Histogram of total # of steps/day w NA's imputed
```

![](PA1_Template_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

Comparing the two histograms of the total number of steps per day does not show a change in the distribution using imputed values for the NA's.

The new mean and median # of total steps is calculated here:

```r
summary(cdat1)
```

```
##          date        steps      
##  2012-10-01: 1   Min.   :   41  
##  2012-10-02: 1   1st Qu.: 9819  
##  2012-10-03: 1   Median :10766  
##  2012-10-04: 1   Mean   :10766  
##  2012-10-05: 1   3rd Qu.:12811  
##  2012-10-06: 1   Max.   :21194  
##  (Other)   :55
```

Old mean = 10,770    New mean = 10,766
Old median = 10,760   New median = 10,766

So, there is not a significant impact of using imputed values for the NA's.

8. Panel plot comparing the average number of steps taken per 5-minute interval across weekdays and weekends

First, a factor variable with two levels ("weekday" and "weekend") is created. Then, we just need to work with the interval, steps and wDay columns, so the date column will be deleted. The resulting dat2 data frame will be melted and recast to get the average number of steps per interval by weekday/weekend.


```r
# First, convert the date column from a factor variable into a date variable
dat$date <- as.Date(dat$date, format= "%Y-%m-%d")
# Here is a vector of weekdays
weekdays1 <- c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
# Now create the factor variable named wDay
dat$wDay <- factor((weekdays(dat$date) %in% weekdays1), levels=c(FALSE, TRUE), labels=c('weekend', 'weekday'))

## Delete unwanted "date" column, then melt and recast data.
dat2 <- dat[-2]
mdat2 <- melt(dat2, id=c("interval", "wDay"))
cdat2 <- dcast(mdat2, wDay+interval~variable,mean)
```




And here is the time series plots comparing weekend vs. weekday activity levels:


```r
ggplot(cdat2, aes(interval,steps)) + xlab("Interval") + ylab("Average # of Steps") + ggtitle("Activity Patterns Weekdays vs. Weekends") + geom_line(aes(group=1)) + facet_wrap( ~ wDay, ncol=1)
```

![](PA1_Template_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

And that's all!






