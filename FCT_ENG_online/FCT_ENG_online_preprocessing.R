# Preprocessing pipeline for Food Choice Task - ENG online version
# Author: Lucija Blazevski (l.blazevski@uva.nl), University of Amsterdam
# Date: 06-09-2023
# Use:   1. Unzip your data folder after downloading it from Pavlovia.
#        2. Place FCT_ENG_online_preprocessing.R script in the same directory as 
#        your data. Your data should be in the sub-folder called 'data' within
#        that directory.
#        3. Go to section 'Prepare work space' and replace the path to your 
#        directory that contains this script - FCT_ENG_online_preprocessing.R, 
#        and 'data' sub-folder with .csv files as mentioned in steps 1. and 2. 
#        4. Go to section 'Options' and choose the type of output (See Notes for
#        further detail)
# Notes: The script executes four processing steps:
#           A) General data cleaning that extracts relevant columns, removes
#              empty rows, and performs reverse coding where needed. The output
#              largely resembles the raw data from Pavlovia and is saved in the
#              folder 'preprocessed_data' with the prefix 'preprocessed' added
#              to the original file name. 
#           B) Extraction of relevant information in a trial-by-trial format 
#              following the previous data preprocessing scripts of Food
#              Choice Task. Outcome is a separate .csv file for each participant
#              with a prefix 'trial_by_trial' in a folder 'trial_by_trial_data'.
#              Each row represents a food item with all the information from 
#              separate blocks in different columns. 
#              In section 'Options' set:
#                   - 'stacked_pp = TRUE'
#                   - 'trial_by_trial = TRUE'
#           C) Stacking data from A) and B) of all participants. Data from A) 
#              are saved as 'preprocessed_data_all_pp.csv' and data from B) as 
#              'trial_by_trial_all_pp.csv'. 
#              In section 'Options' set:
#                   - 'stacked_all = TRUE'
#           D) Summarizing most relevant data per participant. The outcome is 
#              'summary_data.csv' where each participant represents one row.
#              In section 'Options' set:
#                   - summary_all = TRUE
# If you run into any issues, please send an e-mail to l.blazevski@uva.nl



################################################################################
#                     Prepare the workspace                                    #
################################################################################
# Set working directory (replace with your actual working directory path)
#setwd("/path/to/your/directory")

# Clean the work space
rm(list=ls()) 

# Round to 3 decimals
options(digits = 3)

# Load libraries
load_and_install_packages <- function(packages) {
  new.packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if (length(new.packages)) install.packages(new.packages, dependencies = TRUE)
  lapply(packages, require, character.only = TRUE)
}

# List of packages
pkg <- c("ggplot2", "dplyr", "tidyr")

# Load and install (if necessary) all packages
load_and_install_packages(pkg)

# Load data
files <- list.files(path = "./data", pattern = "\\.csv$")
data_list <- lapply(paste0("./data/", files), read.csv)



################################################################################
#                             Options                                          #
################################################################################
# Do you want to stack all blocks of each participant together? We recommend not 
# to change this option as the 'trial_by_trial' preprocessing cannot be executed
# without it.
stacked_pp = TRUE

# Do you want to create a fully preprocessed trial-by-trial file for each 
# participant that will be saved in 'trial_by_trial_data' folder?
trial_by_trial = TRUE

# Do you want to stack participants in one large data frame?
stacked_all = TRUE

# Do you want a summary statistics for the whole sample (each participant in its
# own row)?
summary_all = TRUE



################################################################################
#               Utilities and functions for preprocessing                      #
################################################################################
# Cleaning data frames
columns_to_keep <- c("participant", "condition", "order", "reverse_coding", 
                     "date", "frameRate", "FixationLength", "current_food", "fat", 
                     "rating_keys.keys", "rating_keys.rt", "block", 
                     "reference_item", "item_to_compare", "c_rating.keys", 
                     "c_rating.rt", "chosen_item")

clean_df <- function(df) {
  df$participant <- as.character(df$participant)
  rating_df <- df %>% filter(block == "tasty" | block == "healthy")
  choice_df <- df %>% filter(block == "choice")
  rating_df <- rating_df[!is.na(rating_df$current_food),]
  choice_df <- choice_df[!is.na(choice_df$chosen_item),]
  rating_df <- rating_df %>% select("participant", "date", "condition", "order",
                                    "reverse_coding", "frameRate", 
                                    "FixationLength", "current_food", "fat",
                                    "rating_keys.keys", "rating_keys.rt", 
                                    "block")
  choice_df <- choice_df %>% select("participant", "date", "condition", "order",
                                    "reverse_coding","frameRate", 
                                    "FixationLength", "block", "reference_item",
                                    "item_to_compare", "c_rating.keys", 
                                    "c_rating.rt", "chosen_item")
  tasty_df <- rating_df %>% filter(block == "tasty")
  healthy_df <- rating_df %>% filter(block == "healthy")
  return(list(tasty = tasty_df, healthy = healthy_df, choice = choice_df))
}

