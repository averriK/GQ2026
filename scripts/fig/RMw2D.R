# nolint start
DT <- RMwTable[Tn == Tn_TARGET & TR == TR_TARGET]
if (!nrow(DT)) {
  AUX       <- sort(unique(RMwTable$TR))
  TR_TARGET <- AUX[which.min(abs(AUX - TR_TARGET))]
  DT        <- RMwTable[Tn == Tn_TARGET & TR == TR_TARGET]
  rm(AUX)
}
DT[, pct := p / sum(p) * 100]

Widest <- RMwTable[Tn == Tn_TARGET & TR == sort(unique(RMwTable[Tn == Tn_TARGET]$TR))[1] & p > 0]
RStep  <- unique(diff(sort(unique(RMwTable$R))))[1]
MwStep <- unique(diff(sort(unique(RMwTable$Mw))))[1]
Rmax   <- min(max(Widest$R), RStep * 16L)
NICE   <- c(50, 100, 150, 200, 250, 300, 400, 500, 750, 1000)
AUX    <- NICE[which(NICE >= Rmax)[1]]
if (!is.na(AUX)) Rmax <- AUX
MwSpan <- max(Widest$Mw) - min(Widest$Mw)
MwPad  <- max(0, (8L * MwStep - MwSpan) / 2)
MwMin  <- floor((min(Widest$Mw) - MwPad) / MwStep) * MwStep
MwMax  <- ceiling((max(Widest$Mw) + MwPad) / MwStep) * MwStep
DT     <- DT[R <= Rmax & Mw >= MwMin & Mw <= MwMax]
rm(Widest, RStep, MwStep, Rmax, NICE, AUX, MwSpan, MwPad, MwMin, MwMax)

DT <- DT[, .(X = R, Y = Mw, Z = pct)]

PLOT <- NGR::buildHeatmap(
  .data          = DT,
  xAxis.legend   = "R [km]",
  yAxis.legend   = "Mw",
  plot.title     = "Hazard Deaggregation",
  series.name    = "Contribution [%]",
  tooltip.format = "R = <b>{point.x}</b> km | Mw = <b>{point.y}</b><br>Contribution: <b>{point.value}%</b>",
  plot.theme     = NGR::hc_theme_538_gridlines()
)
# nolint end
rm(DT, DATA)
