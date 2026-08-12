# Privacy, attestation, and trust research log

## Covered areas

- Opening and tracing authorities in anonymous hardware-attestation schemes.
- Public inventory accountability for unlinkable anonymous-attestation credential issuance.
- Privacy trust boundaries and proof-randomness control in split anonymous-attestation implementations.
- Cryptographic statement-type binding and delegated scope for trust metadata.
- Pre-connection phone identity leakage in Bluetooth and nearby-peer discovery for offline BSLRR transfer.
- Cumulative manufacturing-quota enforcement across batch issuances and transparency services.
- Canonical construction and count-bound verification of manufacturing-inventory Merkle commitments.
- Soundness and governance of structured setup for zero-knowledge manufacturing-inventory membership proofs.
- Revocation-dependent resource growth and anonymity tradeoffs for passive anonymous attesters.
- Cryptographic co-binding of anonymous membership, current attestation evidence, and verifier freshness.
- Cryptographic binding of an NFC bootstrap to the authenticated BSLRR bulk-transfer channel and coin update.
- Backward unlinkability of anonymous attestations after member-secret exposure or revocation disclosure.
- Active linkability from verifier-controlled or malicious signature-revocation inputs.
- Witness confidentiality when private-refresh zero-knowledge proof generation is delegated.
- Anonymity-set partitioning and timing correlation in short-lived anonymous-credential issuance.
- Verifier-client telemetry, diagnostic leakage, and installed-binary update provenance.

## Research entries

### 2026-07-16 - Review 1

