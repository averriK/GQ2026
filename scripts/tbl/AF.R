# Model average
DT <- UHSTable[Tn == 0 & p == p_TARGET &  ID %in% AF_MODEL_TARGET & Vs30 %in% Vs30_TARGET & TR %in% TR_TARGET,.(TR,Vs30,AF,Tn,p)]
# AF are available only in ID=="gmdp" models
DT[, `:=`(AF = round(AF, 2), POE = round(100 * (1 - exp(-50 / TR)), 1))]
AUX <- dcast(
  DT[, .(TR, Vs30, AF, POE)], 
  TR + POE  ~ Vs30, 
  value.var = "AF", 
  fun.aggregate = mean
)
setnames(AUX, old = "POE", new = "poe[%]")

COLS <- grep(colnames(AUX), pattern = "[0123456789]", value = TRUE)
setnames(AUX, old = COLS, new = paste0(COLS, " m/s"))

TBL <- AUX |> buildTable(
  library         = "flextable", 
  align.body      = "center",
  font.size.body  = FONT.SIZE.BODY, 
  font.size.header= FONT.SIZE.HEADER
)
TBL <- flextable::set_table_properties(TBL,layout = "autofit")
rm(DT, AUX, COLS)
