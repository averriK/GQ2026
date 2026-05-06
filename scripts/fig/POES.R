# nolint start
#

AEPS <- AEPSTable[ID %in% ID_TARGET & Tn %in% Tn_TARGET & Vs30 %in% Vs30_TARGET & p == "mean"]
AEPS <- AEPS[AEP >= 1e-6]

# Drop sources whose POE at min(Sa) is below POE_MIN
keepProviders <- AEPS[, .(POE_at_minSa = POE[which.min(Sa)]), by = providerID][POE_at_minSa >= POE_MIN]$providerID

DATA <- AEPS[providerID %in% keepProviders, .(
    ID = providerID,
    Y = POE,
    X = Sa,
    style = "Solid",
    size = THIN_LINE_SIZE
)][order(X)][order(ID)] |> unique()

# Total curve: POE from summed AEP at each Sa (all sources)
TOTAL <- AEPS[, .(AEP = sum(AEP)), by = Sa][order(Sa)]
TOTAL <- TOTAL[AEP >= 1e-6]
TOTAL <- TOTAL[, .(
    ID = "Total",
    Y = 1 - exp(-AEP * ITo),
    X = Sa,
    style = "Dash",
    size = THICK_LINE_SIZE
)]

DATA <- data.table::rbindlist(list(TOTAL, DATA), use.names = TRUE)

PLOT <- buildPlot(
  xAxis.label = TRUE,
  yAxis.label = TRUE,
  plot.height = 750,
  legend.layout = "horizontal",
  legend.show = TRUE,
  line.size = MID_LINE_SIZE,
  xAxis.log = TRUE,
  yAxis.log = FALSE,
  yAxis.legend = "POE",
  xAxis.legend = "Sa(Tn) [g]",
  group.legend = "ID",
  plot.theme = NGR::hc_theme_538_gridlines(),
  data.lines = DATA
)
# nolint end
rm(AEPS, DATA, TOTAL, keepProviders)
