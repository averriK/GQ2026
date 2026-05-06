---
title: "Probabilistic estimation of Newmark displacements and seismic coefficients under hazard uncertainty"
author: "Alejandro Verri Kozlowski"
bibliography: bib/Verri.bib
---

# Probabilistic estimation of Newmark displacements and seismic coefficients under hazard uncertainty

> **Working paper, draft.** This draft contains the methodology only; abstract, case study, discussion, conclusion, and a publication-ready bibliography are out of scope until each can be grounded in source material. Symbol conventions: $T_s$ for the fundamental period of the sliding mass, $D_a$ for the admissible target displacement, $k_y$ for the dimensionless yield coefficient, $k_\text{max}$ for the design seismic yield coefficient, and $K_h$ for its normalised form expressed as a percentage of the rock-level mean PGA. All methodology items have been resolved at this draft stage; pending items refer only to the case-study-specific weight vector $w_i$ in §7.1 and the operational defaults for $N_S$ / $N_k$.

## Introduction

The geotechnical stability of embankments — including the containment dykes of tailings storage facilities (TSFs) and waste rock dumps (WRDs) — is most commonly assessed in routine practice through deterministic limit-equilibrium analyses. A factor of safety (FoS) is computed for prescribed loading conditions and fixed input parameters describing loads and resistances. For the seismic component of the design, the dynamic effect of earthquake shaking is simplified and represented as an equivalent static horizontal force, proportional to a dimensionless seismic coefficient $k_h$ and to the weight of the potential sliding mass. Historically, the value of $k_h$ has been selected either as a fixed fraction of the regional design peak ground acceleration (PGA) or by engineering judgement informed by precedent. Both routes collapse the uncertainty budget of the underlying problem into a single deterministic value, and they sever the link between $k_h$ and the engineering quantity that
performance-based design constrains: the permanent co-seismic displacement that the slope is required to tolerate without loss of containment.

Performance-based extensions of pseudo-static analysis tie $k_h$ to a tolerable displacement $D_a$. The Bray and Travasarou [-@BrayTravasarou2007] flexible-block displacement model and the inversion procedure in Bray and Travasarou [-@BrayTravasarou2009] define the design coefficient — denoted $k_\text{max}(D_a)$ — as the smallest yield coefficient $k_y$ for which the probability that $D(k_y) > D_a$ is bounded by a target $p$. Subsequent work by Bray, Macedo and co-authors [@BrayEtAl2018; @BrayMacedo2019; @BrayMacedo2023] refines and extends the displacement regression to subduction-zone interface and intraslab earthquakes and to shallow crustal events (with the 2023 dispersion correction). Code-based and standards-based recommendations sit alongside this work: USACE EM 1110-2-1902 and EM 1110-2-2100 [@USACE2003; @USACE2005] endorse Newmark sliding-block analysis as a deformation check supplementing the pseudo-static factor-of-safety analysis; NCHRP Report 611 [@AndersonEtAl2008]
codifies a displacement-based pseudo-static recommendation; EN 1998-5 [@CEN2004] admits Newmark-style displacement evaluation as a simplified option; ICOLD Bulletin 148 [@ICOLD2016] endorses Newmark for moderate-to-high consequence dams; the Canadian Dam Association Technical Bulletins [@CDA2019] and the Quebec MERN guidelines [@MERN2024] endorse Newmark for tailings-dam closure design. Across these documents the common caveat is that the selection of $k_h$ must reflect project-specific conditions.

Three properties of the published procedures motivate the approach taken here. First, the input ground-motion intensity measures are typically treated as deterministic mean values from probabilistic seismic hazard analysis (PSHA), and the local site amplification factor is handled either through GMPE site terms or, when an external site-response analysis is performed, by collapsing its lognormal distribution to a mean. Both shortcuts ignore the fractile description of the uniform-hazard spectrum that contemporary PSHA workflows actually deliver — a discrete set of fractiles per oscillator period and per return period that integrates the GMM and seismic-source logic-trees and the GMPE total $\sigma$ over the hazard integral. Second, the choice of a single empirical Newmark relationship collapses the epistemic uncertainty associated with model selection: different regressions are calibrated against datasets of different size, vintage, and tectonic scope, and an explicit logic-tree over
alternative regressions follows the same logic that PSHA already applies on the GMM side. Third, the propagation of aleatory residuals across multiple displacement models requires an explicit assumption about cross-model residual dependence: drawing independent residuals per model amounts to assuming uncorrelated residuals, which underestimates the joint variability of the ensemble; drawing a single residual per realisation across all models amounts to assuming perfect cross-model correlation, the strongest possible assumption in this direction. The procedure described here adopts the perfect-cross-model-correlation form ($\rho = 1$) as a working assumption documented as such in §10; intermediate cross-model correlations are an obvious refinement direction.

No new empirical regression, site-amplification model, or correlation model is introduced. The procedure described here integrates existing tools into a single Monte Carlo loop that (i) consumes the PSHA output in fractile form, (ii) propagates rock-level inter-period dependence through the full Baker and Jayaram [-@BakerJayaram2008] inter-period correlation matrix (§5.2), (iii) applies a published lognormal site-amplification model with its own dispersion, (iv) runs a logic-tree-weighted combination of six empirical Newmark relationships with a single shared aleatory residual per realisation, (v) projects each per-realisation displacement curve to enforce monotonicity in $k_y$ before inversion, and (vi) reports the design $k_\text{max}(D_a)$ together with an uncertainty band.

The remainder of this draft is the methodology proper. Section 2 states the inverse problem. Section 3 introduces the probabilistic functional form. Section 4 specifies the six empirical models. Section 5 describes PSHA-driven scenario sampling. Section 6 specifies the site-amplification model. Section 7 details the realisation structure and the cross-model residual treatment. Section 8 covers the monotone projection and the inversion. Section 9 covers statistical reporting and the seismic coefficient. Section 10 consolidates the modelling hypotheses.

---

## Problem statement

Let $D(k_y)$ denote the random permanent co-seismic displacement at the toe of a sliding mass governed by a yield acceleration $k_y g$, where $k_y \in (0, k_{y,\max})$ is the dimensionless yield coefficient and $g$ is gravitational acceleration. The performance-based design problem is to choose, for a given target tolerable displacement $D_a > 0$ and a target exceedance probability $p \in (0, 1)$, the smallest $k_y$ such that the displacement induced at the design return period $T_R$ remains below $D_a$ with probability at least $1 - p$:

