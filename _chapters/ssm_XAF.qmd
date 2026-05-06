##  Regional Sources (SSM)

The seismic source model (SSM) defines the spatial distribution, geometry, and earthquake occurrence rates of all seismogenic sources considered capable of contributing to ground-motion hazard at a site. In the hazard integral ([@eq-hazard-integral]), the SSM provides the magnitude-frequency distributions $f_{M,s}(m)$, the spatial distributions $f_{\mathbf{R}|M,s}(\mathbf{r}|m)$, the occurrence rates $\nu_0^{(s)}$, and the maximum magnitude $M_{\max}^{(s)}$ for each source $s$ [@Cornell1968; @SSHAC1997]. Epistemic uncertainty in these parameters is captured through the source-model logic tree described in [@sec-ssm].

This appendix documents the Western and Northern Africa SSM adopted in this assessment, including the source inventory, logic-tree structure, recurrence parameters, magnitude-frequency distribution types, magnitude-area scaling relationships, maximum magnitude characterization, and seismogenic depth architecture. The model is implemented in the OpenQuake Engine through source-model XML files referenced by the logic tree.

### Source Inventory

The XAF seismic source model comprises 255 seismic sources of two types: 115 simple fault sources (`simpleFaultSource`) and 140 multi-point sources (`multiPointSource`). These sources are classified under two tectonic region types: Active Shallow Crust (ASC, 150 sources) and Stable Continental Crust (SCC, 105 sources). Within the fault source group, 69 sources are ASC and 46 are SCC; within the multi-point source group, 81 are ASC and 59 are SCC. The model is encoded in a logic-tree files with five branch sets yielding $2 \times 3 \times 3 \times 3 \times 3 = 162$ end-branches. [@Poggi2020]. 

The model domain extends from approximately $19.5^\circ$W to $52.9^\circ$E in longitude and $28.7^\circ$S to $38.5^\circ$N in latitude, covering North Africa, West Africa, and parts of sub-Saharan Africa. The minimum earthquake magnitude ($M_{\min}$) adopted for hazard calculations is 4.0 Mw for multi-point sources (ranging from 4.0 to 4.5 Mw depending on the source group) and 6.05 Mw for simple fault sources [@Poggi2020].

All 255 sources are attributed to the North Africa probabilistic seismic hazard model developed by Poggi et al. [@Poggi2020], assembled under the GEM Global Seismic Hazard Map programme. Fault source geometries and kinematics are derived from the GEM North Africa Active Fault Database (NAAFD) compiled by Styron and Poggi [@Styron2018]. Seismic-source characterisation follows the classical PSHA framework outlined by Cornell [@Cornell1968] and formalised under SSHAC guidelines [@SSHAC1997]; sources are delineated from geologic, geophysical, and seismological evidence, with geometry and parametrisation defined in OpenQuake source-model XML files and encoded in the logic tree.

### Logic Tree Structure

The source-model logic tree encodes epistemic uncertainty by defining alternative realisations of the SSM. Each branch set addresses a specific source of uncertainty; branches within each set carry weights reflecting the relative credibility of each alternative. The primary logic tree  contains five branch sets yielding $2 \times 3 \times 3 \times 3 \times 3 = 162$ end-branches [@Poggi2020].

Branch set 1 governs source-model selection and applies to all sources. It comprises two branches: `naf_faults` (weight 0.50), which incorporates `FaultSources.xml`, `GridMultiSources_C_L50_BG.xml`, and the collapsed WAF and SSA multi-point source files; and `naf_smooth` (weight 0.50), which replaces the explicit fault sources with a purely smoothed-seismicity representation using `GridMultiSources_C.xml` alongside the same collapsed regional files [@Poggi2020].

Branch sets 2 and 3 apply to the West African (WAF) group sources `MPS-1` through MPS-6. Branch set 2 (`mmax_waf`, type `maxMagGRRelative`) applies maximum-magnitude perturbations of $+0.2$, $0.0$, and $-0.2$ Mw with weights 0.25, 0.50, and 0.25 respectively. Branch set 3 (`bval_waf`, type `bGRRelative`) applies $b$-value perturbations of $+0.05$, $0.0$, and $-0.05$ with the same weight distribution [@Poggi2020].

Branch sets 4 and 5 apply to the North Africa (NAF) smoothed-seismicity sources SC_1 through SC_54. Branch set 4 (`naf_b`, type `bGRRelative`) applies $b$-value perturbations of $+0.05$, $0.0$, and $-0.05$ with weights 0.25, 0.50, and 0.25. Branch set 5 (`naf_m`, type `maxMagGRRelative`) applies $M_{\max}$ perturbations of $+0.2$, $0.0$, and $-0.2$ Mw with the same weights. The perturbation structure for the NAF group is structurally identical to that of the WAF group [@Poggi2020].

The following table summarises the complete logic-tree structure of `ssmLT_XAF.xml`.

