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

DT   <- DT[pct >= 1e-3]
DATA <- DT[, .(Y = round(Mw, 2), X = round(R), Z = pct)]

PLOT <- NGR::buildPlot.Hist3D(
  data           = DATA,
  nbins          = 16,
  bin.width      = 0.4,
  color.palette  = hcl.pals()[112],
  yAxis.label    = "Magnitude Mw",
  xAxis.label    = "Distance R [km]",
  aspect.ratio   = list(x = 1, y = 1, z = 1.5),
  xAxis.legend   = TRUE,
  yAxis.legend   = TRUE,
  zAxis.legend   = FALSE,
  xAxis.tickangle = 45,
  yAxis.tickangle = -45,
  axis.fontsize  = "14px",
  legend.font    = "Arial",
  legend.valign  = "top",
  plot.title     = sprintf("Hazard Deaggregation | Tn=%.2f s | TR=%s yr",
    Tn_TARGET, prettyNum(round(TR_TARGET, 0), big.mark = ",")),
  title.fontsize = "24px",
  title.font     = "Arial"
)
# nolint end
rm(DT, DATA)
