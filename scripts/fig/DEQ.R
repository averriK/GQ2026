# nolint start
DEQ <- DEQTable[ID %in% ID_TARGET & Vs30 %in% Vs30_TARGET & Standard %in% Standard_TARGET & Stage %in% Stage_TARGET]


DATA <- DEQ[, .(
    ID = paste0("[", Standard, "]", " Class:", Class, " Stage:", Stage, " Vs30=", Vs30),
    Y = SaF,
    X = Tn,
    style = "ShortDashDot"
)][order(X)][order(ID)] |> unique()


# DATA[X == 0, X := 0.001]
DATA <- DATA[order(X)][order(ID)] |> unique()
PLOT <- buildPlot(
    yAxis.label = TRUE,
    line.type = "spline",
    plot.height = 750,
    legend.layout = "horizontal",
    legend.show = TRUE,
    xAxis.log = Tn_LOG,
    yAxis.log = Sa_LOG,
    line.size = MID_LINE_SIZE,
    xAxis.legend = "Tn [s]",
    yAxis.legend = "Sa [g]",
    group.legend = "ID",
    plot.theme = NGR::hc_theme_538_gridlines(),
  fill.legend    = "Total Variability",
    fill.minmax    = TRUE,
    fill.max.size  = THICK_LINE_SIZE, # Envelope line width
    fill.min.size  = THICK_LINE_SIZE, # Envelope line width
    data.lines = DATA
)
rm(DEQ, DATA)
