# nolint start
AEP <- AEPTable[ID %in% ID_TARGET & Tn %in% Tn_TARGET & Vs30 %in% Vs30_TARGET & p == "mean"]


DATA <- AEP[, .(
    ID = paste0("Tn=", Tn, " (", Vs30,"-",  ID, ")"),
    Y = POE,
    X = Sa,
    style = "Solid",
    size = MID_LINE_SIZE
)][order(X)][order(ID)] |> unique()


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

rm(AEP, DATA)
