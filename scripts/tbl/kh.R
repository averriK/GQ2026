## ── filtra y deja solo columnas necesarias (formato largo actual) ─────────
# Default: show only envelopes to keep tables compact

DT <- kmaxTable[
    TR %in% TR_TARGET & Da %in% Da_TARGET &
      IDg %in% IDg_TARGET & ID %in% ID_TARGET,
    .(Kh = if (all(is.na(Kh))) NA_real_ else mean(Kh, na.rm = TRUE)),
    by = .(TR, IDg, ID, Da)
] |> unique()

DT[, Kh := round(Kh, 0)]

AUX <- data.table::dcast(
    DT,
    TR + IDg + ID ~ Da,
    value.var = "Kh",
    fun.aggregate = mean
)
COLS <- setdiff(names(AUX), c("TR","IDg","ID"))

data.table::setnames(AUX, "TR", "TR[yr]")
data.table::setnames(AUX, old = COLS, new = paste0(COLS, " cm"))

TBL <- AUX |>
    buildTable(
        library        = "flextable",
        align.body     = "center",
        font.size.body = FONT.SIZE.BODY,
        font.size.header = FONT.SIZE.HEADER
    ) |>
    flextable::set_table_properties(layout = "autofit")
rm(DT, AUX, COLS)
