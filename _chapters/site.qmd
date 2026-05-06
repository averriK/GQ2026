---
reference-location: section
link-citations: true
---


Near-surface geology modifies seismic waves as they propagate from bedrock to the ground surface. Soft soils amplify ground motion at intermediate-to-long periods while potentially deamplifying short-period motion through nonlinear strain effects; stiff rock sites transmit near-bedrock intensity levels with minimal modification [@Baker2021]. In probabilistic seismic hazard analysis, site effects can be incorporated through two mechanisms: (1) the site term embedded within ground-motion prediction equations (GMPEs), in which the median prediction and aleatory variability are functions of $V_{S30}$, or (2) an external amplification model applied to a reference-rock hazard curve [@Stewart2020]. The first mechanism is ergodic by construction—the empirical site term averages over many recording sites globally and may not capture conditions at a specific site or region. The second mechanism allows regionally calibrated amplification that accounts for nonlinear soil behavior as a function of shaking intensity. This assessment employs both approaches and selects the controlling (maximum) spectral ordinate for each period and hazard level to ensure that the design spectrum is not governed by whichever model happens to be less conservative at a given period.

Site effects were introduced in the probabilistic seismic hazard analysis through two complementary models. The first used an ergodic ground-motion framework in which a logic tree of $V_{S30}$-dependent GMPEs was evaluated for shear-wave velocities ranging from 200 m/s to 1100 m/s. For every branch, OpenQuake computed spectral accelerations $S_a(T_n, V_{S30})$ at the required service levels. Epistemic uncertainty was represented by the branch weights prescribed in the logic tree, and aleatory variability followed the total standard deviation of each GMPE. Because the site term is embedded empirically within the GMPEs, the resulting uniform-hazard spectra remain ergodic.

The second model is an amplification model based on a reference-rock hazard curve at $V_{\mathrm{ref}} = 760\,\text{m/s}$ and transforms it to the target condition $V_{S30}$ by applying period-dependent, nonlinear amplification factors $F(T_n, V_{S30})$, according to [@eq-site-af]. The amplification model follows the formulation of Stewart and co-authors, which expresses $F$ as a log-normal random variable whose mean $\eta_{F\mid\mathrm{PGA}}\!\left(T_n, V_{S30}\right)$ and dispersion $\sigma_{\ln F}$ depend on oscillator period, shear-wave velocity, and input PGA [@Stewart2020; @Hashash2020]. For $V_{S30} < V_{\mathrm{ref}}$, the model captures nonlinear deamplification at short periods and amplification at intermediate-to-long periods; for stiffer sites, the amplification asymptotically approaches unity. Formally, the amplification factor is modeled as a lognormal random variable [@eq-site-lnf]:

$$
\ln F \sim \mathcal{N}\!\left(\mu_{\ln F},\; \sigma_{\ln F}^2\right)
$${#eq-site-lnf}

where $\mu_{\ln F}$ is the conditional mean of the log-amplification factor and $\sigma_{\ln F}$ is the total aleatory standard deviation, both for a given ($V_{S30}$, $T_n$, $pga^*$). The mean $\mu_{\ln F}$ decomposes additively into three period-dependent terms [@Stewart2020]: a reference-condition adjustment $F_{760}$ that bridges the difference between the 760 m/s and 3000 m/s reference horizons, a linear site term $F_V$ that scales with $V_{S30}$ relative to the reference velocity, and a nonlinear factor $F_{nl}$ that captures PGA-dependent soil deamplification at high strain levels. Similarly, the total dispersion decomposes in quadrature [@eq-site-sigma-decomp]:

$$
\sigma_{\ln F}^2 = \sigma_{L}^2 + \sigma_{I}^2 + \sigma_{NL}^2
$${#eq-site-sigma-decomp}

where $\sigma_L$ is the linear site-term dispersion (dependent on $V_{S30}$ and period), $\sigma_I$ is the inter-reference dispersion (nonzero only when $V_{\mathrm{ref}} = 3000\,\text{m/s}$), and $\sigma_{NL}$ is the nonlinear dispersion (dependent on $V_{S30}$ and $pga^*$). All components are period-dependent and tabulated in the published model [@Stewart2020]. The detailed functional forms and calibration of each component are documented in [@sec-site_model].

$$
S_a\!\left(T_n, V_{S30}\right) = F\!\left(T_n, V_{S30}\right)\,S_a\!\left(T_n, V_{\mathrm{ref}}\right).
$${#eq-site-af}

For each return period $T_R$, oscillator period $T_n$, fractile $p$, and site class $V_{S30}$, the design spectral ordinate is defined as the maximum across the GMPE-based and amplification-based estimates [@eq-site-envelope]:

$$
S_a^{\mathrm{max}}(T_n, V_{S30}) = \max\!\left\{S_a^{\mathrm{GMPE}}(T_n, V_{S30}),\; S_a^{F}(T_n, V_{S30})\right\}
$${#eq-site-envelope}

where $S_a^{\mathrm{GMPE}}$ is the spectral ordinate obtained from the GMPE logic tree evaluated directly at the target $V_{S30}$, and $S_a^{F}$ is the spectral ordinate obtained by applying the amplification factor $F$ to the reference-rock hazard curve per [@eq-site-af]. This envelope ensures that the controlling (most hazardous) estimate governs the design spectrum at every period. GMPEs may underpredict at certain periods or $V_{S30}$ ranges where their empirical site terms are poorly constrained by the underlying strong-motion database, while the amplification model may underpredict where the reference-rock hazard curve does not fully represent near-field or source-specific effects. The envelope eliminates the risk of unconservative design by selecting the larger ordinate at each spectral period.

