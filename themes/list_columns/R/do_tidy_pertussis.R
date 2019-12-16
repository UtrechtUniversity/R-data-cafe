#```{r, error_variable_reference, eval=FALSE}

## try the code below, why does it fail?
# pertussis_data_tidy <- pertussis_data %>% 
  #gather(1980:2018, key = "year", value = "annual_pertussis_cases") %>%
  #print()

#```

#Using ``` ` ``` to reference names that contain 'digits' or other 'special characters'
#```{r, good_variable_reference}

pertussis_data_tidy <- pertussis_data %>% 
  gather(`1980`:`2018`, 
         key = "year", 
         value = "annual_pertussis_cases") %>%
  ## rename X1 / x2 columns
  rename(key = X1,
         country = X2) %>%
  mutate(annual_pertussis_cases = as.integer(annual_pertussis_cases)) %>%
  # we pretend that the measurement for the year was reported on January 1st the next  year.
  mutate(year = lubridate::ymd(year, truncated = 2L)) %>%
  mutate(year = lubridate::floor_date(year, unit = "year"))

# pertussis_data_tidy
#```

## Removing years for which there is no data
#```{r, tidy_data}
no_data_years <- c("1981":"1990", "2015":"2018") %>% 
  lubridate::ymd(truncated = 2L) 


## using an index vector to filter() the years
pertussis_data_tidy <- pertussis_data_tidy %>%
  dplyr::filter(!year %in% no_data_years)

pertussis_data_tidy$year %>%
  as.character() %>%
  as_factor() %>% levels()
#```
