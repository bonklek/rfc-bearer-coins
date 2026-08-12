# Complaints log

This is an append-only review log for objections to the Physical Bearer Cryptocurrency RFC.

An entry belongs here when it identifies a concrete technical, security, economic, usability, governance, or specification problem. Similar findings are merged when they share the same underlying failure mode. Resolution of a complaint should be recorded without deleting the original objection.

## Status legend

- **Open:** not yet addressed.
- **Partially addressed:** mitigated or clarified, but the underlying concern remains.
- **Resolved:** the RFC changed or evidence answered the objection.
- **Accepted risk:** understood and deliberately retained.

Status records remediation, not product disposition. A separate `Disposition`
may record that a proposal was adopted, rejected, or deferred without erasing the
original objection.

## Complaints

Review run: 2026-07-16. Six bounded category review tracks covered hardware,
protocol state, Ethereum, privacy and trust, register and human factors, and the
business ecosystem. Findings below are deduplicated by underlying failure mode;
multiple manifestations are retained within a single entry where appropriate.

## Bounded review-discovery record

`review_saturation_reached` means the defined discovery loop produced the
required consecutive passes with no new complaint. It is not a security audit,
remediation status, assurance claim, or production-readiness signal. See
[Audit methodology](./AUDIT_METHODOLOGY.md).

```yaml
protocol_version: 2
updated: 2026-07-17
required_consecutive_clean_reviews: 3
research_logs_required: true
categories:
  hardware:
    reviews_completed: 16
    clean_streak: 3
    latest_result: no_new_complaint
    review_saturation_reached: true
  protocol_state_machine:
    reviews_completed: 6
    clean_streak: 3
    latest_result: no_new_complaint
    review_saturation_reached: true
  ethereum:
    reviews_completed: 10
    clean_streak: 3
    latest_result: no_new_complaint
    review_saturation_reached: true
  privacy_trust:
    reviews_completed: 17
    clean_streak: 3
    latest_result: no_new_complaint
    review_saturation_reached: true
  register_human_factors:
    reviews_completed: 12
    clean_streak: 3
    latest_result: no_new_complaint
    review_saturation_reached: true
  business_ecosystem:
    reviews_completed: 8
    clean_streak: 3
    latest_result: no_new_complaint
    review_saturation_reached: true
```

### C-001: Live relay can authenticate the wrong physical object

- **Status:** Partially addressed
- **Severity:** Critical
- **Affected:** [coin hardware](docs/coin-hardware.md), [verification](docs/verification-and-bslrr.md), [master architecture](docs/master-architecture.md)
- **Complaint:** Fresh nonces authenticate a reachable core, not its physical co-location with the coin being inspected. A counterfeit shell can relay a live session to a genuine activated coin elsewhere.
- **Failure mode:** One genuine backed coin serially authenticates multiple counterfeit objects during offline handoffs.
- **Requested RFC change:** Downgrade the assurance claim for local attestation and either make measured relay resistance or distance bounding a gating requirement, or require immediate claim for strong counterfeit resistance.
- **Existing RFC coverage:** None.
- **Accepted design:** D-001 limits local attestation to authenticating a responding approved core, keeps offline transfer and acceptance unrestricted, makes stronger assurance recipient-selected, requires assembled-device relay measurement, and treats immediate claim as the strongest ordinary merchant response.
- **Remaining work:** Prototype relay characterization and any future distance-bounding profile remain hardware gates. Until those exist, the system makes no physical co-location claim.

### C-002: Claim authorization is not bound to all customer-visible terms

- **Status:** Partially addressed
- **Severity:** Critical
- **Affected:** [register and checkout](docs/register-and-checkout.md), [key lifecycle](docs/key-lifecycle.md), [Ethereum accounts](docs/ethereum-accounts-and-assets.md)
- **Complaint:** The destination-bound intent does not normatively bind the merchant quote, settlement provider, fees, expiry, operation type, protocol version, schema, chain, account implementation, and basket identity in one canonical digest.
- **Failure mode:** A malicious register displays an expected quote while obtaining an authorization for a different destination, provider, fee, or operation.
- **Requested RFC change:** Define a typed `ClaimIntent` digest covering every material term and require both the coin and customer confirmation path to authenticate it.
- **Existing RFC coverage:** [Open questions](docs/open-questions.md) partially asks for the exact signed claim domain.
- **Accepted design:** D-002 defines one canonical versioned `ClaimIntent` binding the complete monetary, merchant, beneficiary, quote, fee, expiry, basket, settlement, and execution context. Coin authorization, account execution, display record, receipt, and provider settlement use the same digest without adding a customer interaction.
- **Remaining work:** The exact typed binary encoding, reference test vectors, account implementation, and conformance tests remain to be produced. The separate question of whether a malicious register displayed the signed terms is tracked by C-003.

### C-003: Mechanical button actuation does not itself prove informed consent

- **Status:** Partially addressed
- **Severity:** Critical
- **Affected:** [coin hardware](docs/coin-hardware.md), [register and checkout](docs/register-and-checkout.md), [master architecture](docs/master-architecture.md)
- **Complaint:** A register controls the rails, contacts, center actuator, display, and command input. A modified machine can bridge or secretly actuate contacts while displaying benign terms; transparent mechanics do not authenticate the electronic intent.
- **Failure mode:** The register claims a coin without the holder knowingly approving the actual authorization.
- **Requested RFC change:** Require an unpressed baseline and fresh deliberate transition, plus a customer-controlled or independently trusted confirmation path tied to the claim digest. Otherwise state that the register UI and mechanics are in the trusted computing base.
- **Existing RFC coverage:** The customer-approval open question covers only part of this problem.
- **Accepted design:** D-003 places the authoritative display, exact `ClaimIntent`, approval state, one-way gate, fresh center-button transition, actuator, and signed receipt inside one narrow evaluated secure claim controller. Normal checkout trusts that boundary without requiring a phone; an open customer verifier may independently check the same digest.
- **Remaining work:** The controller architecture, physical input sensing, display path, secure boot, isolation, receipts, optional phone exchange, and complete-register evaluation remain to be implemented and tested. A fully malicious trusted register can still deceive a customer, so that trust assumption must remain explicit.

### C-004: Monetary operations are not globally serialized