# Reverse code, and reorder columns
add_columns <- function(df) {
  # Reverse coding for rating_keys.keys if reverse_coding is 'Yes'
  if ("rating_keys.keys" %in% colnames(df) & "reverse_coding" %in% colnames(df)) {
    df <- df %>% mutate(
      rating_keys.keys = case_when(
        reverse_coding == "Yes" & rating_keys.keys == 5 ~ 1,
        reverse_coding == "Yes" & rating_keys.keys == 4 ~ 2,
        reverse_coding == "Yes" & rating_keys.keys == 3 ~ 3,
        reverse_coding == "Yes" & rating_keys.keys == 2 ~ 4,
        reverse_coding == "Yes" & rating_keys.keys == 1 ~ 5,
        TRUE ~ rating_keys.keys
      )
    )
  }
  
  return(df)
}



################################################################################
#                      A) General data cleaning                                #
################################################################################
# Reorder columns
new_order_tasty_healthy <- c("participant", "date", "frameRate", "condition",
                             "order", "reverse_coding", "block", 
                             "FixationLength", "current_food","fat",
                             "rating_keys.keys","rating_keys.rt")
new_order_choice <- c("participant", "date", "frameRate", "condition","order",
                      "reverse_coding", "block", "FixationLength", 
                      "reference_item","item_to_compare", "c_rating.keys",
                      "c_rating.rt", "chosen_item")

data_list_clean <- lapply(data_list, clean_df)
data_list_clean <- lapply(data_list_clean, function(df_list) {
  df_list <- lapply(df_list, add_columns)
  df_list$tasty <- df_list$tasty[, new_order_tasty_healthy]
  df_list$healthy <- df_list$healthy[, new_order_tasty_healthy]
  df_list$choice <- df_list$choice[, new_order_choice]
  return(df_list)
})

# Stack blocks per participant
if (stacked_pp) {
  stack_df <- function(df_list) {
    df_list$choice <- df_list$choice[!(!nzchar(trimws(df_list$choice$item_to_compare)) & !nzchar(trimws(df_list$choice$reference_item))), ]
    all_cols <- unique(c(names(df_list$healthy), names(df_list$tasty), names(df_list$choice)))
    for(df_name in names(df_list)) {
      missing_cols <- setdiff(all_cols, names(df_list[[df_name]]))
      df_list[[df_name]][, missing_cols] <- NA
    }
    stacked_df <- bind_rows(df_list$healthy, df_list$tasty, df_list$choice)
    return(stacked_df)
  }
  data_combined <- lapply(data_list_clean, stack_df)
}

# Create new directory if it doesn't exist
if (!dir.exists("./preprocessed_data")) {
  dir.create("./preprocessed_data")
}

# Write preprocessed data to CSV in the new directory
mapply(function(data, file_name) {
  write.csv(data, file = paste0("./preprocessed_data/preprocessed_", file_name), row.names = FALSE)
}, data_combined, files)


# Create an empty list to store reshaped data
reshaped_data_list <- list()


################################################################################
#                           B) Trial by trial                                  #
################################################################################
# Check if 'trial_by_trial' is TRUE
if (trial_by_trial) {
  # Perform reshaping for each data_combined file and store in the list
  reshaped_data_list <- lapply(data_combined, function(data) {
    # Split data based on block
    healthy_block <- data %>%
      filter(block == "healthy") %>%
      select(participant, date, frameRate, condition, order, reverse_coding, fat, participant, current_food, rating = rating_keys.keys, RT = rating_keys.rt)
    
    tasty_block <- data %>%
      filter(block == "tasty") %>%
      select(participant, current_food, rating = rating_keys.keys, RT = rating_keys.rt)
    
    choice_block <- data %>%
      filter(block == "choice") %>%
      select(participant, item_to_compare, reference_item, rating = c_rating.keys, RT = c_rating.rt) %>% 
      mutate(current_food = item_to_compare)
    
    # Join blocks back together
    reshaped_data <- healthy_block %>%
      rename(health_rating = rating, health_RT = RT) %>%
      left_join(tasty_block %>% rename(taste_rating = rating, taste_RT = RT), by = c("participant", "current_food")) %>%
      left_join(choice_block %>% rename(choice_rating = rating, choice_RT = RT), by = c("participant", "current_food")) %>%
      mutate(
        choice_rating = ifelse(current_food == reference_item, NA, choice_rating),
        choice_RT = ifelse(current_food == reference_item, NA, choice_RT),
        food = current_food,
        chosen_food = case_when(
          choice_rating %in% c(1, 2) ~ reference_item,
          choice_rating == 3 ~ 'neutral',
          TRUE ~ food
        )
      ) %>%
      mutate(
        fat_chosen_food = case_when(
          chosen_food %in% c(reference_item, 'neutral', NA) ~ NA,
          TRUE ~ fat
          
        )
      ) %>% 
      mutate(
        self_control_possible = case_when(
          (health_rating %in% c(1,2) & taste_rating %in% c(4,5)) ~ T,
          (health_rating %in% c(4,5) & taste_rating %in% c(1,2)) ~ T,
          (health_rating %in% c(1,2) & taste_rating %in% c(1,2)) ~ F,
          (health_rating %in% c(4,5) & taste_rating %in% c(4,5)) ~ F,
          TRUE ~ NA)
      ) %>%
      mutate(
        self_control_applied = case_when(
          ((health_rating %in% c(1,2) & taste_rating %in% c(4,5)) & chosen_food == reference_item) ~ T,
          ((health_rating %in% c(4,5) & taste_rating %in% c(1,2)) & chosen_food == current_food) ~ T,
          ((health_rating %in% c(1,2) & taste_rating %in% c(4,5)) & chosen_food == current_food) ~ F,
          ((health_rating %in% c(4,5) & taste_rating %in% c(1,2)) & chosen_food == reference_item) ~ F,
          TRUE ~ NA
        )
      ) %>%
      select(participant, date, frameRate, condition, order, reverse_coding, food, everything()) %>%
      select(-c(item_to_compare, current_food))
    
    return(reshaped_data)
  })
  
  # Create 'trial_by_trial_data' directory if it does not exist
  if (!dir.exists("./trial_by_trial_data")) {
    dir.create("./trial_by_trial_data")
  }
  
  # Write reshaped data to CSV in the 'trial_by_trial_data' directory
  mapply(function(data, file_name) {
    write.csv(data, file = paste0("./trial_by_trial_data/trial_by_trial_", file_name), row.names = FALSE)
  }, reshaped_data_list, files)
}



