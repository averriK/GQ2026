# global.R — load OQ tables from oq/data/
# Sourced by setup.R after data.R is loaded.

.loadOQ <- function(name) {
  FILE <- file.path(root, "oq", "data", paste0(name, ".Rds"))
  if (!file.exists(FILE)) return(NULL)
  DT <- readRDS(FILE)
  if ("p" %in% names(DT)) DT[p == "0.1", p := "0.10"]
  DT
}

if (!exists("UHSTable"))   UHSTable   <- .loadOQ("UHSTable")
if (!exists("AEPTable"))   AEPTable   <- .loadOQ("AEPTable")
if (!exists("AEPSTable"))  AEPSTable  <- .loadOQ("AEPSTable")
if (!exists("DnTable"))    DnTable    <- .loadOQ("DnTable")
if (!exists("kmaxTable"))  kmaxTable  <- .loadOQ("kmaxTable")
if (!exists("ShearTable")) ShearTable <- .loadOQ("ShearTable")
if (!exists("RMwTable"))   RMwTable   <- .loadOQ("RMwTable")
if (!exists("DEQTable"))   DEQTable   <- .loadOQ("DEQTable")
rm(.loadOQ)

if (!is.null(UHSTable) && !exists("TR_data")) {
  TR_data   <- sort(as.numeric(unique(UHSTable$TR)))
  Tn_gmdp   <- sort(unique(UHSTable$Tn))
  Tn_PGA    <- min(UHSTable$Tn)
  Vref_data <- sort(as.numeric(unique(UHSTable[grepl("\\.site$", ID)]$Vref)))
  Vs30_gmdp <- sort(setdiff(as.numeric(unique(UHSTable$Vs30)), Vref_data))
}

if (!is.null(kmaxTable) && !exists("Da_data")) {
  Da_data <- sort(as.numeric(unique(kmaxTable$Da)))
}
