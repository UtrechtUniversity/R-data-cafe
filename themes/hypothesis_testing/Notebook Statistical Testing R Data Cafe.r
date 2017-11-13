## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ------------------------------------------------------------------------

library(ggplot2)
library(dplyr)

# Select 
aq_obs <- airquality[complete.cases(airquality), ]

## ------------------------------------------------------------------------
aq_obs$HighTemperature <- cut(aq_obs$Temp, breaks = 2, labels = c("Cold", "Hot"))

aq_obs$HighTemperature

## ------------------------------------------------------------------------
aq_obs %>% group_by(HighTemperature) %>% summarize(mean(Ozone), median(Ozone), min(Ozone), max(Ozone))

## ------------------------------------------------------------------------

ggplot(aq_obs, aes(x = Ozone)) + geom_histogram() + facet_wrap(~HighTemperature) + theme_bw()

## ------------------------------------------------------------------------
aq_anova_model <- aov(Ozone ~ HighTemperature, data = aq_obs)
aq_anova_model

## ------------------------------------------------------------------------
summary(aq_anova_model)

## ------------------------------------------------------------------------
ggplot(aq_obs, aes(x = Temp, y = Ozone)) + geom_point() + theme_bw()

## ------------------------------------------------------------------------
temp_lm <- lm(Ozone ~ Temp, data = aq_obs)

summary(temp_lm)

## ------------------------------------------------------------------------
plot(temp_lm)

## ------------------------------------------------------------------------
temp_log_lm <- lm(log(Ozone) ~ Temp, data = aq_obs)

summary(temp_log_lm)

## ------------------------------------------------------------------------
temp_log_interaction_lm <- lm(log(Ozone) ~ Temp*Wind, data = aq_obs)
summary(temp_log_interaction_lm)

## ------------------------------------------------------------------------
temp_log_quadratic_lm <- lm(log(Ozone) ~ Temp + Wind + I(Wind^2), data = aq_obs)
summary(temp_log_quadratic_lm)

## ------------------------------------------------------------------------
icpt_model <- lm(Ozone ~ 1, data = aq_obs)
temp_model <- lm(Ozone ~ HighTemperature, data = aq_obs)

## ------------------------------------------------------------------------
summary(aq_anova_model)

# Two regressions as input gives the same result.
anova(icpt_model, temp_model)

## ------------------------------------------------------------------------
wind_model <- lm(Ozone ~ HighTemperature + Wind, data = aq_obs)
interaction_model <- lm(Ozone ~ HighTemperature + Wind + HighTemperature*Wind, data = aq_obs)


anova(icpt_model, temp_model, wind_model, interaction_model)

## ------------------------------------------------------------------------
ancova_type_mod <- lm(log(Ozone) ~ Temp + Wind, data = aq_obs)
summary(ancova_type_mod)

## ------------------------------------------------------------------------
aq_glm <- glm(HighTemperature ~ Ozone, data = aq_obs, family = binomial(link = "logit"))

summary(aq_glm)

## ---- eval = FALSE-------------------------------------------------------
## library(brms)
## aq_bayes_glm <- brm(Ozone ~ Temp, data = aq_obs)
## 
## summary(aq_bayes_glm)