$$
k_\text{max}(p \mid D_a, T_R)
\;=\;
\inf\!\Bigl\{\,k_y \,:\, P\!\bigl[\,D(k_y; T_R) > D_a\,\bigr] \,\leq\, p\,\Bigr\}.
$$

The probability above is taken with respect to the full uncertainty budget of the displacement: the joint distribution of intensity measures at rock level produced by the PSHA at return period $T_R$, the lognormal distribution of the site-amplification factor that converts rock to surface, and the regression residual of the empirical Newmark relationship that maps surface intensities to displacement.

The right-hand side has no closed form: the distribution of $D(k_y)$ at fixed $k_y$ has no analytical expression because none of the three contributing distributions does, and their convolution does not admit one. In practice, the analyst is interested in a tabulated map $D_a \mapsto k_\text{max}(p \mid D_a, T_R)$ over a range of $D_a$ values (typically $D_a \in [0.5, 1000]$ cm in steps relevant to facility consequence classification) and over a range of return periods (typically AEP $1/100$ to AEP $1/10\,000$).

The Monte Carlo framework developed in §§3–9 evaluates the inverse mapping numerically. For each realisation $s$, the framework draws from each contributing distribution and computes a per-realisation displacement curve $D_{i,s}(k_y)$ for each model $i$ in the ensemble, an ensemble-weighted curve $D_{\text{ens},s}(k_y)$, and, by inversion, a per-realisation yield coefficient $k_{\text{max},s}(D_a)$. The empirical distribution of $\{k_{\text{max},s}(D_a)\}_{s=1}^{N_S}$ over $N_S$ realisations approximates the inverse mapping; mean and selected percentiles summarise the design value and the uncertainty band.

Throughout the paper, displacements are in centimetres, accelerations in units of $g$, peak ground velocity in cm s$^{-1}$, Arias intensity $\mathrm{AI}$ in m s$^{-1}$, oscillator and sliding-mass periods in seconds, and shear-wave velocities in m s$^{-1}$.

---

## Probabilistic functional form

Each empirical Newmark displacement model $i$ in the ensemble predicts the natural logarithm of permanent displacement at a given yield acceleration $k_y$ and intensity-measure set $\boldsymbol{\mathrm{IM}}$ as a deterministic conditional mean plus a Gaussian residual:

$$
\ln D_i\!\bigl(k_y, \boldsymbol{\mathrm{IM}}\bigr)
\;=\;
\mu_{\ln D,\,i}\!\bigl(k_y, \boldsymbol{\mathrm{IM}}\bigr)
\;+\;
\sigma_{\ln D,\,i}\;\varepsilon,
\qquad
\varepsilon \sim \mathcal{N}(0,1).
$$

The mean function $\mu_{\ln D,\,i}$ is the regression mean published by the model's author against a calibration dataset of strong-motion records, and $\sigma_{\ln D,\,i}$ is the corresponding regression standard deviation in natural-log space. The residual $\varepsilon$ captures record-to-record variability not explained by the predictors of model $i$. The functional form is shared across the six retained models; the model index enters through the functional form of the mean, the magnitude of the dispersion, and the choice of intensity measures.

The intensity-measure set $\boldsymbol{\mathrm{IM}}$ is model-dependent and may include any subset of $\{\mathrm{PGA},\,S_a(T),\,\mathrm{PGV},\,\mathrm{AI},\,T_s,\,M_w\}$, where $T_s$ is the fundamental period of the sliding mass and $M_w$ is the earthquake moment magnitude. The ratio $r = k_y / \mathrm{PGA}$ is also used as a predictor by the rigid-block models.

Two of the six retained models — AM88 and JB07 — report their regression in $\log_{10}$ rather than natural-log space. Conversion to natural-log space uses

$$
\sigma_{\ln D} \;=\; \sigma_{\log_{10} D}\,\ln 10
\;\approx\;
2.3026\,\sigma_{\log_{10} D},
$$

with the mean transforming by the same factor. The framework operates in natural-log space throughout; the conversion is applied at the point where each $\log_{10}$-space regression is loaded.

$\mathrm{AI}$ and $\mathrm{PGV}$ are required by some of the displacement models in the ensemble (JB07 and SR08 use $\mathrm{AI}$; BM19 uses $\mathrm{PGV}$ for the near-fault correction term). $\mathrm{AI}$ and $\mathrm{PGV}$ are taken from the PSHA workflow alongside PGA and $S_a$, using their own published GMPEs — for example, [@BooreEtAl2014] for $\mathrm{PGV}$ and [@TravasarouEtAl2003] or [@CampbellBozorgnia2019] for $\mathrm{AI}$ — and sampled jointly with PGA in the same Gaussian copula step described in §5.[^aipgv]

[^aipgv]: A simplified two-parameter regression of $\mathrm{AI}$ and $\mathrm{PGV}$ on $\mathrm{PGA}$ alone has been fitted by Verri Kozlowski [-@Verri2023] against a global database of strong-motion records, of the form $\mathrm{AI} \approx \mathrm{PGA}^{1.9228}\,e^{2.6109}$ (m s$^{-1}$) and $\mathrm{PGV} \approx \mathrm{PGA}^{1.0529}\,e^{0.1241} \times 100$ (cm s$^{-1}$) for vertical motions in NEHRP site grouping S = 2, with regression dispersions $\sigma_{\ln} \approx 0.60$ (AI) and $\sigma_{\ln} \approx 0.53$ (PGV). The fit captures only the PGA-conditional median and does not reproduce the magnitude, distance, and site dependence of dedicated AI / PGV GMPEs.

---

## Empirical models in the ensemble

The ensemble retains six empirical Newmark relationships, organised into a rigid-block family of three models and a flexible-block family of three models. Each model is calibrated against a published strong-motion dataset, uses predictors that the standard PSHA workflow produces directly or that follow from PSHA outputs, and covers a region of the slope-behaviour space encountered in tailings and waste-rock engineering. Coefficients below are reproduced from the source papers.

### 4.1 Rigid-block family

