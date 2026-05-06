ABSTRACT

This paper presents a performance-based seismic design framework for the preliminary dynamic stability assessment of embankments constructed on soft, sensitive foundations such as varved glaciolacustrine clay. Where regulations require reclaimed tailings impoundments to withstand the Maximum Credible Earthquake (MCE) without loss of containment, robust screening methods become essential—particularly when available geotechnical data are limited.

The framework integrates targeted and comprehensive site and laboratory investigations, inputs from coupled limit equilibrium and finite element seepage stability analyses, and discuss importance of performing screening-level liquefaction assessments as part of the process. A core element is the calibration of seismic coefficients to specific performance criteria, especially restricting predicted permanent deformations to acceptable levels under design-level earthquakes.

By explicitly accounting for uncertainties from site amplification and material property variability, the methodology produces mean values and error estimates for seismic design parameters. The proposed framework demonstrates that performance-based seismic design can be reliably applied in early project stages to support compliance and inform risk management for tailings impoundments, even in contexts with limited data.

RESUME

Cet article présente un cadre de conception sismique basé sur la performance pour l’évaluation préliminaire de la stabilité dynamique des digues construites sur des fondations molles et sensibles, telles que les argiles varvées glaciolacustres. Lorsque la réglementation exige que les parcs à résidus réhabilités résistent au séisme maximal crédible (SMC) sans perte de confinement, des méthodes de vérification robustes deviennent essentielles, en particulier lorsque les données géotechniques disponibles sont limitées.

Le cadre intègre des investigations ciblées et complètes sur le site et en laboratoire, les résultats d’analyses de stabilité par équilibre limite et éléments finis couplées avec l’écoulement, et souligne l’importance de réaliser des analyses de liquéfaction de type dépistage (screening) dans le cadre du processus. Un élément central est l’étalonnage des coefficients sismiques en fonction de critères de performance spécifiques, notamment la limitation des déformations permanentes prédites à des niveaux acceptables sous les séismes de dimensionnement.

En tenant explicitement compte des incertitudes liées à l’amplification de site et à la variabilité des propriétés des matériaux, la méthodologie fournit des valeurs moyennes ainsi que des estimations d’erreur pour les paramètres de conception sismique. Le cadre proposé démontre qu’une conception sismique basée sur la performance peut être appliquée de manière fiable aux premières étapes d’un projet pour soutenir la conformité réglementaire et éclairer la gestion des risques des parcs à résidus, même dans des contextes où les données sont limitées.

# INTRODUCTION

The rewards of successful mineral exploration and development can be substantial when a deposit is discovered, evaluated, and ultimately brought into production. However, mine development is inherently risky and time‑consuming. It typically takes many years for a mining company to progress from early opportunity identification through to project execution and mine commissioning. Over this lifecycle, the development of a mining project and its associated infrastructure, such as the tailings storage facility (TSF) requires a series of technical and economic studies, beginning with general site characterization and progressing through multiple levels of economic evaluation. Social acceptability and environmental liability are among the key factors that must be addressed throughout this process.

Adopting a performance‑based design approach for the reclamation, development, and operation of a TSF provides a transparent and technically robust way to link seismic demand directly to clearly defined performance objectives (e.g., allowable deformations, loss‑of‑containment criteria). This approach moves beyond prescriptive factors of safety and allows engineers to “right‑size” designs: avoiding under‑design that could compromise safety, while also avoiding overly conservative embankments design that drive unnecessary capital and operating costs. Since performance criteria and risk tolerances are explicitly defined and quantified, performance‑based design can support faster and more defensible permitting, improve communication with regulators and communities, and enhance social acceptability and stakeholder appreciation and approval.

This is particularly important given that TSFs typically represent the longest‑lived asset and the most enduring liability for a mining company. While ore processing and active operations are finite in time, the tailings facility remains on site effectively in perpetuity, carrying long‑term geotechnical, environmental, and reputational risks. A performance‑based seismic design framework provides a rational basis for managing this long‑term liability by demonstrating, in quantifiable terms, that the facility can meet its required performance levels throughout its operational life and into closure and post‑closure.

As part of early stage of project, a performance‑based design methodology can be deployed. The performance of of an embankment can be defined against multiple objectives and criteria, through the used of a deterministic model. As emphasized by Lacasse and Nadim (1998), as more sounding, drilling and testing becomes available, a performance-based progress toward a probabilistic framework.

This paper presents the application of a performance‑based seismic design framework to evaluate the long‑term performance of a TSF and to inform the selection and refinement of the reclamation concept.

