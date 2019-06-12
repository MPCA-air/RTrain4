library(dplyr)

# Create 5 island names
islands <- paste0(sample(LETTERS, 64, T),
                  sample(LETTERS, 64, T),
                  "-",
                  sample(c(101:998), 64, T)) %>%
           sample(5, replace=T) %>%
           c(., "Temple-Island")

# Porg records
porgs <- data_frame(Planet           = "Anch-To",
                    sample_date      = sample(seq(as.Date("3030-02-20"), as.Date("3030-03-15"), by = "day"), 64, replace=T),
                    `1_species name` = "Porg",
                    gender           = sample(0:1, 64, replace=T),
                    Mass           = ifelse(sex == 1,
                                            rnorm(64, 3, .8),
                                            rnorm(64, 4.2, .97)) %>% round(3),
                    Chem_name        = "Corundum",
                    CAS              = "224A-901-33") %>%
         mutate(Island         = sample(islands, 64, replace=T),
                Concentration  = ifelse(sex == 1,
                                        rnorm(64, 688, 324),
                                        rnorm(64, 609, 364)),
                Conc_units     = sample(c("ppm", "ppm", "ppm", "ppb"), 64, replace=T))

# Save to CSV
write_csv(porgs, "data/Porg_samples.csv")

#