Rigid-block models treat the sliding mass as undeformable; the response is governed entirely by base excitation and dynamic amplification within the mass is neglected. The single predictor common to all three is the critical-acceleration ratio $r = k_y / \mathrm{PGA}$.

**AM88 — Ambraseys and Menu [-@AmbraseysMenu1988].** Calibrated against 50 records from 11 earthquakes. Reported in $\log_{10}$ space:

$$
\mu_{\log_{10} D}
\;=\;
0.90 + \log_{10}\!\bigl[(1-r)^{2.53}\,r^{-1.09}\bigr],
\qquad
\sigma_{\log_{10} D} = 0.30,
\qquad
0 < r < 1.
$$

The dispersion converts to $\sigma_{\ln D} \approx 0.691$. The bounds $0 < r < 1$ are physical, not calibration: the regression diverges at $r = 0$ and is identically zero at $r = 1$. The original paper does not report a calibration window in $r$. AM88 is evaluated over the full physical interval; predictions near $r \to 0$ and $r \to 1$ are extrapolations relative to the densely-sampled portion of the calibration dataset and to the asymptotic log-log linearity of the regression.

**JB07 — Jibson [-@Jibson2007].** Calibrated against 2,270 records from 30 worldwide earthquakes; predictors are $\mathrm{AI}$ (m s$^{-1}$) and $r$. Reported in $\log_{10}$ space:

$$
\mu_{\log_{10} D}
\;=\;
0.561\,\log_{10}\mathrm{AI}
\;-\;
3.833\,\log_{10}r
\;-\;
1.474,
\qquad
\sigma_{\log_{10} D} = 0.616.
$$

The dispersion converts to $\sigma_{\ln D} \approx 1.419$. Calibration window in $k_y$: $\{0.05, 0.10, 0.20, 0.30, 0.40\}$ g (five discrete values).

**SR08 — Saygili and Rathje [-@SaygiliRathje2008].** Calibrated against more than 2,000 acceleration time-histories; predictors are $\mathrm{PGA}$, $\mathrm{AI}$, and $r$. Dispersion is amplitude-dependent. Reported in natural-log space:

$$
\mu_{\ln D}
\;=\;
2.39
\;-\; 5.24\,r
\;-\; 18.78\,r^{2}
\;+\; 42.01\,r^{3}
\;-\; 29.15\,r^{4}
\;-\; 1.56\,\ln\mathrm{PGA}
\;+\; 1.38\,\ln\mathrm{AI},
$$

$$
\sigma_{\ln D}(r) \;=\; 0.46 \;+\; 0.56\,r.
$$

Calibration window in $k_y$: $\{0.05, 0.10, 0.20, 0.30\}$ g (four discrete absolute values, not in $r$). The polynomial in $r$ is a fourth-order fit; its extrapolation outside the calibration window is monitored by the monotone projection of §8.

### 4.2 Flexible-block family

Flexible-block models account for the dynamic response of the sliding mass as a deformable body with fundamental period $T_s$. The relevant intensity measure is no longer rock PGA but a spectral acceleration evaluated at a model-specific period proportional to $T_s$. All three flexible-block models include an explicit dependence on moment magnitude $M_w$, reflecting the duration sensitivity of accumulated displacement. Throughout this subsection let $S^{(\alpha)} \equiv S_a(\alpha\,T_s)$.

**BT07 — Bray and Travasarou [-@BrayTravasarou2007].** Calibrated against 688 records via coupled stick-slip analyses. Spectral acceleration evaluated at $\alpha = 1.5$. Total dispersion $\sigma_{\ln D} = 0.66$:

$$
\mu_{\ln D}
\;=\;
-1.10
\;-\; 2.83\,\ln k_y
\;-\; 0.333\,(\ln k_y)^{2}
\;+\; 0.566\,\ln k_y\,\ln S^{(1.5)}
\;+\; 3.04\,\ln S^{(1.5)}
\;-\; 0.244\,(\ln S^{(1.5)})^{2}
\;+\; 0.278\,(M_w - 7).
$$

Calibration window in $k_y$: $\{0.02, 0.05, 0.075, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40\}$ g (ten discrete values). The original BT07 formulation includes a probability of negligible displacement $P[D \leq 1\,\text{cm}]$; the working framework treats $D$ as a continuous lognormal variable for inversion, and that simplification is documented in §10 (H7).

**BM17 — Bray, Macedo and Travasarou [-@BrayEtAl2018].** Calibrated for subduction-zone interface and intraslab earthquakes ($M_w \geq 7.0$) against 810 two-component recordings. Spectral acceleration evaluated at $\alpha = 1.5$. Total dispersion $\sigma_{\ln D} = 0.73$. Coefficients depend on $T_s$ piecewise:

$$
\mu_{\ln D}
\;=\;
a_0(T_s, M_w, k_y)
\;+\; a_1(k_y)\,\ln S^{(1.5)}
\;+\; a_2\,(\ln S^{(1.5)})^{2},
$$

$$
a_0 = \begin{cases}
-5.864 + 0.550\,M_w - 9.421\,T_s - 3.353\,\ln k_y - 0.390\,(\ln k_y)^{2}, & T_s < 0.1, \\[2pt]
-6.896 + 0.550\,M_w + 3.081\,T_s - 0.803\,T_s^{2} - 3.353\,\ln k_y - 0.390\,(\ln k_y)^{2}, & T_s \geq 0.1,
\end{cases}
$$

$$
a_1(k_y) = 3.060 + 0.538\,\ln k_y, \qquad a_2 = -0.225.
$$

Calibration window in $k_y$: $\{0.01, 0.02, 0.035, 0.05, 0.075, 0.10, 0.15, 0.20, 0.25, 0.30, 0.40, 0.50, 0.80\}$ g (thirteen discrete values).

**BM19 — Bray and Macedo [-@BrayMacedo2019], with the dispersion correction in [@BrayMacedo2023].** Calibrated for shallow crustal earthquakes against 6,711 two-component recordings from the NGA-West2 database. Spectral acceleration evaluated at $\alpha = 1.3$. Total dispersion $\sigma_{\ln D} = 0.72$ ([@BrayMacedo2023]-corrected value).

For ordinary motions, the displacement equation has the same structural form as BM17 with the BM19 coefficients:

