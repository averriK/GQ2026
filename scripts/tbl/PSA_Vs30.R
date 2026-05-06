ITo <- AEPTable$ITo |> unique()
DT <- UHSTable[Tn %in% Tn_TARGET & p %in% p_TARGET & ID %in% ID_TARGET & Vs30 %in% Vs30_TARGET & TR %in% TR_TARGET][, .(TR, Vs30, PSA=SaF, Tn, p, ID)]
DT <- DT[order(as.numeric(Vs30))]
if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) {
    DT[, PSA := round(PSA * 988, 0)]
}
if (PSA_Units %in% c("g")) {
    DT[, PSA := round(PSA, 3)]
}
AUX <- dcast(
    DT[, .(Tn,TR,  PSA, Vs30,ID,p)],
    Tn +  TR +ID +p~ Vs30,
    value.var = "PSA"
)
setcolorder(AUX, c("Tn", "TR",sort(as.numeric(unique(DT$Vs30))),"ID","p"))
setnames(AUX, old = c("Tn"), new = c("Tn[s]"))
setnames(AUX, old = c("TR"), new = c("TR[yr]"))
TBL <- AUX |> buildTable(
    library = "flextable",
    align.body = "center",
    font.size.body = FONT.SIZE.BODY,
    font.size.header = FONT.SIZE.HEADER
)
TBL <- flextable::set_table_properties(TBL, layout = "autofit")
rm(DT, AUX, ITo)
