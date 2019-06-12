#Get your starships ready

library(readxl)
library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)
library(ggplot2)

#read in the data from excel
pfas = read_excel("X:/Agency_Files/Outcomes/Risk_Eval_Air_Mod/_Air_Risk_Evaluation/R/R_Camp/Intro to R/RCamp - Star Wars/data/PFAS data.xlsx", sheet = "pore water")

#Let's start by giving the columns better names
new_names = c("planet", "loc_id", "analyte", "june11_2018", "oct12_2018", "unit")
names(pfas) = new_names

#Or change the names directly in one line
names(pfas) = c("planet", "loc_id", "analyte", "june11_2018", "oct12_2018", "unit")

#Use gather to get data into long format
pfas_long = gather(pfas, key = date, value = result, june11_2018, oct12_2018)

#Now use mutate to fill units column with ppb/L
pfas_long = mutate(pfas_long, unit = "ppb/L")

#Use mutate again with mdy to change date into a more useable date format
pfas_long = mutate(pfas_long, date = mdy(date))

#Another mutate to create a "note" column which will tell us if the result is below detection
pfas_long = mutate(pfas_long, note = ifelse(str_detect(result, "<"), "below_dl", NA))

#Mutate result again to remove < character
pfas_long = mutate(pfas_long, result = str_replace(result, "<", ""))

#Change result to numeric values
pfas_long = mutate(pfas_long, result = as.numeric(result))

#Let's plot our results to check if any results look strange
plot(pfas_long$result)

#Change negative values to NA
pfas_long = mutate(pfas_long, result = ifelse(result < 0, NA, result))

#We can make as many edits as we want in one mutate function so we don't have to keep typing the mutate function
pfas_long = gather(pfas, key = date, value = result, june11_2018, oct12_2018)

pfas_long = mutate(pfas_long,
                   unit = "ppb/L",
                   date = mdy(date),
                   note = ifelse(str_detect(result, "<"), "below_dl", NA),
                   result = str_replace(result, "<", ""),
                   result = as.numeric(result),
                   result = ifelse(result < 0, NA, result)
                   )

#Find the highest result
summarize(pfas_long, biggest_value = max(result))

#Ignore NA values this time
summarize(pfas_long, biggest_value = max(result, na.rm = TRUE))

#Now find the largest for each analyte
pfas_grouped = group_by(pfas_long, analyte)

summarize(pfas_grouped, biggest_value = max(result, na.rm = TRUE))

#Now find the largest result for each analyte on each planet
pfas_grouped = group_by(pfas_long, analyte, planet)

summarize(pfas_grouped, biggest_value = max(result, na.rm = TRUE))

#ggplot examples

#Let's do a quick ggplot of the results
ggplot(pfas_long, aes(x = analyte, y = result))

#Let's add in the points
ggplot(pfas_long, aes(x = analyte, y = result)) + geom_point()

#Let's show the differences between planets by making the points different colors
ggplot(pfas_long, aes(x = analyte, y = result, color = planet)) + geom_point()

#Let's use different shapes instead
ggplot(pfas_long, aes(x = analyte, y = result, shape = planet)) + geom_point()

#What about both?
ggplot(pfas_long, aes(x = analyte, y = result, color = planet, shape = planet)) + geom_point()

#Make those points bigger
ggplot(pfas_long, aes(x = analyte, y = result, color = planet, shape = planet)) + geom_point(size = 10)

#Too big! Make them smaller.
ggplot(pfas_long, aes(x = analyte, y = result, color = planet, shape = planet)) + geom_point(size = 3)

#Let's plot the results by date
ggplot(pfas_long, aes(x = date, y = result, color = analyte, shape = planet)) + geom_point()

#Too confusing. Let's create separate charts for each planet using facet wrap.
ggplot(pfas_long, aes(x = date, y = result, color = analyte, shape = planet)) + geom_point() +
  facet_wrap("planet")

#Let's add lines to see the trends for each sampling location
ggplot(pfas_long, aes(x = date, y = result, color = analyte, group = paste(analyte, loc_id))) +
  geom_point() +
  geom_line() +
  facet_wrap("planet")

#Make the features bigger with size =
ggplot(pfas_long, aes(x = date, y = result, color = analyte, group = paste(analyte, loc_id))) +
  geom_point(size = 3) +
  geom_line(size = 2) +
  facet_wrap("planet")







#Save this chart as a png to print and hang on your fridge tonight
ggsave("H:/My super awesome ggplot 2018.png")