$$
\mu_{\ln D}
\;=\;
a_0(T_s, M_w, k_y)
\;+\; a_1(k_y)\,\ln S^{(1.3)}
\;+\; a_2\,(\ln S^{(1.3)})^{2},
$$

$$
a_0 = \begin{cases}
-4.684 + 0.603\,M_w - 9.471\,T_s - 2.482\,\ln k_y - 0.244\,(\ln k_y)^{2}, & T_s < 0.1, \\[2pt]
-5.981 + 0.603\,M_w + 3.223\,T_s - 0.945\,T_s^{2} - 2.482\,\ln k_y - 0.244\,(\ln k_y)^{2}, & T_s \geq 0.1,
\end{cases}
$$

$$
a_1(k_y) = 2.649 + 0.344\,\ln k_y, \qquad a_2 = -0.090.
$$

For near-fault pulse motions, $\mathrm{PGV} > 115$ cm s$^{-1}$, BM23 prescribes separate equations: Eq (6) for the maximum-component displacement $D_{100}$ and Eq (7) for the median-component displacement $D_{50}$. The selection between $D_{100}$ and $D_{50}$ depends on the orientation of the slope relative to the fault-normal direction: $D_{100}$ is used for slopes oriented within $\pm 45°$ of fault-normal (the conservative case); $D_{50}$ is used for other orientations. Both equations have the structural form

$$
\ln D_{\bullet}
\;=\;
c_1
\;-\; b_1\,\ln k_y
\;+\; b_2\,(\ln k_y)^{2}
\;+\; b_3\,\ln k_y\,\ln S^{(1.3)}
\;+\; b_4\,\ln S^{(1.3)}
\;-\; b_5\,(\ln S^{(1.3)})^{2}
\;+\; c_2\,T_s
\;+\; c_3\,T_s^{2}
\;+\; b_M\,M_w
\;+\; c_4\,\ln \mathrm{PGV},
$$

with $D_\bullet \in \{D_{100}, D_{50}\}$ selecting one of the two coefficient sets, and a sub-regime split at $\mathrm{PGV} = 150$ cm s$^{-1}$: the $(c_1, c_2, c_3, c_4)$ values change at this threshold to capture the saturation of seismic displacement at very high PGV. The total dispersion is $\sigma_{\ln D_{100}} = 0.56$ for the maximum-component case and $\sigma_{\ln D_{50}} = 0.54$ for the median-component case (both smaller than the ordinary-motion $\sigma = 0.72$ because the pulse equations include $\mathrm{PGV}$ as an extra predictor). Coefficient values are reproduced from Tables 1 and 2 of BM23.

Calibration window in $k_y$: same thirteen discrete values as BM17.

---

## PSHA-driven scenario sampling

The probabilistic seismic hazard analysis returns, at each oscillator period $T$ of interest and each return period $T_R$, a discrete set of empirical fractiles of the uniform-hazard spectrum at reference rock conditions $V_{S30,\text{ref}}$ (typically 760 m s$^{-1}$):

$$
\bigl\{\,(q^{(k)},\; S_a^{(k)}(T, T_R))\,\bigr\}_{k=1}^{K},
$$

where $q^{(k)} \in (0,1)$ is the quantile level (commonly the 2nd, 5th, 16th, 50th, 84th, 95th, and 98th percentiles, plus the mean) and $S_a^{(k)}(T, T_R)$ is the corresponding spectral ordinate. The fractile set carries the combined epistemic uncertainty of the GMM and seismic-source logic-trees and the aleatory uncertainty of the GMPE total $\sigma$, both already integrated through the hazard integral. It does not carry a closed-form joint distribution across periods, because the hazard integral is computed period-by-period and inter-period dependence is not preserved in the output.

For each return period $T_R$, the sampling proceeds in three steps.

### Period vector and quantile function

The required periods are: $T_1 = 0$ (PGA) for the rigid-block models and the nonlinear site-amplification term; for the flexible-block models, $\alpha_i\,T_s$ where $\alpha_i \in \{1.3, 1.5\}$ depending on the model — BT07 and BM17 use $\alpha = 1.5$, BM19 uses $\alpha = 1.3$. At each required period, a monotone, piecewise quantile function $Q_T(p)$ is fitted to the $\{q^{(k)}, \ln S_a^{(k)}\}$ pairs in natural-log space, constrained to be monotone in $p$ and continuous between knots. Periods not explicitly tabulated by the hazard analysis are obtained by logarithmic interpolation in $T$ between the two closest tabulated periods.

### Correlated standard normals via a Gaussian copula with full B&J 2008 matrix

The framework samples $N_S$ realisations of a standard-normal vector $\boldsymbol{u}_s = (u_{s,1}, \ldots, u_{s,J})^\top$, where the periods $\{T_1, \ldots, T_J\}$ are PGA (anchored at $T_1 = 0.01$ s, the lower limit of validity of the correlation model) plus the model-specific multiplier periods $\alpha_i\,T_s$ required by the flexible-block models. The correlation matrix $\boldsymbol{C}$ is the **full** Baker and Jayaram [-@BakerJayaram2008] inter-period matrix, with every off-diagonal entry given by the canonical formula:

$$
C_{jk} = \rho_\text{BJ}(T_j,\,T_k)
\qquad \text{for all } j, k = 1, \ldots, J.
$$

The full matrix preserves the high inter-period correlations that the canonical model predicts among non-PGA pairs. For typical flexible-block sliding-mass periods $T_s$, the conditional correlation between $S_a(1.3\,T_s)$ and $S_a(1.5\,T_s)$ given PGA is $\approx 0.94$ — a single ground-motion record that produces $S_a(1.5\,T_s)$ at the 80th percentile of its hazard distribution will produce $S_a(1.3\,T_s)$ at a comparable percentile, not at the 20th. Setting these inter-period entries to zero (a star/hub simplification) would generate physically inconsistent realisations in which $S_a(1.3\,T_s)$ and $S_a(1.5\,T_s)$ wander independently across percentile rank, which does not occur in real records. The full-matrix specification is therefore required.

The function $\rho_\text{BJ}(T_a, T_b)$ is the inter-period correlation of total residuals of $\ln S_a$ proposed by Baker and Jayaram [-@BakerJayaram2008]. With $T_\text{min} = \min(T_a, T_b)$, $T_\text{max} = \max(T_a, T_b)$, and the four auxiliary coefficients

