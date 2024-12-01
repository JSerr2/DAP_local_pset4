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
This part of the code evaluates the performance difference between processing non-partitioned and partitioned data sets for each state in the data set. It iterates over all unique states, filters the data by state, and measures the time required to compute the number of deficiencies for each severity level using both non-partitioned CSV and partitioned Parquet data. For each state, the code calculates the size of the filtered data and the speed improvement ratio (non-partitioned over partitioned time). The results are stored in a data frame, and a scatter plot is generated to visualize the relationship between the size of the filtered data and the speed improvement. The plot reveals no significant relationship between the size of the filtered data and the speed improvement, as the best-fit line is flat. One possible reason I didn't see any meaningful relationship could be because the filtering and grouping operations for each state were efficient enough that the dataset size did not significantly impact performance. 

#### 6
The plot compares the total processing time for non-partitioned and partitioned datasets across different states and the time difference between the two. The y-axis represents the time (in seconds), and the x-axis shows the size of the filtered data (number of observations). The results indicate that partitioned files are overall faster than non-partitioned files. However, it seems like there is no meaningful association between the size of the file and the time saved. There are more differences in size in the smaller files. One possible reason we don't see any meaningful difference could be that the file processing was already efficient enough, and as such, the size of the file made no difference. 

### Question 2 Python to R

#### 1
The Python code is a word-guessing game. The program selects from  a list a random five-letter word, and the player is given a fixed number of attempts to guess the correct word. After each attempt, the program provides feedback by revealing which letters are in the correct position and which are not by using underscores. The game continues until the player guesses the word correctly or runs out of attempts. Once the player runs out of attempts, the program reveals the correct word. 
