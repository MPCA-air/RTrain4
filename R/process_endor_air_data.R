###=============================###
##Find the magnetic storm in this messy data set

air_data <- read_csv(data/"air_endor.csv")

glimpse(air_data)
plot(air_data$Result)
unique(air_data$Parameter)

air_magnetic <- filter(air_data, Analyte == "magnetic_field")

##When was the magnetic storm?
arrange(air_data, desc(Result))