# BASIC R TUTORIAL
# GETTING HELP
?mean
?ChickWeight
# just put a question mark in front of what you want to know

# OBJECTS AND FUNCTIONS
5 + 6
a <- 5
b <- 6
a + b
# remember to run each line that initializes the variable too
# each line is run individually with ctrl + enter
# or you can run multiple lines at once by highlighting and pressing ctrl + enter

# built in function
sum(a,b)

# concatenation
ages <- c(5,6)      # turns ages into an object (vector) with values 5, 6
ages                # ages = 5 6
sum(ages)

names <- c("John", "James")

friends <- data.frame(names, ages)
View(friends)      # V has to be capital... spent way too long on this error
str(friends)       # display the structure of an R object

friends$ages       # looking at the friends dataset, we can see 
                   # the data for a particular var in that dataset
                   # 5 6

#       r,c
friends[1,1]       # to subset specific parts of data frame
                   # shows row 1 column 1
friends[,1]        # all of the rows for column 1
friends[1,]        # all of the columns for row 1
                   
# built in data sets
data()             # shows all available datasets in R
View(starwars)     # star wars data set
                   # PLEASE REMEMBER TO LOAD PACKAGES YOU WANT DATASETS FROM
                   # using library(package_name)

starwars %>%           # pipe operator // press shift + ctrl + M
  # basically just means 'and then..'
  filter(height > 150 & mass < 200) %>%       # filter data set by this constraint 
  mutate(height_in_meters = height/100) %>%   # and then change the data (new var created)
  select(height_in_meters, mass) %>%          # lets us select data that we want to work with
  arrange(mass) %>%                           # and then arrange/sort all data by mass. if you want it to sort from high to low, do -mass
  # View()
  plot()

# DATA STRUCTURES AND TYPES OF VARIABLES
View(msleep)                 # about the types of mammals, view in separate tab
glimpse(msleep)              # quick overview in console
head(msleep)                 # shows the first few data (6 of them)
class(msleep$name)           # class tells you the type of data
                             # from msleep data set, what type of data is name?
length(msleep)               # number of variables
length(msleep$name)          # how many observations for the variable
names(msleep)                # names of all variables
unique(msleep$vore)          # each distinct type?? name?? desc?? under the variable
missing <- !complete.cases(msleep)
# create missing object called data
# complete.cases returns data which are complete
# (it returns boolean values for each *line of data*)
# (e.g. first row complete? return TRUE, incomplete return FALSE)
# negate complete.cases to get data with incomplete fields
# and put them into object missing
msleep[missing, ]
# rn msleep is a data frame
# data.frame[] gives subsets of data frame according to
# row and column given
# so now, i want all the rows which are missing (boolean TRUE), 
# and show all columns
# from the msleep data frame

# CLEANING DATA UP
# CLEANING DATA INVOLVES SELECTING VARS, SELECTING ROWS/COLUMNS, DEALING
# WITH MISSING DATA
#################
# SELECTING VARIABLES
starwars %>%
  select(name,height,mass)         # name height and mass selected

starwars %>%
  select(1:3)                      # same thing

starwars %>%
  select(ends_with("color")) %>%   # all vars that end with color
  View()

# other relevant functions:
# starts_with, contains

# CHANGING VARIABLE ORDER WITH SELECT
starwars %>%
  select(name,mass,height,everything()) %>%    # order changed
  View()                                       # everything() displays remaining

# CHANGING VARIABLE NAME
starwars %>%
  rename("characters" = "name") %>%
  head()

# CHANGING A VARIABLE TYPE
class(starwars$hair_color)
starwars$hair_color <- as.factor(starwars$hair_color)
class(starwars$hair_color)
# hair_color from dataset starwars changed to vector from character

class(starwars$hair_color)
starwars$hair_color <- as.character(starwars$hair_color)
class(starwars$hair_color)
#hair_color is mutated from factor to character again
class(starwars$hair_color)
starwars$hair_color <- as.factor(starwars$hair_color)
class(starwars$hair_color)

# USING TIDYVERSE TO CHANGE VARIABLE TYPE
class(starwars$hair_color)

