library(ggplot2)
library(tidyverse)
library(maps)
library(mapproj)
library(RColorBrewer)
library(ggridges)
library(countrycode)
library(gridExtra)
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Exploratory Plot 1
# Safety Values
p1 = ggplot(qol, aes(x = Safety.Value)) +
  geom_histogram(binwidth = 2, fill = "lightblue", color = "black", alpha = 0.7) +
  theme_minimal() +
  labs(
    title = "Distribution of Safety Values",
    x = "Safety Value",
    y = "Count"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title = element_text(size = 12, face = "bold"),
    axis.text = element_text(size = 10)
  ) 

# Cost of Living Categories
p2 = ggplot(qol |> filter(!is.na(Cost.of.Living.Category)), aes(x = Cost.of.Living.Category, fill = Cost.of.Living.Category)) +
  geom_bar() +
  scale_fill_brewer(palette = "Set3") +
  theme_minimal() +
  labs(
    title = "Count of Countries by Cost of Living Category",
    x = "Cost of Living Category",
    y = "Count"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title = element_text(size = 12, face = "bold"),
    axis.text = element_text(size = 10)
  ) +
  theme(legend.position = 'none')

#Arrange next to each other 
grid.arrange(p1, p2, ncol = 2)

# Q1
#Is there a correlation between Safety Value and Cost of Living, where less safe countries tend to have a lower cost of living?
qol$Cost.of.Living.Category = factor(x = qol$Cost.of.Living.Category, levels = c("Very Low", "Low", "Moderate", "High", "Very High"))
qol_clean = qol |> filter(!is.na(Safety.Value) & !is.na(Cost.of.Living.Category))

ggplot(data = qol_clean, aes(y = Cost.of.Living.Category, x = Safety.Value, fill = Cost.of.Living.Category)) +
  geom_density_ridges(alpha = 0.7, scale = 1.2) +
  scale_fill_brewer(palette = 'RdYlBu') +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title = element_text(size = 12, face = "bold"),
    axis.text = element_text(size = 10)
  ) +
  labs(
    x = "Safety Value",
    y = "Cost of Living Category",
    title = "Cost of Living vs Safety Value"
  )
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Exploratory Plot 2
# World Plot
qol$region <- countrycode(qol$country, origin = "country.name", destination = "iso3c")
qol$region <- as.factor(qol$region)

# Set the Pollution.Category factor levels
qol$Pollution.Category <- factor(qol$Pollution.Category, levels = c("Very Low", "Low", "Moderate", "High", "Very High"))

# Load world map data and convert country names to ISO3 codes
world_map <- map_data("world")
world_map$region <- countrycode(world_map$region, origin = "country.name", destination = "iso3c")

# Merge qol dataset with the world map based on ISO3 code
world_pollution <- left_join(world_map, qol, by = "region")

# Mutate Pollution.Value and Pollution.Category for Greenland
world_pollution <- world_pollution %>%
  mutate(
    Pollution.Value = if_else(region == "GRL", NA_real_, Pollution.Value),  # Set Pollution.Value to NA for Greenland
    Pollution.Category = if_else(region == "GRL", NA_character_, Pollution.Category)  # Set Pollution.Category to NA for Greenland
  )

# Plot the world map with Pollution Category
ggplot(world_pollution, aes(long, lat, group = group, fill = Pollution.Category)) +
  geom_polygon(color = "white", linewidth = 0.2) +  # Adds white borders between countries
  scale_fill_manual(values = c("Very Low" = "lightblue", "Low" = "yellow2", "Moderate" = "orange", 
                               "High" = "red", "Very High" = "darkred"), na.value = "grey50") +
  labs(
    title = "Global Pollution by Country", 
    subtitle = "Based on a composite index of air and water quality, waste management, noise and light pollution, with the highest weight on air pollution.", 
    fill = "Pollution Category",
    caption = 
  ) +
  theme_minimal(base_size = 14) +  # Use minimal theme with a larger base font size
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),  # Bold and centered title
    plot.subtitle = element_text(size = 12, hjust = 0.5),  # Centered subtitle
    legend.position = "bottom",  # Position the legend at the bottom
    legend.title = element_text(size = 12, face = "bold"),  # Bold legend title
    legend.text = element_text(size = 10),  # Smaller legend text size
    axis.title = element_blank(),  # Remove axis titles for a cleaner look
    axis.text = element_blank()  # Remove axis text
  )

# Q2    
#Which continents have the highest pollution values, and how do commute times contribute to these pollution levels? Do cars show to play a significant role in overall pollution?
qol$Traffic.Commute.Time.Category = factor(x = qol$Traffic.Commute.Time.Category, levels = c("Very Low", "Low", "Moderate", "High", "Very High"))
ggplot(data = qol |> filter(!is.na(Traffic.Commute.Time.Category), Pollution.Value > 0), aes(x = Traffic.Commute.Time.Category, y = Pollution.Value)) +
  geom_boxplot(fill = "lightblue", color = "darkblue", outlier.shape = 8, outlier.colour = "red", outlier.size = 2) +
  labs(
    title = "Pollution Value by Traffic Commute Time Category",
    x = "Traffic Commute Time Category",
    y = "Pollution Value"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
    axis.title = element_text(size = 14, face = "bold")
  )
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Exploratory Plot 3

ggplot(qol, aes(x = Health.Care.Category)) +
  geom_bar(data = subset(qol, !is.na(Health.Care.Category)), fill = "lightgreen") +
  theme_minimal() +
  labs(
    title = "Distribution of Health Care Access (Category)",
    x = "Health Care Access Category",
    y = "Count"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
    axis.title = element_text(size = 14, face = "bold"),
    axis.text = element_text(size = 14)
  )

# Q3
# Do countries with higher purchasing power tend to have better access to quality health care?
# Sort by Purchasing Power Value and identify the top 3 outliers (highest Purchasing Power Value)
top_3_outliers = qol |> 
  filter(Health.Care.Value > 0 & Purchasing.Power.Value > 0) |> 
  arrange(desc(Purchasing.Power.Value)) |> 
  head(3)

# Scatter plot with top 3 outliers labeled on the y-axis
ggplot(qol |> filter(Health.Care.Value > 0 & Purchasing.Power.Value > 0), aes(x = Health.Care.Value, y = Purchasing.Power.Value)) +
  geom_point(color = "blue", alpha = 0.6, size = 3) +  
  geom_smooth(method = "lm", color = "red", size = 3, se = FALSE) + 
  geom_point(data = top_3_outliers, aes(x = Health.Care.Value, y = Purchasing.Power.Value), color = "red", size = 4) +  # Top 3 outliers in red
  geom_text(data = top_3_outliers, aes(label = country), vjust = -1, color = "black", size = 3) +  # Label top 3 outliers
  labs(
    title = "Purchasing Power vs Health Care Quality",
    x = "Health Care Quality Value",
    y = "Purchasing Power Value"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
    axis.title = element_text(size = 14, face = "bold"),
    axis.text = element_text(size = 14, face = "bold")
  )