# performance‑based seismic design framework - Concept and vision

The geotechnical stability of embankments is most commonly evaluated using deterministic limit‑equilibrium analyses, in which a factor of safety (FoS) is computed for specified loading conditions and fixed input parameters describing loads and resistances.

By contrast to the resistance of geomaterials that is often poorly constrained, the distributions describing the main external loads—such as design seismic loads—can usually be defined at an early stage of a project and tend to evolve less as the project progresses (Lacasse and Nadim, 1998).

Likewise, performance criteria or performance objectives for TSFs are typically established early and, similar to the load definition, should not vary significantly throughout the engineering process.

In current practice, assessment of embankment safety often relies on verifying that the FoS under static and pseudo‑static (seismic) loading exceeds prescribed minimum values. The performance objectives and earthquake design criteria for TSFs is a function of consequence classification and, where applicable, project phase. Consequence classes are based primarily on population at risk, potential loss of life, and the scale of environmental and socio‑economic impacts. In all recommended frameworks, post‑closure conditions must satisfy the most stringent seismic criteria, with the desired annual probability of exceedance (AEP). In Québec, the prescribed post-closure seismic criteria require TSFs to be designed either for an event with an annual exceedance probability (AEP) of 1/10 000 or for the Maximum Credible Earthquake (MCE), as defined in the MERN (2024) guidelines. It must be demonstrated that the facility can withstand such events without catastrophic failure.

Demonstrating compliance with these seismic criteria depends critically on the choice of analysis method. Within this regulatory context, it is acknowledged that advanced equivalent-linear or fully nonlinear dynamic finite-element/finite-difference (FE/FD) analyses are often difficult to justify for preliminary or screening-level studies, given their data requirements, cost, and complexity. Consequently, at early project stages, the dynamic stability of TSF embankments is typically evaluated by comparing pseudo-static factors of safety against prescribed criteria.

Typically, when target FoS for pseudo-static loading condition is not achieved, the standard response is to modify the geometry (e.g., flatten slopes, add buttresses) of embankment(s) or to recommend additional works or assessment(s). This approach frequently leads to conservative designs, higher capital and operating costs. This FoS‑centred methodology is inherently focused on “failure” as a binary outcome and tends to obscure the underlying question of what constitutes unacceptable performance. Therefore, Newmark displacement analyses are increasingly used as an alternative or complement to pseudo-static stability assessment. They serve as a screening-level tool to estimate the relative magnitude of permanent embankment displacements induced by seismic loading. For example, should an earthquake‑induced permanent deformation of 25 cm, 50 cm, or 100 cm for a given embankment be considered “failure,” or could it represent acceptable performance within a performance‑based framework? Such performance-based procedures, allows linking the seismic coefficient () to be used as part of the pseudo-static slope stability assessment to an explicit project-based displacement tolerance and a probabilistic seismic hazard as discussed below.

It is worth mentioning that U.S. Army Corps of Engineers (USACE) Engineer Manual EM 1110-2-1902 and EM 1110-2-2100 endorse pseudo-static stability analysis as one of several acceptable methods and addresses the Newmark sliding-block approach for estimating permanent seismic deformation and establishing the principle that must reflect project-specific conditions. As the USACE, the Canadian Dan Association (CDA), the Eurocode, the National Cooperative Highway Research Program (NCHRP) and the International Commission on Large Dams (ICOLD), endorse the Newmark displacement approach, with the same caveat: the must reflect project-specific conditions.

# pseudo-static coefficient determination

As part of pseudo-static slope stability, the dynamic effect of earthquake shaking is simplified and represented as an equivalent static horizontal force. This force is proportional to a seismic coefficient, , and the weight of the potential sliding mass. Historically, the value of has been selected either as a fixed fraction of the regional design peak ground acceleration (PGA) (REF) or based on engineering judgment.

Over the past decades, a transition toward performance-based procedures linking to an explicit project-based displacement tolerance and a probabilistic seismic hazard level reflecting the consequence class of the structure occured. This transition has been enabled by the development of empirical Newmark sliding-block displacement models (rigid-block and flexible-block formulations) translating ground-motion intensity into probability distributions of permanent residual displacement. This approach allows defining seismic design criteria in terms of quantified performance outcomes rather than nominal force levels [U.S. Army Corps of Engineers (2003)](Anderson et al. 2008).

