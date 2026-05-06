# nolint start
# setup.R — sourced by all Quarto manifests. Safe to source multiple times.
#
# Responsibilities:
#   1) packages / libraries
#   2) helpers (utils.R)
#   3) optional project user values (oq/data/data.R)
#   4) params.yml
#   5) plotting / formatting defaults
#   6) OQ table loading (global.R)

stopifnot(exists("root"))

# ── 1) Packages ────────────────────────────────────────────────────────
for (pkg in c("data.table", "yaml", "knitr", "highcharter", "htmlwidgets",
              "webshot2", "ggplot2", "flextable", "devtools")) {
  if (!requireNamespace(pkg, quietly = TRUE)) install.packages(pkg)
}
if (!requireNamespace("dsra", quietly = TRUE)) devtools::install_github("averriK/dsra")
if (!requireNamespace("NGR", quietly = TRUE))  devtools::install_github("averriK/NGR")

library(dsra)
library(NGR)
library(data.table)
library(knitr)
library(highcharter)
library(htmlwidgets)
library(webshot2)

# ── 2) Helpers ─────────────────────────────────────────────────────────
source(file.path(root, "scripts", "setup", "utils.R"))
ID_max <- "max"

# ── 3) Optional project user values ────────────────────────────────────
FILE <- file.path(root, "oq", "data", "data.R")
if (file.exists(FILE)) source(FILE)

# ── 4) params.yml ──────────────────────────────────────────────────────
FILE <- file.path(root, "params.yml")
if (!file.exists(FILE)) FILE <- file.path(root, "yml", "params.yml")
params <- readFile(FILE, "Missing params.yml", yaml::read_yaml)$params

if (is.list(params$consultant)) params$SRK_short <- "SRK"

# ── 5) Plotting / formatting defaults ──────────────────────────────────
if (!exists("p_TARGET",      inherits = FALSE)) p_TARGET      <- NULL
if (!exists("S_TARGET",      inherits = FALSE)) S_TARGET      <- NULL
if (!exists("NMAX",          inherits = FALSE)) NMAX          <- 2500
if (!exists("PALETTE",       inherits = FALSE)) PALETTE       <- "Set1"
if (!exists("DELAY",         inherits = FALSE)) DELAY         <- 0.3
if (!exists("PAGE_WIDTH",    inherits = FALSE)) PAGE_WIDTH    <- 8.27
if (!exists("PAGE_HEIGHT",   inherits = FALSE)) PAGE_HEIGHT   <- 11.69
if (!exists("FACTOR_WIDTH",  inherits = FALSE)) FACTOR_WIDTH  <- 1
if (!exists("FACTOR_HEIGHT", inherits = FALSE)) FACTOR_HEIGHT <- 0.5
if (!exists("THIN_LINE_SIZE",  inherits = FALSE)) THIN_LINE_SIZE  <- 0.75
if (!exists("MID_LINE_SIZE",   inherits = FALSE)) MID_LINE_SIZE   <- 1.5
if (!exists("THICK_LINE_SIZE", inherits = FALSE)) THICK_LINE_SIZE <- 3.5
if (!exists("GG_THEME", inherits = FALSE)) GG_THEME <- ggplot2::theme_light()
if (!exists("HC.THEME", inherits = FALSE)) HC.THEME <- NGR::hc_theme_538_gridlines()

if (knitr::is_html_output()) {
  if (!exists("FONT.SIZE.BODY",   inherits = FALSE)) FONT.SIZE.BODY   <- 11
  if (!exists("FONT.SIZE.HEADER", inherits = FALSE)) FONT.SIZE.HEADER <- 12
} else {
  if (!exists("FONT.SIZE.BODY",   inherits = FALSE)) FONT.SIZE.BODY   <- 10
  if (!exists("FONT.SIZE.HEADER", inherits = FALSE)) FONT.SIZE.HEADER <- 10
}

# ── 6) OQ tables ───────────────────────────────────────────────────────
source(file.path(root, "scripts", "setup", "global.R"))

# nolint end
