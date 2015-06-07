#load and subset data
> pw<-read.table("household_power_consumption.txt",sep=";", na.strings= "?",colClasses="character",header=TRUE)
> pw$Date<-as.Date(pw$Date, format="%d/%m/%Y")  
> tdpw<-subset(pw, pw$Date %in% as.Date(c('2007-02-01', '2007-02-02')))
#plotting
par(mfrow=c(2,2),oma=c(0,0,0,0))
with(tdpw, {
  plot(strptime(paste(tdpw$Date, tdpw$Time),format="%Y-%m-%d %H:%M:%S", tz = "EST5EDT"),as.numeric(tdpw$Global_active_power), type = "l", xlab="", ylab="Global Active Power (kilowatts)")
  plot(strptime(paste(tdpw$Date, tdpw$Time),format="%Y-%m-%d %H:%M:%S", tz = "EST5EDT"), as.numeric(tdpw$Voltage), xlab="datetime", ylab="Voltage", type="l")
  plot(strptime(paste(tdpw$Date, tdpw$Time),format="%Y-%m-%d %H:%M:%S", tz = "EST5EDT"),as.numeric(tdpw$Sub_metering_1), type="l", xlab="", ylab="Energy sub metering")
  lines(strptime(paste(tdpw$Date, tdpw$Time),format="%Y-%m-%d %H:%M:%S", tz = "EST5EDT"),as.numeric(tdpw$Sub_metering_2), col="red")
  lines(strptime(paste(tdpw$Date, tdpw$Time),format="%Y-%m-%d %H:%M:%S", tz = "EST5EDT"),as.numeric(tdpw$Sub_metering_3), col="blue")
  legend("topright", lty=c(1,1,1),box.col= "transparent", cex=0.8, col=c("black", "red", "blue"),legend=c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
  plot(strptime(paste(tdpw$Date, tdpw$Time),format="%Y-%m-%d %H:%M:%S", tz = "EST5EDT"), as.numeric(tdpw$Global_reactive_power), xlab="datetime", ylab="Global_reactive_power", type="l")})
dev.copy(png, file="plot4.png",width = 480, height = 480, units = "px")
dev.off()