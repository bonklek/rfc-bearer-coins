# Complaint triage (C-012–C-096)

This historical triage began after D-011 and classifies the 85 complaints from
C-012 through C-096. Later accepted decisions are recorded in the same snapshot.
It determines which findings need a product decision and which can proceed as
engineering requirements without repeated approval.

The categories do not mark a complaint resolved. Resolution still requires the
RFC text, implementation, evidence, tests, or operating policy identified in
[the complaint log](./COMPLAINTS.md).

## Triage rules

### Covered or deferred

Use this category when an accepted decision makes the issue non-applicable to the
first profile, substantially supplies its answer, or deliberately reserves the
feature for a later generation. Reopen the complaint if the excluded feature is
introduced.

### Auto-adopt engineering safeguard

Use this category when the proposed correction:

- does not change physical bearer transfer or normal checkout interaction;
- does not add a mandatory intermediary, account, phone, or network check;
- improves cryptographic binding, crash consistency, privacy, testability,
  manufacturing integrity, safety, or commercial measurement; and
- remains subject to the non-negotiable product invariants.

These findings may be incorporated without individual product-owner approval.
`Auto-adopt` does not mean that an untested claim may be presented as complete.

### User review required

Use this category when the answer changes bearer-loss behavior, custody,
multi-coin checkout, visible confirmation, accessibility, physical fungibility,
operator compensation, or permissionlessness during exceptional chain events.

## Summary

| Queue | Count | Next action |
|---|---:|---|
| Covered or deferred | 12 | Preserve the exclusion or accepted invariant; reopen only with scope change. |
| Auto-adopt engineering safeguard | 63 | Incorporate in coordinated technical programs without one-by-one approval. |
| Accepted during product review | 7 | D-014, D-037, D-038, D-039, D-040, D-044, and D-045 record the selected product behavior. |
| Resolved by product decision | 1 | C-051 rejects an additional Asset Profile marker for the first-generation display. |
| User review required | 2 | Discuss and accept or reject individually. |
| Total classified | 85 | C-012 through C-096, each listed exactly once below. |

## Covered or deferred

| ID | Topic | Triage reason |
|---|---|---|
| C-021 | Counterfactual account assurance | Version 1 requires a deployed immutable account before proof-activated funding. Reopen for any counterfactual profile. |
| C-026 | Unsolicited-asset sweeping | Version 1 does not execute arbitrary token sweeps. D-007 handles only surplus of the represented AssetID. |
| C-027 | Private-refresh authorization binding | Private refresh is later-generation work. Its extension point inherits D-002 and D-004 and must bind the complete proof instance before activation. |
| C-028 | Private-refresh durable lifecycle | Production private refresh is deferred; transparent lifecycle ships first. The complaint remains its gate. |
| C-046 | Accept without claim | The two merchant paths, recirculation and exceptional claim, are already an accepted product invariant. |
| C-050 | Loader role | D-005 defines permissionless proof-activated loading and an optional commercial loader without exclusive authority. |
| C-053 | Legal feasibility | Jurisdiction-specific role analysis is explicitly deferred until technical and product feasibility; it cannot become a protocol permission gate. |
| C-061 | ERC-4337 retry authority | D-004 and D-006 preserve one inner intent and exact stored signature across replaceable transport. Remaining conformance work is grouped with C-065. |
| C-075 | Shared counterfactual factory risk | Counterfactual funding is excluded from version 1 by the deployed-account rule. |
| C-083 | EIP-7702 second authority | Version 1 uses an ordinary deployed immutable contract and excludes EIP-7702. |
| C-084 | Anonymous-proof setup authority | Production anonymous proof profiles are gated. Transparent setup is preferred; any later setup-dependent profile must reopen this issue. |
| C-096 | Delegated private-proof linkability | Production private refresh is deferred. Holder-controlled proving is the preferred future baseline; delegated proving must disclose its linking authority. |

## Resolved by product decision

