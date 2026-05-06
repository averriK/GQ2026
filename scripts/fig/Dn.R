# nolint start
DN <- DnTable[
  IDg %in% IDg_TARGET & IDn %in% IDn_TARGET &
  ID  %in% ID_TARGET  & TR  == TR_TARGET & p == "mean" &
  (is.na(w) | w > 0),
  .(Dn = mean(Dn, na.rm = TRUE)),
  by = .(IDn, IDg, ky, TR)
][Dn >= min(Da_TARGET) & Dn <= max(Da_TARGET)]

DT0 <- DN[IDn == "ensemble", .(
  ID    = paste(IDn, IDg),
  Y     = round(Dn, 2),
  X     = round(ky, 3),
  style = "Solid",
  size  = THICK_LINE_SIZE
)][order(X)][order(ID)] |> unique()

DT1 <- DN[IDn != "ensemble", .(
  ID    = paste(IDn, IDg),
  Y     = round(Dn, 2),
  X     = round(ky, 3),
  style = "ShortDashDot",
  size  = MID_LINE_SIZE
)][order(X)][order(ID)] |> unique()

DATA <- rbindlist(list(DT0, DT1), use.names = TRUE)

PLOT <- buildPlot(
  line.type     = "spline",
  plot.height   = 750,
  legend.layout = "horizontal",
  legend.show   = TRUE,
  xAxis.log     = TRUE,
  yAxis.log     = TRUE,
  xAxis.legend  = "ky [g]",
  yAxis.legend  = "Dn [cm]",
  group.legend  = "ID",
  plot.theme    = NGR::hc_theme_538_gridlines(),
  data.lines    = DATA
)
rm(DN, DT0, DT1, DATA)
# nolint end
