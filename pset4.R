library(arrow)
library(tidyverse)


## When prompted to input path to folder in the console, remove quotation marks and don't add backslashes,  then press enter in the console

csv_dir <- readline(prompt = "Enter the path to the folder containing the unzipped CSV files: ")

csv_files <- list.files(path = csv_dir, pattern = "\\.csv$", full.names = TRUE)

read_csv_with_fallback <- function(file) {
  read_csv(
    file,
    col_types = cols(.default = col_character()) 
  )
}

combined_df <- csv_files %>%
  map_dfr(read_csv_with_fallback)

# Parquets

parquet_path <- readline(prompt = "Enter the path where you want to save the combined Parquet file: ")

write_parquet(combined_df, sink = file.path(parquet_path, "combined.parquet"))

partitioned_path <- readline(prompt = "Enter the path where you want to save the partitioned Parquet files: ")

if (!"state" %in% colnames(combined_df)) {
  stop("The 'state' column is not present in the dataset. Check your CSV files.")
}

combined_df %>%
  group_by(state) %>%
  write_dataset(
    path = partitioned_path,
    format = "parquet",
    partitioning = "state"
  )

parquet_files <- list.files(
  path = partitioned_path,
  pattern = "\\.parquet$",
  full.names = TRUE,
  recursive = TRUE
)

partioned_dataset <- open_dataset(parquet_files, format = "parquet")

print(partioned_dataset)

## Question 4

comparison_partitioned_non_partitioned <- function(state_name, csv_data, partitioned_path) {
  
  #Non partitioned CSV
  
  csv_arrow_table <- as_arrow_table(csv_data)
  
  start_non_partitioned <- Sys.time()
  
  non_partitioned_summary <- csv_arrow_table %>% 
    filter(state == state_name) %>% 
    group_by(scope_severity) %>% 
    summarise(num_deficiencies = n(), .groups = "drop")
  
  end_non_partitioned <- Sys.time()
  time_non_partitioned <- end_non_partitioned - start_non_partitioned
  
  # Partitioned Parquet
  
  start_partitioned <- Sys.time()
  
  state_partition_path <- file.path(partitioned_path, paste0("state=", state_name))
  partitioned_data <- open_dataset(state_partition_path, format = "parquet")
  
  partitioned_summary <- partitioned_data %>% 
    group_by(scope_severity) %>% 
    summarise(num_deficiencies = n(), .groups = "drop")
  
  end_partitioned <- Sys.time()
  time_partitioned <- end_partitioned - start_partitioned
  
  time_difference <- time_non_partitioned - time_partitioned
  
  cat("Time using non-partitioned data:", time_non_partitioned, "seconds\n")
  cat("Time using partitioned data:", time_partitioned, "seconds\n")
  cat("Time difference:", time_difference, "seconds\n")
  
  list(
    non_partitioned_summary = non_partitioned_summary,
    partitioned_summary = partitioned_summary
  )
}

sample_test <- comparison_partitioned_non_partitioned(
  state_name = "GA",
  csv_data = combined_df,       
  partitioned_path = partitioned_path 
)

## Question 5

unique_states <- unique(combined_df$state)

results <- data.frame(
  state = character(),
  num_observations = numeric(),
  speed_ratio = numeric(),
  stringsAsFactors = FALSE
)

for (state_name in unique_states) {
  csv_arrow_table <- as_arrow_table(combined_df)
  
  start_non_partitioned <- Sys.time()
  filtered_non_partitioned <- csv_arrow_table %>% filter(state == state_name)
  non_partitioned_summary <- filtered_non_partitioned %>%
    group_by(scope_severity) %>%
    summarise(num_deficiencies = n(), .groups = "drop")
  end_non_partitioned <- Sys.time()
  
  time_non_partitioned <- as.numeric(end_non_partitioned - start_non_partitioned, units = "secs") 
  
  # Partitioned data
  state_partition_path <- file.path(partitioned_path, paste0("state=", state_name))
  
  start_partitioned <- Sys.time()
  partitioned_data <- open_dataset(state_partition_path, format = "parquet")
  filtered_partitioned <- partitioned_data %>%
    group_by(scope_severity) %>%
    summarise(num_deficiencies = n(), .groups = "drop")
  end_partitioned <- Sys.time()
  
  time_partitioned <- as.numeric(end_partitioned - start_partitioned, units = "secs")
  
  num_observations <- nrow(as.data.frame(filtered_non_partitioned))
  speed_ratio <- as.numeric(time_non_partitioned / time_partitioned)
  
  results <- rbind(
    results,
    data.frame(
      state = state_name,
      num_observations = num_observations,
      speed_ratio = speed_ratio
    )
  )
}

## Plot

plot <- ggplot(results, aes(x = num_observations, y = speed_ratio)) +
  geom_point() +
  geom_smooth(method = "lm", color = "blue", se = FALSE) +
  labs(
    title = "Partitioned Speedup vs. Filtered Data Size",
    x = "Number of Observations (Filtered Data)",
    y = "Speed Improvement (Non-Partitioned Time / Partitioned Time)"
  ) +
  theme_minimal()

png("scatter_plot_partitioned_speedup.png", width = 800, height = 600)
print(plot)  
dev.off()   

print(plot)

## Question 6

results <- results %>%
  mutate(
    time_non_partitioned = sapply(unique_states, function(state_name) {
      start <- Sys.time()
      csv_arrow_table <- as_arrow_table(combined_df)
      csv_arrow_table %>% filter(state == state_name)
      as.numeric(Sys.time() - start, units = "secs")
    }),
    time_partitioned = sapply(unique_states, function(state_name) {
      start <- Sys.time()
      state_partition_path <- file.path(partitioned_path, paste0("state=", state_name))
      partitioned_data <- open_dataset(state_partition_path, format = "parquet")
      partitioned_data %>% filter(state == state_name)
      as.numeric(Sys.time() - start, units = "secs")
    }),
    time_difference = time_non_partitioned - time_partitioned
  )

## plot
plot <- ggplot(results, aes(x = num_observations)) +
  geom_line(aes(y = time_non_partitioned, color = "Non-Partitioned Time"), linewidth = 1) +
  geom_line(aes(y = time_partitioned, color = "Partitioned Time"), linewidth = 1) +
  geom_line(aes(y = time_difference, color = "Time Difference"), linewidth = 1) +
  labs(
    title = "Time Comparison: Partitioned vs Non-Partitioned Data",
    x = "Number of Observations (Filtered Data)",
    y = "Time (Seconds)",
    color = "Legend"
  ) +
  theme_minimal()

png("time_comparison_plot.png", width = 800, height = 600)
print(plot)
dev.off()

print(plot)





