library(tidyverse)

porgs <- data.frame(id     = 1:5,
                    #porg   = c("Carl", "Phil", "Tom", "Tim", "Jerry"),
                    color  = c("yellow", "yellow", "purple", "purple","yellow"),
                    age    = c(5,6,11,12,3),
                    mass   = c(36,41,39,43,39),
                    height = c(66,72,58,53,79))

write_csv(porgs, "data/porg_observations.csv")

summarize(porgs, avg_age = mean(age))

arrange(porgs, -age) %>% mutate(bmi = mass/height)

porgs2 <- data.frame(id = 6:12,
                     minion = c("Dave", "Stuart", "Mike", "Mark", "Kevin", "Josh","Donny"),
                     color  = c("yellow", "yellow", "purple", "purple","yellow","yellow","purple"),
                     age    = c(8,1,22,7,5,5,3),
                     mass   = c(22,31,38,66,19,47,65),
                     height = c(28,4,41,55,72,46,12)
)


porgs_all <- rbind(porgs, porgs2)

#write.csv(porgs_all, "porgs_bmi.csv", row.names = F)
