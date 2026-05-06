# nolint start
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

# ── UHSTable ──────────────────────────────────────────────────────────────────
if (!is.null(UHSTable) && !exists("Tn_PGA")) {
  TR_data    <- sort(as.numeric(unique(UHSTable$TR)))
  Tn_gmdp    <- sort(unique(UHSTable$Tn))
  p_gmdp     <- unique(UHSTable[p != "std"]$p)
  Tn_PGA     <- min(UHSTable$Tn)
  Vref_data  <- sort(as.numeric(unique(UHSTable[grepl("\\.site$", ID)]$Vref)))
  Vs30_gmdp  <- sort(setdiff(as.numeric(unique(UHSTable$Vs30)), Vref_data))

  AUX <- c("1500"="A/B","1250"="B","800"="B","760"="B/C","560"="C","360"="C/D","270"="D","180"="D/E")
  Site_gmdp  <- AUX[as.character(Vs30_gmdp)]
  Site_gmdp[is.na(Site_gmdp)] <- paste0("Vs30=", Vs30_gmdp[is.na(Site_gmdp)])
  Site_LABEL <- paste0(Site_gmdp, " (", Vs30_gmdp, ")")
  rm(AUX)

  if (!exists("TR_gmdp")) {
    TR_gmdp <- TR_data
  } else {
    TR_gmdp <- sort(unique(as.numeric(TR_gmdp)))
    OK <- TR_gmdp %in% TR_data
    if (any(!OK)) stop(sprintf("TR_gmdp not in UHSTable$TR: %s", paste(TR_gmdp[!OK], collapse = ", ")))
    rm(OK)
  }

  if (!exists("Vref_gmdp")) {
    Vref_gmdp <- Vref_data
  } else {
    Vref_gmdp <- sort(unique(as.numeric(Vref_gmdp)))
    OK <- sapply(Vref_gmdp, function(v) any(abs(Vref_data - v) < 1e-10))
    if (any(!OK)) stop(sprintf("Vref_gmdp not in UHSTable$Vref: %s", paste(Vref_gmdp[!OK], collapse = ", ")))
    rm(OK)
  }

  TR_LABEL <- prettyNum(TR_gmdp, big.mark = ",", scientific = FALSE)
}

# ── DnTable ───────────────────────────────────────────────────────────────────
if (!is.null(DnTable) && !exists("IDg_gmdp")) {
  IDg_gmdp <- unique(DnTable$IDg)
  IDm_gmdp <- unique(DnTable$IDm)
  IDn_gmdp <- setdiff(unique(DnTable$IDn), "ensemble")
  IDg_gmdp <- IDg_gmdp[order(as.numeric(sub("^S", "", IDg_gmdp)))]
  if (!exists("Dn_units")) Dn_units <- "mm"
}

# ── kmaxTable ─────────────────────────────────────────────────────────────────
if (!is.null(kmaxTable) && !exists("Da_data")) {
  Da_data <- sort(as.numeric(unique(kmaxTable$Da)))
  if (!exists("Da_gmdp")) {
    Da_gmdp <- Da_data
  } else {
    Da_gmdp <- sort(unique(as.numeric(Da_gmdp)))
    OK <- sapply(Da_gmdp, function(v) any(abs(Da_data - v) < 1e-10))
    if (any(!OK)) stop(sprintf(
      "Da_gmdp not in kmaxTable$Da: %s. Update oq/data/data.R",
      paste(Da_gmdp[!OK], collapse = ", ")
    ))
    rm(OK)
  }
}
# nolint end
