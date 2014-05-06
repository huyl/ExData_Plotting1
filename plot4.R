

readData = function() {
  # Read in data
  pow <<- read.table(
    "household_power_consumption.txt", header = T, sep = ";", na.strings = "?",
    colClasses = c("character", "character", "numeric", "numeric", "numeric",
                   "numeric", "numeric", "numeric", "numeric"))
  
  # Convert date
  pow$DateTime <<- as.Date(pow$Date, "%d/%m/%Y")
  
  # Subset data
  pow <<- subset(pow, DateTime >= as.Date("2007-02-01") &
                   DateTime <= as.Date("2007-02-02"))
  #head(pow$DateTime)
  #tail(pow$DateTime)
  
  # Check if there are any NAs left
  if (sum(is.na(pow)) > 0) {
    stop("There are NAs in our subset")
  }
  
  # Convert date and time into one column
  pow$DateTime <<- strptime(paste(pow$Date, pow$Time), "%d/%m/%Y %H:%M:%S",
                            tz="GMT")
  pow$Date <<- NULL
  pow$Time <<- NULL
  str(pow)
}

if (!exists("pow")) {
  readData()
}


# Open the device
png("plot4.png", width=480, height=480)

# Layout plots in 2x2 grid
par(mfcol = c(2,2))

# From plot2
plot(pow$DateTime, pow$Global_active_power, type="l", xlab="",
     ylab="Global Active Power (kilowatts)")

# From plot3
plot(pow$DateTime, pow$Sub_metering_1, type="l",
     xlab="", ylab="Energy sub metering")
lines(pow$DateTime, pow$Sub_metering_2, col="red")
lines(pow$DateTime, pow$Sub_metering_3, col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"), lty=1, bty="n")

# New plots
with (pow, {
  plot(DateTime, Voltage, type="l", xlab="datetime")
  plot(DateTime, Global_reactive_power, type="l", xlab="datetime")
})


# Close the device to save the file
dev.off()
