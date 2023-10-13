**Documentation for Food Choice Task - PsychoPy Builder and Pavlovia Version**
=============================================================

This repository contains materials to run the Columbia Center for Eating Disorders Food Choice Task that captures eating behaviour.

When using the task, please reference the following publications:

Steinglass, J., Foerde, K., Kostro, K., Shohamy, D., & Walsh, B. T. (2015). Restrictive food intake as a choice—A paradigm for study. *International Journal of Eating Disorders, 48*(1), 59-66.

Foerde, K., Steinglass, J. E., Shohamy, D., & Walsh, B. T. (2015). Neural mechanisms supporting maladaptive food choices in anorexia nervosa. *Nature Neuroscience, 18*(11), 1571-1573.


**Task**
--------

This experiment is designed for both online and local use. Below, you'll find a description of each version of the task.

### Versions

#### Version 1: General online task

- **Link:** [FCT General Online Task](https://gitlab.pavlovia.org/lblazev_uva/fct_eng_v1_legacy)
- **Description:** This version of the task is available for download or forking/cloning via the provided link. Participants must input their participant ID and the experimental condition will be randomly assigned to each participant.

#### Version 2: Separate online tasks for each condition

- **Links:**
  - Condition A: [FCT Online - Condition A](https://gitlab.pavlovia.org/lblazev_uva/fct_eng_v1_cond_a)
  - Condition B: [FCT Online - Condition B](https://gitlab.pavlovia.org/lblazev_uva/fct_eng_v1_cond_b)
  - Condition C: [FCT Online - Condition C](https://gitlab.pavlovia.org/lblazev_uva/fct_eng_v1_cond_c)
  - Condition D: [FCT Online - Condition D](https://gitlab.pavlovia.org/lblazev_uva/fct_eng_v1_cond_d)
  
- **Description:** In this version, separate online tasks are available for each experimental condition. Participants must input their participant ID, and their condition will be determined based on the specific link they access.

#### Version 3: Local version of the task

- **Link:** [FCT Local Version]()
- **Description:** This version of the task is designed for local use. The experimenter will need to input the participant ID and select the condition from a dropdown menu provided in the interface.

*Note*: For detailed information on forking/cloning experiments from Pavlovia, please refer to the Pavlovia documentation available at [https://pavlovia.org/docs/experiments/create-fork](https://pavlovia.org/docs/experiments/create-fork).
   

### Task description

In this task, participants will be asked to evaluate 76 different food items. The task is in English. They will provide ratings on a scale ranging from 1 to 5, using the corresponding keys positioned in the top left corner of the keyboard (1, 2, 3, 4, or 5). It is important to note that the meaning of this rating scale will vary based on the specific condition they are assigned to. 

The task is structured into three distinct blocks: the Healthy block, the Tasty block, and the Choice block:  

 1. **Healthy block**: Participants assess the perceived healthiness of
    various food items. 
    
2. **Tasty block**: Participants assess the perceived tastiness of
    different food items. 
    
3. **Choice block**: Participants compare 75 food items to a reference food
    item selected earlier in the experiment, which is typically chosen
    to be neutral in both healthiness and tastiness ratings (e.g., rated
    3 in both blocks) but may involve presenting an image of crackers if
    no neutral food is available.

The order in which Healthy and Tasty blocks appear and the way participants should rate the foods differ across four possible conditions. Condition is determined randomly for each participant.  

#### Conditions

 - **A**. Healthy block followed by Tasty block. Ratings in these blocks will follow a scale
   that transitions from unhealthy/bad to healthy/good. There is no
   reverse coding of ratings in this condition.
   
-  **B**. Tasty block followed by Healthy block. Ratings in these blocks will follow a scale from
   bad/unhealthy to good/healthy. No reverse coding is needed in this
   condition.
   
-  **C**. Healthy block followed by Tasty block. Ratings in these blocks will follow a scale from healthy/good
   to unhealthy/bad. Reverse coding is applied in this condition.
   
-   **D**. Tasty block followed by Healthy block. Ratings in these blocks will follow a scale from good/healthy to
   bad/unhealthy. Reverse coding is applied here as well.

*Note.* Reverse coding indicates in which condition it is necessary to perform reverse coding of ratings. Important: Reverse coding is automatically applied in the Preprocessing pipeline. 

**Preprocessing pipeline**
----------------------

The preprocessing script is designed to facilitate the preparation of data for the Food Choice Task (FCT) – English version. Its purpose is to streamline the data cleaning and extraction process, making it easier for researchers to analyse and interpret the data collected locally or from Pavlovia. If you encounter any issues or need further assistance, please feel free to reach out to Lucija Blazevski at l.blazevski@uva.nl. 

*Important note*. Our current data preprocessing pipeline assumes that the data is either complete or nearly complete. This means that all participants have completed all the blocks. It's important to note that the pipeline does not verify or handle missing values or incomplete trials. Instead, it aims to maintain flexibility by returning outputs for all available data, regardless of the number of completed trials. Therefore, if you anticipate missing data or need to perform any data exclusions or treatments for missing values, it should be done prior to running the preprocessing scripts listed here. Ensure that only complete .csv data files are placed in the *data* folder before utilizing these preprocessing scripts. Additionally, we recommend checking the *summary.csv* file, specifically in columns labeled 'h_resp,' 't_resp,' and 'c_resp.' These columns provide information on response proportions (completed trials) within the healthy, tasty, and choice blocks, respectively.

### Getting started

Before you begin using this script, make sure to follow these steps: 

1. If using the task locally, skip to Step 2. If using the task online, unzip your data folder after downloading it from Pavlovia. 

2. Depending on online or local use, place the [FCT_ENG_online_preprocessing.R](https://osf.io/5p7dm) or [FCT_ENG_local_preprocessing.R](https://osf.io/u9me2),  script in the same directory as your data. Your data should be located in the sub-folder called *data* within that directory. 

### Prepare workspace

In the section Prepare the workspace in line 45, you will need to specify the path to your directory containing the FCT_ENG_preprocessing.R script and the *data* sub-folder with the CSV files you downloaded. Ensure that the script knows where to find your data by replacing the placeholders with your directory path. 


### Options

The script provides several options to customize the preprocessing
   according to your needs. You can choose the type of output that best
   suits your analysis: 
   
   A) **General data cleaning**
   
   This step involves general data cleaning, which includes extracting
   relevant columns, removing empty rows, and performing reverse coding
   where needed. The output closely resembles the raw data from Pavlovia
   and is saved in the *preprocessed_data* folder with the prefix
   *'preprocessed'* added to the original file name. 
   
   B) **Trial-by-trial data extraction** 
   
   This step extracts relevant information in a trial-by-trial format,
   following the format used in previous data preprocessing scripts for
   the Food Choice Task. The outcome is a separate CSV file for each
   participant, with a prefix *'trial_by_trial'*, stored in the
   *trial_by_trial_data* folder. Each row represents a food item with all
   the information from separate blocks in different columns. 
   
   To enable this option, set: 
   
     stacked_pp = TRUE 
   
     trial_by_trial = TRUE 
   
   C) **Stacking data** 
   
   This step combines data from A) or B) for all participants. Data from
   A) are saved as *preprocessed_data_all_pp.csv*, and data from B) as
   *trial_by_trial_all_pp.csv*. 
   
   To enable this option, set: 
   
    stacked_all = TRUE 
   
   D) **Summary data**
   
   This step summarizes the most relevant data per participant. The
   outcome is *summary_data.csv*, where each participant represents one
   row. 
   
   To enable this option, set: 
   
    summary_all = TRUE 
   
   The columns represent the following: 
   
