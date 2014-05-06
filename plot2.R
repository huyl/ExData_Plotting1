

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

# Oops, we don't actually need to average across the weeks.
# The data is only 2 days
#
# computeTimeOfWeek = function() {
#   secondsOfWeek = function(t) {
#     d = as.integer(format(t, "%w"))
#     # Let's make week on starts on Monday 
#     d = ifelse(d, d - 1, 6)
#     weekstart = as.POSIXct(as.Date(t) - d)
#     as.numeric(difftime(t, weekstart), units="secs")
#   }
#   
#   pow$SecondsOfWeek <<- secondsOfWeek(pow$DateTime)
# }
# 
# computeTimeOfWeek()
# #head(pow)


# Open the device
png("plot2.png", width=480, height=480)

# Display the plot
plot(pow$DateTime, pow$Global_active_power, type="l",
     xlab="", ylab="Global Active Power (kilowatts)")

# Close the device to save the file
dev.off()