- **Area:** Authority-level privacy in anonymous attestation, especially group-signature opening.
- **Investigation:** Compared generic group signatures, DAA, TPM credential behavior, and WebAuthn privacy guidance.
- **Primary sources:** [ISO/IEC 20008-2:2013](https://www.iso.org/standard/56916.html), [Direct Anonymous Attestation](https://research.ibm.com/publications/direct-anonymous-attestation), [TCG TPM 1.2 Part 1](https://trustedcomputinggroup.org/wp-content/uploads/Main-Part1-Rev94.pdf), [WebAuthn Level 3](https://www.w3.org/TR/webauthn-3/).
- **Material facts:** Group signatures may support opening and linking. DAA was designed without signature opening, while credential multiplicity and replacement can create separate lifecycle concerns.
- **RFC implication:** "Anonymous" needs an explicit threat model against the scheme's own administrative authorities.
- **Disposition:** Produced C-062; replacement concerns were duplicates of C-031 and C-032.

### 2026-07-16 - Review 2

- **Area:** Public inventory accountability for unlinkable anonymous-attestation credential issuance.
- **Investigation:** Traced DAA enrollment and verification semantics to determine whether issuer-approved anonymous membership consumes a publicly committed manufacturing-inventory leaf.
- **Primary sources:** [IETF RATS DAA draft](https://www.ietf.org/archive/id/draft-ietf-rats-daa-07.html), [Brickell and Li DAA construction](https://iacr.org/archive/pkc2007/44500016/44500016.pdf), [Direct Anonymous Attestation](https://doi.org/10.1145/1030083.1030103).
- **Material facts:** DAA issuers use a group private key to admit members, while verifiers validate randomized credentials under the group public key without learning member identity. Generic DAA proves issuer-approved membership but does not publicly audit membership count or bind each credential to an external manifest leaf.
- **RFC implication:** A logged group key, count, and Merkle root constrain issuance only if every accepted membership is cryptographically linked to one precommitted leaf with one credential lineage per leaf; otherwise the issuer remains an unbounded provenance authority.
- **Disposition:** Candidate PT-002-01 accepted as C-069; opening, shared-secret compromise, field fingerprinting, and log split-view concerns remained duplicates.

### 2026-07-16 - Review 3

- **Area:** Privacy trust boundaries and ephemeral-randomness control in split anonymous-attestation implementations.
- **Investigation:** Compared the RFC's secure-element-plus-host architecture with FIDO ECDAA, TCG ECDAA operations and certification, and CFRG BBS proof-randomness requirements.
- **Primary sources:** [FIDO ECDAA Algorithm v2.1](https://fidoalliance.org/specs/common-specs/fido-ecdaa-algorithm-v2.1-rd-20210525.pdf), [TCG TPM protection profile](https://trustedcomputinggroup.org/wp-content/uploads/Protection-Profile-PC-Client-Specific-TPM-TPM-Library-Spec-Family-2.0_Version-2.0_pub.pdf), [TPM 2.0 Library Part 3](https://trustedcomputinggroup.org/wp-content/uploads/Trusted-Platform-Module-2.0-Library-Part-3-Version-184_pub.pdf), [CFRG BBS Signatures draft](https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-bbs-signatures-10).
- **Material facts:** FIDO places ECDAA credential randomization in the ASM and requires both ASM and authenticator to be honest for anonymity. BBS proofs require fresh uniform scalars; reused, predictable, or malicious randomness can expose hidden material or carry an undetected tag. A valid secure-element operation therefore does not alone establish unlinkability.
- **RFC implication:** Anonymous-attestation profiles must define and certify the complete privacy-critical prover boundary, constrain host-controlled framing and context, and require reset-safe per-presentation randomness; otherwise a conforming split implementation can remain unforgeable while becoming trackable.
- **Disposition:** Candidate PT-003-01 accepted as C-070; key entropy, disclosed-field fingerprinting, opening, firmware measurement, extraction, and unlogged issuance remained duplicates.

### 2026-07-16 - Review 4

- **Area:** Cryptographic statement-type binding and machine-enforced delegation scope for trust metadata.
- **Investigation:** Traced signing-role separation through verifier authorization and compared the missing type and scope semantics with DSSE, in-toto, Sigstore bundles, and TUF delegation rules.
- **Primary sources:** [DSSE protocol](https://github.com/secure-systems-lab/dsse/blob/master/protocol.md), [in-toto envelope specification](https://github.com/in-toto/attestation/blob/main/spec/v1/envelope.md), [TUF specification](https://theupdateframework.github.io/specification/v1.0.26/), [Sigstore bundles](https://docs.sigstore.dev/about/bundle/).
- **Material facts:** DSSE authenticates an application-specific payload type with the body and requires unsupported types to be rejected; in-toto similarly authenticates statement semantics. TUF maps keys and thresholds to roles and constrains delegated authority by scope. Signature validity alone does not establish authorization for a statement class.
- **RFC implication:** Trust metadata needs canonical authenticated object types, schema versions, role-specific key and threshold mappings, scope-constrained delegation, and deterministic rejection rules; otherwise valid laboratory, publisher, manufacturer, or batch signatures can be interpreted outside their intended authority.
- **Disposition:** Candidate PT-004-01 accepted as C-071; rollback, root recovery, signer independence, log equivocation, parser attacks, policy fragmentation, and prior anonymous-attestation issues remained duplicates.

### 2026-07-16 - Review 5

- **Area:** Pre-connection identity and linkability in Bluetooth and nearby-peer discovery used for offline BSLRR transfer.
- **Investigation:** Traced BSLRR's NFC-bootstrapped Bluetooth or peer-to-peer Wi-Fi handoff through Bluetooth address and advertising privacy rules, Android BLE advertiser controls, and Apple's Multipeer Connectivity discovery identifiers.
- **Primary sources:** [Bluetooth Core GAP 6.2](https://www.bluetooth.com/wp-content/uploads/Files/Specification/HTML/Core-62/out/en/host/generic-access-profile.html), [Bluetooth Link Layer 6.0](https://www.bluetooth.com/wp-content/uploads/Files/Specification/HTML/Core-60/out/en/low-energy-controller/link-layer-specification.html), [Android BluetoothLeAdvertiser](https://developer.android.com/reference/android/bluetooth/le/BluetoothLeAdvertiser), [Apple Multipeer Connectivity](https://developer.apple.com/documentation/multipeerconnectivity), [Apple MCPeerID](https://developer.apple.com/documentation/multipeerconnectivity/mcpeerid/init%28displayname%3A%29), [Apple MCNearbyServiceBrowser](https://developer.apple.com/documentation/multipeerconnectivity/mcnearbyservicebrowser/init%28peer%3Aservicetype%3A%29).
- **Material facts:** Bluetooth distinguishes static, resolvable-private, and non-resolvable-private addresses; peers holding an IRK can resolve resolvable-private addresses, and device names or unique advertising data can remain recognizable despite private addressing. Ordinary Android applications cannot assume control of the own-address privacy mode, while Multipeer Connectivity exposes application-selected service types and peer display names that applications may persist. These observables precede and are independent of encrypted BSLRR payloads and fresh application nonces.
- **RFC implication:** End-to-end claims that BSLRR omits stable phone identifiers require a normative, platform-tested discovery profile with per-session identities and metadata, no reusable pairing state, bounded advertising, and packet-capture conformance evidence; otherwise the claim must be limited to record contents and transport linkability disclosed.
- **Disposition:** Candidate PT-005-01 accepted as C-077; coin NFC leakage, BSLRR payload tagging, remote-feed leakage, and prior anonymous-attestation issues remained duplicates.

### 2026-07-16 - Review 6

- **Area:** Cumulative quota enforcement for manufacturing delegations across batch issuances and transparency services.
- **Investigation:** Traced a manufacturer's quantity ceiling through batch delegation, manifests, multiple logs, and relying-party verification, then compared those semantics with SCITT registration, Certificate Transparency monitoring, and PKIX issuer-global serial uniqueness.
- **Primary sources:** [RFC 9943](https://datatracker.ietf.org/doc/rfc9943/), [RFC 9162](https://www.rfc-editor.org/rfc/rfc9162.html), [RFC 5280 section 4.1.2.2](https://www.rfc-editor.org/rfc/rfc5280.html#section-4.1.2.2).
- **Material facts:** Transparency receipts prove registration of a signed statement, not its accuracy or compliance with aggregate policy; one statement may appear in multiple services, services may contain different subsets, and inclusion proofs establish only one entry's presence. CT relies on monitors to detect misissuance. PKIX's separate issuer-global serial uniqueness rule illustrates that a global namespace is an additional profile invariant. Signatures and append-only ordering therefore do not make a numeric parent allowance consumable across descendant batches.
- **RFC implication:** Quantity containment requires a stable parent-grant identity, globally unique non-overlapping allocations, deduplication across logs, complete rollback-resistant consumption state, and deterministic rejection of cumulative excess. Without those rules, quantity ceilings are monitor-audited policy promises rather than cryptographic compromise bounds.
- **Disposition:** Candidate PT-006-01 accepted as C-078; unlogged anonymous issuance, role misuse, physical-output falsity, log equivocation, and stale feeds remained duplicates.

### 2026-07-16 - Review 7

- **Area:** Canonical construction and verification of fixed manufacturing-inventory Merkle commitments.
- **Investigation:** Enumerated the parameters needed to reconstruct and verify the RFC's batch root, then compared the undefined construction with Certificate Transparency's Merkle Tree Hash and inclusion algorithms and the COSE Merkle Tree Proofs algorithm and proof identifiers.
- **Primary sources:** [RFC 9162 tree construction](https://www.rfc-editor.org/rfc/rfc9162.html#section-2.1.1), [RFC 9162 inclusion verification](https://www.rfc-editor.org/rfc/rfc9162.html#section-2.1.3.2), [COSE Merkle Tree Proofs section 4](https://datatracker.ietf.org/doc/html/draft-ietf-cose-merkle-tree-proofs-18#section-4), [COSE Merkle Tree Proofs section 5.2](https://datatracker.ietf.org/doc/html/draft-ietf-cose-merkle-tree-proofs-18#section-5.2).
- **Material facts:** RFC 9162 domain-separates leaves and internal nodes, fixes tree shape from the leaf count, and verifies inclusion using both leaf index and tree size while requiring complete path consumption. COSE Merkle Tree Proofs identifies the verifiable data structure algorithm and carries tree size, leaf index, and inclusion path because proof representations are structure-specific. A bare root and separately signed count do not establish that the root commits to exactly that count.
- **RFC implication:** The batch profile and any zero-knowledge membership circuit must bind a versioned hash and leaf encoding, domain separation, ordering, duplicate policy, non-full-tree shape, signed tree size, leaf index, and exact-path rejection rules. Otherwise oversized trees or subtree nodes can satisfy permissive membership checks under a smaller declared count, and conforming verifiers can disagree.
- **Disposition:** Candidate PT-007-01 accepted as C-079; inventory-unbound issuance, cross-batch quota reuse, split views, physical-output falsity, role misuse, fingerprinting, and parser attacks remained duplicates.

### 2026-07-16 - Review 8

- **Area:** Structured-setup soundness and governance for zero-knowledge manufacturing-inventory membership proofs.
- **Primary sources:** [Updatable and Universal Common Reference Strings with Applications to zk-SNARKs](https://eprint.iacr.org/2018/280.pdf), [Groth16](https://doi.org/10.1007/978-3-319-96878-0_24), [Zcash ZIP 224](https://zips.z.cash/zip-0224), [The Knowledge of Exponent Assumption and the Security of Groth's zk-SNARK](https://eprint.iacr.org/2016/260.pdf).
- **Material facts:** Preprocessing zk-SNARK parameters embed security-critical secret structure; a retained setup trapdoor can permit false proofs under the authentic verification key. Multi-party or updatable setup protects soundness only under its stated honest-contributor assumption, while transparent systems avoid this SRS risk.
- **RFC implication:** Anonymous inventory-membership profiles must bind parameter provenance, generation and update methods, circuit and key digests, validation evidence, and the compromise domain, or use transparent parameters; signing a verification key alone does not establish proof soundness.
- **Disposition:** Candidate PT-008-01 accepted as C-084; related Merkle, issuance, quota, role, log, opening, linkability, and proof-randomness failures remained duplicates.

### 2026-07-16 - Review 9

- **Area:** Revocation-dependent resource growth and privacy consequences for passive anonymous hardware attesters.
- **Primary sources:** [IETF RATS DAA draft, section 8](https://datatracker.ietf.org/doc/html/draft-ietf-rats-daa-09#section-8), [Enhanced Privacy ID with Enhanced Revocation](https://intel-epid-sdk.github.io/download/enhanced-privacy-id-enhanced-revocation.pdf), [Enhanced Privacy ID from Bilinear Pairing](https://eprint.iacr.org/2009/095.pdf).
- **Material facts:** EPID-style precise revocation can require an honest prover to supply a non-revocation proof for every relevant list entry, making proof size and prover and verifier work grow linearly with valid revocations. Smaller groups reduce cost but expose smaller anonymity cohorts, while group replacement requires re-keying every legitimate member.
- **RFC implication:** Each accepted profile must set maximum revocation populations within certified energy, memory, time, and transport limits and define rollover or re-credentialing before those limits; otherwise compromise response can disable assurance fleet-wide or force weaker anonymity.
- **Disposition:** Candidate PT-009-01 accepted as C-085; stale state, shared credentials, linkable handles, network lookups, parser attacks, role confusion, setup, issuance, and transport failures remained duplicates.

### 2026-07-16 - Review 10

- **Area:** Cryptographic co-binding of anonymous hardware membership, proof of possession, complete attestation evidence, and verifier freshness.
- **Primary sources:** [RFC 9334, section 10.2](https://www.rfc-editor.org/rfc/rfc9334.html#section-10.2), [IETF RATS DAA draft, section 5](https://datatracker.ietf.org/doc/html/draft-ietf-rats-daa-09#section-5), [WebAuthn packed attestation](https://www.w3.org/TR/webauthn-3/#sctn-packed-attestation), [WebAuthn cryptographic challenges](https://www.w3.org/TR/webauthn-3/#sctn-cryptographic-challenges).
- **Material facts:** RATS freshness requires the nonce and claims to be protected as signed Evidence; the DAA mapping cryptographically associates Evidence with the randomized credential; and WebAuthn signs authenticator data together with challenge-bearing client data. An adjacent membership proof and unrelated fresh signature do not establish that the enrolled anonymous member authenticated the response.
- **RFC implication:** A canonical evidence relation must jointly bind the same enrolled non-exportable member secret to every current-state field, the exact verifier challenge, and any separate response key; detached or static membership proofs must be rejected.
- **Disposition:** Candidate PT-010-01 accepted as C-086; challenge quality, relay, extraction, enrollment, issuance, proof randomness, setup, Merkle, revocation-growth, and transport failures remained duplicates.

### 2026-07-16 - Review 11

- **Area:** Cryptographic binding of the NFC/out-of-band BSLRR bootstrap to the authenticated bulk-transfer peer and coin-authorized handoff transcript.
- **Primary sources:** [Bluetooth Core 6.3 Security Manager](https://www.bluetooth.com/wp-content/uploads/Files/Specification/HTML/Core_v6.3/out/en/host/security-manager-specification.html), [Apple MCSession identity validation](https://developer.apple.com/documentation/multipeerconnectivity/mcsessiondelegate/session%28_%3Adidreceivecertificate%3Afrompeer%3Acertificatehandler%3A%29), [RFC 5056](https://www.rfc-editor.org/rfc/rfc5056.html), [RFC 9140](https://www.rfc-editor.org/rfc/rfc9140.html), [NFC Forum Connection Handover](https://nfc-forum.org/build/specifications/connection-handover-technical-specification/).
- **Material facts:** Bluetooth encryption can use an unauthenticated no-MITM association, and Multipeer Connectivity leaves peer-certificate validation to the application. Channel binding requires both endpoints to authenticate the same key exchange and negotiation before confidential data is sent; an OOB-authenticated ECDHE transcript with key confirmation prevents physical-endpoint misbinding.
- **RFC implication:** Fresh discovery identifiers and carrier encryption do not protect BSLRR history unless the NFC exchange authenticates the carrier keys and negotiated transcript and the coin update co-binds those values with roles, epoch, prior root, participant nonces, and final root.
- **Disposition:** Candidate PT-011-01 accepted as C-092; discovery leakage, participant tagging, coin NFC leakage, crash consistency, core relay, and parser failures remained duplicates.

### 2026-07-16 - Review 12

- **Area:** Backward unlinkability of archived anonymous-attestation presentations after member-secret exposure or revocation.
- **Primary sources:** [IETF RATS DAA draft, section 8](https://datatracker.ietf.org/doc/html/draft-ietf-rats-daa-09#section-8), [Enhanced Privacy ID](https://eprint.iacr.org/2007/194.pdf), [Backward Unlinkable Group Signature Schemes with Verifier-Local Revocation](https://globals.ieice.org/en_transactions/fundamentals/10.1093/ietfec/e90-a.1.65/_p).
- **Material facts:** EPID random-base signatures are unlinkable while the member secret is unknown, but private-key revocation publishes the member value and checks each signature's `(B, K)` pair using `K = B^f`. The same test applies to archived pre-compromise signatures, while backward unlinkability is a separate formally defined property.
- **RFC implication:** Unlinkability claims need an explicit post-compromise horizon, revocation-token disclosure semantics, and either a backward-unlinkable construction or epoch-evolving credentials with erased old secrets; otherwise retained transcripts become retrospectively searchable after exposure.
- **Disposition:** Candidate PT-012-01 accepted as C-093; credential forgery, opening, ordinary field linkability, proof-randomness tagging, revocation growth, stale state, and issuance failures remained duplicates.

### 2026-07-16 - Review 13

- **Area:** Anonymity under verifier-controlled or malicious signature-revocation lists.
- **Primary sources:** [An Analysis of Revocation in Group Signatures](https://eprint.iacr.org/2020/1498.pdf), [Enhanced Privacy ID with Enhanced Revocation](https://intel-epid-sdk.github.io/download/enhanced-privacy-id-enhanced-revocation.pdf), [IETF RATS DAA draft, section 8](https://datatracker.ietf.org/doc/html/draft-ietf-rats-daa-09#section-8), [Intel EPID ecosystem](https://intel-epid-sdk.github.io/ecosystem/), [ISO/IEC 20008-2:2013](https://www.iso.org/standard/56916.html).
- **Material facts:** EPID signature revocation lets a prior signature's `(B, K)` pair become a list entry and requires a member to prove it did not create that signature. A verifier that supplies a tailored list can query a candidate device: success excludes it as the prior signer, while abort or failure identifies it, creating an active linking oracle without secret exposure or an opening key.
- **RFC implication:** Revocation-list provenance, admission policy, and consistency are privacy-critical. Profiles must bind a uniform authenticated checkpoint, prevent private targeted variants, govern signature-derived entries, and analyze member-dependent failure behavior or qualify unlinkability against list controllers.
- **Disposition:** Candidate PT-013-01 accepted as C-094; backward linkage after secret exposure, opening, stable handles, stale feeds, log equivocation, role confusion, revocation growth, and detached evidence remained duplicates.

### 2026-07-16 - Review 14

- **Area:** Witness confidentiality in delegated zero-knowledge proof generation for private refresh.
- **Primary sources:** [Halo 2 proof concepts](https://zcash.github.io/halo2/concepts/proofs.html), [Orchard design](https://zcash.github.io/orchard/design.html), [Orchard keys](https://zcash.github.io/orchard/design/keys.html), [Eos delegated zkSNARK proving](https://www.usenix.org/conference/usenixsecurity23/presentation/chiesa).
- **Material facts:** Ordinary zero knowledge hides a witness from the verifier, not from the machine executing the prover with private inputs and advice. Orchard treats privacy from a delegated prover as an additional protocol property, while Eos obtains worker privacy through distributed proving under an explicit non-collusion assumption.
- **RFC implication:** A private-refresh profile must keep proving holder-controlled, specify a privacy-preserving delegation protocol and its collusion assumptions, or disclose the prover as an authority that learns the exact old-to-new asset linkage even when it receives no reusable spending key.
- **Disposition:** Candidate PT-014-01 accepted as C-096; spending-authority export, public-input substitution, interrupted lifecycle, metadata correlation, setup soundness, proof-randomness tagging, and parser failures remained duplicates.

### 2026-07-16 - Review 15

- **Area:** Anonymity-set partitioning and cross-context timing correlation in short-lived anonymous-attestation credential issuance.
- **Primary sources:** [RFC 9576 sections 6.1-6.3](https://www.rfc-editor.org/rfc/rfc9576.html#section-6.1), [RFC 9614 section 3.3](https://www.rfc-editor.org/rfc/rfc9614.html#section-3.3), [FIDO ECDAA v2.1](https://fidoalliance.org/specs/common-specs/fido-ecdaa-algorithm-v2.1-ps-20220523.html), [WebAuthn Level 3 attestation privacy](https://www.w3.org/TR/webauthn-3/#sctn-attestation-privacy).
- **Material facts:** Issuance metadata, issuer configurations, key rotation, and timing can partition otherwise unlinkable clients; cryptographic context separation alone does not prevent correlation through shared operators, identifiers, paths, or closely timed interactions.
- **RFC implication:** Short-lived credential profiles need uniform bounded configurations, minimum cohorts, globally consistent epochs, and issuance decoupled from physical verification, but these requirements apply existing protections for field fingerprinting, network correlation, authority tracing, and host-controlled proof context.
- **Disposition:** No new complaint; the assessed candidate was covered by C-035, C-036, C-062, C-069, C-070, and C-085.

### 2026-07-16 - Review 16

- **Area:** Verifier-client telemetry and diagnostic leakage, plus provenance and update security of installed verifier binaries.
- **Primary sources:** [TUF specification](https://theupdateframework.github.io/specification/latest/), [Android information-disclosure logging guidance](https://developer.android.com/privacy-and-security/risks/log-info-disclosure), [Firebase Crashlytics customization](https://firebase.google.com/docs/crashlytics/android/customize-crash-reports), [Android in-app updates](https://developer.android.com/google/play/app-updates), [Apple logging guidance](https://developer.apple.com/documentation/os/generating-log-messages-from-your-code).
- **Material facts:** Mobile applications can export verifier-visible values through ordinary network access, custom crash keys, logs, identifiers, and analytics breadcrumbs. Package-signature continuity authorizes an update but does not by itself provide rollback, freeze, key-compromise, wrong-target, or source-to-binary privacy assurance.
- **RFC implication:** Local verification implementations should prohibit protocol values in production logs and third-party telemetry, bound diagnostic collection and retention, test network egress, and publish authenticated artifacts with compromise recovery and anti-rollback controls; these widen existing disclosure, retention, and executable-integrity requirements rather than establish a new failure mode.
- **Disposition:** No new complaint; verifier telemetry and update-path risks were covered by C-035, C-036, C-053, C-080, C-029, and C-070.

### 2026-07-16 - Review 17

- **Area:** Anonymous-attestation enrollment privacy and correctness, including the identifying Join ceremony, member validation of issuer output, one-time enrollment, group-parameter consistency, and issuer/verifier collusion.
- **Primary sources:** [IETF RATS DAA draft](https://datatracker.ietf.org/doc/draft-ietf-rats-daa/), [FIDO ECDAA v2.1](https://fidoalliance.org/specs/common-specs/fido-ecdaa-algorithm-v2.1-ps-20220523.html), [Direct Anonymous Attestation](https://eprint.iacr.org/2004/205.pdf), [Formal Analysis of Privacy in Direct Anonymous Attestation Schemes](https://eprint.iacr.org/2012/650.pdf).
- **Material facts:** DAA Join is identifying enrollment; later privacy depends on the selected construction and its issuer/verifier collusion assumptions. Member-side validation of issuer-generated credentials and uniform group parameters are security requirements, and repeated or uniquely configured enrollment can partition or trace the anonymity set.
- **RFC implication:** A selected profile must bind authenticated one-time same-core enrollment, validation of issuer output, uniform group parameters, explicit collusion assumptions, and one credential lineage per logged inventory leaf.
- **Disposition:** No new complaint; reinforced C-035, C-036, C-062, C-068, C-069, C-070, C-071, C-085, and C-093.