The performance-based framework for pseudo-static seismic coefficient selection was established by Bray and Travasarou (2007, 2009). The procedure enables direct determination of the design seismic coefficient required to limit the probability of exceeding a specified displacement threshold, given the site ground-motion demand, the fundamental period of the sliding mass, and the yield acceleration. The framework was subsequently extended by Bray and Macedo (2017, 2019), Macedo et al (2018) and Macedo et al. (2020).

The performance-based framework reconceptualizes selection as an inverse problem defined by an explicit displacement performance objective defined on a project-based basis. The design coefficient is the minimum yield acceleration ratio, , for which the probability of the ensemble-predicted permanent co-seismic displacement exceeding an allowable threshold, , is controlled at a specified target exceedance probability :

where is the critical (yield) acceleration, is gravitational acceleration, is the ensemble-predicted Newmark displacement, and is the target exceedance probability.

The coefficient is calibrated as per the target ground-motion intensity level, expressed as an annual exceedance probability (AEP) and the physical and dynamic properties of the embankment. The physical property of the embankment is established through the yield acceleration ratio representing the minimum normalized horizontal acceleration required to initiate permanent sliding. The dynamic properties of the embankment is represented through of the potentially sliding mass and depends on the shear stiffness and geometric extent of the sliding body. Together, and define the mechanical response of the slope to a given seismic excitation. The methodology connects these two parameter groups through Newmark sliding-block displacement regression models, which translate ground-motion intensity measures - including peak ground acceleration (PGA), spectral acceleration , peak ground velocity (PGV), and Arias intensity (AI) - into probability distributions of permanent residual displacement. The performance-based coefficient is then identified by inverting this displacement framework: for a given target AEP and allowable displacement threshold , the minimum satisfying the prescribed performance criterion constitutes the design seismic coefficient. (REFs)

# Newmark displacement models

The Newmark sliding-block method conceptualizes the seismically loaded slope as either a rigid or a flexible (compliant) block resting on an inclined frictional surface. When the driving acceleration component along the failure plane exceeds the yield acceleration , the block undergoes incremental downslope movement; relative motion ceases when the driving acceleration falls below this threshold. The total permanent displacement accumulates over all exceedance episodes throughout the duration of shaking (REFs) as per the following equation :

where denotes the set of ground-motion intensity measures specific to each model (e.g., , spectral acceleration at a reference period, Arias intensity , or peak ground velocity ); is the fundamental period of the sliding mass (Ishihara (1997)); is the earthquake moment magnitude where included as a model predictor; is the model-predicted mean displacement in natural-log space; is the associated standard deviation in natural-log space; and is a standard-normal variate capturing record-to-record variability not explained by the regression.

The rigid-block models treat the sliding mass as an undistorted body that moves as a whole relative to the underlying ground, as described in the Probabilistic Model section. Dynamic amplification within the mass is negligible, and the response is governed entirely by the base excitation. This idealization is appropriate for shallow translational failure surfaces in relatively stiff materials whose fundamental period is short relative to the dominant periods of the input motion. Four rigid-block models are retained in the ensemble (Ambraseys and Menu (1988), Yegian, Marciano, and Varzaghian (1991), Jibson (2007), Saygili and Rathje (2008)).

Flexible-block models account for the dynamic response of the sliding mass as a deformable body, as described in the Probabilistic Model section, by incorporating the fundamental period and spectral acceleration evaluated at a period proportional to . All three flexible-block models include an explicit dependence on to account for the influence of earthquake duration on accumulated displacement. These models are appropriate for deeper-seated failure surfaces in earth dams, natural slopes, compacted fills, and waste embankments where the sliding mass has significant deformability (Bray, Macedo, and Travasarou (2017), Bray and Macedo (2019), Bray and Travasarou (2007)).

# Suggested approach to assess the residusal displacement using Newmark displacement models

Considering that the four rigid-block models and three flexible-block models described above were developed under specific assumptions and each has its own limitations and associated uncertainties. Therefore, rather than relying on a single preferred model, it is recommended that all seven relationships be retained and their results aggregated through a logic-tree weighting scheme, thereby representing epistemic uncertainty in model choice as a formal component of the assessment. The weighting strategy should assigns greater weight to more recent models on the basis that they were calibrated against larger ground-motion databases, and the logic-tree weights should be assigned prior to aggregation, maintaining explicit separation between epistemic model uncertainty and aleatory ground-motion variability throughout the simulation.