| ID | Topic | Disposition |
|---|---|---|
| C-051 | Physical policy fungibility | Rejected for the first-generation profile. The reusable e-paper face remains limited to represented asset, amount, and local status under the one-chain-per-asset launch constraint. D-045 adds a short approved chain name and icon to register confirmation, and verifier clients expose exact chain and asset metadata. No Asset Profile marker is introduced. A future relaxation of the one-chain-per-asset constraint requires a new product decision. |

## Auto-adopt engineering safeguards

| ID | Topic | Adopted direction |
|---|---|---|
| C-012 | Visible display integrity | Use authenticated display generations, unmistakable interrupted-update state, optical comparison, and an explicit statement that overlays are externally detected. |
| C-013 | NFC-layer privacy | Require RF disconnection at rest, non-identifying active-session behavior, and lower-layer packet analysis. |
| C-015 | Refurbishment boundary | Treat the complete assembly as security-relevant and requalify, reseal, and issue a new credential for every reused assembly. |
| C-016 | Firmware measurement root | Bind immutable measurement and attestation roots, signed monotonic updates, downgrade prevention, debug state, and torn-update recovery. |
| C-017 | BSLRR crash consistency | Keep verification stateless by default; use an idempotent journal and exact retry only for requested continuity mutation. |
| C-018 | Hardware mission profile | Define service life and accelerated aging for memory, buttons, display, antenna, seals, and enclosure. |
| C-019 | Physical-test pass criteria | Publish attacker budgets, success thresholds, tested configuration, and denomination claims supported by measured fixed and marginal attack cost. |
| C-020 | ERC-4337 fee authority | Use a separate typed transport authorization with chain, EntryPoint, gas and fee caps; prefer external or paymaster gas. |
| C-022 | Funded but unclaimable assets | Separate balance from live claimability and report restrictions without blocking physical handoff. |
| C-023 | Proxy and upgrade proofs | Version code, proxy, storage, decoding, and block context; downgrade assurance on unknown implementation changes. |
| C-024 | P-256 compatibility | Specify exact hashing, encoding, normalization, nonce semantics, precompile return handling, and known-answer tests. |
| C-025 | Gas feasibility | Gate each asset and path on reproducible gas benchmarks and a maximum fee-to-denomination ratio. |
| C-029 | Trust-feed rollback | Require versioned expiring snapshots, monotonic progression, consistent hashes, supersession, and visible stale status. |
| C-030 | Ecosystem-root recovery | Use threshold-controlled root rotation, monotonic versions, cross-signing, and independent offline recovery anchors. |
| C-031 | Attestation blast radius | Forbid shared member secrets; use unique hardware-bound secrets and granular revocation handles. |
| C-032 | Organizational independence | Count separately administered entities and define precisely what each signature attests. |
| C-033 | Transparency-log reliance | Any policy claiming batch or cutoff containment must require fresh witnessed inclusion and consistency evidence. |
| C-034 | BSLRR participant tagging | Constrain participant inputs, disclose retained-link risk, and use unlinkable continuation when prior event material must be hidden. |
| C-035 | Auxiliary-field fingerprinting | Minimize disclosure and use unlinkable lifecycle-predicate proofs instead of exact counters and roots by default. |
| C-036 | Feed-retrieval tracking | Use bulk cohort downloads or local mirrors; prohibit baseline per-core lookups. |
| C-041 | Dispute receipts | Define canonical pre-claim and post-claim evidence while keeping technical detail secondary in the normal UI. |
| C-042 | Jam and substitution recovery | Track one coin across checkpoints and use location-specific return or quarantine states with no unresolved service access. |
| C-043 | Register capacity | Publish stage capacity, timeout, bypass, return, and quarantine envelopes. |
| C-047 | Circulation adverse selection | Model age and history effects and measure whether optional non-claim acceptance remains rational; limits stay recipient-selected. |
| C-048 | Fleet-wide exploit economics | Model fixed and marginal attack cost, batch exposure, detection delay, migration capacity, and denomination ceilings. |
| C-049 | Claim broadcast delay | Define a broadcast SLA and gas reserve; label or withhold commercial credit when submission is deliberately deferred. |
| C-052 | Unit economics | Build a parameterized pessimistic model and explicit pilot thresholds. |
| C-054 | Pilot claims | Separate engineering, adversarial-value, circulation, and commercial pilots and limit the claims drawn from each. |
| C-055 | ECDSA nonce safety | Use deterministic reset-safe signing for the canonical digest and test power-cycle, fault, and side-channel behavior. |
| C-056 | Hostile coin parsing | Bound every schema, isolate unauthenticated parsing, reset sessions, fuzz parsers, and expose a fixed authenticated interface to the claim controller. |
| C-058 | Duplicate managed settlement | Enforce one provider-wide settlement identity and atomic unique credit across every retry and transport wrapper. |
| C-059 | Key-generation entropy | Specify entropy sources, conditioning, health tests, failure behavior, environmental limits, and evaluated configuration. |
| C-060 | Verifier challenge freshness | Require at least 128 unpredictable bits, one outstanding challenge, secure consumption, and fail-closed randomness. |
| C-062 | Attestation opener privacy | Prefer an unopenable profile for anonymity claims; otherwise label exactly which colluding authorities can trace. |
| C-063 | Treasury and beneficiary binding | Bind provider settlement instructions, beneficiary, payout, fees, expiry, and claim identity into the authorized settlement context. |
| C-064 | Sponsored-gas loss controls | Use one-use typed sponsorship, bounded gas and fee authority, sponsor nonces, budgets, quotas, and explicit reverted-operation loss allocation. |
| C-065 | ERC-4337 validity bounds | Return authenticated validity windows through the canonical validation format and test canonical-mempool and direct-relay behavior. |
| C-067 | Evaluated configuration changes | Bind credentials to the complete versioned configuration and require impact analysis and delta qualification for supplier changes. |
| C-068 | Same-core batch enrollment | Require challenged hardware-root proof, possession, immutable device and firmware binding, and transcript-bound batch leaves. |
| C-069 | Anonymous credential inventory | Bind each accepted member lineage to one logged batch leaf or drop quantity-containment claims. |
| C-070 | Anonymous-proof randomness | Put proof randomness and host inputs inside the defined privacy boundary and test hostile-host behavior. |
| C-071 | Metadata role separation | Use typed versioned envelopes, scoped delegation, unique key IDs, thresholds, critical fields, and cross-type rejection. |
| C-072 | Replacement-key possession | Require core-selected replacement bytes, old-key authorization, new-key possession, and same-core attestation in one transcript. |
| C-073 | Merchant administration | Use least privilege, strong authentication, dual approval for critical changes, monotonic signed configuration, alerts, and off-device audit records. |
| C-074 | Register mechanism safety | Require force limits, interlocks, isolated maintenance, intentional restart, and complete single-fault testing. |
| C-076 | Production conformance | Define process windows, per-unit tests, lot sampling, traceability, abnormal-yield containment, and controlled rework. |
| C-077 | Phone discovery privacy | Use per-session discovery identifiers, no stable names or bonding, private addressing, bounded advertising, and packet-capture tests. |
| C-078 | Quantity-grant consumption | Use immutable grant IDs, cumulative limits, disjoint one-use ranges, and rollback-resistant allocation. |
| C-079 | Batch Merkle profile | Canonicalize tree, leaf, size, index, algorithms, duplicate rejection, and zero-knowledge compatibility for core-identity batches. |
| C-080 | Claim-controller integrity | Specify the trusted computing base, authenticated boot, measured updates, recovery, debug restrictions, isolation, keys, and support lifetime. |
| C-081 | Ingestion and small parts | Define market-specific geometry, retention, abuse conditioning, damaged-token retirement, and requalification. |
| C-082 | Sharp edges and puncture | Test conditioned damaged assemblies and define quarantine and safe-return handling. |
| C-085 | Revocation scaling | Bound lifetime proof, core, verifier, and policy costs and define accumulator or epoch migration before resource exhaustion. |
| C-086 | Membership-response binding | Authenticate the exact fresh response with the enrolled member secret or prove same-core derivation. |
| C-087 | RF and implanted-device safety | Qualify the assembled RF profile, hardware field timeout, exposure and implant EMC, plus an equivalent separated workflow. |
| C-088 | Foreign objects and heat | Add abnormal-load detection, hardware timeout, thermal limits, cooling, and inaccessible quarantine. |
| C-089 | Chemical and material safety | Define contact materials, supplier evidence, restricted substances, conditioned release, change control, and recycling. |
| C-090 | Electrical and fire safety | Qualify the complete powered register under normal, abnormal, and single-fault conditions with production routine tests. |
| C-091 | EMC and spectrum | Test the complete configured register in every state and require fail-closed monetary behavior under disturbance. |
| C-092 | BSLRR peer binding | Use an NFC-authenticated ephemeral key exchange with mutual confirmation and one canonical transcript. |
| C-093 | Post-compromise unlinkability | Use evolving erased credentials for unqualified backward-privacy claims; otherwise label retrospective traceability and minimize retention. |
| C-094 | Revocation linking oracle | Use one authenticated monotonic checkpoint, prohibit verifier-local entries, bind its digest, and audit admission. |
| C-095 | Register stability | Test complete installations under load, movement, cables, access panels, and misuse; require rated anchorage where necessary. |