starwars <- starwars %>%                 # if starwars is not assigned back to the same dataset, the mutate function only changes variable type within local scope, and the lifetime of it changing is also within that scope only
  mutate(hair_color = as.character(hair_color)) %>%
  glimpse()

class(starwars$hair_color)
mutate(starwars, hair_color = as.factor(starwars$hair_color))

# CHANGING FACTOR LEVELS
df <- starwars
df$sex <- as.factor(df$sex)

levels(df$sex)

df <- df %>%
  mutate(sex = factor(sex,
                      levels = c("male","female","hermaphroditic","none"))) # this changes the order

levels(df$sex)

# FILTERING ROWS
starwars %>%
  select(mass,sex) %>%
  filter(mass < 55 & sex == "male")

# RECODE DATA
starwars %>%
  select(sex) %>%           # not necessary, but makes code clearer
  mutate(sex = recode(sex,"male" = "man", "female" = "woman"))

# DEALING WITH MISSING DATA
mean(starwars$height, na.rm = TRUE)       # na.rm = TRUE removes data that is NA

starwars %>%
  select(name, gender, hair_color, height)

starwars %>%
  drop_na(hair_color)

# DEALING WITH DUPLICATES
names <- c("peter","john","andrew","peter")
age <- c(22,33,44,22)

friends <- data.frame(names,age)
friends

friends %>%
  distinct()

distinct(friends)
# friends <- distinct(friends)   makes changes permanent

# MANIPULATE
#############
# CREATE OR CHANGE A VARIABLE (MUTATE)
starwars %>%
  mutate(height_m = height/100) %>%
  select(name, height, height_m)

# CONDITIONAL CHANGE (IF_ELSE)
starwars %>%
  mutate(height_m = height/100) %>%
  select(name, height, height_m) %>%
  mutate(tallness = 
           if_else(height_m < 1,
                   "short",
                   "tall"))      # if_else(condition,if true,if false)

# RESHAPE DATA WITH PIVOT WIDER
library(gapminder)
View(gapminder)

data <- select(gapminder, country, year, lifeExp)
View(data)

wide_data <- data %>%
  pivot_wider(names_from = year, values_from = lifeExp) %>% # pivot_wider spreads data from long to wide (increases number of columns, decreases number of rows)
  View()                                                    # 2 values: names_from and values_from, i.e. where to get the name for output column and where to get values

# RESHAPE DATA WITH PIVOT LONGER
long_data <- wide_data %>%
  pivot_longer(2:13,
               names_to = "year",          # names of columns, put under the header year now. note that year is a new variable name. any other name couldve been given
               values_to = "lifeExp") %>%  # all the values, put under column w header lifeExp
  View()

# DESCRIBING DATA
#################
View(msleep)

# RANGE/SPREAD OF DATA
min(msleep$awake)
max(msleep$awake)
range(msleep$awake)
IQR(msleep$awake)

# MEASURES OF CENTRAL TENDENCY
mean(msleep$awake)
median(msleep$awake)

# VARIANCE
var(msleep$awake)

summary(msleep$awake)           # gives min, 1st + 3rd q, mean, median, max

msleep %>%
  select(awake, sleep_total) %>%
  summary()                        # gives data for 2 variables

# SUMMARIZE YOUR DATA
msleep %>%
  drop_na(vore) %>%        # drops data that is unavailable
  group_by(vore) %>%       # groups by what kind of eater they are // THIS IS THE GROUPING VAR. A ROW IS CREATED FOR EACH KIND OF VORE
  summarise(Lower = min(sleep_total),       # summarises each group down to one row. creates  new data frame and returns one row for for each combi of grouping vars
            Average = mean(sleep_total),    # with one column for each grouping var and one column for each summary stat specified
            Upper = max(sleep_total),
            Difference = max(sleep_total) - min(sleep_total)) %>%
  arrange(Average) %>%      # data is arranged from low to high avg
  View()

# CREATING TABLES
table(msleep$vore)          # creates a table w frequency based on vore

msleep %>%
  select(vore,order) %>%    # from msleep dataset, vore and order is selected
  filter(order %in% c("Rodentia", "Primates")) %>%   # filter out rodentia and primates
  table()    # and create a table
# %in% operator checks in an array if the value youve given it exists or not
# table(msleep$vore,msleep$order) <- without filtering

