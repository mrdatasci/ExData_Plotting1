####################################################################################################

## Coursera Exploratory Data Analysis Project 1

# plot4.R file description

# This script will perform the following steps on the UCI HAR Dataset available at 
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# 1. Download Electric Power Consumption data set
# 2. Read in data for 1/2/2007 and 2/2/2007 and add column names
# 3. Concatenate "Date" and "Time" (paste) and convert to date-time format (strptime)
# 4. Reconstruct the plot using the base plotting system and save to PNG file (480 x 480 pixels)

####################################################################################################

# Step 1: Download Electric Power Consumption data set

if(!file.exists("ExData_Plotting1")) {
  dir.create("ExData_Plotting1")
}
setwd("./ExData_Plotting1")

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./household_power_consumption.zip", method = "curl")
dateDownloaded <- date()
unzip("./household_power_consumption.zip", exdir = "./")

# Step 2: Read in data for 2007-02-01 and 2007-02-02 [rows 66638:69517, 2880 rows]
# 1st row date time = 2006/12/16  17:24:00
# elaspsed time until 2007-02-01 00:00:00 = 46 days 6.6 hours = 66636 minutes
# skip 66637 rows (66636 minute-observations + header row)
# subset 2880 rows for the two dates 2007-02-01 and 2007-02-02

epc <- read.table("./household_power_consumption.txt", header = FALSE, sep = ";", 
                  stringsAsFactors = FALSE, skip = 66637, nrows = 2880)

# add column names
labels <- read.table("./household_power_consumption.txt", header = FALSE, sep = ";", 
                     stringsAsFactors = FALSE, nrows = 1)
labels <- as.character(labels)
labels <- tocamel(labels)
colnames(epc) <- c(labels)

# Step 3: Concatenate "Date" and "Time" (paste) and convert to date-time format (strptime)

epc$DateTime <- strptime(paste(epc$Date, epc$Time), "%d/%m/%Y %H:%M:%S")
epc$Date <- NULL # remove "Date" column
epc$Time <- NULL # remove "Time" column
epc <- epc[, c(8, 1:7)] # order data frame with "DateTime" as 1st column

# Step 4: Reconstruct plot4 and save to PNG file

png(filename = "plot4.png", width = 480, height = 480, units = 'px')

par(mfcol = c(2, 2))

# upper-left plot
plot(epc$DateTime, epc$GlobalActivePower, type = "l", 
     xlab = "", ylab = "Global Active Power")

# lower-left plot
plot(epc$DateTime, epc$SubMetering1, type = "l", 
     ylim = c(0, 38), xlab = "", ylab = "Energy sub metering")
lines(epc$DateTime, epc$SubMetering2, type='l', col='red')
lines(epc$DateTime, epc$SubMetering3, type='l', col='blue')
legend("topright", lty = 1, bty = "n", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# upper-right plot
plot(epc$DateTime, epc$Voltage, type = "l", 
     xlab = "datetime", ylab = "Voltage")

# lower-right plot
plot(epc$DateTime, epc$GlobalReactivePower, type = "l", 
     xlab = "datetime", ylab = "Global_reactive_power")

dev.off()