## Accepted during product review

| ID | Topic | Accepted direction |
|---|---|---|
| C-014 | Destructive tamper response | D-014 uses irreversible tamper evidence, disables future loading, preserves one exact all-three-button evacuation, and permanently retires the core after finalized zero-out. Automatic monetary-key destruction is not the consumer default. |
| C-037 | Custody and loss allocation | D-037 records customer-approved secure gate crossing as the intended commercial acceptance event. The reference operating model changes from customer to merchant treatment at that event; agreements and law control legal effects. |
| C-038 | Multi-coin atomicity | D-038 uses one approved basket, per-coin gate-crossing evidence, an exact merchant remedy for partial physical routing, and one reverting same-chain `BasketClaim` when the complete authorization set exists. Pending coins never return as ordinary tender. |
| C-039 | Quotes, fees, rounding, and change | D-039 binds a relationship-appropriate quote source, integer arithmetic, one final rounding operation, all customer fees, quote expiry, selected coins, change, and failure remedies before approval. Approval locks the terms. |
| C-040 | Offline claim and merchant credit | D-040 limits standard offline checkout to verification-only acceptance. Claim requires online preflight; a later connection loss follows explicit pre-gate, post-gate, captured-authorization, and uncertain-submission recovery states. |
| C-044 | Accessible consent path | D-044 uses one standard customer basket-commit lever, authoritative visual and nonvisual terms, and a bounded fresh center cycle for each approved claim coin. It preserves verification-only routing and the existing per-coin ownership gates. |
| C-045 | Primary confirmation view | D-045 makes amount, merchant, action, tender/change, fees, short approved-chain name and icon, and material risk warnings primary in both visual and nonvisual flows. Exact identifiers and contract internals remain secondary unless they create a warning. |

## User review required

| ID | Topic | Why product-owner review is required |
|---|---|---|
| C-057 | Operator revenue attribution | Pooled revenue sharing, qualified identities, Sybil controls, and penalties materially affect the operator business model. |
| C-066 | Same-ID chain split | Freezing or qualifying claims after a contentious split affects permissionlessness and whether pre-split authorizations remain usable. |

## Review order

The recommended manual sequence is:

```text
C-057 -> C-066
```

The 63 auto-adopt findings should be implemented in coordinated groups rather
than treated as 63 unrelated product discussions: display and passive hardware,
Ethereum and transport, trust and manufacturing, privacy and BSLRR, register
security and safety, and business evidence.