# DATA VISUALIZATION
####################

plot(pressure)

# THE GRAMMAR OF GRAPHICS
# DATA - WHAT DATA YOU ARE USING
# MAPPING - HOW TO MAP OUT VARIABLES, XY AXES ETC
# GEOMETRY - LINES, BAR CHARTS, DIFFERENT PLOTS

# BAR PLOTS
ggplot(data = starwars,
       mapping = aes(x = gender))+      # use + instead of %>% when piping in ggplot2 statements
  geom_bar()

# HISTOGRAMS
starwars %>%
  drop_na(height) %>%
  ggplot(aes(height))+    # aes creates mappings, with aes(x,y,...)
  geom_histogram()

# BOX PLOTS
starwars %>%
  drop_na(height) %>%
  ggplot(mapping = aes(x = height))+
  geom_boxplot(fill = "steelblue")+
  theme_bw()+
  labs(title = "Boxplot of height",
       x = "Height of characters")

# DENSITY PLOTS
starwars %>%
  drop_na(height) %>%
  filter(sex %in% c("male","female")) %>%
  ggplot(aes(height,
             color = sex,        # color of line based on var sex
             fill = sex))+       # fill based on var sex
  geom_density(alpha = 0.2)+     # alpha is transparency, with 1 being not transparent
  theme_bw()

# SCATTER PLOTS
starwars %>% 
  filter(mass < 200) %>%                   # starwars character below 200 mass
  ggplot(aes(height,mass,color = sex))+    # plot x is height, y is mass, colour it in based on the sex
  geom_point(size = 5, alpha = 0.5)+       
  theme_minimal()+                        # for grids and stuff. j the theme tbh
  labs(title = "Height and mass by sex")   # labels

# SMOOTHED MODEL
starwars %>%
  filter(mass < 200) %>%
  ggplot(aes(height,mass,color = sex))+
  geom_point(size = 3, alpha = 0.8)+
  geom_smooth()+                # draws a smooth linear layer over your plot. grey area represents standard error
  facet_wrap(~sex)+             # so like yk how other than height and mass you are also plotting by sex. you can separate the sex var out and make it any number of diff plots depending on the level of your data
  theme_bw()+
  labs(title = "Height and mass by sex")

# ANALYZING DATA
################
# HYPOTHESIS TESTING
# T-TEST
library(gapminder)
View(gapminder)
t_test_plot

gapminder %>%
  filter(continent %in% c("Africa", "Europe")) %>%
  t.test(lifeExp ~ continent, data = .,
         alternative = "two.sided",
         paired = FALSE)

# ANOVA - analysis of variance
ANOVA_plot

gapminder %>%
  filter(year == 2007) %>%
  filter(continent %in% c("Americas","Europe","Asia")) %>%
  aov(lifeExp ~ continent, data =.) %>%
  summary()

gapminder %>%
  filter(year == 2007) %>%
  filter(continent %in% c("Americas","Europe","Asia")) %>%
  aov(lifeExp ~ continent, data =.) %>%
  TukeyHSD()

gapminder %>%
  filter(year == 2007) %>%
  filter(continent %in% c("Americas","Europe","Asia")) %>%
  aov(lifeExp ~ continent, data =.) %>%
  TukeyHSD() %>%
  plot()

# CHI SQUARED TEST - for categorical data
chi_plot

head(iris)

flower <- iris %>%
  mutate(Size = cut(Sepal.Length,       # cut divides sepal length into intervals and codes them based on where on the interval they fall
                  breaks = 3,           # here we want to divide sepal length by 3
                  labels = c("small", "medium", "large"))) %>%    # first interval is small, 2nd is medium, 3rd is large
  select(Species, Size)    # select only species and size

# CHI SQUARED GOODNESS OF FIT TEST
flower %>%
  select(Size) %>%
  table() %>%
  chisq.test()

# CHI SQUARED TEST OF INDEPENDENCE
flower %>%
  table() %>%
  chisq.test()

# LINEAR MODEL
linear_plot

head(cars,10)

cars %>%
  lm(dist ~ speed, data = .) %>%   # linear model of dependent variable vs independent variable
  summary()
# residuals = difference between model + line
# coefficients: y-intercept, slope, p value of slope