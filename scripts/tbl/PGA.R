# nolint start
# Expects: ID_TARGET, Vs30_TARGET (scalar), TR_TARGET, PSA_Units
# Multiple ID_TARGET → max envelope across IDs (columns = p intervals)
# Single  ID_TARGET → rows = TR + ID (columns = p intervals)

P_COLS <- c("0.50", "mean", "0.84", "0.90", "0.95")
ITo    <- unique(AEPTable$ITo)[1]

DT <- UHSTable[
  p %in% P_COLS & ID %in% ID_TARGET &
  Vs30 %in% Vs30_TARGET & TR %in% TR_TARGET
][Tn == min(Tn), .(TR, PGA = SaF, p, ID)][order(as.numeric(TR))]

if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, PGA := round(PGA * 988, 0)]
if (PSA_Units %in% c("g"))                                  DT[, PGA := round(PGA, 3)]

if (length(ID_TARGET) > 1) {
  DT <- DT[, .(PGA = max(PGA, na.rm = FALSE)), by = .(TR, p)]
  AUX <- dcast(DT, TR ~ p, value.var = "PGA", fun.aggregate = mean)
} else {
  AUX <- dcast(DT, TR + ID ~ p, value.var = "PGA", fun.aggregate = mean)
}

P_PRESENT <- intersect(P_COLS, names(AUX))
AUX[, "poe[%]" := round(100 * (1 - exp(-ITo / as.numeric(TR))), 1)]
setcolorder(AUX, c("TR", "poe[%]", P_PRESENT))
setnames(AUX, "TR", "TR[yr]")

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")

if ("mean" %in% names(AUX)) {
  TBL <- flextable::bold(TBL, j = "mean", part = "body")
  TBL <- flextable::bold(TBL, j = "mean", part = "header")
}

rm(DT, AUX, P_COLS, P_PRESENT, ITo)
# nolint end
