#load and subset data
#The following descriptions of the 9 variables in the dataset are taken from the UCI web site:
#1. Date: Date in format dd/mm/yyyy
#2. Time: time in format hh:mm:ss
#3.Global_active_power: household global minute-averaged active power (in kilowatt)
#4. Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
#5. Voltage: minute-averaged voltage (in volt)
#6. Global_intensity: household global minute-averaged current intensity (in ampere)
#7. Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
#8. Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
#9. Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.

pw<-read.table("household_power_consumption.txt",sep=";", na.strings= "?", colClasses="character",header=TRUE)
pw$Date<-as.Date(pw$Date, format="%d/%m/%Y")  #must include the format and Y is capital for four digit year
tdpw<-subset(pw, pw$Date %in% as.Date(c('2007-02-01', '2007-02-02')))
#plotting and save the plot to a PNG file with a width of 480 pixels and a height of 480 pixels.
png(file="plot1.png", width = 480, height = 480, units = "px")
hist(as.numeric(tdpw$Global_active_power), main="Global Active Power", xlab="Global Active (kilowatts)", ylab="Frequency", col="red")
dev.off()
