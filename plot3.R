#load and subset data
pw<-read.table("household_power_consumption.txt",sep=";",na.strings= "?", colClasses="character",header=TRUE)
pw$Date<-as.Date(pw$Date, format="%d/%m/%Y")  #must include the format and Y is capital for four digit year
tdpw<-subset(pw, pw$Date %in% as.Date(c('2007-02-01', '2007-02-02')))
#plotting 
x<-paste(tdpw$Date, tdpw$Time)
x<-strptime(x,  format="%Y-%m-%d %H:%M:%S", tz = "EST5EDT")
png(file="plot3.png", width = 480, height = 480, units = "px")
plot(x,as.numeric(tdpw$Sub_metering_1), type="l", xlab="", ylab="Energy sub metering")
lines(x,as.numeric(tdpw$Sub_metering_2), col="red")
lines(x,as.numeric(tdpw$Sub_metering_3), col="blue")
legend("topright", lty=c(1,1,1),col=c("black", "red", "blue"),legend=c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
dev.off()