$$
C_1 = 1 - \cos\!\left(\frac{\pi}{2} - 0.366\,\ln\!\frac{T_\text{max}}{\max(T_\text{min},\,0.109)}\right),
$$

$$
C_2 = \begin{cases}
1 - 0.105\!\left(1 - \dfrac{1}{1+\exp(100\,T_\text{max} - 5)}\right)\!\dfrac{T_\text{max} - T_\text{min}}{T_\text{max} - 0.0099}, & T_\text{max} < 0.2, \\[2pt]
0, & \text{otherwise},
\end{cases}
$$

$$
C_3 = \begin{cases} C_2, & T_\text{max} < 0.109, \\ C_1, & \text{otherwise}, \end{cases}
\qquad
C_4 = C_1 + 0.5\,(\sqrt{C_3} - C_3)\,(1 + \cos(\pi\,T_\text{min}/0.109)),
$$

the predicted correlation is

$$
\rho_\text{BJ}(T_a, T_b) = \begin{cases}
C_2 & \text{if } T_\text{max} < 0.109, \\
C_1 & \text{else if } T_\text{min} > 0.109, \\
\min(C_2, C_4) & \text{else if } T_\text{max} < 0.2, \\
C_4 & \text{otherwise}.
\end{cases}
$$

The form has no $R_\text{rup}$ or magnitude dependence. The source paper observes that "correlations were independent of the ground motions' causal magnitudes and distances; that finding was assumed to hold here as well" [@BakerJayaram2008]. The form is calibrated for $T_a, T_b \in [0.01, 10]$ s and is not to be extrapolated outside that range. The model applies to total residuals; intra-event and inter-event residuals exhibit the same correlation structure [@BakerJayaram2008] and the same form is used in PSHA practice for both.

The full matrix is positive semi-definite by construction of the B&J 2008 fit; positive definiteness for the specific period set required by an application can be verified by Cholesky decomposition. In practice the period set is small (PGA plus the $\alpha\,T_s$ multipliers required by the flexible-block models in the ensemble — typically PGA, $1.3\,T_s$, and $1.5\,T_s$, hence $J = 3$), so the matrix is well-conditioned at all sliding-mass periods of engineering interest.

### Mapping to intensity measures

Each component of $\boldsymbol{u}_s$ is mapped through the standard-normal CDF and then through the period-specific quantile function:

$$
\ln S_a(T_j)_s
\;=\;
Q_{T_j}\!\bigl(\,\Phi(u_{s,j})\,\bigr),
\qquad j = 1, \ldots, J,
$$

with $S_a(T_1)_s = \mathrm{PGA}_s$. The resulting tuple $\bigl(\mathrm{PGA}_s,\;S_a(\alpha_i T_s)_s,\;\ldots\bigr)$ is one realisation of the rock-level intensity measures at the chosen $T_R$, drawn from a distribution whose marginals match the empirical PSHA fractiles and whose inter-period dependence respects the correlation matrix above. Each marginal sample is re-centred so its empirical mean equals the tabulated PSHA mean exactly; this corrects sampling bias when $N_S$ is small. $\mathrm{AI}_s$ and $\mathrm{PGV}_s$ are computed from $\mathrm{PGA}_s$ via the fallback in §3 when not externally supplied.

---

## Site amplification

The rock-level intensities $\bigl\{S_a(T_j, V_{S30,\text{ref}})_s\bigr\}$ are converted to surface intensities at the target site via a lognormal amplification factor $F$. The factor follows the ergodic site-amplification framework of Stewart and co-authors developed for Central and Eastern North America: the linear-plus-nonlinear-plus-reference-adjustment decomposition is from [@Stewart2020], and the nonlinear deamplification term is from [@Hashash2020]. The framework allows two reference rock conditions, $V_{S30,\text{ref}} \in \{760,\,3000\}$ m s$^{-1}$, with the $F_{760}$ adjustment activated when the PSHA hazard is reported at the 3000 m s$^{-1}$ hard-rock baseline.

The mean log-amplification decomposes additively:

$$
\mu_{\ln F}\!\bigl(T, V_{S30}, \mathrm{PGA}^*\bigr)
\;=\;
\ln F_{760}(T)
\;+\;
\ln F_V(V_{S30}, T)
\;+\;
\ln F_{nl}(V_{S30}, \mathrm{PGA}^*, T),
$$

where $\ln F_{760}(T)$ adjusts the reference horizon from 3000 m s$^{-1}$ to 760 m s$^{-1}$, $\ln F_V(V_{S30}, T)$ scales linearly with $\ln V_{S30}$ relative to the 760 m s$^{-1}$ reference, and $\ln F_{nl}(V_{S30}, \mathrm{PGA}^*, T)$ captures the strain-dependent deamplification at high input PGA. When the rock-level reference is at $V_{S30} = 760$ m s$^{-1}$, $\ln F_{760}(T) = 0$ and the decomposition reduces to the linear-plus-nonlinear pair.

The total log-space dispersion decomposes in quadrature:

$$
\sigma_{\ln F}^{2}(T, V_{S30}, \mathrm{PGA}^*)
\;=\;
\sigma_L^{2}(T, V_{S30})
\;+\;
\sigma_I^{2}(T)\,\mathbb{1}\!\bigl[V_{\text{ref}} = 3000\,\text{m s}^{-1}\bigr]
\;+\;
\sigma_{NL}^{2}(T, V_{S30}, \mathrm{PGA}^*),
$$

where $\sigma_L$ is the linear-term dispersion, $\sigma_I$ is the inter-reference dispersion (active only when the rock-level reference is at 3000 m s$^{-1}$), and $\sigma_{NL}$ is the nonlinear-term dispersion. The components are tabulated period-by-period in the published model.

For each Monte Carlo realisation $s$ produced by §5, an independent amplification residual is drawn at each required period:

$$
\ln F(T_j)_s
\;\sim\;
\mathcal{N}\!\Bigl(\,
\mu_{\ln F}(T_j, V_{S30}, \mathrm{PGA}^{*}_s),\;
\sigma_{\ln F}^{2}(T_j, V_{S30}, \mathrm{PGA}^{*}_s)
\,\Bigr),
$$

