# File:   BarCharts.R
# Course: R: An Introduction (with RStudio)

# LOAD DATASETS PACKAGES ###################################

library(datasets)

# LOAD DATA ################################################

?mtcars
head(mtcars)

# BAR CHARTS ###############################################

barplot(mtcars$cyl)             # Doesn't work
# plot goes through all cases and whats the no of cyl
# in each case

# Need a table with frequencies for each category
cylinders <- table(mtcars$cyl)  # Create table
# creates table from cyl of mtcars
# feed it into object cylinders
barplot(cylinders)              # Bar chart
plot(cylinders)                 # Default X-Y plot (lines)

# CLEAN UP #################################################

# Clear environment
rm(list = ls()) 

# Clear packages
detach("package:datasets", unload = TRUE)  # For base

# Clear plots
dev.off()  # But only if there IS a plot

# Clear console
cat("\014")  # ctrl+L

# Clear mind :)
