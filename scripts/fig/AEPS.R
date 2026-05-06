# nolint start
#
AEPS <- AEPSTable[ID %in% ID_TARGET & Tn %in% Tn_TARGET & Vs30 %in% Vs30_TARGET & p == "mean"]
AEPS <- AEPS[AEP >= 1e-6]

DATA <- AEPS[, .(
    ID = providerID,
    Y = AEP,
    X = Sa,
    style = "Solid",
    size = THIN_LINE_SIZE
)][order(X)][order(ID)] |> unique()

# Total curve: sum of all sources at each Sa (full range)
TOTAL <- AEPS[, .(Y = sum(AEP)), by = Sa][order(Sa)]
TOTAL <- TOTAL[Y >= 1e-6]
TOTAL <- TOTAL[, .(
    ID = "Total",
    Y = Y,
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
  yAxis.log = AEP_LOG,
  xAxis.log = Sa_LOG,
  yAxis.legend  = "AEP [1/yr]",
  yAxis2.legend = "TR [yr]",
  yAxis2.transform = ~ 1 / Y,
  yAxis2.decimals = 0,
  xAxis.legend = "Sa(Tn) [g]",
  group.legend = "ID",
  plot.theme = NGR::hc_theme_538_gridlines(),
  data.lines = DATA
)
# nolint end
rm(AEPS, DATA, TOTAL)
