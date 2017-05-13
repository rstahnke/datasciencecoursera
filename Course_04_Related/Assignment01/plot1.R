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

data_small[,3] <- as.numeric((data_small[,3])) #Convert "Global_active_power" to numeric (from char)

hist(data_small[,3], col = "red", main="Global Active Power", xlab="Global Active Power (kilowatts)")
dev.copy(png, file = "plot1.png")  ## Copy my plot to a PNG file
dev.off()