-   participant: Subject ID, a unique identifier for each participant 
   
-   date: The date when the participant completed the task 
   
-   ref: The reference food, which is the specific food item used as a
   reference point in the task for each participant 
   
-   ref_h: Health rating for the reference food, indicating how
   participants rated the healthiness of the reference food 
   
-   ref_t: Taste rating for the reference food, indicating how
   participants rated the taste of the reference food 
   
-   h_resp: Proportion of responses on Health trials, representing how
   often the participant chose items based on health considerations 
   
-   t_resp: Proportion of responses on Taste trials, indicating how often
   the participant chose items based on taste considerations 
   
-   c_resp: Proportion of responses on Choice trials, showing how often
   the participant made choices between items 
   
-   h_mean: Mean ratings on Health trials, the average health-related
   rating given by the participant 
   
-   t_mean: Mean ratings on Taste trials, the average taste-related
   rating given by the participant 
   
-   c_mean: Mean ratings on Choice trials, the average choice rating
   given by the participant 
   
-   cneu_lo: Proportion of trials with neutral choice (neither food nor
   reference) for low-fat items 
   
-   cneu_hi: Proportion of trials with neutral choice (neither food nor
   reference) for high-fat items 
   
-   cho_noneut_lo: Proportion of trials with food chosen over reference
   when neutral responses are excluded for low-fat items 
   
-   cho_noneut_hi: Proportion of trials with food chosen over reference
   when neutral responses are excluded for high-fat items 
   
-   self_ctrl_bin: Proportion of trials on which self-control could be
   implemented out of relevant trials 
   
-   self_ctrl_bin_COUNT: Count of trials on which self-control could be
   implemented out of relevant trials 
   
-   self_ctrl: Proportion of trials with self-control out of the trials
   on which that was possible 
   
-   h_rt: Median response time (RT) for Health trials 
   
-   t_rt: Median response time (RT) for Taste trials 
   
-   c_rt: Median response time (RT) for Choice trials 
   
-   h_lo_rt: Median RT for Health trials - Low-fat 
