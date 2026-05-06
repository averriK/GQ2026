DT <- ShearTable[IDg %in% IDg_TARGET & level %in% p_TARGET, .(IDm, USCS,IDg, "Hs[m]" = Hs, "b[m]" = b, "s"=s,  lo, mo,"a1"=an, "Go[MPa]" = Go, "VSo[m/s]"= VSo,"Ts[s]" = Ts)] |> unique()


TBL <- DT |> buildTable(
    library = "flextable",
    align.body = "center",
    font.size.body = FONT.SIZE.BODY,
    font.size.header = FONT.SIZE.HEADER
)
TBL <- flextable::set_table_properties(TBL, layout = "autofit")
rm(DT)
