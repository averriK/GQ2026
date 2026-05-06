# nolint start
UHS <- UHSTable[ID %in% ID_TARGET & Vs30 %in% Vs30_TARGET & TR %in% TR_TARGET & p %in% p_TARGET]

DATA <- UHS[, .(
  ID    = paste(ID, TR, Vs30, p),
  X     = Tn,
  Y     = round(SaF, 4),
  style = fifelse(p == "mean" | ID %in% c("max", "min"), "Solid",       "ShortDashDot"),
  size  = fifelse(p == "mean" | ID %in% c("max", "min"), MID_LINE_SIZE, THIN_LINE_SIZE)
)][order(X)][order(ID)] |> unique()

PLOT <- buildPlot(
  line.type     = "spline",
  plot.height   = 750,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.log     = Tn_LOG,
  yAxis.log     = Sa_LOG,
  xAxis.legend  = "Tn [s]",
  yAxis.legend  = "Sa [g]",
  group.legend  = "ID",
  plot.theme    = NGR::hc_theme_538_gridlines(),
  fill.legend   = "Total Variability",
  fill.minmax   = TRUE,
  fill.max.size = THICK_LINE_SIZE,
  fill.min.size = THICK_LINE_SIZE,
  data.lines    = DATA
)
rm(UHS, DATA)
# nolint end