- **Status:** Partially addressed
- **Severity:** Critical
- **Affected:** [key lifecycle](docs/key-lifecycle.md), [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [privacy routes](docs/privacy-routes.md)
- **Complaint:** Claim, rotation, migration, sweep, and private refresh do not share one durable authorization state and nonce. ERC-4337 validation may also occur before execution, allowing several operations to validate against the same old state.
- **Failure mode:** Conflicting operations are simultaneously authorized, or a recovery rotation invalidates an already released claim and permits a different later spend.
- **Requested RFC change:** Define one crash-consistent `AUTH_PENDING(kind, digest, epoch, nonce)` mechanism for every monetary operation. Consume and recheck the shared semantic nonce during execution before external calls.
- **Existing RFC coverage:** None fully.
- **Accepted design:** D-004 gives claim, rotation, migration, and future private refresh one core `AUTH_PENDING` lane and one account `semanticNonce`. A pending core reproduces only the committed authorization, and the account rechecks and consumes the nonce during execution before external effects, reverting all state on failure.
- **Remaining work:** The canonical state encoding, exact pending artifact, crash-consistency implementation, account code, concurrency tests, ERC-4337 interaction tests, and a recovery protocol that first invalidates the old authorization remain unresolved.

### C-005: Chain-success evidence has no authenticated trust anchor

- **Status:** Partially addressed
- **Severity:** High
- **Affected:** [key lifecycle](docs/key-lifecycle.md), [verification](docs/verification-and-bslrr.md), [Ethereum accounts](docs/ethereum-accounts-and-assets.md)
- **Complaint:** The core is expected to accept successful-execution evidence, but the proof format, authenticated Ethereum checkpoint, finality rule, reorganization handling, and power-budget feasibility are unspecified. A chain ID or storage proof alone does not authenticate a canonical state root.
- **Failure mode:** A hostile or stale reader causes irreversible key retirement after a transaction that failed, was never canonical, or was later reorganized.
- **Requested RFC change:** Specify finality-rooted evidence anchored to a pinned genesis and authenticated checkpoint. If the passive core cannot verify it, treat external confirmation as advisory and do not automatically retire the key.
- **Existing RFC coverage:** Open questions mention evidence timing but not its trust anchor.
- **Accepted design:** D-005 makes the normal post-depletion lifecycle an ordered finite-slot series. Finalized proof that the old represented balance was depleted and its bearer authority retired closes that epoch. The next account and activation challenge are then revealed, and the coin remains `AWAITING_LOAD_PROOF` until it internally verifies a slot-bound proof of the exact finalized account, implementation, key, asset, amount, nonce, and funding state. Proof construction is permissionless; only core verification and a crash-consistent commit can produce `ACTIVE`. Balance-preserving rotation remains a separate same-account operation.
- **Remaining work:** Select and specify the finalized-chain proof system, pinned chain and fork identity, authenticated checkpoint and weak-subjectivity rules, proof public inputs, verifier key lifecycle, reorganization policy, account-state encoding, passive power and latency budget, crash-consistent storage primitive, and conformance and adversarial tests.

### C-006: A commitment is insufficient for exact authorization replay

- **Status:** Partially addressed
- **Severity:** High
- **Affected:** [coin hardware](docs/coin-hardware.md), [key lifecycle](docs/key-lifecycle.md)
- **Complaint:** A hash or reproducible commitment cannot be re-released as the original signed authorization unless the exact bytes are stored or every signing input and signature algorithm are deterministically reproducible under restricted old-key access.
- **Failure mode:** Power loss leaves a pending coin unable to deliver the authorization whose release caused the irreversible state change.
- **Requested RFC change:** Store the exact serialized authorization atomically, or normatively define deterministic regeneration, key access in the pending state, and commit-buffer sizing.
- **Existing RFC coverage:** Fully recognized as an open question, but unresolved.
- **Accepted design:** D-006 requires the core to create the normalized P-256 signature once and atomically persist its exact bytes, canonical intent digest, operation, epoch, semantic nonce, and `AUTH_PENDING` before releasing any authorization byte. Retry resupplies the canonical intent, rechecks its digest, and receives the stored signature without invoking the monetary key again. Replaceable transport wrappers are outside the stable monetary identity.
- **Remaining work:** Specify the exact persistent record encoding and maximum size, signature normalization and serialization, transactional storage primitive, intent-resupply protocol, erasure timing, settlement identifier, and power-cut, fault-injection, malformed-retry, and storage-endurance tests.

### C-007: Represented value has no exact onchain invariant

- **Status:** Partially addressed
- **Severity:** High
- **Affected:** [master architecture](docs/master-architecture.md), [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [register and checkout](docs/register-and-checkout.md)
- **Complaint:** Anyone can overfund or underfund an account. A full-balance claim can capture later deposits, a fixed claim can strand surplus after retirement, and a lesser-of rule can silently underpay. The display does not define ownership of surplus.
- **Failure mode:** A displayed denomination either overpays, underpays, or leaves inaccessible value.
- **Requested RFC change:** Require an exact represented amount and exact-amount claim, classify any mismatch as inconsistent, and define separate authorization for surplus, deficit, dust, rebasing, and unsolicited same-asset transfers.
- **Existing RFC coverage:** The amount rule is explicitly open in [open questions](docs/open-questions.md).
- **Accepted design:** D-007 fixes one represented amount and residual beneficiary during proof-activated loading. Standard claim requires at least the represented amount, sends exactly that amount to the claim destination, sends every remaining unit of the represented asset to the residual beneficiary, requires a zero ending represented-asset balance, and retires bearer authority in one reverting execution. Underfunding fails rather than silently underpaying. Unrelated token contracts are not represented value and are outside the zero-out invariant.
- **Remaining work:** Specify exact balance-delta checks, residual-beneficiary encoding and disclosure, transfer ordering and reentrancy protection, token return-value handling, fee/rebase exclusions, surplus race tests, restricted-beneficiary failure handling, gas bounds, and the finalized zero-balance and authority-retirement proof consumed by the coin.

### C-008: Finite key commitments do not prove distinct or isolated future keys

- **Status:** Partially addressed
- **Severity:** High
- **Affected:** [coin hardware](docs/coin-hardware.md), [key lifecycle](docs/key-lifecycle.md)
- **Complaint:** A Merkle commitment can include the same public key in multiple epochs and proves neither independent generation nor compartmentalization. Precommitting all public keys normally means all private keys coexist for the device lifetime.
- **Failure mode:** One invasive compromise extracts every future slot, while verifiers incorrectly infer one-time physical isolation from Merkle membership.
- **Requested RFC change:** Require certified key uniqueness and per-slot isolation/destruction with a stated compromise blast radius, or describe finite slots only as an inventory limit with no stronger security claim.
- **Existing RFC coverage:** The future-key design is already listed as open, but these claims must be narrowed now.
- **Accepted design:** D-008 removes precomputed and precommitted future monetary keys from version 1. The core certificate binds an irreversible maximum epoch count, while the core stores only the current monetary key. After finalized depletion closes an epoch, it generates the next independent key internally, atomically commits that key and the advanced epoch before revealing the public key, and attests their same-core origin. The finite count is described only as a lifecycle bound unless stronger physical isolation is evaluated.
- **Remaining work:** Specify and test the key-generation entropy profile, atomic key-and-epoch transaction, old-key destruction, no-output-before-commit behavior, maximum count enforcement, duplicate and correlation detection, fault injection, rollback resistance, and the exact compromise boundary under which future-key nonexistence remains credible.

### C-009: External risk judgments are conflated with core lifecycle state

- **Status:** Partially addressed
- **Severity:** Medium
- **Affected:** [key lifecycle](docs/key-lifecycle.md), [trust and manufacturing](docs/trust-and-manufacturing.md), [verification](docs/verification-and-bslrr.md)
- **Complaint:** `INCONSISTENT`, warnings, and endangered status mix coin-signed state, observed chain state, and client-selected feed policy even though no feed has protocol-wide authority.
- **Failure mode:** Different clients present contradictory statuses as if each were attested by the core.
- **Requested RFC change:** Model and display `coreState`, `observedChainState` with block/source/finality, and `externalRiskStatus` as separate fields with explicit authorities.
- **Existing RFC coverage:** None fully.
- **Accepted design:** D-009 requires every verifier to keep signed `coreState`, source- and finality-qualified `observedChainState`, and publisher-specific `externalRiskStatus` separate in both protocol data and presentation. External warnings remain advisory and cannot mutate the core, block its authorization, or become protocol-wide revocation.
- **Remaining work:** Define canonical encodings and freshness rules, publisher and source identifiers, conflict presentation, cached/offline behavior, primary-screen language, accessibility tests, and cross-client conformance fixtures showing that no opinion is presented as core-attested fact.

### C-010: Claim execution is not required to be atomic onchain

- **Status:** Partially addressed
- **Severity:** High
- **Affected:** [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [key lifecycle](docs/key-lifecycle.md)
- **Complaint:** The RFC says old-key invalidation should occur in the same execution only "where practical." Token calls can fail, return false, reenter, or change behavior through proxies.
- **Failure mode:** The nonce or old key is retired without asset movement, or assets move without consuming the authority.
- **Requested RFC change:** Require one reverting execution that consumes status and nonce before the external call, checks strict token success and balance delta, invalidates the old key, and moves exactly the authorized amount.
- **Existing RFC coverage:** None.
- **Accepted design:** D-010 makes claim one reverting, reentrancy-guarded account execution. It rechecks the complete intent, epoch, status, and semantic nonce; enters `EXECUTING` and consumes the nonce before external interaction; requires strict transfer success and exact balance deltas for the represented amount and surplus; requires zero ending represented-asset balance; retires authority; and emits completion. Any failure reverts every effect. The coin advances only after finalized proof of zero balance and retired authority.
- **Remaining work:** Implement and formally specify the account code, exact native and ERC-20 safe-call rules, sender and recipient balance-delta checks, reentrancy guard, proxy-policy checks, event schema, gas limits, unsupported-token exclusions, and adversarial tests for false returns, malformed returns, callbacks, upgrades, partial effects, and proof consumption.

### C-011: The passive-power operating envelope is unspecified

- **Status:** Partially addressed
- **Severity:** High
- **Affected:** [coin hardware](docs/coin-hardware.md), [register and checkout](docs/register-and-checkout.md)
- **Complaint:** There is no energy budget, coupling requirement, reservoir sizing, brownout threshold, or timing profile for attestation, irreversible writes, signatures, and e-paper updates. Phone-powered and certified-reader operations are treated as interchangeable.
- **Failure mode:** Ordinary readers cause torn writes or incomplete display updates, or the product works only in a much larger/thicker form factor than described.
- **Requested RFC change:** Publish quantitative power and timing profiles per operation and require a certified reader for mutations that phones cannot safely power.
- **Existing RFC coverage:** Several hardware questions touch pieces, but no complete envelope exists.
- **Accepted design:** D-011 assigns every operation a measured harvested-energy and timing profile. Stateless verification targets compatible phones, while continuity writes, claim, load-proof verification, key generation, rotation or migration, and display update use an open powered-reader profile unless a phone independently satisfies the same limits. The coin measures actual coupling, field stability, reservoir energy, brownout margin, and temperature and refuses before mutation when insufficient. Reader conformance is not central permission, and interruption safety remains mandatory.
- **Remaining work:** Measure and publish quantitative values for each operation and hardware revision, select reservoir and brownout circuitry, define coupling fixtures and reader negotiation, characterize phone models, specify retry and duty-cycle limits, and pass arbitrary-removal, low-field, detuning, thermal, and long-operation tests on the complete assembly.

### C-012: A signed display payload does not authenticate visible pixels

- **Status:** Open
- **Severity:** High
- **Affected:** [coin hardware](docs/coin-hardware.md), [key lifecycle](docs/key-lifecycle.md)
- **Complaint:** The core can sign intended bytes but cannot prove the physical pixels, absence of an overlay, optical readability, or completion of a power-interrupted e-paper waveform.
- **Failure mode:** A stale, partial, or covered display shows a value that no longer matches the secured state.
- **Requested RFC change:** Define torn-update behavior and a display-generation protocol, mark every incomplete image non-authoritative, and state that overlay detection is external rather than cryptographic.
- **Existing RFC coverage:** The display-atomicity open question fully recognizes the issue.

### C-013: NFC privacy is not enforced below the application protocol

- **Status:** Open
- **Severity:** High
- **Affected:** [coin hardware](docs/coin-hardware.md), [privacy routes](docs/privacy-routes.md)
- **Complaint:** Disconnecting only the secure command path can leave a static anticollision UID visible. Even after deliberate activation, lower-layer UIDs, protocol identifiers, and RF fingerprints can defeat anonymous application-layer attestation.
- **Failure mode:** Nearby readers track a coin at rest or registers track it across private rotations despite unlinkable cryptographic transcripts.
- **Requested RFC change:** Require complete RF disconnection at rest and a tested randomized or non-identifying NFC profile during active sessions, including lower-layer frame analysis.
- **Existing RFC coverage:** None.

### C-014: Tamper response can permanently destroy live backing

- **Status:** Partially addressed
- **Severity:** High
- **Affected:** [coin hardware](docs/coin-hardware.md), [master architecture](docs/master-architecture.md), [trust and manufacturing](docs/trust-and-manufacturing.md)
- **Complaint:** Automatic destruction of the monetary key after a false positive, damage, or induced sensor event can strand a funded account. A batteryless device cannot actively respond while unpowered.
- **Failure mode:** An attacker destroys bearer value by triggering a sensor without ever learning the key.
- **Requested RFC change:** Use evidence-only tamper response by default unless an onchain recovery path was established before funding. Label destructive response explicitly as possible bearer loss.
- **Existing RFC coverage:** None fully.
- **Accepted design:** D-014 makes a confirmed tamper event irreversibly set `TAMPER_SUSPECTED`, disables `ACTIVE` presentation, future loading, and future epoch generation, but preserves the current key for one exact all-three-button evacuation authorization through the shared pending lane. Finalized zero-out evidence permanently retires the core. Automatic monetary-key destruction is excluded from the ordinary consumer profile; any destructive profile must be separately labeled and backed by explicit bearer-loss acceptance or a recovery authority configured before funding.
- **Remaining work:** Define sensor confirmation and false-positive thresholds, event encoding, exact evacuation intent and account operation, power and retry profile, key-access restrictions, permanent retirement transition, destructive-profile disclosures, and adversarial tests for induced alarms, extraction races, interrupted evacuation, and attempts to reload or clear the flag.

### C-015: Refurbishment reuses security-relevant components

- **Status:** Open
- **Severity:** High
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md), [coin hardware](docs/coin-hardware.md), [master architecture](docs/master-architecture.md)
- **Complaint:** The antenna, buttons, display, bonding, and shell are called non-security-critical even though they enforce anti-skimming, verify-versus-claim separation, tamper evidence, and denomination presentation.
- **Failure mode:** A modified reused shell keeps NFC live, bridges the claim button, or deceives the next owner around a newly certified core.
- **Requested RFC change:** Classify the full assembly as security-relevant and require replacement or requalification, resealing, and a new enclosure credential during refurbishment.
- **Existing RFC coverage:** None.

### C-016: Firmware attestation lacks an immutable measurement root

- **Status:** Open
- **Severity:** High
- **Affected:** [coin hardware](docs/coin-hardware.md), [trust and manufacturing](docs/trust-and-manufacturing.md), [verification](docs/verification-and-bslrr.md)
- **Complaint:** A signed `firmware_profile` is not credible without immutable measured boot, anti-rollback state, update authorization, debug-lock semantics, applet privilege separation, and power-loss-safe update behavior.
- **Failure mode:** Compromised monetary code reports an approved profile while signing outside the intended state machine.
- **Requested RFC change:** Define the immutable measurement and attestation roots plus update, downgrade, debug, and torn-update rules for the evaluated configuration.
- **Existing RFC coverage:** The evaluated-configuration question only partially covers this.

### C-017: BSLRR mutation is not crash-consistent

- **Status:** Open
- **Severity:** Medium
- **Affected:** [verification and BSLRR](docs/verification-and-bslrr.md), [coin hardware](docs/coin-hardware.md)
- **Complaint:** Updating a root or counter and returning its authentication has the same commit-before-output problem as claim, but no pending record or retry semantics exist.
- **Failure mode:** The phone and coin disagree about the latest record after power loss; repeated interrupted writes also exhaust memory endurance.
- **Requested RFC change:** Keep initial verification stateless, or define an idempotent pending handoff record, exact retry protocol, and lifetime write budget.
- **Existing RFC coverage:** Existing questions cover endurance and semantics separately, not the crash-consistency failure.

### C-018: The hardware has no complete lifecycle mission profile

- **Status:** Open
- **Severity:** Medium
- **Affected:** [coin hardware](docs/coin-hardware.md), [README](README.md)
- **Complaint:** Batterylessness does not establish shelf life. NVM retention, tear endurance, display refresh life, button cycles, seal life, bending, abrasion, washing, temperature, humidity, and aging margin are unspecified.
- **Failure mode:** A long-held coin loses state, display legibility, or activation reliability before its expected circulation life.
- **Requested RFC change:** Add a product mission profile and accelerated-aging acceptance tests for persistent, mechanical, optical, and enclosure components.
- **Existing RFC coverage:** Hardware questions cover only portions.

### C-019: Physical attack testing has no pass criterion

- **Status:** Open
- **Severity:** High
- **Affected:** [coin hardware](docs/coin-hardware.md), [request for comments](REQUEST_FOR_COMMENTS.md)
- **Complaint:** Listing fault injection and side-channel tests does not define attack potential, chosen-message trace limits, acceptable fault rate, evaluation target, or how denomination limits follow from results. Base-chip certification may exclude the custom applet and assembly.
- **Failure mode:** A scalable extraction method passes an underspecified test program and invalidates an entire production batch.
- **Requested RFC change:** Define attacker resources, trace/query limits, success thresholds, target configuration, rate limits, and the denomination ceiling justified by measured fixed and marginal attack cost.
- **Existing RFC coverage:** None fully.

### C-020: ERC-4337 transport fees are insufficiently authorized

- **Status:** Open
- **Severity:** Critical
- **Affected:** [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [key lifecycle](docs/key-lifecycle.md), [operator network](docs/operator-network-and-business.md)
- **Complaint:** The inner coin intent omits EntryPoint and fee fields while account-funded execution is allowed. A bundler can select excessive gas parameters, and represented ETH is indistinguishable from gas unless separately reserved. The stated self-settlement fallback still requires an outside ETH-funded submitter.
- **Failure mode:** A valid claim pays an attacker-selected or excessive fee, consumes bearer ETH, or cannot use its supposedly permissionless fallback.
- **Requested RFC change:** Bind chain, EntryPoint, and a maximum account-paid gas amount in a separate transport authorization. Prefer paymaster funding, segregate any gas reserve from represented value, and specify the external self-submission prerequisite.
- **Existing RFC coverage:** Fee-envelope questions recognize part of this issue.

### C-021: Counterfactual accounts receive overstated assurance

- **Status:** Open
- **Severity:** High
- **Affected:** [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [verification](docs/verification-and-bslrr.md)
- **Complaint:** Before deployment there is no account code, stored key, epoch, nonce, or status to inspect. A token balance at a predicted address is recoverable only if the exact factory and initialization path remain valid.
- **Failure mode:** A verifier reports account backing even though the intended account cannot be deployed or would deploy under different authority.
- **Requested RFC change:** Define a lower counterfactual assurance level requiring factory code hash, CREATE2 derivation, complete initialization data, EntryPoint version, initial-key binding, and deployment simulation.
- **Existing RFC coverage:** None.

### C-022: Token balances can be funded but unclaimable

- **Status:** Open
- **Severity:** High
- **Affected:** [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [register and checkout](docs/register-and-checkout.md)
- **Complaint:** Balance and metadata checks do not establish transferability. Approved assets can be paused, sender-blacklisted, destination-blacklisted, upgraded, or frozen by issuer controls.
- **Failure mode:** A coin appears fully backed but cannot transfer to the merchant or holder.
- **Requested RFC change:** Check live pause and sender restrictions during verification, destination restrictions at claim, and display a distinct `funded but currently unclaimable` status. Document WBTC and stablecoin control powers precisely.
- **Existing RFC coverage:** Metadata disclosure exists, but live transferability does not.

### C-023: Proof-checked token state is undefined across proxies and upgrades

- **Status:** Open
- **Severity:** High
- **Affected:** [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [verification](docs/verification-and-bslrr.md)
- **Complaint:** `eth_getProof` proves selected storage slots, not arbitrary `balanceOf` execution. A proxy upgrade can change storage layout and semantics while the verifier still labels the result proof-checked.
- **Failure mode:** A locally verified slot is decoded under an obsolete layout and produces a false balance or policy result.
- **Requested RFC change:** Version each asset policy with proxy slots, implementation/code hashes, storage keys, layout, decoding rules, and block hash, or require an execution proof. Unknown upgrades must reduce assurance.
- **Existing RFC coverage:** None.

### C-024: The P-256 compatibility profile is incomplete

- **Status:** Open
- **Severity:** High
- **Affected:** [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [key lifecycle](docs/key-lifecycle.md)
- **Complaint:** Hardware P-256 support does not by itself match EIP-7951 hash, coordinate, signature, failure-output, and malleability semantics. Checking only call success can accept a failed or missing precompile response.
- **Failure mode:** Valid hardware signatures fail onchain, malformed signatures pass incorrect wrapper logic, or replay tracking is bypassed through ECDSA malleability.
- **Requested RFC change:** Define the exact prehash and encoding profile, low-`s` policy, semantic nonce rule, and a positive known-answer precompile test requiring the exact success value.
- **Existing RFC coverage:** None.

### C-025: Ethereum mainnet has no gas-feasibility gate

- **Status:** Open
- **Severity:** Medium
- **Affected:** [README](README.md), [request for comments](REQUEST_FOR_COMMENTS.md), [operator network](docs/operator-network-and-business.md)
- **Complaint:** Mainnet is selected without gas benchmarks for deployed and counterfactual claims, rotations, migrations, paymaster validation, bundles, failures, and privacy routes.
- **Failure mode:** Network fees consume an unacceptable fraction of low denominations during ordinary or stressed conditions.
- **Requested RFC change:** Make launch contingent on reproducible gas benchmarks and a maximum fee-to-denomination ratio for every supported asset and execution path.
- **Existing RFC coverage:** Economic modeling is deferred, but no technical gate is stated.

### C-026: Sweeping unsolicited assets executes attacker-controlled code

- **Status:** Open
- **Severity:** Medium
- **Affected:** [Ethereum accounts](docs/ethereum-accounts-and-assets.md)
- **Complaint:** `sweepUnrepresentedAsset` calls a token contract selected by whoever sent the unsolicited asset. That contract can reenter, lie about success, or consume unusual gas.
- **Failure mode:** A nuisance token exploits the account during cleanup or corrupts nonce and lifecycle behavior.
- **Requested RFC change:** Omit sweeping from v1, or require nonce consumption before calls, reentrancy protection, strict return decoding, and post-transfer balance checks.
- **Existing RFC coverage:** Fully recognized by an open question, but unresolved.

### C-027: Private-refresh authorization is under-bound

- **Status:** Open
- **Severity:** High
- **Affected:** [privacy routes](docs/privacy-routes.md), [key lifecycle](docs/key-lifecycle.md)
- **Complaint:** Binding only asset, amount, and destination omits chain, privacy contract, circuit and verifying key, public inputs, nullifier domain, protocol version, and maximum fee.
- **Failure mode:** A malicious prover consumes a one-use authorization through an attacker-controlled, non-exitable, or incompatible pool while satisfying the stated destination constraint.
- **Requested RFC change:** Bind a canonical hash of the complete privacy protocol instance, proof public inputs, destination, amount, expiry, and fee bounds.
- **Existing RFC coverage:** Witness-disclosure questions do not cover authorization substitution.

### C-028: Private refresh has no durable end-to-end lifecycle

- **Status:** Open
- **Severity:** High
- **Affected:** [privacy routes](docs/privacy-routes.md), [key lifecycle](docs/key-lifecycle.md)
- **Complaint:** Deposit, note creation, proof generation, withdrawal, exit, key retirement, and replay handling span multiple failure domains, but `MIGRATION_PENDING` has no complete transition or recovery protocol.
- **Failure mode:** A confirmed deposit followed by prover or power failure strands value, or an early local advance leaves two usable authorization paths.
- **Requested RFC change:** Define a crash-consistent migration state machine with resumable artifacts, retirement point, authenticated chain evidence, replay rules, and unilateral exit.
- **Existing RFC coverage:** None.

### C-029: Trust feeds permit rollback and freeze attacks

- **Status:** Open
- **Severity:** High
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md), [register and checkout](docs/register-and-checkout.md)
- **Complaint:** Signed manifests distributed by mirrors, Git, app bundles, or offline packages lack monotonic versions, snapshot binding, maximum age, trusted-time rules, and rollback state.
- **Failure mode:** A malicious or stale mirror freezes a verifier before a compromise warning and keeps old `accepted` metadata valid indefinitely.
- **Requested RFC change:** Define versioned, expiring, consistently hashed snapshots with rollback protection, effective and supersession times, and a visible stale-policy status.
- **Existing RFC coverage:** Conflicting publishers are a separate listed question.

### C-030: Ecosystem-root compromise has no recovery protocol

- **Status:** Open
- **Severity:** High
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md)
- **Complaint:** Root keys authorize subordinate roles and successor roots, but the threshold, update authority, rollback protection, and compromise recovery path are unspecified.
- **Failure mode:** A compromised root authorizes counterfeit batches and its own successor, splitting clients between attacker and recovery histories.
- **Requested RFC change:** Define threshold root updates, monotonic versions, old/new cross-signing, independent offline recovery anchors, and an explicit root-compromise response.
- **Existing RFC coverage:** Questions ask which root scheme is practical, not how compromise is recovered.

### C-031: Core-attestation compromise can have batch-wide blast radius

- **Status:** Open
- **Severity:** High
- **Affected:** [coin hardware](docs/coin-hardware.md), [trust and manufacturing](docs/trust-and-manufacturing.md)
- **Complaint:** The compromise taxonomy omits core credentials, and shared batch signing secrets would let one invasive extraction authenticate arbitrary counterfeits for an entire batch.
- **Failure mode:** One compromised coin creates a mass-counterfeiting capability while precise revocation becomes impossible.
- **Requested RFC change:** Disallow shared signing secrets. Require unique hardware-bound membership secrets plus revocation handles, compromise granularity, and freshness rules for each anonymous-attestation profile.
- **Existing RFC coverage:** Anonymous membership is discussed, but its compromise blast radius is not.

### C-032: Signature thresholds do not establish organizational independence

- **Status:** Open
- **Severity:** High
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md)
- **Complaint:** The RFC counts nominal manufacturer, laboratory, and witness signatures without defining separate control domains, conflicts of interest, or the physical fact each signer observed.
- **Failure mode:** A manufacturer and captive entities satisfy a threshold for phantom, duplicated, or unevaluated production.
- **Requested RFC change:** Count independently administered entities, require conflict disclosures, and specify whether each signature attests a key ceremony, firmware measurement, physical sampling, or production quantity.
- **Existing RFC coverage:** The collusion open question fully recognizes this objection.

### C-033: Transparency-log protections are optional despite being relied upon

- **Status:** Open
- **Severity:** High
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md)
- **Complaint:** Batch containment and cutoff logic rely on sequence and timestamp visibility, while witnessed checkpoints, consistency proofs, and gossip are described as conditional.
- **Failure mode:** A signer and log show a targeted malicious batch to one victim without exposing it to monitors.
- **Requested RFC change:** Any policy claiming cutoff or batch containment must require inclusion in a fresh witnessed checkpoint plus consistency and split-view evidence.
- **Existing RFC coverage:** Split-view prevention is already an open question.

### C-034: BSLRR permits durable participant tagging

- **Status:** Open
- **Severity:** Medium
- **Affected:** [verification and BSLRR](docs/verification-and-bslrr.md), [privacy routes](docs/privacy-routes.md)
- **Complaint:** Sender- and receiver-chosen nonces remain in an append-only history. Prior holders recognize prefixes, and malicious apps can encode persistent identifiers in nonce choices.
- **Failure mode:** A wallet inserts a customer or device tag that later colluding verifiers recover; removing it invalidates the root.
- **Requested RFC change:** State the linkability explicitly, constrain participant inputs, and use a zero-knowledge continuation proof if later holders must not receive prior event material.
- **Existing RFC coverage:** Existing privacy questions cover root disclosure, not retained prefixes or subliminal tags.

### C-035: Anonymous attestation leaks identity through auxiliary fields

- **Status:** Open
- **Severity:** Medium
- **Affected:** [verification and BSLRR](docs/verification-and-bslrr.md), [privacy routes](docs/privacy-routes.md), [trust and manufacturing](docs/trust-and-manufacturing.md)
- **Complaint:** Hiding a core credential still exposes exact epoch, account binding, asset, amount, counters, and BSLRR root. Their intersection can fingerprint a coin across private refresh.
- **Failure mode:** Colluding verifiers link an unusual metadata tuple before and after account migration.
- **Requested RFC change:** Define selective disclosure, hide exact counters and roots by default, prove lifecycle predicates, and require an unlinkable no-basename attestation profile.
- **Existing RFC coverage:** Feasibility of unlinkable attestation is open, but auxiliary-field fingerprinting is not stated.

### C-036: Trust-feed retrieval itself can track coins and verifiers

- **Status:** Open
- **Severity:** Medium
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md), [privacy routes](docs/privacy-routes.md)
- **Complaint:** Network privacy covers backing RPCs but not per-core, per-leaf, or small-batch hardware status lookups.
- **Failure mode:** A manufacturer or mirror correlates verifier IP, time, merchant, and hardware cohort with issuance data.
- **Requested RFC change:** Require bulk cohort downloads or local mirrors in the baseline, prohibit per-core lookup endpoints, and document relay or PIR options for incremental updates.
- **Existing RFC coverage:** None.

### C-037: Custody, ownership, and loss allocation are undefined

- **Status:** Partially addressed
- **Severity:** High
- **Affected:** [register and checkout](docs/register-and-checkout.md), [operator network](docs/operator-network-and-business.md), [master architecture](docs/master-architecture.md)
- **Complaint:** Physical possession, local-key authority, onchain ownership, merchant payment, provider acquisition, and final settlement change at different moments without a normative boundary or loss waterfall.
- **Failure mode:** A jam, failed claim, reorganization, freeze, hidden authorization, provider failure, or counterfeit produces a dispute with no defined owner or bearer of loss.
- **Requested RFC change:** Add a per-state custody and risk table for waiting, approval, gate crossing, authorization, submission, confirmation, return, quarantine, and payout, including recourse and refund rules.
- **Existing RFC coverage:** Customer approval is open, but end-to-end loss allocation is not.
- **Accepted design:** D-037 makes customer approval plus secure crossing of either the verification-only accept gate or the claim gate the ownership boundary. Before crossing, the customer owns the coin and the register operator is a bailee obligated to return the same object. After crossing, the merchant owns the coin or pending claim and bears ordinary counterfeit, backing, submission, freeze, and reorganization risk. A provider assumes only the acquisition risk in a signed acceptance bound to the canonical settlement identity and payout terms. Equipment failure follows custody; intentional fraud creates legal recourse rather than protocol clawback.
- **Remaining work:** Specify canonical gate and receipt events, signed provider acceptance, custody records, equipment-operator agreements, return and quarantine procedures, jurisdiction-specific title and bailment analysis, fraud evidence, payout remedies, insurance or bonding, and tests for every jam, cancellation, restart, and disagreement boundary.

### C-038: Multi-coin checkout is not atomic

- **Status:** Partially addressed
- **Severity:** High
- **Affected:** [register and checkout](docs/register-and-checkout.md), [key lifecycle](docs/key-lifecycle.md)
- **Complaint:** Each coin can enter an irreversible pending state before the basket is fully paid. Failure of the last coin or aggregator operation leaves earlier coins locked without completing the sale.
- **Failure mode:** Customer and merchant end with a partially claimed basket, live authorizations, and no safe automatic refund.
- **Requested RFC change:** Restrict v1 to one claimed coin or define a basket escrow/compensation protocol. Never return a pending coin as normal tender.
- **Existing RFC coverage:** Partial basket failure is listed as an open question.
- **Accepted design:** D-038 preserves multi-coin checkout. All coins are verified and tallied before one basket approval; each selected coin binds the same canonical basket and transfers ownership at its own secure gate crossing. Completion requires every selected crossing. If routing stops early, the merchant owes the basket's exact precommitted remedy for the accepted subset. A complete same-chain authorization set may execute atomically through one reverting `BasketClaim`; incomplete physical routing is not described as atomic. Pending coins are never returned as ordinary active tender.
- **Remaining work:** Specify canonical `BasketTerms`, per-coin acceptance events, the partial-acceptance remedy, receipt and restart behavior, `BasketClaim` validation and gas bounds, token conformance, authorization recovery, and tests covering every failure before, between, and after gate crossings and onchain execution.

### C-039: Quote expiry, rounding, fees, and change are non-normative

- **Status:** Partially addressed
- **Severity:** High
- **Affected:** [register and checkout](docs/register-and-checkout.md), [operator network](docs/operator-network-and-business.md)
- **Complaint:** Sequential multi-asset claims share a quote without canonical decimal rules, rounding, spread, fee allocation, price source, validity through the whole claim window, or enforceable change procedure.
- **Failure mode:** A quote expires mid-basket, or merchant and customer calculate different totals and change after irreversible claims begin.
- **Requested RFC change:** Canonicalize quote math and sources, lock a basket quote through a bounded claim window, and require exact tender, change-before-claim, or signed refund/change obligations.
- **Existing RFC coverage:** Quote expiry is open; the other arithmetic rules are not.
- **Accepted design:** D-039 defines no protocol-wide oracle. An independent merchant may choose its quote source; use of an issuer or settlement provider may contractually require that party's source, spread, or fee policy. The register discloses and binds the applicable source and relationship. It uses canonical integer arithmetic, rounds the basket once under the quote-currency profile, and displays every spread and customer fee before approval. Quote expiry gates approval only; approved terms do not reprice. Excess coins return before approval, and any remaining change or partial-basket remedy becomes an exact signed merchant obligation under the locked quote.
- **Remaining work:** Specify quote and relationship identifiers, integer rate encoding, quote-currency profiles, deterministic line-item residual allocation, change methods, proof of change availability, receipts, stale-source warnings, provider acceptance, and conformance tests for decimal extremes, expiry boundaries, and every failure before and after approval.

### C-040: Offline claim is unsecured merchant credit

- **Status:** Partially addressed
- **Severity:** High
- **Affected:** [register and checkout](docs/register-and-checkout.md), [operator network](docs/operator-network-and-business.md)
- **Complaint:** Offline acceptance cannot check backing, account nonce, code, policy, freeze status, or prior authorization, yet the design permits irreversible claim and may imply completed payment.
- **Failure mode:** The merchant gives goods for an empty, already-authorized, frozen, or incompatible coin.
- **Requested RFC change:** Define an explicit `UNVERIFIED_OFFLINE` receipt and credit-risk state, denomination and exposure limits, reconnect deadline, and whether irreversible offline claim is allowed at all.
- **Existing RFC coverage:** The assurance ladder exists, but commercial consequences are not specified.
- **Accepted design:** D-040 distinguishes offline acceptance from claim authorization. Standard registers permit verification-only offline acceptance but do not initiate all-three-button claim without a fresh chain check, working submission path, durable authorization storage, and available gas or sponsorship. A network cut before gate crossing returns the coin; after crossing but before authorization the active coin is merchant property; after durable authorization the merchant retains the `AUTH_PENDING` coin and exact authorization for retry. Provider credit requires separate signed acceptance.
- **Remaining work:** Define freshness and availability tests, controller interlocks, durable queue and reconciliation formats, customer and merchant receipts, retry and escalation policy, gas and sponsor readiness, provider acceptance behavior, and fault-injection tests for connectivity loss at every instruction and physical boundary.

### C-041: Register receipts are not sufficient dispute evidence

- **Status:** Open
- **Severity:** High
- **Affected:** [register and checkout](docs/register-and-checkout.md), [operator network](docs/operator-network-and-business.md)
- **Complaint:** A register signature proves only that the register asserted something. Current receipts omit immutable claim terms, customer approval, proof source and block, transaction identifier, status evolution, and refund obligation.
- **Failure mode:** A merchant or provider cannot prove what was authorized or whether a later failure happened before or after ownership transferred.
- **Requested RFC change:** Define canonical pre-claim and post-claim receipt schemas covering quote hash, destination, account and coin references, intent digest, event status, chain proof source/block, UserOperation or transaction ID, operator key, and remedies.
- **Existing RFC coverage:** None.

### C-042: Mechanical jams and substitution lack fail-closed recovery

- **Status:** Open
- **Severity:** High
- **Affected:** [register and checkout](docs/register-and-checkout.md), [coin hardware](docs/coin-hardware.md)
- **Complaint:** The register does not specify recovery for every physical path segment or prove that the verified object is the claimed object. Service access, double-feed, substitution gaps, and jams can change custody invisibly.
- **Failure mode:** The machine returns a different coin, exposes a pending coin to staff, or claims an object other than the one verified.
- **Requested RFC change:** Add one-coin tracking and attestations at both checkpoints, a location-specific fail-closed recovery state machine, pre-claim return, post-claim quarantine, and no service access while ownership is unresolved.
- **Existing RFC coverage:** Object binding is identified as an engineering concern, not specified.

### C-043: Register throughput and capacity are unbounded

- **Status:** Open
- **Severity:** Medium
- **Affected:** [register and checkout](docs/register-and-checkout.md)
- **Complaint:** No latency budget, maximum basket size, waiting-chamber capacity, timeout, coins-per-minute target, or quarantine capacity supports the proposed retail flow.
- **Failure mode:** Slow chain checks, display updates, or one failed coin block the lane and force unsafe bypass handling.
- **Requested RFC change:** Define a service envelope for each stage and safe bypass, timeout, return, and quarantine behavior.
- **Existing RFC coverage:** None.

### C-044: The physical interaction lacks an equivalent accessible path

- **Status:** Partially addressed
- **Severity:** Medium
- **Affected:** [coin hardware](docs/coin-hardware.md), [register and checkout](docs/register-and-checkout.md)
- **Complaint:** Simultaneous side-button use, visual observation of a clear path, and two-sided display exclude users with limited dexterity, one-handed use, or low vision.
- **Failure mode:** Users must surrender control to another person or use a weaker security path.
- **Requested RFC change:** Define an accessible activation method with equivalent anti-skimming and consent guarantees, plus nonvisual presentation of the authoritative terms.
- **Existing RFC coverage:** None.
- **Accepted design:** D-044 makes a customer-controlled basket-commit lever the standard accessible initiation action rather than introducing a weaker alternate command. It remains unavailable until the complete basket is fixed and, for claims, D-040's online checks pass. One pull permits exactly one fresh center press-and-release cycle per approved claim coin while the secure mechanism applies the side-button state. It cannot hold center continuously, alter terms, add coins, or exceed the approved basket; it disarms on completion, cancellation, or failure. Verification-only coins receive no center stroke. The same secure controller provides authoritative visual and nonvisual terms, while existing per-coin gate and ownership rules remain unchanged.
- **Remaining work:** Specify lever force, travel, reach, handedness, assistive interfaces, detents and interlocks; cam or ratchet indexing and full center release; cycle-count and tracked-object binding; nonvisual output and private-listening options; fail-safe disarm and restart; human-factors, accessibility, spoofing, jam, wear, and single-fault tests; and complete-equipment safety under C-074.

### C-045: Detailed metadata does not guarantee risk comprehension

- **Status:** Partially addressed
- **Severity:** Medium
- **Affected:** [register and checkout](docs/register-and-checkout.md), [Ethereum accounts](docs/ethereum-accounts-and-assets.md)
- **Complaint:** Requiring clients to display contract, proxy, custody, freeze, and wrapped-asset metadata does not ensure that users understand which facts affect immediate payment risk.
- **Failure mode:** A technically complete details page obscures that the asset is frozen, wrapped, upgradeable, or accepted only by one acquirer.
- **Requested RFC change:** Standardize a primary confirmation view showing risk class, chain, amount, recipient, action, fees, transferability, and material warnings, with technical details secondary.
- **Existing RFC coverage:** Verification presentation is planned but not normalized.
- **Accepted design:** D-045 standardizes a risk-first visual and nonvisual hierarchy. The primary confirmation presents the purchase total, merchant or recipient, selected action, tender and change, customer fees, and each asset's amount beside a short approved-chain name and recognizable chain icon. Concrete material warnings for backing, settlement, custody, freezability, and upgradeability are also primary. Exact chain IDs, contracts, proxies, implementations, and other technical metadata remain secondary unless they generate a material warning. The written chain name accompanies every icon and is spoken by the nonvisual path.
- **Remaining work:** Specify the approved chain-name and icon registry, plain-language risk vocabulary and warning severities, stale and conflicting evidence handling, layout and audio order, localization, color-independent rendering, acknowledgement behavior, detail navigation, receipt rendering, and human-factors tests for comprehension under retail time pressure.

### C-046: The register flow cannot measure or support recirculation

- **Status:** Open
- **Severity:** High
- **Affected:** [register and checkout](docs/register-and-checkout.md), [operator network](docs/operator-network-and-business.md)
- **Complaint:** The described checkout claims selected coins into a one-way chamber, while the pilot and cash analogy depend on merchants accepting and recirculating still-active coins.
- **Failure mode:** The first merchant redeems every coin, so offline circulation, change inventory, and the primary claimed product behavior are never exercised.
- **Requested RFC change:** Specify a separate accept-without-claim path with receipts, inventory, change handling, risk limits, and pilot metrics, or narrow the product to redemption-at-POS.
- **Existing RFC coverage:** None.

### C-047: Circulation creates adverse selection for compromised coins

- **Status:** Open
- **Severity:** High
- **Affected:** [master architecture](docs/master-architecture.md), [operator network](docs/operator-network-and-business.md), [verification](docs/verification-and-bslrr.md)
- **Complaint:** Holders with sound coins can redeem them, while holders who copied a key have an incentive to pass the physical object. Live backing can still look valid immediately before the copied key is exercised.
- **Failure mode:** Repeated circulation concentrates compromised coins among less cautious recipients until rational merchants insist on immediate claim.
- **Requested RFC change:** Analyze adverse selection explicitly and define age, history, and exposure limits plus pilot measurements that test whether non-claim circulation remains rational.
- **Existing RFC coverage:** None.

### C-048: Low denomination does not bound batch-wide exploit economics

- **Status:** Open
- **Severity:** High
- **Affected:** [master architecture](docs/master-architecture.md), [coin hardware](docs/coin-hardware.md), [operator network](docs/operator-network-and-business.md)
- **Complaint:** The attack-cost argument treats extraction as a per-coin expense. A model, firmware, factory, or provisioning exploit can have a high one-time discovery cost and very low marginal cost across an entire batch.
- **Failure mode:** Aggregate backing, not one denomination, becomes the prize after a scalable exploit is developed.
- **Requested RFC change:** Model fixed exploit cost, marginal extraction cost, batch exposure, detection delay, migration capacity, and reserves or insurance. Tie denomination and batch-size ceilings to that model.
- **Existing RFC coverage:** None fully.

### C-049: Deferred submission conflicts with rapid-claim security

- **Status:** Open
- **Severity:** High
- **Affected:** [operator network](docs/operator-network-and-business.md), [register and checkout](docs/register-and-checkout.md)
- **Complaint:** Security arguments rely on broadcasting merchant claims quickly, while fee-band policy permits queued submission "where safe" without defining safety.
- **Failure mode:** A copied key, account rotation, token freeze, quote expiry, or state change defeats a claim after the merchant or provider has credited payment.
- **Requested RFC change:** Define a broadcast SLA and gas reserve. Do not provide final or instant credit when submission is intentionally deferred unless the loss allocation is explicit.
- **Existing RFC coverage:** None.

### C-050: Loading and inventory issuance are missing protocol roles

- **Status:** Open
- **Severity:** High
- **Affected:** [key lifecycle](docs/key-lifecycle.md), [operator network](docs/operator-network-and-business.md), [Ethereum accounts](docs/ethereum-accounts-and-assets.md)
- **Complaint:** Reloading requires asset-policy selection, account deployment, funding, confirmation, display update, inventory financing, reconciliation, and liability, but no loader actor or fee flow is defined.
- **Failure mode:** A coin displays value before funding is final, or merchants accumulate empty hardware with no reliable reload and inventory process.
- **Requested RFC change:** Define a permissionless loader protocol and optional commercial loader role, including ordering, receipts, confirmation, display transition, fees, and liability.
- **Existing RFC coverage:** None.

### C-051: Plural asset and trust policies can destroy physical fungibility

- **Status:** Resolved
- **Disposition:** Rejected for the first-generation profile
- **Severity:** High
- **Affected:** [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [trust and manufacturing](docs/trust-and-manufacturing.md), [operator network](docs/operator-network-and-business.md)
- **Complaint:** The face initially omits network and contract while apps, register vendors, and acquirers can subscribe to different asset and trust policies. Two objects labeled `USDC` may have materially different acceptance.
- **Failure mode:** Users cannot know from physical presentation whether a coin is native, wrapped, frozen, supported by the local register, or accepted by an instant-settlement provider.
- **Requested RFC change:** Define an unambiguous asset-policy namespace or compact fingerprint on the object, prohibit unqualified ticker presentation, and document fragmentation as a tradeoff of permissionless policy diversity.
- **Disposition:** Rejected. The first-generation profile deliberately supports one chain per represented asset and preserves the reusable e-paper display model: asset, amount, and relevant local status. It does not add a permanent or epoch-specific Asset Profile marker. Register confirmation uses the short approved chain name and icon required by D-045; verifier clients expose exact chain and asset metadata. Local app, register, and acquirer policies remain advisory and may differ. A future expansion that permits visually identical labels for distinct represented-asset identities must be proposed as a new product decision rather than inferred from this rejected complaint.

### C-052: The business viability test is not yet a model

- **Status:** Open
- **Severity:** Medium
- **Affected:** [operator network](docs/operator-network-and-business.md)
- **Complaint:** Stating that revenue must exceed a list of costs is tautological and gives no ranges, correlations, stress cases, capital requirement, or go/no-go threshold.
- **Failure mode:** Investor materials imply favorable economics without showing which fee, volume, fraud, gas, hardware, and liquidity assumptions carry the result.
- **Requested RFC change:** Build a parameterized unit-economics model with pessimistic ranges, sensitivity analysis, capital-at-risk duration, and explicit pilot thresholds.
- **Existing RFC coverage:** Economic modeling is listed as future work.

### C-053: Commercial and legal feasibility is omitted rather than scoped

- **Status:** Open
- **Severity:** High
- **Affected:** [operator network](docs/operator-network-and-business.md), [request for comments](REQUEST_FOR_COMMENTS.md)
- **Complaint:** A not-legal-advice disclaimer does not identify the separate gates created by acquisition, instant credit, custody, conversion, fiat payout, certification, operator identity, and data retention.
- **Failure mode:** A pilot architecture assumes privacy, decentralization, or margins that the eventual regulated roles cannot retain.
- **Requested RFC change:** Add a nontechnical-gates section mapping each optional role to required jurisdiction-specific analysis without implying a protocol-wide permission gate.
- **Existing RFC coverage:** Deliberately deferred, but the dependency remains material.

### C-054: A controlled pilot cannot estimate commercial fraud rates

- **Status:** Open
- **Severity:** Medium
- **Affected:** [operator network](docs/operator-network-and-business.md), [request for comments](REQUEST_FOR_COMMENTS.md)
- **Complaint:** A low-value or supervised beta suppresses economic attack incentives and does not validate ordinary comprehension, circulation, support burden, or fraud loss.
- **Failure mode:** Engineering success is mistaken for evidence that the acquisition business is commercially safe.
- **Requested RFC change:** Separate engineering, adversarial-value, circulation, and commercial pilot stages, and state which claims each stage can and cannot support.
- **Existing RFC coverage:** Pilot measurement is planned, but evidentiary limits are not stated.

### C-055: ECDSA nonce behavior is unsafe unless reset-resistant

- **Status:** Open
- **Severity:** Critical
- **Affected:** [coin hardware](docs/coin-hardware.md), [key lifecycle](docs/key-lifecycle.md), [Ethereum accounts](docs/ethereum-accounts-and-assets.md)
- **Complaint:** The P-256 profile does not specify generation and reset behavior for ECDSA's per-signature secret `k`. A randomized signer whose DRBG state repeats or rolls back after NFC power interruption can reuse `k` on two different digests, revealing the monetary private key.
- **Failure mode:** A hostile holder induces reset around signing, obtains two permitted signatures with the same `r`, derives the private key, and retains a spendable clone after transferring the coin.
- **Requested RFC change:** Require deterministic ECDSA under FIPS 186-5 and RFC 6979 for the canonical digest, or an equally explicit reset-safe construction. Test distinct digests across repeated power cycles for duplicate `r` and include fault and side-channel criteria for nonce generation.
- **Existing RFC coverage:** C-006 covers preservation of an already-created authorization, C-019 covers general physical test criteria, and C-024 covers verifier encoding. None specifies signer nonce generation.

### C-056: Hostile coin data can compromise a shared register

- **Status:** Open
- **Severity:** High
- **Affected:** [register and checkout](docs/register-and-checkout.md), [verification](docs/verification-and-bslrr.md), [operator network](docs/operator-network-and-business.md)
- **Complaint:** A register parses unauthenticated NFC frames, attestation objects, membership proofs, metadata, and potentially variable-length BSLRR records before authenticity is established, but the RFC defines no canonical size limits, parser isolation, resource bounds, or narrow interface to the mechanical controller.
- **Failure mode:** A counterfeit NFC device exploits or exhausts the verifier, then redirects or falsely reports subsequent customer claims through access to actuators, receipt keys, claim preparation, or persistent state.
- **Requested RFC change:** Treat every pre-authentication byte as hostile; require canonical bounded schemas, disposable least-privileged parsing, strict resource limits, session reset, parser fuzzing, and a fixed-size authenticated interface into the claim controller.
- **Existing RFC coverage:** C-042 covers physical substitution and jams; it does not cover malicious tender data compromising the register.

### C-057: Operator revenue sharing lacks Sybil-resistant attribution

- **Status:** Open
- **Severity:** Medium
- **Affected:** [operator network](docs/operator-network-and-business.md), [open questions](docs/open-questions.md)
- **Complaint:** Pooled rewards for bundles, relays, mirrors, uptime, and support lack a qualified identity model, third-party demand evidence, independently measurable work, anti-self-dealing rules, or objectively slashable facts.
- **Failure mode:** One operator creates merchant and operator identities, generates circular low-value activity, probes its own services, and extracts shared revenue while diluting honest operators.
- **Requested RFC change:** Keep pooled operator rewards out of v1 unless a commercial specification defines qualified identities, auditable attribution, third-party demand, independent availability measurement, caps, and objective penalties. Transaction-specific customer-paid fees remain possible.
- **Existing RFC coverage:** Fake traffic is acknowledged as an open question, but no existing complaint records the incentive failure.

### C-058: Managed settlement can credit one claim more than once

- **Status:** Open
- **Severity:** High
- **Affected:** [operator network](docs/operator-network-and-business.md), [register and checkout](docs/register-and-checkout.md), [key lifecycle](docs/key-lifecycle.md)
- **Complaint:** Recoverable claim authorizations can be submitted repeatedly or through different transaction wrappers, but the provider ledger has no canonical settlement identity or atomic credit-once invariant. Onchain nonce protection does not deduplicate offchain merchant credits.
- **Failure mode:** A lost response or malicious concurrent retry causes two merchant credits for one economic claim even though only one onchain transfer can succeed.
- **Requested RFC change:** Derive a canonical provider-wide `settlementId` from chain, account, epoch, semantic nonce, and complete signed intent digest. Enforce an atomic unique credit record across retries, regions, transaction replacements, and UserOperation wrappers.
- **Existing RFC coverage:** C-004 protects protocol authorization; C-037 and C-041 cover custody and evidence. None prevents duplicate provider-ledger payout.

### C-059: Long-lived private-key generation lacks an entropy profile

- **Status:** Open
- **Severity:** Critical
- **Affected:** [coin hardware](docs/coin-hardware.md), [key lifecycle](docs/key-lifecycle.md), [trust and manufacturing](docs/trust-and-manufacturing.md)
- **Complaint:** Internal generation proves where a monetary or attestation key was created, not that it is unpredictable. The RFC does not define the RBG, entropy source, startup and continuous health tests, P-256 generation method, or failure behavior across passive cold starts.
- **Failure mode:** Distinct but predictable or correlated keys are generated in a factory batch or after RF-powered startup, allowing offline recovery of monetary keys or attestation credentials.
- **Requested RFC change:** Define a normative P-256 key-generation and entropy profile covering factory slots, renewable keys, attestation keys, and salts, with startup health tests, fail-closed behavior, environmental and power-cycle testing, and evaluated configuration binding.
- **Existing RFC coverage:** C-008 covers uniqueness and isolation; C-055 covers per-signature nonce generation. Neither covers entropy for the long-lived private key.

### C-060: Verifier challenge freshness has no enforceable profile

- **Status:** Open
- **Severity:** High
- **Affected:** [coin hardware](docs/coin-hardware.md), [verification](docs/verification-and-bslrr.md), [master architecture](docs/master-architecture.md)
- **Complaint:** A "fresh reader nonce" has no minimum entropy, trusted generation boundary, outstanding-challenge state, single-use rule, reboot behavior, or randomness-failure handling.
- **Failure mode:** An attacker predicts or resets an offline register's challenge sequence, precomputes genuine responses during temporary coin possession, and installs them in counterfeit objects that later pass without a live genuine core.
- **Requested RFC change:** Require at least 128 unpredictable bits from a CSPRNG in the trusted verifier boundary, retain and consume exactly one outstanding challenge, prevent rollback across restart, and fail closed if secure randomness is unavailable.
- **Existing RFC coverage:** C-001 assumes fresh challenges and addresses live relay. C-055 addresses the signer's secret nonce, not the verifier's public challenge.

### C-061: ERC-4337 failures can consume the nonce required for retry

- **Status:** Open
- **Severity:** High
- **Affected:** [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [key lifecycle](docs/key-lifecycle.md)
- **Complaint:** EntryPoint can consume its transport nonce during validation before account execution. If execution is included but reverts, an identical signed UserOperation cannot be retried, while changing nonce, fees, or paymaster changes `userOpHash` and requires a new signature.
- **Failure mode:** A pending coin releases a claim, token or paymaster execution reverts, the EntryPoint nonce advances, and the coin cannot produce the replacement transport signature required to complete the unchanged claim.
- **Requested RFC change:** Persist the inner ClaimIntent and allow bounded replacement UserOperation signatures for that exact intent, or provide a direct-relay recovery path. Pin EntryPoint versions and test included-but-reverted retry behavior.
- **Existing RFC coverage:** C-006 concerns preserving bytes; here the preserved bytes become invalid. C-020 concerns fee authority, not retry liveness.

### C-062: Anonymous attestation may be traceable by an opening authority

- **Status:** Open
- **Severity:** Medium
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md), [privacy routes](docs/privacy-routes.md), [verification](docs/verification-and-bslrr.md)
- **Complaint:** Generic group signatures can include a designed opening or tracing key. Unlinkability and no-basename operation do not establish anonymity against the manufacturer, group manager, or opener.
- **Failure mode:** An opening authority resolves retained merchant transcripts to enrolled cores and links a coin across merchants, rotations, and private migrations while clients label the attestation anonymous.
- **Requested RFC change:** Include issuer, manufacturer, publisher, and opener collusion in the threat model. Require an unopenable profile for exact-core anonymity claims or label threshold/openable profiles as traceable.
- **Existing RFC coverage:** C-035 covers metadata fingerprinting; this works even with selective disclosure. C-031 covers compromised credentials, not intentional opening functionality.

### C-063: Treasury acquisition is not bound to the merchant beneficiary

- **Status:** Open
- **Severity:** High
- **Affected:** [operator network](docs/operator-network-and-business.md), [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [register and checkout](docs/register-and-checkout.md)
- **Complaint:** A valid transfer to a shared provider treasury does not authenticate which merchant ledger account is entitled to credit. Exactly-once settlement identity prevents duplicate credit but not beneficiary substitution.
- **Failure mode:** A compromised client sends the real asset to the real treasury while naming an attacker-controlled merchant account in a separate credit request.
- **Requested RFC change:** Bind a provider-signed settlement instruction naming treasury, merchant beneficiary, claim identity, payout asset and amount, fees, expiry, and quote into the coin-authorized claim or emitted event, then consume it atomically once.
- **Existing RFC coverage:** C-002 binds customer-visible terms and C-058 deduplicates credits; neither establishes provider-ledger beneficiary attribution.

### C-064: Sponsored gas lacks an authorization and loss-control invariant

- **Status:** Open
- **Severity:** High
- **Affected:** [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [operator network](docs/operator-network-and-business.md), [key lifecycle](docs/key-lifecycle.md)
- **Complaint:** A paymaster can remain liable for gas when account execution reverts, but the RFC defines no typed sponsor consent, one-use budget, quotas, or circuit breaker for that separate loss.
- **Failure mode:** Attackers make many simulations succeed, change destination state before inclusion, retain their backing after reverted execution, and drain the sponsor deposit through protocol-valid gas charges.
- **Requested RFC change:** Require a typed one-use sponsorship authorization binding the complete operation, settlement, gas cap, fee cap, validity, and sponsor nonce; reserve budget during validation and define quotas, deposit caps, and `opReverted` loss allocation.
- **Existing RFC coverage:** C-020 protects represented value from account-paid gas; it does not protect the sponsor's deposit.

### C-065: Naive claim expiry can violate canonical ERC-4337 mempool rules

- **Status:** Open
- **Severity:** High
- **Affected:** [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [key lifecycle](docs/key-lifecycle.md), [operator network](docs/operator-network-and-business.md)
- **Complaint:** Reading `block.timestamp` or `block.number` directly during `validateUserOp` to enforce signed claim expiry can violate ERC-7562 canonical-mempool validation rules.
- **Failure mode:** A correctly signed and funded operation executes through direct EntryPoint submission but every conforming canonical bundler rejects it before propagation.
- **Requested RFC change:** Define an ERC-4337 validation profile that authenticates validity bounds and returns them through `validationData`, plus equivalent direct-relay semantics and canonical-mempool conformance tests.
- **Existing RFC coverage:** C-002 requires expiry to be signed; it does not specify an admissible ERC-4337 implementation.

### C-066: Chain ID does not isolate authorizations across same-ID chain splits

- **Status:** Open
- **Severity:** High
- **Affected:** [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [key lifecycle](docs/key-lifecycle.md), [verification](docs/verification-and-bslrr.md)
- **Complaint:** Two descendants of a contentious split can retain the same chain ID, EntryPoint, account, contract addresses, balances, and pre-split nonces. The signed domain then identifies both ledgers.
- **Failure mode:** One released claim executes on both branches, consuming the holder's forked asset twice despite one approval.
- **Requested RFC change:** Specify a contentious-split freeze and recovery policy. Resume only after a distinct chain or fork domain exists, and treat unexpired pre-split authorizations as replayable on every same-ID descendant.
- **Existing RFC coverage:** C-005 authenticates canonical evidence within a selected chain; it does not stop cross-descendant replay.

### C-067: Evaluated hardware identity can survive unevaluated component changes

- **Status:** Open
- **Severity:** High
- **Affected:** [coin hardware](docs/coin-hardware.md), [trust and manufacturing](docs/trust-and-manufacturing.md)
- **Complaint:** Hardware profiles and batch manifests do not bind exact security-relevant component revisions or require requalification after supplier changes, fab transfers, ROM/library revisions, package changes, or front-end substitution.
- **Failure mode:** New production inherits an old accepted profile after a change alters brownout, write timing, sensing, RF, or fault resistance.
- **Requested RFC change:** Bind an immutable versioned evaluated configuration to credentials and manifests, require security impact analysis for every supplier change, and issue a new profile after any relevant delta testing.
- **Existing RFC coverage:** C-016 and C-019 concern firmware roots and initial evaluation, not assurance continuity after production changes.

### C-068: Batch enrollment does not prove key residence in the inspected core

- **Status:** Open
- **Severity:** High
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md), [coin hardware](docs/coin-hardware.md), [key lifecycle](docs/key-lifecycle.md)
- **Complaint:** A manifest can include a substituted software public key because no fresh hardware-rooted enrollment ceremony joins the inspected core, generated key, non-exportable policy, and committed batch leaf.
- **Failure mode:** Factory malware replaces core-generated attestation keys before manifest construction, leaving all batch signatures and log proofs valid while counterfeit devices hold the accepted private keys.
- **Requested RFC change:** Require a challenged hardware-root certification, proof of possession, same-core credential activation, immutable device and firmware binding, and a validated transcript hash in each batch leaf.
- **Existing RFC coverage:** C-031 covers extracted credentials and C-032 covers witness independence; neither proves same-core key residence at enrollment.

### C-069: Anonymous credential issuance is not bound to logged inventory

- **Status:** Open
- **Severity:** High
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md), [privacy routes](docs/privacy-routes.md), [verification](docs/verification-and-bslrr.md)
- **Complaint:** A DAA-style issuer can mint additional unique member credentials under an accepted group key without consuming leaves from the logged batch root. Membership proves issuer approval, not inventory inclusion.
- **Failure mode:** A compromised issuer enrolls unlimited counterfeit devices while the public batch count and transparency log remain unchanged.
- **Requested RFC change:** Require zero-knowledge proof that every accepted member secret corresponds to one logged batch leaf and enforce one credential lineage per leaf, or drop quantity-containment claims for that profile.
- **Existing RFC coverage:** C-031 covers shared or extracted secrets; this attack uses unique valid credentials minted outside the inventory.

### C-070: Anonymous-proof randomness lies outside the specified privacy boundary

- **Status:** Open
- **Severity:** Medium
- **Affected:** [coin hardware](docs/coin-hardware.md), [trust and manufacturing](docs/trust-and-manufacturing.md), [privacy routes](docs/privacy-routes.md)
- **Complaint:** A host controller may choose credential randomizers, witnesses, basenames, disclosed fields, and transcript framing. Valid proofs can remain linkable or leak secrets if that host reuses or biases per-proof randomness.
- **Failure mode:** A genuine non-exportable credential produces accepted proofs containing a stable host-generated tag across rotations and private migrations.
- **Requested RFC change:** Specify and certify the complete anonymity trust boundary, constrain host inputs, require reset-safe per-proof randomness and adversarial-host tests, and qualify privacy claims when a general host remains trusted.
- **Existing RFC coverage:** C-035 covers disclosed-field fingerprints and C-062 covers an intentional opener; this tag exists inside otherwise valid proof randomization.

### C-071: Trust-metadata signing roles are not cryptographically scoped

- **Status:** Open
- **Severity:** High
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md), [Ethereum accounts](docs/ethereum-accounts-and-assets.md)
- **Complaint:** Named manufacturer, batch, laboratory, app, and feed roles lack a canonical signed envelope and verifier algorithm binding each key and threshold to an authenticated statement type, namespace, schema, and permitted scope.
- **Failure mode:** A legitimate laboratory key signs data that a permissive client interprets as a batch manifest, minting accepted batches without compromising any key.
- **Requested RFC change:** Define versioned typed envelopes, authenticated role and scope, delegation constraints, unique key IDs and thresholds, critical-field handling, and mandatory cross-type rejection.
- **Existing RFC coverage:** C-032 covers signer independence and C-030 root compromise; neither prevents legitimate subordinate keys from being accepted outside their role.

### C-072: Rotation does not prove control of the replacement private key

- **Status:** Open
- **Severity:** High
- **Affected:** [key lifecycle](docs/key-lifecycle.md), [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [coin hardware](docs/coin-hardware.md)
- **Complaint:** The old key can authorize caller-supplied `newKey` bytes without proving that the corresponding private key exists, is usable, or is the exact staged key inside the same core.
- **Failure mode:** A compromised host substitutes an attacker key during refresh; the account rotates successfully while the physical coin loses authority.
- **Requested RFC change:** Make replacement bytes core-selected and require old-key authorization plus new-key proof of possession and same-core attestation over one canonical rotation transcript.
- **Existing RFC coverage:** C-008 covers future-slot isolation and C-059 key entropy; neither binds the installed authority to the staged core key.

### C-073: The register lacks a protected merchant administration plane

- **Status:** Open
- **Severity:** High
- **Affected:** [register and checkout](docs/register-and-checkout.md), [operator network](docs/operator-network-and-business.md), [master architecture](docs/master-architecture.md)
- **Complaint:** Settlement destinations, merchant identity, policies, quote sources, fee rules, exposure limits, trust feeds, endpoints, receipt keys, and maintenance access have no authenticated configuration lifecycle or privilege model.
- **Failure mode:** A cashier, technician, or compromised management account changes the destination; display, receipt, and claim remain mutually consistent while value is diverted.
- **Requested RFC change:** Define merchant enrollment, least-privilege administration, strong authentication, dual approval for critical changes, signed monotonic configurations, out-of-band alerts, and tamper-evident off-device audit records.
- **Existing RFC coverage:** C-002 and C-003 address customer authorization and malicious display, not unauthorized changes to a legitimate merchant configuration.

### C-074: The powered register mechanism has no human-safety profile

- **Status:** Open
- **Severity:** Medium
- **Affected:** [register and checkout](docs/register-and-checkout.md), [master architecture](docs/master-architecture.md), [request for comments](REQUEST_FOR_COMMENTS.md)
- **Complaint:** Moving gates, rails, levers, return paths, and service openings have no hazard analysis, reachable-motion envelope, force and stored-energy limits, guarding, safe stop, or restart and jam-clear rules.
- **Failure mode:** A customer or technician reaches into a path during retry, power restoration, or service and suffers pinch, shear, or crush injury while coin custody remains otherwise correct.
- **Requested RFC change:** Require a physical-safety risk assessment, inaccessible or force-limited motion, fail-safe interlocks, isolated maintenance state, intentional local restart, single-fault tests, and emergency or presence protection where necessary.
- **Existing RFC coverage:** C-042 covers monetary custody and substitution during jams, not human injury.

### C-075: Shared counterfactual factories create cross-account liveness risk

- **Status:** Open
- **Severity:** High
- **Affected:** [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [key lifecycle](docs/key-lifecycle.md), [operator network](docs/operator-network-and-business.md)
- **Complaint:** Canonical ERC-4337 bundlers can throttle or ban a staked factory based on failures and non-inclusion from unrelated accounts. Correct bytecode, derivation, initialization, and simulation do not establish current mempool eligibility.
- **Failure mode:** Attackers damage a shared factory's reputation, causing a genuinely funded counterfactual coin's first claim to be rejected before inclusion.
- **Requested RFC change:** Prefer deployment and finality before funding. If counterfactual funding remains, make factory reputation a live claimability condition and provide a tested direct-submission recovery route and abuse policy.
- **Existing RFC coverage:** C-021 covers counterfactual derivation and deployment correctness, not mutable offchain factory reputation.

### C-076: Batch approval does not prove assembled-unit production conformance

- **Status:** Open
- **Severity:** High
- **Affected:** [coin hardware](docs/coin-hardware.md), [trust and manufacturing](docs/trust-and-manufacturing.md)
- **Complaint:** The RFC defines design evaluation and core provisioning but no volume-line process controls, end-of-line testing, destructive lot sampling, genealogy, excursion thresholds, or quarantine for the complete assembled coin.
- **Failure mode:** Approved parts and manifests cover moisture, reflow, bonding, or handling defects that later cause marginal power, torn state, bad buttons, or stranded backing.
- **Requested RFC change:** Define a versioned manufacturing-conformance profile with controlled process windows, per-unit functional and margin tests, lot sampling, traceability, abnormal-yield limits, containment, and rework rules.
- **Existing RFC coverage:** C-018 covers design lifetime and C-067 covers component changes; neither proves each production lot conforms to the unchanged design.

### C-077: BSLRR discovery can disclose stable phone identity

- **Status:** Open
- **Severity:** Medium
- **Affected:** [verification and BSLRR](docs/verification-and-bslrr.md), [privacy routes](docs/privacy-routes.md)
- **Complaint:** NFC-bootstrapped Bluetooth or peer-to-peer Wi-Fi can expose persistent addresses, peer names, service identifiers, scan-response data, or resolvable identities before encrypted BSLRR exchange begins.
- **Failure mode:** Venues link a holder's offline handoffs across coins and epochs through phone discovery metadata despite ephemeral application payloads.
- **Requested RFC change:** Define a transport-privacy profile using per-session discovery identifiers, no names or bonding, strongest available private addressing, bounded advertising, and packet-capture tests across restarts; qualify privacy where platforms cannot comply.
- **Existing RFC coverage:** C-013 covers the coin's NFC identity and C-034 covers BSLRR payload tags, not participant-phone discovery traffic.

### C-078: Manufacturing quantity ceilings are not cumulatively consumed

- **Status:** Open
- **Severity:** High
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md), [open questions](docs/open-questions.md)
- **Complaint:** A manufacturer grant's quantity ceiling has no authorization ID, global allocation namespace, cumulative counter, or verifier rule preventing many individually capped descendant batches from reusing the same allowance.
- **Failure mode:** A compromised manufacturer key issues many correctly typed and logged batches, each within the nominal cap, multiplying total production without violating any per-manifest check.
- **Requested RFC change:** Give grants immutable IDs and cumulative limits, allocate disjoint one-use ranges to batches, reject overlap and excess, and define one rollback-resistant consistency domain for consumption.
- **Existing RFC coverage:** C-069 constrains membership within one batch; this reuses the parent allowance across many valid batches.

### C-079: Batch Merkle commitments lack a canonical proof profile

- **Status:** Open
- **Severity:** High
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md), [verification](docs/verification-and-bslrr.md)
- **Complaint:** Hash algorithm, leaf encoding, domain separation, ordering, non-power-of-two shape, duplicate handling, index, path orientation, and binding to signed count are unspecified.
- **Failure mode:** A manifest claims a count of 10 while a generic path verifier accepts membership for 1,000 leaves under the same root, or different clients assign different meanings to one proof.
- **Requested RFC change:** Version a canonical tree and leaf schema, bind root and exact tree size, require indexed bounded inclusion verification, domain-separate leaves and nodes, reject duplicates and unknown algorithms, and use the same profile in zero-knowledge circuits.
- **Existing RFC coverage:** C-069 requires inventory membership and C-078 cumulative allocation; neither makes one root cryptographically commit to its claimed count.

### C-080: Register-controller executable integrity is unspecified

- **Status:** Open
- **Severity:** High
- **Affected:** [register and checkout](docs/register-and-checkout.md), [operator network](docs/operator-network-and-business.md), [master architecture](docs/master-architecture.md)
- **Complaint:** The security-critical controller has no hardware-anchored boot chain, authenticated and anti-rollback update process, debug lock, protected keys, component isolation, self-test, or interrupted-update recovery.
- **Failure mode:** A malicious or rolled-back controller image preserves legitimate configuration while redirecting claims, leaking receipt keys, suppressing location faults, and falsifying evidence for every later customer.
- **Requested RFC change:** Define the controller trusted computing base, authenticated boot and measurement, signed monotonic updates, fail-safe recovery, debug restrictions, least-privilege component isolation, non-exportable keys, integrity self-tests, and support lifetime.
- **Existing RFC coverage:** C-016 applies to coin firmware, C-056 to hostile tender parsing, and C-073 to administration; none roots the executable enforcing register behavior.

### C-081: The circulating token lacks an ingestion and small-parts safety gate

- **Status:** Open
- **Severity:** Medium
- **Affected:** [master architecture](docs/master-architecture.md), [coin hardware](docs/coin-hardware.md), [trust and manufacturing](docs/trust-and-manufacturing.md)
- **Complaint:** Coin dimensions and enclosure retention are unresolved despite foreseeable access by children and release of buttons, display fragments, or shell parts after circulation and abuse.
- **Failure mode:** The whole token or a detached component becomes a choking, aspiration, or ingestion hazard while every monetary and reliability check passes.
- **Requested RFC change:** Define market-specific minimum geometry, small-parts fixtures, use-and-abuse conditioning, component-retention criteria, damaged-token retirement, and production/refurbishment requalification before circulation trials.
- **Existing RFC coverage:** C-018 concerns useful life and C-074 register motion; neither addresses ingestion of the passive token.

### C-082: Damaged coin enclosures lack sharp-edge and puncture testing

- **Status:** Open
- **Severity:** Medium
- **Affected:** [coin hardware](docs/coin-hardware.md), [trust and manufacturing](docs/trust-and-manufacturing.md)
- **Complaint:** Brittle covers, metal layers, antenna conductors, seams, and button hardware can become accessible sharp edges or points after foreseeable damage without making the coin electronically invalid.
- **Failure mode:** A still-attesting damaged token cuts or punctures a holder, cashier, child, or service worker.
- **Requested RFC change:** Add conditioned sharp-edge and point testing after drop, impact, flex, torque, wear, washing, temperature, aging, and refurbishment, with quarantine cues and safe return handling.
- **Existing RFC coverage:** C-081 concerns ingestion; objects too large to ingest can still lacerate or puncture.

### C-083: EIP-7702 can leave a hidden second authority over coin accounts

- **Status:** Open
- **Severity:** High
- **Affected:** [Ethereum accounts](docs/ethereum-accounts-and-assets.md), [key lifecycle](docs/key-lifecycle.md)
- **Complaint:** If an EIP-7702 delegated EOA is accepted as the smart account, its separate secp256k1 authority can replace or clear delegation independently of the coin's P-256 lifecycle.
- **Failure mode:** A loader retains the EOA key, later installs attacker code at the funded address, and drains it while all visible P-256 account state had verified correctly.
- **Requested RFC change:** Make the first profile an ordinary deployed immutable contract and reject EIP-7702 delegation indicators. Any later EIP-7702 profile must put the EOA key inside the same non-exportable lifecycle and serialized authority model.
- **Existing RFC coverage:** C-021 covers counterfactual deployment and C-072 P-256 rotation; neither models a consensus-recognized alternate EOA authority.

### C-084: Anonymous-proof setup can become an unbounded provenance authority

- **Status:** Open
- **Severity:** High
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md), [privacy routes](docs/privacy-routes.md), [verification](docs/verification-and-bslrr.md)
- **Complaint:** A setup-dependent zero-knowledge membership system can be unsound to anyone retaining its structured-reference-string trapdoor even when the circuit, tree, and signed verifying key are correct.
- **Failure mode:** The setup holder forges unlimited accepted inventory-membership proofs for counterfeit keys without compromising batches, credentials, or logs.
- **Requested RFC change:** Bind proof system, circuit, public inputs, parameters, and generation transcript in the profile; prefer transparent setup or require a public verifiable multiparty ceremony and treat suspected setup compromise as profile-wide compromise.
- **Existing RFC coverage:** C-069 constrains credential issuance and C-079 defines the tree; neither guarantees proof-system soundness against the setup authority.

### C-085: Revocation growth can disable anonymous local attestation

- **Status:** Open
- **Severity:** Medium
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md), [verification](docs/verification-and-bslrr.md), [coin hardware](docs/coin-hardware.md)
- **Complaint:** Anonymous-attestation revocation can make proof size, core work, verifier work, policy transfer, and passive energy grow with the revocation list, but no lifetime bound exists.
- **Failure mode:** A legitimate unrevoked passive coin can no longer produce or transmit an acceptable proof after years of list growth, effectively revoking an entire class through resource exhaustion.
- **Requested RFC change:** Select a revocation profile with explicit lifetime complexity and energy bounds, benchmark worst-case list growth, and define accumulator or epoch rollover and migration before limits are exceeded.
- **Existing RFC coverage:** C-029 protects metadata freshness and C-011 the nominal power envelope; neither bounds revocation-dependent growth over product life.

### C-086: Anonymous membership is not bound to the fresh core response

- **Status:** Open
- **Severity:** High
- **Affected:** [verification](docs/verification-and-bslrr.md), [trust and manufacturing](docs/trust-and-manufacturing.md), [privacy routes](docs/privacy-routes.md)
- **Complaint:** A valid membership proof and a separate fresh response signature can be verified independently without proving that the response key is the member committed in the batch or that the proof authenticates the complete current response.
- **Failure mode:** Counterfeit devices replay one genuine static membership proof while signing fresh nonces and arbitrary lifecycle or account state with attacker keys.
- **Requested RFC change:** Define one canonical evidence digest and require the anonymous scheme to authenticate that exact nonce and response under the same enrolled member secret or prove certified same-core derivation of a separate response key.
- **Existing RFC coverage:** C-060 ensures challenge freshness and C-068 enrollment binding; neither joins provenance to the presentation-time response.

### C-087: The NFC register lacks an RF and implanted-device safety profile

- **Status:** Open
- **Severity:** Medium
- **Affected:** [register and checkout](docs/register-and-checkout.md), [coin hardware](docs/coin-hardware.md)
- **Complaint:** The powered reader has no upper bound on field strength, duty cycle, activation duration, antenna geometry, fault-on time, human exposure, or electromagnetic compatibility with active implanted medical devices.
- **Failure mode:** A customer or worker near a large or stuck-on 13.56 MHz field experiences clinically relevant implant interference despite correct payment operation.
- **Requested RFC change:** Bind and test the assembled RF profile under normal and single-fault conditions, enforce hardware field-off timeout, assess implant EMC and human exposure, and provide an equivalent separated workflow where necessary.
- **Existing RFC coverage:** C-011 asks whether enough energy reaches the coin, not whether emitted energy is safe for people and nearby devices.

### C-088: The powered coin path lacks foreign-object and thermal safety controls

- **Status:** Open
- **Severity:** Medium
- **Affected:** [register and checkout](docs/register-and-checkout.md), [coin hardware](docs/coin-hardware.md)
- **Complaint:** Long or elevated inductive powering has no selected power mode, field and duty bounds, foreign-object detection, load monitoring, temperature limit, or cool-before-return state.
- **Failure mode:** An ordinary coin, paperclip, foil, stacked tender, damaged antenna, or conductive debris heats during retry and is returned hot enough to injure a customer or damage the token.
- **Requested RFC change:** Define the permitted power profile, hardware timeout and fault removal, foreign-object and abnormal-load detection, worst-case thermal tests, touch-temperature limits, and visible inaccessible cooling or quarantine.
- **Existing RFC coverage:** C-087 concerns tissue exposure and implant EMC; compliant exposure does not establish metallic-object temperature.

### C-089: The circulating token lacks a chemical-material safety profile

- **Status:** Open
- **Severity:** Medium
- **Affected:** [coin hardware](docs/coin-hardware.md), [trust and manufacturing](docs/trust-and-manufacturing.md)
- **Complaint:** Shells, buttons, coatings, inks, adhesives, potting, seals, plating, solder, and exposed surfaces have no composition, migration, sensitizer-release, or repeated-contact qualification.
- **Failure mode:** A fully functional coin exposes holders to restricted PAHs, nickel release, heavy metals, phthalates, or other unsuitable materials after wear, washing, or refurbishment.
- **Requested RFC change:** Define a market-specific material inventory and contact profile, supplier and analytical evidence, conditioned release testing, restricted-substance limits, change control, containment, and safe refurbishment and recycling.
- **Existing RFC coverage:** C-081 and C-082 cover physical ingestion and sharp features, not chemical exposure from intact surfaces.

### C-090: The powered register lacks electrical-shock and fire safety requirements

- **Status:** Open
- **Severity:** High
- **Affected:** [register and checkout](docs/register-and-checkout.md), [master architecture](docs/master-architecture.md)
- **Complaint:** Supply architecture, available energy, insulation, earthing, clearances, touch current, overcurrent protection, wiring, component faults, fire containment, and liquid or conductive-object ingress are unspecified.
- **Failure mode:** A stalled actuator, abraded lead, spill, debris, wrong supply, or single insulation fault shocks a person or ignites the enclosure despite correct payment logic.
- **Requested RFC change:** Define a complete-equipment electrical safety profile with energy-source classification, safeguards, ratings, abnormal and single-fault tests, fire behavior, production routine tests, and configuration-bound evidence.
- **Existing RFC coverage:** C-074 covers moving-part injury and C-088 inductive heating, not contact with supply energy or electrical fire.

### C-091: The powered register lacks EMC and radio-spectrum qualification

- **Status:** Open
- **Severity:** Medium
- **Affected:** [register and checkout](docs/register-and-checkout.md), [coin hardware](docs/coin-hardware.md)
- **Complaint:** The intentional 13.56 MHz source and payment-critical electronics have no emissions, spectrum, conducted-noise, receiver, immunity, port, cable, disturbance, or operating-mode profile.
- **Failure mode:** The register interferes with neighboring equipment or ordinary RF and conducted disturbances reset sensors, actuate a gate, lose coin location, or change payment state.
- **Requested RFC change:** Define market-specific radio and EMC limits, test the complete configured register in every state, and require payment-specific fail-closed performance under radiated, conducted, transient, surge, dip, and proximity disturbances.
- **Existing RFC coverage:** C-087 concerns people and implants; compliance with exposure limits does not establish emissions coexistence or functional immunity.

### C-092: The BSLRR bootstrap is not bound to the bulk-transfer peer

- **Status:** Open
- **Severity:** Medium
- **Affected:** [verification and BSLRR](docs/verification-and-bslrr.md), [privacy routes](docs/privacy-routes.md)
- **Complaint:** NFC bootstrap and the later Bluetooth or peer-to-peer Wi-Fi session lack one authenticated key exchange and transcript binding the intended phones, endpoint keys, carrier session, coin state, roles, and root update.
- **Failure mode:** A nearby attacker splices two individually encrypted but unauthenticated sessions, learns the complete BSLRR history, and relays a root-consistent handoff.
- **Requested RFC change:** Define an NFC-authenticated ephemeral AKE with mutual key confirmation and one canonical transcript bound into the coin update; reject Just Works or self-asserted certificates as sole authentication.
- **Existing RFC coverage:** C-077 hides discovery identifiers; it does not authenticate the discovered endpoint.

### C-093: Later member-secret exposure can deanonymize retained attestations

- **Status:** Open
- **Severity:** Medium
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md), [privacy routes](docs/privacy-routes.md), [verification](docs/verification-and-bslrr.md)
- **Complaint:** Some anonymous-attestation revocation mechanisms publish or expose a member secret that can test every archived random-base signature from that member, defeating backward unlinkability.
- **Failure mode:** Years after circulation, one extracted or published secret lets merchants or data brokers identify every retained historical presentation of that coin.
- **Requested RFC change:** Specify the post-compromise privacy contract, require backward-unlinkable revocation or evolving erased credentials for unqualified privacy claims, and otherwise label retrospective traceability and minimize transcript retention.
- **Existing RFC coverage:** C-062 covers an opener available from issuance and C-035 immediate fingerprinting; this capability appears only after later secret exposure.

### C-094: Verifier-controlled signature revocation can become a linking oracle

- **Status:** Open
- **Severity:** Medium
- **Affected:** [trust and manufacturing](docs/trust-and-manufacturing.md), [verification](docs/verification-and-bslrr.md)
- **Complaint:** A verifier may tailor a signature-revocation list with a retained prior presentation and observe whether the current coin can produce a non-revocation proof.
- **Failure mode:** One prior transcript becomes an active one-bit test for whether a physically presented coin is the same member, without exposing a key or using a basename.
- **Requested RFC change:** Authenticate one uniform monotonic revocation checkpoint, prohibit local ad hoc entries, bind its digest into evidence, globally audit entry admission, and qualify profiles that remain actively linkable.
- **Existing RFC coverage:** C-085 concerns revocation-list resource growth and C-093 retrospective secret exposure; one tailored entry creates this link without either.

### C-095: The complete register lacks stability and mounting qualification

- **Status:** Open
- **Severity:** Medium
- **Affected:** [register and checkout](docs/register-and-checkout.md), [master architecture](docs/master-architecture.md)
- **Complaint:** Register form, mass, center of gravity, supports, feet, anchorage, doors, trays, handles, cables, and installation assumptions have no stability or mounting profile.
- **Failure mode:** Customer pulling, child interaction, cleaning, cable force, an open service panel, or loaded chamber causes the complete unit to slide, overturn, detach, or fall despite safe internal motion.
- **Requested RFC change:** Define each installation configuration and test complete equipment under least-stable loads, push/pull, relocation, mounting, handle, cable, and misuse cases; require rated anchorage and inspection where inherent stability is insufficient.
- **Existing RFC coverage:** C-074 concerns injury from internal moving parts, not motion of the complete equipment and its support.

### C-096: Delegated private-proof generation can reveal the exact refresh link

- **Status:** Open
- **Severity:** Medium
- **Affected:** [privacy routes](docs/privacy-routes.md), [open questions](docs/open-questions.md)
- **Complaint:** Zero knowledge hides the witness from verifiers, not from the party executing the prover. A remote prover can receive old-note membership and nullifier material plus the new destination and transaction randomness.
- **Failure mode:** A valid private refresh completes without exposing reusable spending authority, while the proving service records the exact old-to-new relationship and later correlates it with merchants or analytics.
- **Requested RFC change:** Specify witness visibility and collusion assumptions; prefer holder-controlled proving or a formally analyzed blinded, distributed, or confidential-computing delegation profile, and label any single informed prover as a transaction-linking authority.
- **Existing RFC coverage:** C-027 binds the selected protocol and C-028 its lifecycle; neither protects privacy from an honest-but-curious delegated prover.
