# Quality of Life Dataset Analysis

This project investigates how economic and environmental factors shape quality of life across countries.  
It explores correlations between safety, cost of living, pollution, commute time, and healthcare quality using global data from Numbeo.

The project includes a full R-based analysis, visualizations, and an online slideshow presentation.

## Key Questions Explored

1. Do countries with lower safety tend to have lower costs of living?
2. How do commute times affect pollution across continents?
3. Does higher purchasing power lead to better access to quality healthcare?

## Project Structure
`
analysis/       # Quarto source file for written report
scripts/        # R script for generating plots
data/           # Dataset used in the analysis
report/         # Final compiled PDF report
docs/           # HTML slideshow and assets (hosted with GitHub Pages)
`

## View the Presentation Slides

View the live slideshow here (hosted via GitHub Pages):  
https://msiddiqui44.github.io/qol-analysis/slides.html

## Report

The full PDF report includes data insights, supporting graphs, and conclusions:
- Correlation between cost of living and safety
- Pollution trends by continent and commute time
- Impact of economic strength on healthcare quality

Location: `report/quality-of-life-report.pdf`

## Run Locally

You’ll need:
- R
- Quarto
- R packages: tidyverse, ggplot2, dplyr

To render the report:

```bash
quarto render analysis/report.qmd
```

To view the slides locally, open:

```
docs/slides.html
```

## License

This project is licensed under the MIT License.

## Author

Mustafa Siddiqui  
For questions or feedback, feel free to reach out via GitHub.
