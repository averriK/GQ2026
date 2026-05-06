#root <- here::here()

DT <- DEQTable[ID%in%ID_TARGET & Standard %in% Standard_TARGET & Stage %in% Stage_TARGET & Tn==Tn_TARGET & Vs30 %in% Vs30_TARGET & p==p_TARGET,.(Standard,Class,TR,Stage,Vs30,PGA=SaF,ID)] |> unique()

if (PSA_Units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) {
    DT[, PGA := round(PGA * 988, 0)]
}

if (PSA_Units %in% c("g")) {
    DT[, PGA := round(PGA, 3)]
}
DT <- DT[order(as.numeric(Vs30))]
AUX <- dcast(
    DT[, .(Standard,Class,Stage,Vs30,PGA,TR)],
    Standard+Class+Stage+TR ~ Vs30 ,
    value.var = "PGA",
    fun.aggregate = mean
)
setcolorder(AUX, c("Standard", "Class","Stage", sort(as.numeric(unique(DT$Vs30)))))
AUX <- AUX[order(Standard, chmatch(Class, c("Low", "Significant", "High", "Very High", "Extreme")), Stage)]


TBL <- AUX |> buildTable(
    library = "flextable",
    align.body = "center",
    font.size.body = FONT.SIZE.BODY,
    font.size.header = FONT.SIZE.HEADER
)
TBL <- flextable::set_table_properties(TBL, layout = "autofit")
rm(DT, AUX)
