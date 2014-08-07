####################################################################################################

## Coursera Exploratory Data Analysis Project 1

# plot2.R file description

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

# Step 2: Read in data for 1/2/2007 and 2/2/2007 (rows 66638:69517) and add column names

epc <- read.table("./household_power_consumption.txt", header = FALSE, sep = ";", 
                  stringsAsFactors = FALSE, skip = 66637, nrows = 2880)

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

# Step 4: Reconstruct plot2 and save to PNG file

png(filename = "plot2.png", width = 480, height = 480, units = 'px')
plot(epc$DateTime, epc$GlobalActivePower, type = "l", 
     xlab = "", ylab = "Global Active Power (kilowatts)")
dev.off()