and the surface-level intensity follows multiplicatively:

$$
S_a(T_j, V_{S30})_s
\;=\;
F(T_j)_s \cdot S_a(T_j, V_{S30,\text{ref}})_s.
$$

Three notes on the amplification residual draw: amplification residuals are drawn independently across periods (the correlation structure on the amplification side is not modelled; this is consistent with site-response-analysis practice but is a load-bearing simplification documented in §10, H4a); amplification residuals are drawn independently of the rock-level draws, on the assumption that record-to-record variability of the amplification factor is dominated by site-specific propagation effects rather than by source-specific record characteristics; and the nonlinear term $F_{nl}$ is conditioned on the realisation's $\mathrm{PGA}^{*}_s$, so that the input strain level and the amplification factor are mutually consistent within the realisation.

### Total log-space dispersion of the surface ordinate

Assuming statistical independence of the rock-level spectral ordinate and the amplification factor at each period, the total log-space variance of the surface ordinate decomposes as

$$
\mathrm{Var}\!\bigl[\,\ln S_a^{F}(T_j)\,\bigr]
\;=\;
\mathrm{Var}\!\bigl[\,\ln S_a(T_j)\,\bigr]
\;+\;
\sigma_{\ln F}^{2}(T_j, V_{S30}, \mathrm{PGA}^*),
$$

where the rock-level variance is represented by the empirical PSHA fractiles. The independence assumption is the standard one in site-response practice and is the basis for the Monte Carlo decoupling of §§5–6.

---

## Realisation structure

### Logic-tree weights

Let $\{w_i\,:\, i = 1, \ldots, 6\}$ be the normalised epistemic logic-tree weights, with $\sum_i w_i = 1$. The weighting strategy reflects the failure mechanism that the slope is expected to undergo. Shallow translational failure surfaces in stiff materials are dominated by base-excitation kinematics with negligible dynamic amplification of the sliding mass; the rigid-block family (AM88, JB07, SR08), whose primary predictor is the critical-acceleration ratio $r = k_y/\mathrm{PGA}$, is more representative of this mechanism and receives correspondingly greater weight. Deeper-seated failure surfaces in deformable masses with non-negligible fundamental period $T_s$ are dominated by spectral demand at $T_s$ and on its degraded value; the flexible-block family (BT07, BM17, BM19), whose primary predictor is $S_a(\alpha\,T_s)$, is more representative of this mechanism and receives correspondingly greater weight. Mixed mechanisms — for example, a sliding mass whose critical surface combines a
shallow translational portion with a deeper deformable portion, or a slope whose response is intermediate between rigid and flexible regimes — are represented by a balanced weighting between the two families. The specific weight vector is documented per case study and supported by a documented expert elicitation following SSHAC Level 3–4 procedures [@SSHAC1997] for high-consequence applications. The methodology is independent of the particular choice of $w_i$ provided the normalisation holds. A maximum-entropy default for sensitivity studies is the uniform vector $w_i = 1/6$, which represents the case in which no mechanism-based evidence distinguishes among the candidate regressions.

### Cross-model residual dependence

For each Monte Carlo realisation $s$, a single standard-normal aleatory residual is drawn:

$$
z_s \;\sim\; \mathcal{N}(0,1),
$$

and applied across all six models, scaled by each model's own dispersion. For each model $i$ and each candidate yield acceleration $k_y$ on the evaluation grid (§8.3), the per-model per-realisation displacement is

$$
D_{i,s}(k_y)
\;=\;
\exp\!\Bigl[\,
\mu_{\ln D,\,i}\!\bigl(k_y, \boldsymbol{\mathrm{IM}}_s\bigr)
\;+\;
\sigma_{\ln D,\,i}\,z_s
\,\Bigr],
$$

where $\boldsymbol{\mathrm{IM}}_s$ collects the surface intensities $(\mathrm{PGA}_s,\;S_a(\alpha T_s)_s,\;\ldots)$ produced by §§5–6. For SR08, the dispersion term is $\sigma_{\ln D,\,i}(r_s)\,z_s$ with $r_s = k_y/\mathrm{PGA}_s$, since SR08's dispersion is amplitude-dependent.

The use of a single shared $z_s$ across all six models corresponds to assuming perfect cross-model residual correlation, $\rho = 1$. This is the strongest assumption in the spectrum of cross-model residual dependence and is appropriate when the six retained regressions share most of their predictor structure and the unexplained component reflects mainly record-to-record variability that is common to all of them. The opposite extreme — independent residuals per model ($\rho = 0$) — underestimates the joint variability of the ensemble. Empirically calibrated cross-model residual correlations for displacement-prediction equations are not standard in the published literature; the multi-GMPE PSHA literature on intensity-measure residuals [@BakerBradley2017] reports cross-model correlations in the range $\rho \in [0.5, 0.9]$ for ground-motion residuals, and analogous values for displacement residuals are an open question. The shared-$z_s$ scheme is documented as H4b in §10 and identified as
a working assumption open to refinement.

### Weighted curve per realisation

For each $k_y$, the weighted mean displacement at realisation $s$ is the logic-tree-weighted average of per-model values in linear $D$-space:

$$
D_{\text{ens},s}(k_y)
\;=\;
\sum_{i=1}^{6}\, w_i \, D_{i,s}(k_y).
$$

The aggregation is taken in linear $D$-space rather than in $\ln D$-space; the linear-space mean is the standard mean of the predicted displacement under each model's predictive distribution and is consistent with the reporting of mean displacement in the source papers. The $\ln$-space mean (geometric mean of per-model displacements) is computed alongside as a diagnostic when sensitivity to the mixing space is of interest. The collection $\bigl\{D_{i,s}(k_y)\bigr\}_{i,s,k_y}$ is the primary output of the simulation; downstream statistics are derived from it.

---

## Monotone projection and inversion

### Monotonicity requirement

Physical consistency requires the per-realisation displacement curve to be non-increasing in $k_y$: a slope with a higher yield acceleration cannot accumulate more displacement under the same scenario. The empirical regressions of §4 do not enforce this constraint strictly; near the boundaries of their calibration windows, sampling noise on $z_s$ combined with non-monotonic functional forms (the fourth-order polynomial of SR08 is the prominent example) can produce per-realisation curves with small non-monotonic excursions. Such excursions are artefacts of the regression and corrupt the inversion if not removed.

