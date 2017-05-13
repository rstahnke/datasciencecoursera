## Read in the data
data <- read.table("household_power_consumption.txt",sep=";",header=TRUE, stringsAsFactors=FALSE)

## Convert Date and Time from factors to date and character types to create one date-time variable
data$Date <- as.Date(data$Date, "%d/%m/%Y")
data$Time <- as.character(data$Time)  # Necessary to convert to character first 
library(lubridate)  # needed for next line
data$DateTime <- ymd_hms(paste(data$Date,data$Time))  # Create date-time variable

## Create interval to subset data for 2 days 2/1/2007 to 2/2/2007
date1 <- as.POSIXct("2007-01-31 19:00:00") #Note this is EST, but data is 5 hrs up
date2 <- as.POSIXct("2007-02-02 18:59:59")
int <- interval(date1, date2)
data_small <- data[data$DateTime %within% int,]  # Subset the data here

## plots generated here
with(data_small, plot(DateTime, Sub_metering_1, type="n", ylab="Energy sub metering", xlab=""))
lines(data_small$DateTime,data_small$Sub_metering_1,type='l')  # Add in line of the series
lines(data_small$DateTime,data_small$Sub_metering_2,type='l',col="red")  # Add in line of the series
lines(data_small$DateTime,data_small$Sub_metering_3,type='l',col="blue")  # Add in line of the series
legend("topright", lty = 1, col = c("black","red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))

dev.copy(png, file = "plot3.png")  ## Copy my plot to a PNG file
dev.off()



