## CNOSSOS feasibility study using Banskstown, Australia
## christygeromboux

# Load libraries

library(rmarkdown)
library(bookdown)
library(yaml)
library(knitr)
#library(pander)
library(tinytex)
library(kableExtra)


# Create the report
rmarkdown::render("report.Rmd", "pdf_document2")
