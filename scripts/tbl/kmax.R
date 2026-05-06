## ── filtra y deja solo columnas necesarias (formato largo actual) ─────────
# Default: show only envelopes to keep tables compact

DT <- kmaxTable[
    TR %in% TR_TARGET & Da %in% Da_TARGET &
      IDg %in% IDg_TARGET & ID %in% ID_TARGET,
    .(kmax = mean(kmax, na.rm = TRUE)), by = .(TR, IDg, ID, Da)
] |> unique()

if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) {
    DT[, kmax := round(kmax * 988, 0)]
}

if (PSA_Units %in% c("g")) {
    DT[, kmax := round(kmax, 3)]
}

AUX <- data.table::dcast(
    DT,
    TR + IDg + ID ~ Da,
    value.var = "kmax",
    fun.aggregate = mean
)
valcols <- setdiff(names(AUX), c("TR","IDg","ID"))

data.table::setnames(AUX, "TR", "TR[yr]")
NEW <- paste0(valcols, " cm")
data.table::setnames(AUX, old = valcols, new = NEW)


TBL <- AUX |>
    buildTable(
        library        = "flextable",
        align.body     = "center",
        font.size.body = FONT.SIZE.BODY,
        font.size.header = FONT.SIZE.HEADER
    ) |>
    flextable::set_table_properties(layout = "autofit")

rm(DT, AUX, COLS)
