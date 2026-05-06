# nolint start
DT <- RMwTable[Tn %in% Tn_TARGET & TR %in% TR_TARGET]

DT <- DT[
  ,
  {
    I <- which.max(p)
    .(Mw = round(Mw[I], 2), R = round(R[I], 0))
  },
  by = .(Tn, TR)
][order(TR, Tn)]

Tnvals <- sort(unique(DT$Tn))
TRvals <- sort(unique(DT$TR))
TRlabels <- prettyNum(round(TRvals, 0), big.mark = ",")

# Build wide table: TR | Mw.1 | R.1 | Mw.2 | R.2 | ...
AUX.Mw <- data.table::dcast(DT, TR ~ Tn, value.var = "Mw")
AUX.R  <- data.table::dcast(DT, TR ~ Tn, value.var = "R")

WIDE <- data.table::data.table(`TR[yr]` = TRlabels)
for (i in seq_along(Tnvals)) {
  tn <- as.character(Tnvals[i])
  WIDE[, (paste0("Mw.", i)) := AUX.Mw[[tn]]]
  WIDE[, (paste0("R.", i))  := AUX.R[[tn]]]
}

TBL <- flextable::flextable(WIDE)

# Display labels for sub-header row
lbls <- list(`TR[yr]` = "TR[yr]")
for (i in seq_along(Tnvals)) {
  lbls[[paste0("Mw.", i)]] <- "Mw"
  lbls[[paste0("R.", i)]]  <- "R[km]"
}
TBL <- do.call(flextable::set_header_labels, c(list(x = TBL), lbls))

# Top header: Tn labels spanning Mw+R pairs
topvals <- c("TR[yr]")
for (i in seq_along(Tnvals)) {
  topvals <- c(topvals, paste0("Tn=", Tnvals[i], " s"), paste0("Tn=", Tnvals[i], " s"))
}
TBL <- flextable::add_header_row(TBL, values = topvals, top = TRUE)
TBL <- flextable::merge_h(TBL, part = "header")
TBL <- flextable::merge_v(TBL, j = 1, part = "header")

TBL <- flextable::align(TBL, align = "center", part = "all")
TBL <- flextable::fontsize(TBL, size = FONT.SIZE.BODY, part = "body")
TBL <- flextable::fontsize(TBL, size = FONT.SIZE.HEADER, part = "header")
TBL <- flextable::set_table_properties(TBL, layout = "autofit")
# nolint end
rm(DT, AUX.Mw, AUX.R, WIDE, Tnvals, TRvals, TRlabels, lbls, topvals)
