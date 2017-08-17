library(tidyverse)

df <- data.frame( "county"= c("320", "321", "322", "323"),
		  "long" = c(-121.36, -122.45, -123.45, -121.34),
		  "lat" = c(37.23, 39.45, 36.15, 38.33),
		  "emp" = c(140, 46, 98, 40),
		  stringsAsFactors = FALSE)

mod40 <- function (x) { 
              x %/% 40
}

# Determine num of rows needed for target dataframe
markers <- vector("integer", nrow(df))
for ( i in seq_along(df)) {
   markers[i] <- mod40(df[i,]$emp) 
}
num_rows <- sum(markers)

# pre allocate memory for target dataframe
emp40_df <- data.frame(county = character(num_rows),
		       long = numeric(num_rows),
		       lat = numeric(num_rows),
		       emp40 = numeric(num_rows),
		       instance = numeric(num_rows),
		       stringsAsFactors = FALSE)

# For each observation/row in original dataframe df
# create target dataframe observations/rows of 40 employees
# whose sum approaches the total number of employees df[i,]$EMP
index <- 1
for ( i in seq_along(df)) {
	for ( j in 1:markers[i]) {
		row_index <- index - 1 + j
		emp40_df[row_index,]$county <- df[i,]$county
		emp40_df[row_index,]$long <- df[i,]$long
		emp40_df[row_index,]$lat <- df[i,]$lat
		emp40_df[row_index,]$emp40 <- 40
		emp40_df[row_index,]$instance <- j
	}
	index <- index + markers[i]
}

