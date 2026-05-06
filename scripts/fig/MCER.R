source(file.path(root,"scripts","setup","runASCE.R"))
# nolint start


DT1 <- ASCETable[ID=="mcer"&TR %in% TR_TARGET & Vs30 %in% Vs30_TARGET , .(
    ID = paste0("AEP=1/", TR, " Vs30= ", Vs30, " [", ID, "]"),
    Y = SaF,
    X = Tn,
    style = "Solid",
    type = "line"
)
][order(X)][order(ID)] |> unique()

DT2 <- ASCETable[ID=="design"&TR %in% TR_TARGET & Vs30 %in% Vs30_TARGET , .(
    ID = paste0("AEP=1/", TR, " Vs30= ", Vs30, " [", ID, "]"),
    Y = SaF,
    X = Tn,
    style = "LongDashDot",
    type = "line"
)
][order(X)][order(ID)] |> unique()


DATA <- list(DT1,DT2) |> rbindlist(use.names = TRUE,fill = TRUE)
DATA <- DATA[order(X)][order(ID)] |> unique()
rm(DT1, DT2)
PLOT <- buildPlot(
    yAxis.label = TRUE,
    line.type = "line",
    plot.height = 1000,
    legend.layout = "horizontal",
    legend.show = TRUE,
    xAxis.log = Tn_LOG,
    yAxis.log = Sa_LOG,
    line.size = MID_LINE_SIZE,
    xAxis.legend = "Tn [s]",
    yAxis.legend = "Sa [g]",
    group.legend = "ID",
    plot.theme = HC.THEME,
    data.lines = DATA
)
rm(DATA)
