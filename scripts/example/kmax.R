# nolint start
# kmax.R — produces SUMMARY list for the JF numerical example
# Expects from caller: TR_TARGET, IDg_TARGET, IDm_TARGET, ID_TARGET,
#                      VS30_TARGET, DA_TARGET, p_TARGET, PSA_Units

# ── helpers ────────────────────────────────────────────────────────────────────
.fmt  <- function(x, d = 3) formatC(round(x, d), format = "f", digits = d)
.fmti <- function(x) formatC(as.integer(x), format = "d", big.mark = ",")

.getKmax <- function(da, q) {
  x <- kmaxTable[IDg == IDg_TARGET & ID == ID_TARGET &
                 TR == TR_TARGET & Da == da & p == q, kmax]
  if (!length(x) || all(is.na(x))) NA_real_ else round(x[1], 4)
}
.getKh <- function(da, q) {
  x <- kmaxTable[IDg == IDg_TARGET & ID == ID_TARGET &
                 TR == TR_TARGET & Da == da & p == q, Kh]
  if (!length(x) || all(is.na(x))) NA_real_ else round(x[1], 1)
}

# ── Step 1: slope geometry and T_s ────────────────────────────────────────────
DT      <- ShearTable[IDg == IDg_TARGET & IDm == IDm_TARGET] |> unique()
TsRange <- range(DT$Ts, na.rm = TRUE)
GoRange <- range(DT$Go, na.rm = TRUE)
VSoRange<- range(DT$VSo, na.rm = TRUE)
TsMed   <- median(DT$Ts, na.rm = TRUE)
Slope   <- DT$s[1]
LambdaO <- DT$lo[1]
Berm    <- DT$b[1]
Hs      <- DT$Hs[1]
USCS    <- unique(DT$USCS)
T15Ts   <- 1.5 * TsMed
T13Ts   <- 1.3 * TsMed

# ── Step 2: rock UHS at TR_TARGET (mean, Vref) ────────────────────────────────
DT     <- UHSTable[TR == TR_TARGET & Vs30 == Vref_gmdp[1] &
                   ID == ID_TARGET & p == "mean"]
setorder(DT, Tn)
PGA    <- DT[Tn == 0, Sa]
Sa15Ts <- approx(DT$Tn, DT$Sa, xout = T15Ts, rule = 2)$y
Sa13Ts <- approx(DT$Tn, DT$Sa, xout = T13Ts, rule = 2)$y

# ── Step 2b: rock quantiles at Vs30=800 m/s (Vref=760) ────────────────────────
# Vs30=760 has AF=1 for all p (reference = target); quantile spread only exists
# at Vs30 != Vref because ST17 sigma is applied.
Vrock     <- 800
DTrock    <- UHSTable[TR == TR_TARGET & Vs30 == Vrock & Vref == Vref_gmdp[1] &
                      ID == ID_TARGET]
PGA84rock <- DTrock[p == "0.84" & Tn == 0, SaF]
PGA16rock <- DTrock[p == "0.16" & Tn == 0, SaF]

# ── Step 3: ST17 amplification at VS30_TARGET ─────────────────────────────────
ID_SITE <- sub("max", "site", ID_TARGET)
DT      <- UHSTable[TR == TR_TARGET & Vs30 == VS30_TARGET &
                    ID == ID_SITE & p == "mean"]
setorder(DT, Tn)
AfPGA   <- DT[Tn == 0, AF]
SaF15Ts <- approx(DT$Tn, DT$SaF, xout = T15Ts, rule = 2)$y
SaF13Ts <- approx(DT$Tn, DT$SaF, xout = T13Ts, rule = 2)$y
Af15Ts  <- approx(DT$Tn, DT$AF,  xout = T15Ts, rule = 2)$y
Af13Ts  <- approx(DT$Tn, DT$AF,  xout = T13Ts, rule = 2)$y

DT16 <- UHSTable[TR == TR_TARGET & Vs30 == VS30_TARGET &
                 ID == ID_SITE & p == "0.16" & Tn == 0, AF]
DT84 <- UHSTable[TR == TR_TARGET & Vs30 == VS30_TARGET &
                 ID == ID_SITE & p == "0.84" & Tn == 0, AF]
MuLnFpga  <- log(AfPGA)
SigLnFpga <- if (length(DT16) && length(DT84))
               (log(DT84) - log(DT16)) / (2 * qnorm(0.84)) else NA_real_

# ── Step 4: k_max table across DA_TARGET ──────────────────────────────────────
DaRows <- lapply(DA_TARGET, function(da) {
  list(Da       = da,
       kmax16   = .getKmax(da, "0.16"),
       kmaxMean = .getKmax(da, "mean"),
       kmax84   = .getKmax(da, "0.84"),
       kh16     = .getKh(da, "0.16"),
       khMean   = .getKh(da, "mean"),
       kh84     = .getKh(da, "0.84"))
})

# ── Newmark ensemble ───────────────────────────────────────────────────────────
WActive <- Dn_weights[Dn_weights > 0]
WTotal  <- sum(WActive)
WLabels <- paste0(names(WActive), " (", WActive, "/", WTotal, ")")

SUMMARY <- list(
  IDg        = IDg_TARGET,
  IDm        = IDm_TARGET,
  USCS       = paste(USCS, collapse = " / "),
  Hs         = Hs,
  slope      = .fmt(Slope, 1),
  lambdaO    = .fmt(LambdaO, 2),
  berm       = Berm,
  vs30       = VS30_TARGET,
  vrockLabel = Vrock,
  tsMin      = .fmt(TsRange[1], 3),
  tsMax      = .fmt(TsRange[2], 3),
  tsMed      = .fmt(TsMed, 3),
  T15Ts      = .fmt(T15Ts, 3),
  T13Ts      = .fmt(T13Ts, 3),
  goMin      = .fmt(GoRange[1], 1),
  goMax      = .fmt(GoRange[2], 1),
  vsoMin     = .fmt(VSoRange[1], 0),
  vsoMax     = .fmt(VSoRange[2], 0),
  trLabel    = .fmti(TR_TARGET),
  pga        = .fmt(PGA, 3),
  pga84rock  = .fmt(PGA84rock, 3),
  pga16rock  = .fmt(PGA16rock, 3),
  sa15TsRock = .fmt(Sa15Ts, 3),
  sa13TsRock = .fmt(Sa13Ts, 3),
  afPGA      = .fmt(AfPGA, 3),
  af84PGA    = .fmt(DT84, 3),
  muLnFpga   = .fmt(MuLnFpga, 3),
  sigLnFpga  = .fmt(SigLnFpga, 3),
  saF15Ts    = .fmt(SaF15Ts, 3),
  saF13Ts    = .fmt(SaF13Ts, 3),
  af15Ts     = .fmt(Af15Ts, 3),
  af13Ts     = .fmt(Af13Ts, 3),
  DaRows     = DaRows,
  wLabels    = paste(WLabels, collapse = ", "),
  ns         = NS,
  units      = PSA_Units
)

rm(DT, DT16, DT84, DTrock,
   TsRange, GoRange, VSoRange, TsMed, Slope, LambdaO, Berm, Hs, USCS,
   T15Ts, T13Ts, Vrock,
   PGA, Sa15Ts, Sa13Ts, PGA84rock, PGA16rock,
   AfPGA, SaF15Ts, SaF13Ts, Af15Ts, Af13Ts, MuLnFpga, SigLnFpga,
   WActive, WTotal, WLabels, DaRows, ID_SITE,
   .fmt, .fmti, .getKmax, .getKh)
# nolint end
