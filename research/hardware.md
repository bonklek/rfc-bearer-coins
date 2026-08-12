# Hardware research log

## Covered areas

- ECDSA per-message secret generation across batteryless power loss and reset.
- Entropy and health requirements for long-lived monetary and attestation key generation.
- Secure-element component changes, assurance continuity, and evaluated-hardware identity.
- Hardware-bound attestation-key enrollment and same-core credential activation.
- Complete-assembly ESD immunity and NFC antenna/protection co-design.
- Complete-assembly production conformance and abnormal-lot containment.
- Handled-coin humidity, ionic contamination, and corrosion qualification.
- Ingestion and small-part safety of circulating coin-sized electronic tokens.
- Sharp-edge and sharp-point hazards after foreseeable token damage.
- Chemical composition and contact safety of repeatedly handled electronic tokens.
- Electrical-shock and electrically caused fire safeguards for powered registers.
- Complete-register electromagnetic compatibility and 13.56 MHz spectrum conformance.
- Complete-register stability, support, anchoring, and relocation safety.
- Complete-register transport, shock, vibration, and rough-handling qualification.
- Safety-related control allocation and validation for the powered register.

## Research entries

### 2026-07-16 - Review 1

- **Area:** ECDSA per-message secret generation across batteryless power loss and authorization retry.
- **Investigation:** Compared NIST nonce requirements, deterministic ECDSA guidance, repeated-nonce warnings, and Java Card RNG guarantees.
- **Primary sources:** [NIST FIPS 186-5](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-5.pdf), [RFC 6979](https://www.rfc-editor.org/rfc/rfc6979.html), [RFC 9325](https://www.rfc-editor.org/rfc/rfc9325.html), [Oracle Java Card RandomData](https://docs.oracle.com/en/java/javacard/3.1/jc_api_srvc/api_classic/javacard/security/RandomData.html).
- **Material facts:** ECDSA requires a protected per-message secret. Repetition across distinct messages reveals the private key. Deterministic ECDSA avoids dependence on persistent RNG state, while the generic Java Card API leaves implementation security and conformance to the selected product.
- **RFC implication:** Arbitrary field removal makes reset behavior part of the P-256 security profile, not merely an implementation detail.
- **Disposition:** Produced C-055.

### 2026-07-16 - Review 2

- **Area:** Entropy and health requirements for long-lived P-256 monetary and attestation private keys.
- **Investigation:** Compared RFC key-origin claims with NIST key-pair generation, RBG, and entropy-source requirements.
- **Primary sources:** [NIST FIPS 186-5](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-5.pdf), [NIST SP 800-133 Rev. 2](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-133r2.pdf), [NIST SP 800-90B](https://csrc.nist.gov/pubs/sp/800/90/b/final).
- **Material facts:** P-256 private keys depend on an RBG at the required security strength. Entropy-source validation includes startup health tests before output after initialization or power-up.
- **RFC implication:** Passive cold starts and factory provisioning must be inside the evaluated key-generation profile.
- **Disposition:** Produced C-059.

### 2026-07-16 - Review 3

- **Area:** Secure-element supply changes, assurance continuity, and evaluated-hardware identity.
- **Investigation:** Compared semiconductor longevity and change policies with Common Criteria assurance-continuity rules and a Java Card maintenance report covering a production-site change.
- **Primary sources:** [NXP Product Longevity](https://www.nxp.com/products/nxp-product-information/nxp-product-programs/product-longevity%3APRDCT_LONGEVITY_HM), [CCRA Assurance Continuity Requirements v3.1](https://www.commoncriteriaportal.org/nfs/ccpfiles/files/operatingprocedures/CCDB-014-v3.1-2024-February-29-Final-Assurance_Continuity.pdf), [NSCIB NXP JCOP 5.1 maintenance report](https://www.commoncriteriaportal.org/files/epfiles/NSCIB-CC-221699-2MA2.pdf), [CCRA Certified Products List](https://www.commoncriteriaportal.org/products/index.cfm).
- **Material facts:** Longevity programs can permit site transfers, security modifications, or migration to compatible parts. Common Criteria maintenance may preserve product identity after a change without reassessing attack resistance; the cited maintenance report added a production site while retaining product identification and explicitly did not reassess attack resistance.
- **RFC implication:** Core credentials and batch manifests must bind an exact, versioned evaluated configuration, with security-impact review, delta testing, and a new profile identity for relevant component, site, ROM, library, package, or power-front-end changes.
- **Disposition:** Candidate accepted as C-067.

### 2026-07-16 - Review 4

- **Area:** Hardware-bound attestation-key enrollment and same-core credential activation.
- **Investigation:** Compared the provisioning sketch with TCG endorsement-key and device-identity enrollment procedures, then cross-checked Android hardware-backed key-attestation challenge guidance.
- **Primary sources:** [TCG TPM 2.0 Keys for Device Identity and Attestation](https://trustedcomputinggroup.org/wp-content/uploads/TCG_IWG_DevID_v1r2_02dec2020.pdf), [TCG EK Credential Profile](https://trustedcomputinggroup.org/wp-content/uploads/Credential_Profile_EK_V2.0_R14_published.pdf), [Android hardware-backed key attestation](https://developer.android.com/privacy-and-security/security-key-attestation), [Android attestation challenge API](https://developer.android.com/reference/android/security/keystore/KeyGenParameterSpec.Builder.html#setAttestationChallenge(byte%5B%5D)).
- **Material facts:** TCG enrollment separately validates the endorsement credential, key attributes, proof of possession, and an activation challenge to show that an attestation key is resident, non-duplicable, and fixed to the endorsed TPM; its shortcut lacks equivalent assurance. Android similarly uses a fresh challenge and hardware-rooted certificate chain so relying parties can verify request-bound key creation.
- **RFC implication:** Batch enrollment needs fresh hardware-rooted certification, proof of possession, and same-core credential activation, with the verified transcript and certified key bound into the batch leaf; a signed manifest alone does not establish hardware residence.
- **Disposition:** Candidate accepted as C-068.

### 2026-07-16 - Review 5

- **Area:** Complete-assembly ESD immunity and NFC antenna/protection co-design.
- **Investigation:** Reviewed the IEC system-level ESD test framework, ST testing of passive NFC antenna protection, and ST guidance on excessive inductive-field exposure.
- **Primary sources:** [IEC 61000-4-2:2025](https://webstore.iec.ch/en/publication/68954), [ST AN5425](https://www.st.com/resource/en/application_note/an5425-increasing-the-st25dvi2c-series-dynamic-nfc-tags-esd-robustness-on-antenna-using-an-external-esd-protection-stmicroelectronics.pdf), [ST AN5493](https://www.st.com/resource/en/application_note/an5493-best-practices-for-security-and-privacy-with-st25-nfcrfid-tags-stmicroelectronics.pdf).
- **Material facts:** IEC defines reproducible system-level ESD methods but leaves severity and performance criteria to the product specification. ST demonstrates that an NFC loop conducts discharge into antenna pins and that protection can improve immunity, while clamp voltage, parasitic capacitance, and placement can impair modulation, tuning, and RF power; excessive wireless-power fields can also damage tags.
- **RFC implication:** Complete sealed-assembly qualification must define ESD and excessive-field exposures and validate the selected protection network together with RF coupling, energy, brownout, and interoperability behavior.
- **Disposition:** No new complaint; reinforced C-011, C-014, C-018, and C-019.

### 2026-07-16 - Review 6

- **Area:** Complete-assembly production conformance and abnormal-lot containment.
- **Investigation:** Compared semiconductor package-mounting controls for moisture, reflow, inspection, and flexible-substrate handling with AEC precedents for statistical abnormal-lot detection, defect prevention, and board-level reliability testing.
- **Primary sources:** [NXP AN10365](https://www.nxp.com/documents/application_note/AN10365.pdf), [NXP AN2265](https://www.nxp.com/assets/documents/data/en/application-notes/AN2265.pdf), [AEC Documents](https://www.aecouncil.com/AECDocuments.html).
- **Material facts:** Moisture and out-of-window reflow can cause package delamination, cracks, and die or wire-bond damage; leadless joints and flexible assemblies require controlled handling and appropriate inspection. AEC separately treats initial qualification, abnormal-lot detection, defect-prevention controls, and mounted-component reliability, so approved parts and one-time design qualification do not establish continuing production conformance.
- **RFC implication:** Each batch must bind a versioned manufacturing-conformance profile and traceable evidence for line/process controls, per-unit security-functional end-of-line tests, lot genealogy, excursion thresholds, and hold or quarantine decisions; otherwise valid credentials can cover assemblies that never met the evaluated passive-power, activation, tamper, or reliability behavior.
- **Disposition:** Candidate accepted as C-076.

### 2026-07-16 - Review 7

- **Area:** Handled-coin humidity, ionic contamination, and corrosion qualification.
- **Investigation:** Compared IEC damp-heat and salt-mist methods with NASA workmanship guidance and a documented long-storage failure involving ionic contamination beneath conformal coating.
- **Primary sources:** [IEC 60068-2-78:2025](https://webstore.iec.ch/en/publication/82357), [IEC 60068-2-11:2021](https://webstore.iec.ch/en/publication/64484), [NASA-STD-8739.1B Change 2](https://standards.nasa.gov/sites/default/files/standards/NASA/B/2/nasa-std-87391B-Change-2.pdf), [NASA Lesson 607](https://llis.nasa.gov/lesson/607).
- **Material facts:** Damp heat addresses high-humidity exposure, while salt mist can reveal coating pores and discontinuities. Fingerprints and process salts can form conductive ionic paths in moisture, and moisture permeating conformal coating can combine with trapped contamination to create leakage or corrosion along interfaces and between traces.
- **RFC implication:** C-018's mission profile must define realistic contamination and humidity/salt exposure with post-exposure checks of RF-off state, power margin, activation inputs, tamper continuity, display, persistent state, and seals; C-076 must control production cleanliness and coating/seal coverage, while deliberate chemical or conductive bypass remains within C-019.
- **Disposition:** No new complaint; reinforced C-003, C-013, C-014, C-015, C-018, C-019, C-067, and C-076.

### 2026-07-16 - Review 8

- **Area:** Ingestion and small-part safety of a circulating coin-sized electronic token.
- **Primary sources:** [EU Regulation 2023/988](https://eur-lex.europa.eu/eli/reg/2023/988/oj?locale=en), [16 CFR 1501.4](https://www.ecfr.gov/current/title-16/chapter-II/subchapter-C/part-1501/section-1501.4), [CPSC Small Parts Guidance](https://www.cpsc.gov/Business--Manufacturing/Business-Education/Business-Guidance/Small-Parts-for-Toys-and-Childrens-Products).
- **Material facts:** EU consumer-product safety assessment includes design, composition, presentation, vulnerable consumers, foreseeable child use, documented risk analysis, and continuing series-production conformity. The US small-parts procedure provides a quantitative engineering precedent by testing whether the whole article or any part detached after use-and-abuse conditioning fits completely within a specified cylinder, although its direct legal scope is narrower.
- **RFC implication:** Before geometry is frozen, each intended market needs a physical-product-safety profile covering whole-token dimensions, foreseeable-abuse conditioning, detached-part retention and testing, production controls, configuration changes, and refurbishment.
- **Disposition:** Candidate accepted as C-081.

### 2026-07-16 - Review 9

- **Area:** Sharp-edge and sharp-point hazards after foreseeable token damage.
- **Primary sources:** [16 CFR 1500.48](https://www.ecfr.gov/current/title-16/chapter-II/subchapter-C/part-1500/section-1500.48), [16 CFR 1500.49](https://www.ecfr.gov/current/title-16/chapter-II/subchapter-C/part-1500/section-1500.49), [16 CFR 1500.50-1500.51](https://www.govinfo.gov/link/cfr/16/1500?link-type=pdf&sectionnum=51&year=mostrecent), [EU Regulation 2023/988](https://eur-lex.europa.eu/eli/reg/2023/988/oj?locale=en).
- **Material facts:** US rules separately test accessible sharp points and sharp metal or glass edges before and after normal-use and foreseeable-damage conditioning; the cited child-product rules provide quantitative engineering precedents rather than automatic legal classification. EU rules more broadly require documented assessment and mitigation of consumer-product risks and continued production conformity.
- **RFC implication:** Complete production-representative tokens need market-appropriate edge and point inspection after realistic drop, impact, flexure, abrasion, temperature, aging, and refurbishment conditioning, with results tied to change control, manufacturing conformance, and damaged-coin handling.
- **Disposition:** Candidate accepted as C-082.

### 2026-07-16 - Review 10

- **Area:** Chemical composition and contact safety of a repeatedly handled passive electronic coin.
- **Primary sources:** [EU REACH PAH amendment](https://eur-lex.europa.eu/eli/reg/2013/1272/oj/eng), [REACH consolidated Annex XVII](https://eur-lex.europa.eu/eli/reg/2006/1907/2026-05-11/eng), [EU RoHS Directive](https://eur-lex.europa.eu/legal-content/en/TXT/?uri=CELEX%3A32011L0065), [EU General Product Safety Regulation](https://eur-lex.europa.eu/eli/reg/2023/988/oj?locale=en).
- **Material facts:** REACH restricts specified PAHs in rubber or plastic components with repetitive skin or oral contact and limits nickel release for covered prolonged-contact articles. RoHS sets homogeneous-material limits for specified hazardous substances in covered electrical and electronic equipment, while the General Product Safety Regulation requires chemical-risk assessment, technical documentation, and continuing production conformity.
- **RFC implication:** A market-specific material-safety profile must inventory homogeneous materials and accessible surfaces, classify foreseeable exposure, test relevant composition and release after aging and wear, and bind evidence to configuration, production, and refurbishment controls.
- **Disposition:** Candidate accepted as C-089.

### 2026-07-16 - Review 11

- **Area:** Electrical-shock and electrically caused fire safeguards for the powered register.
- **Primary sources:** [IEC 62368-1:2023](https://webstore.iec.ch/en/publication/69308), [EU Low Voltage Directive](https://eur-lex.europa.eu/eli/dir/2014/35/oj/eng).
- **Material facts:** IEC 62368-1 classifies energy sources and safeguards, covers external supplies and complete equipment, and requires protection during normal, abnormal, and single-fault conditions, including wiring, ignition, fire containment, conductive-object entry, and liquid spillage. The Low Voltage Directive supplies a market-specific precedent for shock, thermal, arc, insulation, overload, documentation, and manufacturing controls where its voltage scope applies.
- **RFC implication:** The complete register needs a versioned electrical-safety profile covering supply energy, access classes, insulation, wiring, overcurrent and thermal safeguards, ingress, fault testing, fire containment, and production configuration control; an approved adapter alone is insufficient.
- **Disposition:** Candidate accepted as C-090.

### 2026-07-16 - Review 12

- **Area:** Complete-register electromagnetic compatibility and 13.56 MHz spectrum conformance.
- **Primary sources:** [EU Radio Equipment Directive](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32014L0053), [EU EMC Directive](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32014L0030), [ETSI EN 300 330 V2.1.1](https://www.etsi.org/deliver/etsi_en/300300_300399/300330/02.01.01_60/en_300330v020101p.pdf), [ETSI EN 301 489-3 V2.3.2](https://www.etsi.org/deliver/etsi_en/301400_301499/30148903/02.03.02_60/en_30148903v020302p.pdf), [IEC 61000-4-39:2017](https://webstore.iec.ch/en/publication/30202).
- **Material facts:** EU rules require radio equipment to use spectrum efficiently, avoid harmful interference, and tolerate expected electromagnetic disturbance. ETSI's inductive-radio standard covers 13.56 MHz NFC/RFID equipment and complete systems with transponders, while its short-range-device EMC standard treats emissions, immunity, ports, operating modes, and unplanned mode transitions; IEC separately addresses close-proximity transmitter immunity.
- **RFC implication:** A complete-equipment radio and EMC profile must define field mode, emissions, ports, configurations, disturbances, and payment-specific criteria that prohibit unintended field, motion, claim, custody, authorization, receipt, identity, or persistent-state transitions and require bounded fail-closed recovery.
- **Disposition:** Candidate accepted as C-091.

### 2026-07-16 - Review 13

- **Area:** Complete-register stability, support, anchoring, and relocation safety.
- **Primary sources:** [IEC 62368-1:2023](https://webstore.iec.ch/en/publication/69308), [Regulation (EU) 2023/1230](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng).
- **Material facts:** IEC 62368-1 treats equipment instability, mounting failure, handle failure, and cart or stand instability separately from moving-part hazards, with dedicated stability, mounting, handle, caster, impact, drop, and glass tests. The EU machinery regulation independently requires equipment and fittings to resist overturning, falling, uncontrolled movement, expected stress, and guard detachment, while documenting anchorage where installation alone is insufficient.
- **RFC implication:** The register needs a defined installation and support configuration plus complete-equipment evidence for its least stable operational and service states, including center of gravity, user loads, mounting, stands, fasteners, relocation, inspection, and configuration control.
- **Disposition:** Candidate accepted as C-095.

### 2026-07-16 - Review 14

- **Area:** Complete-register transport, shock, vibration, and rough-handling qualification.
- **Primary sources:** [IEC 60068-1:2013](https://webstore.iec.ch/en/publication/501), [IEC 60721-3-2:2018](https://webstore.iec.ch/en/publication/29793), [IEC 60721-3-3:2019](https://webstore.iec.ch/en/publication/32620), [IEC 60068-2-27:2008](https://webstore.iec.ch/en/publication/514), [IEC 60068-2-31:2008](https://webstore.iec.ch/en/publication/516), [IEC 60068-2-64:2008+A1:2019](https://webstore.iec.ch/en/publication/547).
- **Material facts:** IEC environmental methods require the product specification to tailor tests and severities to actual transport, handling, installation, and stationary-use conditions. Shock, drop, topple, and random-vibration methods expose structural weakness and accumulated degradation, but do not themselves define mounting state, packaging boundary, operating state, or safety and payment acceptance criteria.
- **RFC implication:** Production-register qualification should map real shipment, relocation, service, and use environments to complete-equipment conditioning, then recheck custody, motion, RF, thermal, electrical, EMC, and stability invariants.
- **Disposition:** No new complaint; reinforced C-042, C-043, C-074, C-087, C-088, C-090, C-091, and C-095.

### 2026-07-16 - Review 15

- **Area:** Safety-related control allocation and validation for the powered register.
- **Primary sources:** [ISO 12100:2010](https://www.iso.org/standard/51528.html), [ISO 13849-1:2023](https://www.iso.org/standard/73481.html), [ISO 13849-2:2012](https://www.iso.org/standard/53640.html), [IEC 62061:2021+A1:2024+A2:2026](https://webstore.iec.ch/en/publication/112847), [ISO 14119:2024](https://www.iso.org/standard/75942.html), [ISO 14118:2017](https://www.iso.org/standard/66460.html).
- **Material facts:** The standards require risk-based definition, design, integration, and validation of safety functions, including architecture, diagnostics, common-cause failures, software, foreseeable interlock defeat, stored energy, unexpected restart, configuration, and proof testing. A transparent guard, ordinary sensor, software stop, or component reliability figure alone does not establish a validated safety function.
- **RFC implication:** Resolving the existing motion-safety complaint requires defining each hazardous state and safety-function boundary, selecting integrity from risk, and validating sensing, logic, final elements, response time, restart, maintenance, and fault behavior in every operating and service mode.
- **Disposition:** No new complaint; reinforced C-003, C-042, C-053, C-074, C-080, C-090, C-091, and C-095.

### 2026-07-16 - Review 16

- **Area:** Powered-register physical security boundary and tamper lifecycle.
- **Primary sources:** [PCI SSC PTS POI v7.0 announcement](https://blog.pcisecuritystandards.org/just-published-pts-poi-v7-0), [PCI PTS POI Evaluation FAQs v5](https://listings.pcisecuritystandards.org/documents/PTS_POI_Technical_FAQs_v5_Dec__2020.pdf), [FIPS 140-3](https://csrc.nist.gov/pubs/fips/140/3/final), [NIST SP 800-140](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-140.pdf), [NIST SP 800-193](https://csrc.nist.gov/pubs/sp/800/193/final).
- **Material facts:** Complete-device physical security requires an explicit boundary and coordinated treatment of penetration, security keys, critical configuration, maintenance interfaces, firmware, detection, response, recovery, and configuration changes. A secure element or authenticated application alone does not establish those properties for an assembled register.
- **RFC implication:** These requirements provide concrete resolution criteria for the malicious-register, custody-continuity, hostile-peripheral, administration, and executable-integrity complaints.
- **Disposition:** No new complaint; reinforced C-003, C-041, C-042, C-056, C-073, C-080, and consequence-specific lifecycle and safety complaints.