################################################################################
#                         C) Stack participants                                #
################################################################################
if (stacked_all) {
  all_participants_data <- bind_rows(data_combined)
  all_participants_data <- as.data.frame(all_participants_data)
  
  all_participants_reshaped_data <- bind_rows(reshaped_data_list)
  all_participants_reshaped_data <- as.data.frame(all_participants_reshaped_data)
  
  # Save data to a csv file
  write.csv(all_participants_data, file = "preprocessed_data_all_pp.csv", row.names = FALSE)
  write.csv(all_participants_reshaped_data, file = "trial_by_trial_all_pp.csv", row.names = FALSE)
}

################################################################################
#                              D) Summary                                      #
################################################################################
summary_data <- all_participants_reshaped_data %>%
  group_by(participant) %>%
  summarise(
    date = first(date[!is.na(date)]), # First non-NA date for each participant
    ref = first(reference_item[!is.na(reference_item)]), # First non-NA reference item for each participant
    
    ref_h = health_rating[food == ref], # Health rating for the reference food
    ref_t = taste_rating[food == ref], # Taste rating for the reference food
    
    h_total_trials = 76,
    t_total_trials = 76,
    c_total_trials = 75,
    
    h_resp_count = sum(!is.na(health_rating)),
    t_resp_count = sum(!is.na(taste_rating)),
    c_resp_count = sum(!is.na(choice_rating)),
    
    h_resp = h_resp_count / h_total_trials,
    t_resp = t_resp_count / t_total_trials,
    c_resp = c_resp_count / c_total_trials,
    
    h_lo = mean(health_rating[fat == 0], na.rm = TRUE),
    h_hi = mean(health_rating[fat == 1], na.rm = TRUE),
    t_lo = mean(taste_rating[fat == 0], na.rm = TRUE),
    t_hi = mean(taste_rating[fat == 1], na.rm = TRUE),
    c_lo = mean(choice_rating[fat == 0], na.rm = TRUE),
    c_hi = mean(choice_rating[fat == 1], na.rm = TRUE),
    
    cneu_lo = mean(choice_rating == 3 & fat == 0, na.rm = TRUE),
    cneu_hi = mean(choice_rating == 3 & fat == 1, na.rm = TRUE),
    
    cho_noneut_lo = mean(choice_rating != 3 & fat == 0, na.rm = TRUE),
    cho_noneut_hi = mean(choice_rating != 3 & fat == 1, na.rm = TRUE),
    
    h_lo_rt = median(health_RT[fat == 0], na.rm = TRUE),
    h_hi_rt = median(health_RT[fat == 1], na.rm = TRUE),
    t_lo_rt = median(taste_RT[fat == 0], na.rm = TRUE),
    t_hi_rt = median(taste_RT[fat == 1], na.rm = TRUE),
    c_lo_rt = median(choice_RT[fat == 0], na.rm = TRUE),
    c_hi_rt = median(choice_RT[fat == 1], na.rm = TRUE),
    
    self_ctrl_bin = mean(self_control_possible, na.rm = TRUE),
    self_ctrl_bin_COUNT = sum (self_control_possible, na.rm = TRUE),
    self_ctrl = sum(self_control_applied, na.rm = TRUE)/self_ctrl_bin_COUNT
  ) %>%
  select(-h_resp_count, -t_resp_count, -c_resp_count, -h_total_trials, -t_total_trials, -c_total_trials)  # Removing intermediate columns

write.csv(summary_data, "summary_data.csv", row.names = FALSE)
