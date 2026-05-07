# setup.R — sourced at the top of every Quarto chunk in this project.

stopifnot(exists("root"))

for (pkg in c("data.table", "yaml", "knitr", "newmark")) {
  if (!requireNamespace(pkg, quietly = TRUE)) install.packages(pkg)
}

library(data.table)
library(knitr)
library(newmark)

FILE <- file.path(root, "oq", "data", "data.R")
if (file.exists(FILE)) source(FILE)

source(file.path(root, "scripts", "setup", "global.R"))
