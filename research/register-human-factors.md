# Register and human-factors research log

## Covered areas

- Hostile NFC tender data as a parser and shared-register compromise surface.
- Accessibility of software-controlled quote expiration.
- Authorization, change control, and auditability for register administration.
- Human safety of powered register motion and jam-clearing workflows.
- Physical reach, approach, and operating-force accessibility for customer-facing register hardware.
- Unicode visual spoofing and safe rendering of security-relevant register and receipt text.
- Register-controller executable integrity across boot, update, rollback, and recovery.
- Human RF exposure and active-medical-device interference from the register's NFC powering field.
- Inductive heating, foreign-object detection, and returned-object touch temperature in an NFC-powered register.
- Choking and detached-small-part hazards of a circulating token.
- Chemical exposure from accessible token materials after circulation wear and refurbishment.
- Electrical-shock and electrically caused fire hazards in the complete powered register.

## Research entries

### 2026-07-16 - Review 1

- **Area:** Hostile NFC coin input as a register-compromise vector.
- **Investigation:** Traced an official Android NFC vulnerability to its corrective source commit and compared NIST untrusted-input guidance.
- **Primary sources:** [Android Security Bulletin, March 2017](https://source.android.com/docs/security/bulletin/2017-03-01), [AOSP libnfc-nci fix](https://android.googlesource.com/platform/external/libnfc-nci/+/c67cc6ad2addddcb7185a33b08d27290ce54e350), [NIST Mobile Threat Catalogue APP-11](https://pages.nist.gov/mobile-threat-catalogue/application-threats/APP-11.html).
- **Material facts:** A proximate NFC attacker obtained privileged code-execution potential through an unsafe length operation. Authentication cannot protect the parser that must process bytes before authentication.
- **RFC implication:** The register needs a normative hostile-input boundary and isolation from monetary and mechanical control.
- **Disposition:** Produced C-056.

### 2026-07-16 - Review 2

- **Area:** Accessibility of software-controlled exchange-quote expiration during approval.
- **Investigation:** Applied WCAG timing requirements and WCAG2ICT guidance to the register's quoted countdown.
- **Primary sources:** [WCAG 2.2](https://www.w3.org/TR/WCAG22/#timing-adjustable), [WCAG2ICT 2.2](https://www.w3.org/TR/wcag2ict-22/#timing-adjustable), [Understanding SC 2.2.1](https://www.w3.org/WAI/WCAG22/Understanding/timing-adjustable.html).
- **Material facts:** Software time limits generally require disabling, adjustment, or repeated extension; real-time and essential exceptions are narrow.
- **RFC implication:** A fresh quote after extended review must preserve the basket, display changed terms, and require renewed approval.
- **Disposition:** No new complaint; duplicate of C-039, C-044, and C-003. Clean streak is 1.

### 2026-07-16 - Review 3

- **Area:** Authorization, change control, and auditability for local and remote register administration.
- **Investigation:** Compared the RFC's merchant configuration and terminal-management boundary with PCI payment-terminal controls and NIST controls for least privilege, separation of duties, controlled configuration changes, and protected audit records.
- **Primary sources:** [PCI P2PE v3.1 Standard](https://www.pcisecuritystandards.org/documents/PCI-P2PE-v3_1-Standard.pdf), [PCI SSC FAQ 1301](https://www.pcisecuritystandards.org/faqs/1301/), [NIST SP 800-53 Rev. 5](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r5.pdf).
- **Material facts:** Deployed payment-device guidance requires attributable individual access, least privilege, strong remote authentication, restricted configuration authority, and retained logs. NIST controls additionally support separation of duties, dual authorization for sensitive changes, and protection of audit information. These sources are engineering analogues, not a claim that card-industry rules govern this register.
- **RFC implication:** Security-critical merchant identity, settlement destination, policy, operator, and receipt settings need a merchant-authenticated, rollback-resistant configuration lifecycle with separated roles, dual authorization for critical changes, out-of-band alerts, and tamper-evident off-device audit records.
- **Disposition:** Candidate R3-001 accepted as C-073.

### 2026-07-16 - Review 4

- **Area:** Human-injury hazards from powered register motion, unexpected restart, and hazardous energy during use and servicing.
- **Investigation:** Compared the proposed gates, pressing rails, center lever, return path, and service openings with primary US machine-guarding and hazardous-energy rules and EU machinery design requirements. Applicability varies by deployment and jurisdiction; the sources provide engineering baselines rather than a legal conclusion.
- **Primary sources:** [OSHA 29 CFR 1910.212](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.212), [OSHA 29 CFR 1910.147](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.147), [Regulation (EU) 2023/1230](https://eur-lex.europa.eu/eli/reg/2023/1230/oj/eng).
- **Material facts:** Machinery safety baselines require guarding against reachable point-of-operation and nip hazards, control of unexpected energization and stored energy during servicing, risk assessment for intended and foreseeable abnormal use, interlocked guards, safe unblocking measures, and prevention of unexpected restart.
- **RFC implication:** The register needs a separate physical-safety gate that either makes hazardous motion unreachable or validates force and energy below a selected injury limit, plus fail-safe access interlocks, hardware energy isolation for jam clearing, local-reset restart behavior, and single-fault validation.
- **Disposition:** Candidate R4-001 accepted as C-074.

### 2026-07-16 - Review 5

- **Area:** Physical reach, approach, and low-force operation for customer-facing register hardware.
- **Investigation:** Compared the register's coin input, decision controls, return path, and receipt delivery with US DOJ ADA design standards, a DOJ point-of-sale enforcement agreement, and US Access Board transaction-machine guidance; these are engineering baselines, not a universal legal-applicability conclusion.
- **Primary sources:** [2010 ADA Standards](https://www.ada.gov/law-and-regs/design-standards/2010-stds/), [DOJ Family Dollar settlement](https://archive.ada.gov/family_dollar_5720_sa.html), [US Access Board Chapter 7](https://www.access-board.gov/ada/chapter/ch07/).
- **Material facts:** The cited standards specify a 30-by-48-inch clear floor space, a generally 15-to-48-inch unobstructed reach range, and one-hand operation without tight grasping, pinching, or wrist twisting at no more than 5 pounds (22.2 N) activation force. Transaction-machine guidance also supports tactilely distinguishable controls and equivalent privacy.
- **RFC implication:** C-044 acceptance criteria should cover the complete physical workflow: approach and required knee/toe clearance, measured reach to input, approve/cancel controls, returns and receipts, one-hand operation within a selected force limit, and an equivalent private output path, reconciled with deliberate-consent and machine-safety requirements.
- **Disposition:** No new complaint; materially sharpens C-044.

### 2026-07-16 - Review 6

- **Area:** Unicode visual spoofing in financial confirmation and receipt text.
- **Investigation:** Applied Unicode security guidance on bidirectional controls, confusables, mixed-script digits, identifier profiles, default-ignorable characters, and missing-glyph behavior to asset, merchant, quote, warning, and receipt fields.
- **Primary sources:** [Unicode Technical Report #36](https://www.unicode.org/reports/tr36/tr36-15.html), [Unicode Technical Standard #39](https://www.unicode.org/reports/tr39/).
- **Material facts:** Logical and displayed character order can differ; visually confusable strings and mixed-script numerals can mislead people while remaining distinct to software. Unicode guidance provides normalization and identifier profiles, script and mixed-number restrictions, confusable detection, and restrictions on controls, default ignorables, private-use, unassigned, unsupported, and ambiguously rendered characters.
- **RFC implication:** Security-relevant identities, amounts, currency, destinations, fees, and validity must derive from typed canonical data and trusted labels. Externally supplied text needs a documented Unicode profile, direction isolation, fixed trusted rendering, length and layout bounds, and fail-closed or escaped handling for dangerous controls, mixed-script numbers, unsupported glyphs, and clipping when resolving C-002, C-039, C-045, C-051, and C-056.
- **Disposition:** No new complaint; concrete mechanism already covered by the cited authorization, arithmetic, identity, comprehension, and hostile-input complaints.

### 2026-07-16 - Review 7

- **Area:** Register-controller firmware and application integrity across boot, update, rollback, and recovery.
- **Investigation:** Compared the register's mechanical-controller trust boundary with NIST platform-firmware resiliency guidance and PCI point-of-interaction requirements as a payment-terminal engineering analogue, not a claim of PCI applicability.
- **Primary sources:** [NIST SP 800-193](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-193.pdf), [PCI PTS POI v6.1](https://www.pcisecuritystandards.org/documents/PCI_PTS_POI_SRs_v6-1_Final.pdf), [PCI SSC POI v7.0 publication notice](https://blog.pcisecuritystandards.org/just-published-pts-poi-v7-0).
- **Material facts:** NIST defines protected roots and chains of trust for authenticated update, pre-use corruption detection, and authentic recovery, including exclusive authorized update paths and power-loss-resilient recovery. PCI POI requirements provide concrete precedents for authenticated firmware and applications, replay-protected updates, integrity self-tests with secure failure, executable signing, application and security-domain separation, and a minimal least-privilege operating system.
- **RFC implication:** The controller needs a hardware-anchored authenticated boot chain; signed versioned anti-rollback updates and protected recovery; controlled debug and alternate boot; separation of tender parsing, UI, networking, receipt, and actuator/claim functions; protected keys; fail-closed integrity tests; maintenance guards for unresolved tender, authorization, settlement, or custody state; and authenticated measurements in administration and off-device audit records.
- **Disposition:** Candidate R7-001 accepted as C-080.

### 2026-07-16 - Review 8

- **Area:** Human RF exposure and interference with active implanted medical devices from the register's NFC powering field.
- **Primary sources:** [NFC Forum technology overview](https://nfc-forum.org/learn/nfc-technology/), [FDA RFID safety guidance](https://www.fda.gov/radiation-emitting-products/electromagnetic-compatibility-emc/radio-frequency-identification-rfid), [Seidman et al. RFID interference study](https://doi.org/10.1016/j.hrthm.2009.09.071), [47 CFR 1.1310](https://www.ecfr.gov/current/title-47/chapter-I/subchapter-A/part-1/subpart-I/section-1.1310), [FDA recognition record for AIM 7351731](https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfStandards/detail.cfm?standard__identification_no=43129).
- **Material facts:** NFC uses a 13.56 MHz field that can power a passive peer. FDA identifies RFID interference with pacemakers, ICDs, and other electronic medical devices as a testing and mitigation concern; an FDA-supported in-vitro study observed 13.56 MHz reader reactions in 6% of pacemaker tests at up to 22.5 cm and 1% of ICD tests at up to 7.5 cm. Tissue-exposure limits and medical-device immunity are separate acceptance questions.
- **RFC implication:** Bind the reader, antenna, enclosure, installation, field strength, modulation, duty cycle, and hardware-enforced maximum on-time into an assembled-product RF/EMC safety profile; test worst-case and single-fault states, document installation constraints, and preserve an equivalent workflow for users who cannot enter the validated field region.
- **Disposition:** Candidate R8-001 accepted as C-087.

### 2026-07-16 - Review 9

- **Area:** Inductive heating, foreign-object detection, and safe returned-object temperature in an NFC-powered register.
- **Primary sources:** [NFC Forum wireless charging](https://nfc-forum.org/build/specifications/wireless-charging/), [NFC Forum wireless-charging specification announcement](https://nfc-forum.org/news/2019-02-single-antenna-handles-iot-wireless-charging-and-communications-new-nfc-forum-candidate-specification-available-for-comment/), [NFC Forum Technical Committee Glossary](https://nfc-forum.org/uploads/Certification-Files/nfcforum-tc-glossary-1-2-00.pdf), [ST AN5584](https://www.st.com/resource/en/application_note/an5584-st25r39xx-nfc-reader-thermal-design-stmicroelectronics.pdf), [IEC 62368-1:2023](https://webstore.iec.ch/en/publication/69308).
- **Material facts:** NFC wireless-power profiles distinguish standard-field operation from higher-power negotiated modes and define coins, paperclips, and tags as foreign objects that can heat or be damaged; the profile uses pre-transfer and ongoing detection to stop power. Continuous-wave operation is a maximum reader-dissipation condition, while thermal injury depends on temperature, thermal mass, heat transfer, and contact duration rather than RF compliance alone.
- **RFC implication:** Select and bound the permitted power mode, field, duty cycle, retry duration, and temperature; independently shut down on unknown loads, lost communication, abnormal antenna behavior, overtemperature, or timeout; and validate approved, damaged, stacked, foreign, jammed, and single-fault cases before returning any object for immediate handling.
- **Disposition:** Candidate R9-001 accepted as C-088.

### 2026-07-16 - Review 10

- **Area:** Whole-token choking and detached-small-part hazards after foreseeable circulation, wear, abuse, and refurbishment.
- **Primary sources:** [CPSC small-parts guidance](https://www.cpsc.gov/Business--Manufacturing/Business-Education/Business-Guidance/Small-Parts-for-Toys-and-Childrens-Products), [16 CFR Part 1501 summary](https://www.cpsc.gov/s3fs-public/Small-Parts-16-C-F-R-Part-1501-English.pdf), [EU General Product Safety Regulation](https://eur-lex.europa.eu/eli/reg/2023/988/oj), [Commission Decision (EU) 2023/1338](https://eur-lex.europa.eu/eli/dec/2023/1338/oj/eng), [pediatric foreign-body ingestion study](https://pmc.ncbi.nlm.nih.gov/articles/PMC6843858/).
- **Material facts:** The CPSC small-parts cylinder is 31.7 mm wide and evaluates whole objects, separate parts, and pieces released by simulated use or abuse. EU safety baselines require documented risk analysis, consideration of vulnerable consumers, and controls against small parts detaching during use or foreseeable drops; clinical evidence identifies coins as a common pediatric ingestion object.
- **RFC implication:** Resolve whole-token airway geometry and conditioned component-retention criteria before circulation, and test every accessible or releasable part after representative aging, drops, washing, abrasion, tamper damage, and refurbishment, with retirement criteria for unsafe damage.
- **Disposition:** No new complaint; duplicate of C-081.

### 2026-07-16 - Review 11

- **Area:** Toxic-substance and skin-sensitizer exposure from accessible token materials after circulation wear and refurbishment.
- **Primary sources:** [EU General Product Safety Regulation](https://eur-lex.europa.eu/eli/reg/2023/988/2026-05-29/eng), [REACH consolidated text](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02006R1907-20251023), [RoHS Directive](https://eur-lex.europa.eu/eli/dir/2011/65/oj/eng), [RoHS Annex II amendment](https://eur-lex.europa.eu/eli/dir_del/2015/863/oj/eng).
- **Material facts:** EU product-safety rules require assessment of composition, foreseeable use, vulnerable consumers, likely mouthing, and reconditioned products. REACH provides lead limits for mouthable general-public articles and nickel-release limits for covered skin-contact parts, including durability conditions where coatings provide compliance; RoHS separately limits specified substances in homogeneous electrical and electronic materials within its scope.
- **RFC implication:** The evaluated token assembly needs controlled material declarations and applicable concentration, migration, and release criteria, tested after representative saliva, sweat, washing, abrasion, aging, damage, and refurbishment conditioning; supplier declarations and initial coating integrity alone do not establish post-circulation safety.
- **Disposition:** No new complaint; duplicate of C-089. Clean streak is 2.

### 2026-07-16 - Review 12

- **Area:** Electrical shock, fault-current heating, arcing, and fire in the complete powered register.
- **Primary sources:** [IEC 62368-1:2023](https://webstore.iec.ch/en/publication/69308), [EU Low Voltage Directive](https://eur-lex.europa.eu/eli/dir/2014/35/oj/eng), [OSHA 29 CFR 1910.303](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.303), [OSHA 29 CFR 1910.304](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.304), [OSHA 29 CFR 1910.305](https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.305).
- **Material facts:** Hazard-based electrical safety classifies energy sources and requires safeguards against injury and fire. The cited EU and US baselines address direct and indirect contact, insulation, earthing and fault clearing, overload, dangerous temperatures and arcs, contamination and wet conditions, guarding live parts, suitable cords, and strain relief; safety is a property of the assembled and installed register, not merely its external adapter.
- **RFC implication:** The register needs a selected end-product safety profile binding its supply, wiring, insulation or earthing, protective devices, actuators, reader stage, enclosure, openings, materials, installation, contamination exposure, service isolation, and abnormal and single-fault tests.
- **Disposition:** No new complaint; duplicate of C-090. Clean streak is 3.
