
# Skeleton file 2 for Assignment 1 in BAN400. 
# -------------------------------------------

# More detailed steps to complete Problem 1.

library(tidyverse)    # Contains most of what we need.
library(ggplot2)

# Read the entire data file into memory using the readLines()-function. Use the
# URL direcly or read the data from the local file that is in the repository.

# The readLines()-function puts each line into a separate element in a character
# vector. Looking at ?readLines it seems that we only need to provide one
# argument: the "connection", or in other words the location of the text file.
# Replace the "?" below with the location of the file. We do get a warning that
# the file does not end with an "end of line"-character (EOL). This does not
# seem to pose a problem later, and it seems that we can silece the warning by
# switchin off the "warn"-argument. Do that if you wish.
raw_file <- readLines(con = "suites_dw_Table1.txt")

# Identify the line number L of the separator line between the column names and
# the rest of the data table.

# Now every line in the file is in its separate element in the character vector
# "raw_file". The next key step is to identify which line contains the separator
# line between the column names and the rest of the table. We have to come up
# with a rule that defines this line. Let us for example say that "L is the
# first line in the data file that starts with '--'". We can extract the first
# two letters of each of the elements in the "raw_data" vector using the
# substr()-function.

# What do you need to replace the two question marks with in order to extract
# the first two letters?
substr(x = raw_file, start = 1, stop = 2)

# The next step is then to find out *which* line starts with "--", and pick out
# the first one. This can be done in a nice little pipe, where you have to fill
# out the question marks and the missing function names:
L <- 
  (substr(x = raw_file, start = 1, stop = 2) == "--") %>% 
  which(raw_file) %>% 
  min()

df <- read_delim("suites_dw_Table1.txt", delim = "|", col_names = T, skip = L-2)
df <- df[-1,]


# Save the variable descriptions (i.e. the information in lines 1:(L-2)) in a
# text-file for future reference using the cat()-function. The first argument is
# the information that we want to print out. In order to get each element in the
# "raw_file"-vector on a separate line we also provide the sep-argument, where
# we put the "end-of-line"-character "\n". We also need to come up with a file
# name. Replace the question marks:
cat(raw_file[1:(L-2)], sep = "\n", file = "var_descriptions.txt")

# Extract the variable names (i.e. line (L-1)), store the names in a vector.

# This is a little bit dirty. We want to *split* the string in raw_data[L-1]
# *by* the character "|", and then we want to *trim* away all the leading and
# trailing white spaces. The first step can be accomplished using the
# str_split()-function in the stringr-package (this is already loaded through
# tidyverse), but there is a delicate detail here. The "|"-character has special
# meaning in R ("or"), so it must be *escaped*, meaning that we tell R that it
# should be interpreted as a normal character. We do that by adding two forward
# slashes in front of it. This function returns a list, with one element for
# each input element. We only send one string in, and hence get only one list
# element out (check that!). We just unlist it to get out the vector. Then we
# apply the str_trim()-function (also in the stringr-package) to get rid of all
# the empty space. Replace the question mark below:
variable_names <- 
  str_split(string = raw_file[L-1], pattern = "\\|") %>% 
  unlist() %>% 
  str_trim()


write.csv(df, file = "df.csv", row.names = F) # Creating a csv file

galaxies <- read_csv("df.csv") # Reading the csv file

# You should now have a nice, clean data frame with galaxies and their
# characteristics in memory. As of March 2022 it should contain 796
# observations.

# Problem 3

galaxies %>% # Creating a histogram showing the amount of galaxies by their a_26 value
  ggplot(aes(x = a_26)) +
  geom_histogram()

