#load and subset data
pw<-read.table("household_power_consumption.txt",sep=";",na.strings= "?", colClasses="character",header=TRUE)
pw$Date<-as.Date(pw$Date, format="%d/%m/%Y")  #must include the format and Y is capital for four digit year
tdpw<-subset(pw, pw$Date %in% as.Date(c('2007-02-01', '2007-02-02')))

x<-paste(tdpw$Date, tdpw$Time)
x<-strptime(x,  format="%Y-%m-%d %H:%M:%S", tz = "EST5EDT")
y<-as.numeric(tdpw$Global_active_power)
#plotting
png(file="plot2.png", width = 480, height = 480, units = "px")
plot(x,y, type = "l", xlab="", ylab="Global Active Power (kilowatts)")
dev.off()