# Prerequisites: 
# 1. The packages "dplyr" and"readr" are installed.
# 2. The data file "household_power_consumption.txt" has been extracted from the source zip
#    file and is present in the working directory

library(readr)
library(dplyr)

# Read the input data treating "NA","" and "?" as NA
data <- read_delim("household_power_consumption.txt", 
                 delim = ";",
                 na = c("NA","","?"),
                 col_types = list(
                 Date = col_character(),
                 Time = col_time(),
                 Global_active_power = col_number(),
                 Global_reactive_power = col_number(),
                 Voltage = col_number(),
                 Global_intensity = col_number(),
                 Sub_metering_1 = col_number(),
                 Sub_metering_2 = col_number(),
                 Sub_metering_3 = col_number()
               )
      )

# Convert Date field into POSIXct class and discard data
# not belonging to the two days specified.
data$Date <- strptime(data$Date, format = "%d/%m/%Y")
day1 <- strptime("2007-02-01", format = "%Y-%m-%d")
day2 <- strptime("2007-02-02", format = "%Y-%m-%d")
data <- data[data$Date == day1 | data$Date == day2,]

# Create new column called datetime that combines the date and time
# into elapsed time.
data <- mutate(data, datetime = as.POSIXct(data$Date + data$Time))

# Create plots, explicitly set the size of the plot.

png("plot3.png", width = 480, height = 480)
with(data, {
  plot(datetime, 
       Sub_metering_1,
       type = "l", 
       xlab = "", 
       ylab = "Energy sub metering", 
       col =1)
  points(datetime, 
         Sub_metering_2,
         type = "l", 
         xlab = "", 
         ylab = "Energy sub metering", 
         col =2)
  points(datetime, 
         Sub_metering_3,
         type = "l", 
         xlab = "", 
         ylab = "Energy sub metering", col =4)
  legend("topright", 
         legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"), 
         col = c("black","red","blue"), 
         lty = "solid")
})
dev.off()

