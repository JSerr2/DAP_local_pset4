# Problem Set 4
## Jose Serrano

#### Packages and Other Important Requirements

R Version: 4.4.2
Packages used: Dyplr, Arrow
Dataset: nursing-home-inspect-data.zip sourced from ProPublica: (https://projects.propublica.org/nursing-homes/)

### Question 1 Big data
#### 1-3
In this process stage, I added a line of code that prompts the user to specify which directory they stored the unzipped folder for easy accessibility. It then reads the files with all the columns stored as characters to avoid type conversion issues. Then, it combines them into one data frame. The combined data set is saved as a single Parquet file and further partitioned by the state column, with each partition saved as a separate Parquet file in a specified directory (NOTE: Partioned Parquet files should all be stored in one separate directory containing only Parquet files to avoid errors). Finally, the partitioned dataset is reloaded to verify the process, ensuring the data is ready for analysis. 

#### 4
This function compares the performance of filtering and summarizing nursing home inspection data using non-partitioned and partitioned datasets. For the non-partitioned data, the function first converts the combined CSV data into an Arrow table for faster processing, then filters by a specified state and groups the data by the scope_severity variable to calculate the number of deficiencies at each severity level. For the partitioned data, the function directly accesses the Parquet files corresponding to the specified states from the partitioned folder structure, performs the same filtering and grouping operations, and measures the time taken for both approaches. It then prints the elapsed time taken for both approaches to compare the efficiency and the time gained by using partitioned Parquet files. 

#### 5