```{r}
#| include: true
#| label: tbl-ssm-xaf-lt
#| tbl-cap: "Logic-tree structure of ssmLT_XAF.xml."

DT <- data.table::data.table(
  `Branch set` = c(1, 2, 3, 4, 5),
  `ID` = c("sourceModel", "mmax_waf", "bval_waf", "naf_b", "naf_m"),
  `Type` = c("Source model selection", "maxMagGRRelative", "bGRRelative", "bGRRelative", "maxMagGRRelative"),
  `Applies to` = c("All sources", "`MPS-1` to MPS-6", "`MPS-1` to MPS-6", "SC_1 to SC_54", "SC_1 to SC_54"),
  `Branches (perturbation / weight)` = c(
    "`naf_faults` (- / 0.50); `naf_smooth` (- / 0.50)",
    "+0.2 (0.25); 0.0 (0.50); -0.2 (0.25)",
    "+0.05 (0.25); 0.0 (0.50); -0.05 (0.25)",
    "+0.05 (0.25); 0.0 (0.50); -0.05 (0.25)",
    "+0.2 (0.25); 0.0 (0.50); -0.2 (0.25)"
  )
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit")
TBL
```


### Earthquake Recurrence Parameters

The earthquake recurrence parameters quantify the expected rate and size distribution of future earthquakes on each seismic source. Recurrence is described by a magnitude-frequency distribution (MFD) whose type and parameters are specified per source in the model. The three source groups in the XAF model correspond to three distinct MFD types, each carrying a different parameterisation approach [@Poggi2020].

```{r}
#| include: true
#| label: tbl-ssm-xaf-recurrence
#| tbl-cap: "Earthquake recurrence parameters by source group."

DT <- data.table::data.table(
  `Source group` = c("Simple fault sources", "MPS/SC (truncated GR)", "BG (arbitrary MFD)"),
  `MFD type` = c("incrementalMFD", "truncGutenbergRichterMFD", "arbitraryMFD"),
  `a-value range` = c("-", "3.13-5.45", "-"),
  `b-value range` = c("-", "0.93-1.16", "-"),
  `Mmin (Mw)` = c("6.05", "4.0-4.5", "-"),
  `Mmax range (Mw)` = c("6.05-7.75", "5.25-9.00", "5.25-9.00"),
  `n` = c(115, 86, 54)
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit")
TBL
```

For fault sources, activity rates are encoded as discrete incremental occurrence rates per 0.1-Mw magnitude bin starting at $M_{\min} = 6.05$ Mw; no parametric $a$- or $b$-values are defined. Maximum magnitudes range from 6.05 to 7.75 Mw across the 115 fault sources [@Poggi2020].

For the 86 multi-point sources with truncated Gutenberg-Richter MFDs, earthquake rates are parameterised by an $a$-value (range 3.13 to 5.45) and $b$-value (range 0.93 to 1.16) subject to explicit $M_{\min}$ and $M_{\max}$ bounds. Epistemic uncertainty in $b$-value is captured through logic-tree branch sets 3 and 4, applying relative perturbations of $\pm 0.05$ to the WAF (MPS group) and NAF (SC group) source groups respectively [@Poggi2020].

For the 54 background sources with arbitrary MFDs, occurrence rates are specified at arbitrary magnitude points, providing a non-parametric representation of seismicity that does not assume a Gutenberg-Richter relationship. No $a$- or $b$-values are defined for these sources [@Poggi2020].

### Magnitude-Frequency Distribution Types

Three magnitude-frequency distribution types are present in the XAF seismic source model, each associated with a distinct source group and rate specification method [@Poggi2020].

The truncated Gutenberg-Richter MFD (`multiMFD:truncGutenbergRichterMFD`) is applied to 86 multi-point sources, comprising the SC_1 through SC_54 NAF smoothed-seismicity sources and the `MPS-1` through MPS-6 WAF sources. Earthquake rates are parameterised by an activity-rate coefficient ($a$-value) and a slope parameter ($b$-value) within explicit $M_{\min}$ and $M_{\max}$ bounds; within those bounds the relationship follows the standard Gutenberg-Richter form. The $a$-value ranges from 3.13 to 5.45 and the $b$-value from 0.93 to 1.16 across all 86 sources [@Poggi2020].

The incremental MFD (`incrementalMFD`) is applied to all 115 simple fault sources. Occurrence rates are specified as discrete values per 0.1-Mw magnitude bin starting at $M_{\min} = 6.05$ Mw; $a$- and $b$-values are not defined for sources using this MFD type. This formulation directly encodes the expected annual rate at each magnitude level, permitting non-parametric shapes consistent with activity rates estimated from fault geometry and slip-rate data [@Poggi2020].

The arbitrary MFD (`multiMFD:arbitraryMFD`) is applied to 54 background multi-point sources (BG_1 through BG_54). Occurrence rates are specified at arbitrary, non-uniformly spaced magnitude points without an underlying parametric model, providing a non-parametric representation of distributed background seismicity that does not assume a Gutenberg-Richter relationship [@Poggi2020].

### Magnitude-Area Scaling Relationships

