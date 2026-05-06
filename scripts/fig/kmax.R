# nolint start
# kmax plot (kmaxTable) – kmax vs Da  (ensemble mean)
# Expects from caller/setup:
# - kmaxTable (data.table)
# - TR_TARGET (scalar)
# - IDg_TARGET (scalar)
# - ID_TARGET (vector, e.g. c("max","min") or c("GMM","SHM"))
# - Da_TARGET (vector, Da in cm)

KMT <- kmaxTable[
  ID  %in% ID_TARGET  &
  IDg %in% IDg_TARGET &
  TR  %in% TR_TARGET  &
  Da  %in% Da_TARGET  &
  p   %in% p_TARGET,
  .(kmax = mean(kmax, na.rm = TRUE)),
  by = .(ID, TR, IDg, Da, p)
] |> unique()

DT0 <- KMT[p == "mean", .(
  ID    = paste(IDg, p),
  Y     = round(kmax, 4),
  X     = round(Da, 4),
  style = "Solid",
  size  = THICK_LINE_SIZE
)][order(X)][order(ID)] |> unique()

DT1 <- KMT[p != "mean", .(
  ID    = paste(IDg, p),
  Y     = round(kmax, 4),
  X     = round(Da, 4),
  style = "ShortDashDot",
  size  = MID_LINE_SIZE
)][order(X)][order(ID)] |> unique()

DATA <- rbindlist(list(DT0, DT1), use.names = TRUE)

PLOT <- buildPlot(
  yAxis.label = TRUE,
  line.type = "spline",
  plot.height = 750,
  legend.layout = "horizontal",
  legend.show = TRUE,
  xAxis.log = TRUE,
  yAxis.log = TRUE,
  line.size = MID_LINE_SIZE,
  xAxis.legend = "Da [cm]",
  yAxis.legend = "kmax [g]",
  group.legend = "ID",
  plot.theme = NGR::hc_theme_538_gridlines(),
  fill.legend   = "Total Variability",
  fill.minmax   = TRUE,
  fill.max.size = THIN_LINE_SIZE,
  fill.min.size = THIN_LINE_SIZE,
  data.lines = DATA
)
# nolint end
rm(KMT, DT0, DT1, DATA)