### Right-cumulative projection

Before inversion, each per-model per-realisation curve is replaced by its right-sided cumulative maximum on the $k_y$ evaluation grid:

$$
\tilde{D}_{i,s}(k_{y,k})
\;=\;
\max_{j \,\geq\, k}\;
D_{i,s}(k_{y,j}),
\qquad k = 1, \ldots, N_k,
$$

where $k_{y,1} < k_{y,2} < \cdots < k_{y,N_k}$ is the grid in ascending order. The projection guarantees a non-increasing sequence in $k_y$ by construction, leaves the rightmost (largest-$k_y$) value unchanged, and never reduces a displacement value, replacing low-side anomalies with the larger of the original value and any value at higher $k_y$. Operationally it is the discrete right-cumulative max on the array of $D_{i,s}$ values, computed in a single right-to-left pass.

Alternative monotone projections include isotonic regression via the Pool-Adjacent-Violators algorithm and monotone-constrained cubic-spline interpolation. The right-cumulative-max choice is more conservative than isotonic regression at the low-$k_y$ end (it never reduces a displacement value), at the cost of a small upward bias relative to the unprojected regression curve.

### Evaluation grid for $k_y$

The grid spans the union of the six models' calibration windows:

$$
\bigl[k_{y,\min},\; k_{y,\max}\bigr]
\;=\;
\Bigl[0.01,\;\max\!\bigl(\mathrm{PGA}_\text{site,mean},\;0.80\bigr)\Bigr]\;\;\text{g},
$$

with $k_{y,\min} = 0.01$ g determined by the BM17 and BM19 calibration windows, and $k_{y,\max}$ the larger of the AM88 physical limit $k_y < \mathrm{PGA}$ and the BM17/BM19 calibration ceiling at $0.80$ g. The grid uses $N_k$ log-spaced points, with $N_k = 30$ as the operational default. Log-spacing is appropriate because $D(k_y)$ varies over orders of magnitude in $k_y$.

### Inversion at the target displacement

For each per-realisation per-model monotone curve $\tilde{D}_{i,s}$, the yield coefficient that limits displacement to the target $D_a$ is obtained by inversion in log-log space:

$$
k_{\text{max},\,i,s}(D_a)
\;=\;
\tilde{D}_{i,s}^{-1}(D_a)
\;=\;
\exp\!\Bigl[\,
\operatorname{interp}_{\ln-\ln}\!\bigl(
\ln D_a;\;
\ln \tilde{D}_{i,s},\;
\ln k_y
\bigr)
\,\Bigr].
$$

The interpolation is log-log linear on the evaluation grid. For $D_a$ outside the grid support $\bigl[\tilde{D}_{i,s}(k_{y,N_k}),\;\tilde{D}_{i,s}(k_{y,1})\bigr]$, linear extrapolation in log-log space at the nearest boundary point is used. The lower-boundary extrapolation is well-behaved for AM88 and JB07, which are asymptotically log-log linear in $r \to 0$; the upper-boundary extrapolation overestimates AM88 at large $k_y$, where the regression decays faster than log-linear because of the $(1-r)^{2.53}$ factor going to zero as $r \to 1$. The AM88 contribution to $k_{\text{max},s}(D_a)$ at very small $D_a$ is therefore a conservative bound rather than a regression-faithful estimate. Per-model calibration ranges are reported separately for diagnostic use when extrapolation is detected.

### Weighted per-realisation yield coefficient

The per-realisation yield coefficient is the logic-tree-weighted mean of the per-model inversions in linear $k_y$-space:

$$
k_{\text{max},\,s}(D_a)
\;=\;
\sum_{i=1}^{6}\, w_i \, k_{\text{max},\,i,s}(D_a).
$$

The mean is taken in linear $k_y$-space; the $\ln k_y$-space alternative (geometric mean of per-model inversions) is computed as a diagnostic. Because the mean is taken over inverses of monotone curves with distinct dispersions, $k_{\text{max},\,s}(D_a)$ is not in general equal to the inverse of $D_{\text{ens},s}(k_y)$ at $D_a$; the two operations do not commute. The weighted mean of inversions is reported on the grounds that the inversion is the natural per-model operation, with each model contributing under its own logic-tree weight.

---

## Statistical summary and seismic coefficient

### Empirical distribution of the design value

Across the $N_S$ Monte Carlo realisations, the design yield coefficient at the target $D_a$ is summarised by its mean and selected empirical quantiles:

$$
\bar{k}_\text{max}(D_a)
\;=\;
\frac{1}{N_S}\sum_{s=1}^{N_S} k_{\text{max},\,s}(D_a),
\qquad
k_\text{max}^{(p)}(D_a)
\;=\;
Q_p\!\bigl[\,k_{\text{max},\,s}(D_a)\,\bigr]_{s=1}^{N_S},
$$

with $p \in \{0.16,\,0.50,\,0.84\}$ as the operational default. Additional quantiles ($p \in \{0.05, 0.95\}$) are computed when extreme-tail reporting is required.

The reported uncertainty band $\bigl[\,k_\text{max}^{(0.16)},\,k_\text{max}^{(0.84)}\bigr]$ combines aleatory uncertainty across the three contributions: (i) hazard variability — the spread of $\boldsymbol{\mathrm{IM}}_s$ governed by the width of the PSHA-derived UHS quantiles and the inter-period correlation; (ii) site-amplification variability — the lognormal residual of the amplification factor; (iii) Newmark-model aleatory variability — the residual $z_s$ scaled by each model's $\sigma_{\ln D,\,i}$ and attenuated by the local slope $\partial \ln D / \partial \ln k_y$. The band also reflects a within-realisation model-mixing component, conditional on the chosen weight vector $w_i$. Epistemic uncertainty over the weight vector itself is not propagated into the band; sensitivity to $w_i$ is reported as a separate diagnostic via re-running the simulation under alternative weight vectors. The reported uncertainty band is probabilistic over seismic demand and site amplification;
geotechnical resistance uncertainty (in $k_y$) is not propagated and is the subject of a separate analysis (see §10, H6).

### Normalised seismic coefficient

