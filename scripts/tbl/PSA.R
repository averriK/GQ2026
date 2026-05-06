# nolint start
DT <- UHSTable[
  Tn %in% Tn_TARGET & p %in% p_TARGET &
  ID %in% ID_TARGET & Vs30 %in% Vs30_TARGET & TR %in% TR_TARGET,
  .(TR, Vs30, PSA = SaF, Tn, p, ID)
][order(as.numeric(Vs30))]

if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) DT[, PSA := round(PSA * 988, 0)]
if (PSA_Units %in% c("g"))                                  DT[, PSA := round(PSA, 3)]

if (length(ID_TARGET) > 1) {
  DT <- DT[, .(PSA = max(PSA, na.rm = FALSE)), by = .(Tn, Vs30, TR, p)]
  AUX <- dcast(DT, Tn ~ TR, value.var = "PSA")
} else {
  AUX <- dcast(DT[, .(Tn, TR, PSA, Vs30, ID, p)], Tn + Vs30 + ID + p ~ TR, value.var = "PSA")
  setcolorder(AUX, c("Tn", "Vs30", sort(as.numeric(unique(DT$TR))), "ID", "p"))
  setnames(AUX, "Vs30", "Vs30[m/s]")
}

setnames(AUX, "Tn", "Tn[s]")

TBL <- AUX |> buildTable(
  library          = "flextable",
  align.body       = "center",
  font.size.body   = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |> flextable::set_table_properties(layout = "autofit")

rm(DT, AUX)
# nolint end