Ground‐motion intensity measures for each Newmark models should be sampled from probabilistic seismic hazard analysis (PSHA) derived empirical quantile distributions using a Monte Carlo procedure that preserves period dependence, applies period-dependent site amplification (with its own uncertainty), and maintains inter-period correlation. For each realization and each model, log-displacement is computed from a common lognormal functional form, with model-specific aleatory variability represented by the regression standard deviation and propagated independently across models. Ensemble predictions are then obtained by weighting individual models according to their logic-tree weights, and displacement quantiles (e.g., median, 84th, 95th) are read directly from the resulting empirical distributions. The performance-based seismic coefficient is determined by finding, for each slope configuration and service level, the minimum yield acceleration, k, for which the probability of exceeding a specified displacement threshold (D) does not exceed a target value (D), yielding tabulated values over the full range of design return periods.

# Application of the suggested approach

# pseudo-static stability assessment outcomes

XX

# stability assessment

The TSF comprises a series of containment embankments founded on proximal glaciolacustrine deposits of the Barlow–Ojibway clay complex. The embankments are constructed of compacted sand and gravel, with a geomembrane clay liner (GCL) placed on the upstream slopes. The tallest embankment segment is approximately 13 m in height, while the lowest is about 2.5 m. The operating water level allows of a permanent freeboard of 2.0 m. The downstream slope of the embankments are considered as not erodible and these are classified as having a “Significant” classification as per the CDA guidelines.

Beneath the glaciolacustrine clays, a stratified silt unit is present. As illustrated in Figures 2 and 3, this unit exhibits sand-like or transitional behaviour and is predominantly dilative. Isotropically consolidated undrained (ICU) triaxial tests performed on undisturbed samples recovered using a 3-inch Osterberg sampler confirm this dilative response (Figure 3). To characterize the small-strain stiffness profile and dynamic properties of this sequence, shear-wave velocities (Vs) were measured using seismic piezocone soundings; the resulting Vs profiles across the site are presented in Figure 5.

Figure 1 Modified Roberston (2016) SBTn chart from a CPTu performed beneath the dam crest

Figure 2 Modified Robertson (2016) SBTn and clean sand equivalent profile for a CPTu performed benath the dam crest

Given that the objective of this study was to evaluate the long-term performance of the TSF and inform the selection and refinement of a reclamation concept compliant with MERN (2024) requirements, a screening-level liquefaction assessment was first undertaken. The purpose of this step was to confirm whether pseudo-static slope stability analyses would be appropriate for the site conditions as discussed by Makdisi and Seed (1977).

The liquefaction screening assessment was conducted following the methodology of Youd et al. (2001), based on comparison of cyclic resistance ratio (CRR) and cyclic stress ratio (CSR). As shown in Figure 4, the results indicate that the foundation soils are predominantly non-liquefiable, thereby supporting the use of pseudo-static FOS as a reliable basis for assessing the seismic stability or performance of the embankments.

Figure 3 Undrained triaxial test performed on the fluvioglacial material

Figure 4 Example of a CRR vs CSR profile for an earthquake with a magnitude of 7.00

Figure 5 Measured Vs profiles across the site

# SITE Specific pseudo-static coefficient determination

XX

Slope stability outcome should be added by me later this week.

# Closing remarks

Acknowledging that the key seismic load parameters for a project typically change little once the controlling sources and design levels have been established, they should be defined as early as practicable in the engineering process. In parallel, clear, quantitative performance objectives (e.g., tolerable permanent displacements, no loss of containment) should also be set at the outset of any studies, assessment or trade-offs while looking to design for closure purpose. Having both the seismic demand and the performance objectives defined from the start greatly facilitates the implementation of a performance‑based approach for assessing TSF embankment long-term stability.

The methodology applied in this study provides a rational framework in which the seismic performance of the TSF embankments is evaluated in terms of earthquake‑induced permanent displacements, rather than solely through prescriptive FoS. By linking a horizontal seismic coefficient directly to an allowable displacement threshold, the approach demonstrates that limited expenditure should be required for the embankment to comply with the applicable regulations and meet project‑specific performance criteria under the required design and safety‑evaluation earthquakes. In this case, the performance‑based assessment showed that the selected reclamation concept is technically robust.

More broadly, introducing performance‑based principles early in a project allows the seismic load definition to be established, while the characterization of material resistance is progressively refined through additional site investigation and testing. As the statistical description of resistance improves, the framework can naturally evolve toward a reliability‑based design, in which probabilities of exceeding specified performance limits are quantified explicitly, moving beyond purely deterministic checks and enabling more transparent, risk‑informed decisions for long‑term TSF stability.

# References