The performance-based pseudo-static seismic coefficient is the ratio of the design $k_\text{max}$ to the mean rock-level peak ground acceleration at the chosen return period:

$$
K_h(D_a)
\;=\;
\frac{k_\text{max}(D_a)}{\overline{\mathrm{PGA}}_\text{rock}}\,\times\,100\%.
$$

The denominator is the mean rock-level PGA, an unambiguous PSHA output that does not require a separate site-amplification step. Standards-based recommendations such as NCHRP 611 [@AndersonEtAl2008] normalise to the site-level PGA, $\overline{\mathrm{PGA}}_\text{site} = F_\text{PGA}\,\overline{\mathrm{PGA}}_\text{rock}$, where $F_\text{PGA}$ is the site amplification factor at PGA. The two normalisations differ by the factor $F_\text{PGA}$, which can range from approximately 1.0 to 1.6 in the linear regime (depending on $V_{S30}$) and approximately 0.6 to 1.0 in the nonlinear regime at high input PGA. Direct comparison with site-PGA-normalised code recommendations therefore requires the multiplicative correction by $F_\text{PGA}$.

The framework reports both the absolute $\bar{k}_\text{max}(D_a)$ in $g$ and the normalised $K_h(D_a)$ as a percentage; the two forms are equivalent representations of the same design value.

### Tabulation across return periods

Repeating the procedure of §§4–9 across a set of return periods $T_R$ produces a tabulated map

$$
T_R \;\longmapsto\; \bar{k}_\text{max}(D_a, T_R) \;\;(\text{or equivalently }K_h(D_a, T_R)),
$$

over the range relevant to facility consequence classification: from AEP $1/100$ for routine operational loading, through AEP $1/475$ to $1/2475$ for moderate-consequence design earthquakes, to AEP $1/10\,000$ for the safety-evaluation earthquake of high-consequence facilities. The full map is the deliverable of the framework; its row at the post-closure design AEP is the input to limit-equilibrium pseudo-static slope-stability calculations.

---

## Modelling hypotheses

The framework rests on the following modelling hypotheses, each invoked at one or more steps above and each requiring justification or sensitivity testing in any application.

**H1 — Inter-period correlation, full B&J 2008 matrix.** Inter-period correlations between $\ln S_a$ residuals follow the canonical Baker and Jayaram [-@BakerJayaram2008] model — piecewise in $|\ln(T_a/T_b)|$, no dependence on rupture distance or magnitude, valid for $T \in [0.01, 10]$ s. Every off-diagonal entry of the correlation matrix is set by this formula; no star/hub simplification is applied. This preserves the empirical fact that $S_a$ at adjacent multipliers of $T_s$ ($1.3\,T_s$ and $1.5\,T_s$) is read from the same response spectrum and is therefore near-perfectly correlated ($\rho \approx 0.94$ conditional on PGA, for typical $T_s$).

**H2 — PSHA output is first-moment-plus-quantiles.** No closed-form joint distribution of intensity measures across periods is assumed; only the mean and a discrete set of empirical fractiles per period are exploited, via the monotone piecewise quantile function (§5.1). This matches the form in which contemporary PSHA computations deliver hazard output.

**H3 — No closed form for conditional means.** The conditional means $\mu_{\ln F}$ (site amplification) and $\mu_{\ln D,\,i}$ (Newmark displacement) have no analytical closed form across the full predictor space; they are evaluated by Monte Carlo realisations (§§6–7). This is a property of the underlying empirical models, not a methodological choice.

**H4a — Site-amplification residual independence.** The site-amplification residual $\ln F(T_j)_s$ is drawn independently across periods and independently of the rock-level draws of §5. The independence between site-amplification draws and rock-level draws rests on the assumption that record-to-record variability of the amplification factor is dominated by site-specific propagation effects rather than by source-specific record characteristics. The cross-period independence among amplification residuals is a simplification whose impact on the displacement output is small relative to the rock-level inter-period correlation but is documented as a load-bearing assumption.

**H4b — Cross-model displacement residual at $\rho = 1$.** The displacement residual $z_s$ is a single standard normal shared across all six models per realisation, which corresponds to perfect cross-model residual correlation. This is the strongest assumption in the spectrum of cross-model residual dependence and is appropriate when the six retained regressions share most of their predictor structure. Empirically calibrated cross-model correlations $\rho \in (0, 1)$ are an open refinement direction.

**H5 — Logarithmic dispersions are constant in the design quantities.** The dispersions $\sigma_{\ln F}(T, V_{S30}, \mathrm{PGA}^*)$ and $\sigma_{\ln D,\,i}$ are taken as constant in the design quantities ($k_y$ and $D_a$), while still depending on the predictor values within each realisation: $\sigma_{\ln F}$ depends on $V_{S30}$, $T$, and $\mathrm{PGA}^*_s$ via the published site-amplification tables; SR08's $\sigma_{\ln D}$ depends on $r_s$ via the published amplitude-dependent formula. The other displacement-model dispersions are reported as constants in their source papers.

**H6 — Yield acceleration is deterministic.** The yield coefficient $k_y$ of the slope is treated as a deterministic property of the failure surface, established by static slope stability analysis with shear strengths assigned per the geotechnical investigation. Uncertainty in $k_y$ — from material variability, residual-strength selection, or pore-pressure assumptions — is not modelled within the framework. The reported design value is therefore probabilistic over seismic demand and site amplification; geotechnical resistance uncertainty is the subject of a separate analysis.

**H7 — Continuous lognormal displacement.** The framework treats the predicted Newmark displacement as a continuous lognormal variable and bypasses the zero-displacement probability term that the BT07 original formulation provides ($P[D \leq 1\,\text{cm}]$). For design $D_a$ values of engineering interest (typically $\geq 1$ cm), the simplification has negligible numerical effect; the small-$D_a$ regime is conservatively handled by the lognormal continuous model.

---

## Open items

- **Logic-tree weights $w_i$**: no default vector is committed in this draft. Each application reports the chosen weight vector and justifies it.
- **Default $N_S$ and $N_k$**: routine practice is $N_S \in [10^3, 10^4]$ and $N_k = 30$; convergence diagnostics (band-width stability under $N_S \times 2$) accompany each case-study report.
- **Out of scope for this draft**: abstract, case study, discussion, conclusion, and a publication-ready bibliography.