Two magnitude-area scaling relationships are applied in the source model, assigned by source type. All 115 simple fault sources use the `Leonard2014_Interplate` relationship [@Leonard2014] with a rupture aspect ratio of 2.0. All 140 multi-point sources use the `WC1994` relationship [@WellsCoppersmith1994] also with a rupture aspect ratio of 2.0. These relationships convert rupture area to moment magnitude and are used by OpenQuake to determine rupture dimensions during hazard calculation.

### Slip-Rate Data and Moment Balance

Activity rates for fault sources with available slip-rate data may be derived from seismic-moment balance:

$$\dot{M}_0 = \mu\, A\, S$$

where $\mu$ is the shear modulus, $A$ is the fault area, and $S$ is the long-term slip rate. This relationship connects geodetic or geologic slip-rate estimates to the seismic moment release rate used in MFD construction.

Slip-rate estimates from the GEM North Africa Active Fault Database (NAAFD) [@Styron2018] are documented for 15 of the 115 fault sources. The documented values encompass net slip rates, strike-parallel rates, vertical rates, and shortening rates, with magnitudes typically in the range 0.01 to 2.5 mm/yr. However, these slip-rate data are not encoded in the OpenQuake source-model XML files; the source-model audit records zero fault sources with slip-rate data present in the XML representation. The incremental MFD rates for fault sources were therefore specified independently of the NAAFD slip-rate constraints at the OpenQuake implementation stage [@Poggi2020].

### Maximum Magnitude

Maximum magnitude ($M_{\max}$) defines the upper bound of the magnitude-frequency distribution for each source and is a critical parameter controlling the tail of the hazard curve. Epistemic uncertainty in $M_{\max}$ is captured through logic-tree branches where specified [@Poggi2020].

For simple fault sources, $M_{\max}$ base values range from 6.05 to 7.75 Mw. Because the incremental MFD directly encodes occurrence rates per magnitude bin, $M_{\max}$ is implicit as the highest-magnitude bin for each source; the low and high epistemic bounds equal the base value, indicating no additional $M_{\max}$ uncertainty beyond the source-model selection captured in branch set 1. The Arzew Fault (FL_119, ASC) carries the largest $M_{\max}$ value in the fault group at 7.75 Mw [@Poggi2020].

For multi-point sources, base $M_{\max}$ values range from 5.25 to 9.00 Mw. Epistemic uncertainty is applied through `maxMagGRRelative` logic-tree branches to two sub-groups: the six WAF sources `MPS-1` through MPS-6 (branch set 2, ID `mmax_waf`) receive perturbations of $+0.2$, $0.0$, and $-0.2$ Mw with weights 0.25, 0.50, and 0.25; the NAF smoothed-seismicity sources SC_1 through SC_54 (branch set 5, ID `naf_m`) receive an identical perturbation structure. The collapsed SSA sub-group sources carry identical base, low, and high $M_{\max}$ values, indicating that epistemic $M_{\max}$ uncertainty for those sources was pre-collapsed into the source parameters prior to model compilation [@Poggi2020].

### Seismogenic Depth Parameters

Seismogenic depth parameters define the vertical extent within which earthquake ruptures are generated. Upper and lower seismogenic depths bound the rupture zone; hypocentral depth distributions, where specified, control the depth placement of point-source ruptures [@Poggi2020].

```{r}
#| include: true
#| label: tbl-ssm-xaf-depth
#| tbl-cap: "Seismogenic depth parameters by source type."

DT <- data.table::data.table(
  `Source type` = c("Simple fault sources", "Multi-point sources (WAF)", "Multi-point sources (SSA)"),
  `z_upper (km)` = c("0.0", "0.0", "0.0"),
  `z_lower (km)` = c("1.7-25.0", "45.0", "40.0"),
  `Hypocentral depth distribution` = c(
    "Not specified (rupture geometry from fault model)",
    "5 km (0.267), 15 km (0.267), 25 km (0.333), 35 km (0.133)",
    "Depth-weighted discrete distribution; mean 18.0-19.5 km"
  )
)

TBL <- DT |> buildTable(
  library = "flextable",
  align.body = "center",
  font.size.body = FONT.SIZE.BODY,
  font.size.header = FONT.SIZE.HEADER
) |>
  flextable::set_table_properties(layout = "autofit")
TBL
```

Simple fault sources share an upper seismogenic depth of 0.0 km; their lower seismogenic depth ranges from 1.7 km for very shallow structures to 25.0 km for crustal-scale faults. Multi-point sources are assigned a deeper seismogenic base: WAF collapsed sources extend to 45.0 km and SSA collapsed sources to 40.0 km, reflecting the broader depth distribution of smoothed background seismicity across the model domain [@Poggi2020].

For the WAF multi-point sources (`MPS-1` through MPS-6), hypocentral depth distributions are explicitly defined with a mean hypocentral depth of 18.3 km, based on a four-level discrete distribution: 5 km (weight 0.267), 15 km (weight 0.267), 25 km (weight 0.333), and 35 km (weight 0.133). SSA collapsed sources carry comparable mean hypocentral depths of approximately 18.0 to 19.5 km depending on the source sub-group [@Poggi2020].
