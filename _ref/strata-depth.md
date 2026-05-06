# Louvicourt TSF — stratigraphy in depth-from-surface coordinates

Conversion of `_ref/strata.md` from elevation (asl) to depth-from-crest convention used by dsra (`zm`, `hs`, `Hs`, `Water`).

Crest elevation: 400 m. `z_top = 400 - elev_top_layer`.

| Layer | Description       | USCS    | hs (m) | elev_top | elev_bot | z_top (m) | z_bot (m) | zm (m) | Notes                                                              |
|-------|-------------------|---------|--------|----------|----------|-----------|-----------|--------|--------------------------------------------------------------------|
| 1     | Dam               | GC-GM   | 18     | 400      | 382      | 0         | 18        | 9      | Estimated Vs ≈ 250–300 m/s (Karray et al. 2011); internal zoning   |
| 2     | Foundation        | CL-ML   | 6      | 382      | 376      | 18        | 24        | 21     | Upper varved clay (mainly CL)                                      |
| 3     | Foundation        | ML-CL   | 4      | 376      | 372      | 24        | 28        | 26     | Lower varved clay (mainly ML)                                      |
| 4     | Foundation        | SM-SC   | 5      | 372      | 367      | 28        | 33        | 30.5   | Upper fluvioglacial, getting finer                                 |
| 5     | Foundation        | SP      | 5      | 367      | 362      | 33        | 38        | 35.5   | Sand poorly graded above bedrock                                   |
| —     | Bedrock           | —       | —      | 362      | —        | 38        | —         | —      | Vref = 760 (default)                                                |

Totals:
- `Hs = 18 + 6 + 4 + 5 + 5 = 38 m`
- Water table at elev 382 → depth 18 m → saturated thickness `Hw = 38 − 18 = 20 m` → **`Water = Hw/Hs = 20/38 ≈ 0.526`**
- Layers above WT (capa 1, dam): dry. Layers 2–5: saturated.

dsra-ready vectors (top → bedrock):

```r
hs    <- c(18, 6, 4, 5, 5)
USCS  <- c("GC-GM", "CL-ML", "ML-CL", "SM-SC", "SP")  # dual codes — needs canonicalization for dsra
Hs    <- sum(hs)                                      # 38
zm    <- cumsum(hs) - hs/2                            # 9, 21, 26, 30.5, 35.5
Water <- 0.526
```

Note: dsra's `ValidUSCS` does not accept dual codes (`GC-GM`, `CL-ML`, `ML-CL`, `SM-SC`). A canonical-code mapping is required before passing to dsra.
