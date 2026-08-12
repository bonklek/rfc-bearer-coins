# Open questions

The questions below are unresolved. Accepted version 1 choices are
recorded in [Document authority](../DOCUMENT_AUTHORITY.md) and are not repeated
here as open product choices. Remaining questions separate hardware feasibility,
protocol design, and commercial validation so a positive result in one layer is
not mistaken for proof of the others.

Questions that require an explicit product choice rather than research or
implementation evidence are collected in
[Open product decisions](../OPEN_DECISIONS.md).

## Related docs

- [Master architecture](./master-architecture.md)
- [Coin hardware](./coin-hardware.md)
- [Key lifecycle and claim protocol](./key-lifecycle.md)
- [Verification and BSLRR](./verification-and-bslrr.md)
- [Register and checkout](./register-and-checkout.md)
- [Ethereum accounts and assets](./ethereum-accounts-and-assets.md)
- [Privacy routes](./privacy-routes.md)
- [Trust, manufacturing, and compromise response](./trust-and-manufacturing.md)
- [Operator network and business model](./operator-network-and-business.md)

## Gating hardware questions

- Which secure element or secure MCU can execute the complete custom state machine within an evaluated configuration?
- Can a batteryless core durably commit a prepared authorization before releasing it under arbitrary power interruption and fault injection?
- Can the core prevent every conflicting monetary authorization after `AUTH_PENDING` while still supporting exact retry?
- Does available hardware expose P-256, attestation, persistent transactions, and lifecycle controls with acceptable vendor access and cost?
- What exact tamper events can a passive coin detect, and what attacks remain invisible while unpowered?
- What confirmation, false-positive, evidence-retention, and attack thresholds govern the irreversible `TAMPER_SUSPECTED` transition?
- Can the core enforce evacuation-only key access and permanent post-evacuation retirement under power interruption and fault injection?
- Can the secure subsystem authenticate display state strongly enough to detect stale labels, overlays, or peripheral substitution?
- What relay distance, latency, false-accept rate, and false-reject rate does the complete passive prototype exhibit under adversarial forwarding equipment?
- Can a practical distance-bounding profile fit the passive power, timing, secure-core, register, and cost envelope without becoming mandatory for ordinary offline handoff?
- Can the passive core verify the selected finalized-chain and account-state proof within its harvested-energy, RAM, storage, latency, and thermal budgets?
- Can proof reception, verification, lifecycle commitment, and display update recover from every NFC power interruption as exactly `AWAITING_LOAD_PROOF` or fully `ACTIVE`?
- What quantitative field, coupling, reservoir, brownout, duration, retry, duty-cycle, and thermal limits apply to each D-011 operation profile on the complete assembly?
- Which phones satisfy only stateless verification, and which, if any, satisfy a persistent-mutation profile under tested coupling conditions?
- How thick, durable, washable, drop-resistant, and abrasion-resistant can the full package be?

## Finite key-slot questions

- How many generate-on-advance epochs provide useful life within irreversible-counter, key-storage, endurance, and product-cost limits?
- Can the selected core atomically install a newly generated key, advance the epoch, and destroy the old key before any public output under arbitrary power interruption?
- What evaluated entropy source and health tests remain reliable under passive RF-powered cold starts and adversarial environmental conditions?
- What exact attack boundary supports the claim that future monetary keys do not yet exist, and what complete-core compromises can still control later generation?
- Can a future physical-cell profile demonstrate that attacking the current cell does not expose or control later cells?
- Is early slot exhaustion a practical denial-of-service problem?
- Must every exhausted core be replaced, or could a future independently certifiable reconfigurable physical primitive provide equivalent freshness?
- What exact epoch count provides useful life without exceeding counter, key-generation, proof-verification, manufacturing, and refurbishment budgets?

## Claim protocol questions

- What canonical typed-encoding specification and test-vector suite best realizes the accepted logical `ClaimIntent` schema?
- What separately bounded transport fields may a relayer replace without changing the inner `ClaimIntent` digest?
- What exact encoding, integrity metadata, transactional overhead, and storage allocation does the accepted persisted-signature record require?
- Can the selected core return the stored signature after arbitrary interruption without invoking the old monetary key or accepting a digest-mismatched intent?
- What protocol proves an `AUTH_PENDING` authorization unusable before releasing a different monetary authorization?
- Can that recovery remain permissionless without creating a race between the old authorization and a replacement operation?
- When does local retirement occur relative to onchain execution and proof of confirmation?
- What implementation and conformance evidence demonstrates that version 1 has no
  monetary private-key export command or mode?

## Rotation questions

- How does the coin preserve a retry path if same-account rotation is delayed or replaced?
- Which finalized proof profile establishes depletion of the represented balance and retirement of its bearer authority before local slot advance?
- How should clients present a sealed new key whose backing is absent, unknown, or still controlled by the old account state?
- What finalized evidence proves that migration retired the old account after
  moving only the represented AssetID? Version 1 never sweeps unsolicited assets.

## Ethereum account questions

- What is the minimal immutable account interface?
- Which safe-call, balance-delta, execution-guard, and event profile implements
  D-010 for a native test asset and each approved test-token behavior class?
- Does it use ERC-4337 as the primary execution path, an account-native intent relayer, or both?
- How is P-256 key representation normalized and validated?
- What evidence would be required before a later profile could admit
  counterfactual account funding?
- Which exact balance-delta and transfer-return profile enforces the accepted represented-amount, surplus-routing, zero-balance claim across each supported asset?
- How should the system handle a residual beneficiary that becomes transfer-restricted without allowing surplus to strand the represented claim indefinitely?
- How are fee-on-transfer, pausable, rebasing, or otherwise unusual tokens excluded?
- How should clients disclose unsupported tokens that version 1
  cannot sweep?
- Which valueless test assets reproduce native, issuer-controlled, and
  wrapped/custodial behavior well enough for conformance testing? Mainnet policy
  selection is future work.

## Verification questions

- What vocabulary prevents users from confusing device attestation with backing verification?
- Should routine verification be stateless, counted, or selectable?
- What counter endurance and anti-rollback properties are available?
- Can an attacker exhaust counters by repeatedly pressing the verification buttons?
- What is the minimum online check for a base register?
- When are embedded Ethereum light clients mature enough for production-value decisions?
- How should a verifier handle inconsistent RPC providers, stale proofs, or a chain reorganization?
- Should the core verify compressed Ethereum light-client evidence directly or a succinct proof of finality and exact account state?
- How are chain forks, proof-verifier upgrades, weak-subjectivity checkpoints, and expiring proof profiles handled during a finite core's service life?

## BSLRR questions

- Does the continuity signal change real acceptance behavior enough to justify implementation?
- Should BSLRR count only explicit handoffs or also ordinary verifications?
- How is the phone-to-phone protocol authenticated across iOS and Android while offline?
- How large can the record become, and should it carry the full chain or compact proofs?
- What happens when the phone record is lost but the coin root has advanced?
- Does repeatedly disclosing root and count create more tracking risk than value?

## Register questions

- What mechanical design guarantees one-coin continuity through verification, waiting, return, and claim paths?
- What canonical gate-crossing, custody, quarantine, and provider-acceptance events implement D-037 across equipment and commercial agreements?
- What is the safe response to jams at each physical location?
- What implementation and evaluation profile proves that the accepted secure claim controller binds its authoritative display, armed intent, approval state, gate, actuator, and receipt?
- Which optional phone-to-register exchange lets a customer independently verify the armed intent without making a phone part of normal checkout?
- Which quote-source and commercial-relationship identifiers should the first profile standardize?
- Which legal cash-rounding profiles need exceptions to the default final-basket round-half-even rule?
- What canonical basket and per-coin event encodings make partial acceptance and its remedy independently auditable?
- What maximum basket size and gas envelope keeps a reverting `BasketClaim` practical for every supported asset profile?
- What freshness, submission-readiness, durable-storage, and gas-readiness tests must the claim controller pass before enabling the all-three-button mechanism?
- What reconciliation evidence distinguishes never submitted, submitted but pending, reverted, and finalized after connectivity loss?
- What lever force, travel, reach, detent, assistive interface, and guarding profile provides one-handed access without creating a new pinch or stored-energy hazard?
- What independent sensors and tests prove complete center release, exact approved cycle consumption, tracked-coin binding, and fail-safe disarm after every fault?
- Which private audio, tactile, or assistive output profile makes the canonical basket authoritative and comprehensible without requiring a personal phone?
- Which approved-chain name and icon registry provides durable recognition without implying that an icon is a technical identifier?
- Which plain-language material-warning vocabulary, severity cues, localization, and acknowledgement behavior is comprehensible under retail time pressure?
- What evidence is available if a registered register operator modifies the mechanism?

## Privacy questions

- Can Architecture B's shared commitment/nullifier pool replace per-coin smart
  accounts without introducing a larger shared failure or governance domain?
- What exact note commitment, nullifier, Merkle tree, spent-set, circuit, and
  verifying-key profile supports hardware-held shielded notes?
- Can a holder-controlled prover privately verify a fresh P-256 core signature,
  hidden note membership, and nullifier nonmembership at acceptable latency?
- What raw witness material may leave the core without enabling claim redirection,
  cloning, premature nullifier linkage, or retrospective tracking?
- Can the passive core verify a succinct Architecture B activation proof within
  its measured power and memory envelope?
- How does a note holder exit if the preferred relayer, prover, pool interface, or
  upgrade authority disappears or censors it?
- Which private-refresh system first satisfies the hardware-key and exit requirements?
- What witness can an external prover receive without obtaining reusable spending authority?
- Which anonymity-set, denomination, timing, and relayer policies are meaningful in practice?
- Can first-generation hardware provide unlinkable batch attestation?
- How are compromised individual cores handled if attestation is anonymous?
- How can backing checks reduce RPC and merchant correlation?
- What privacy statements remain true after a managed settlement provider receives the claim?

## Manufacturing and trust questions

- What root sets, thresholds, and witness combinations are practical?
- How are batch quantity commitments audited against physical output?
- What prevents factory collusion across identity generation and batch publication?
- Which transparency logs and gossip mechanisms prevent split views?
- What observation delay is useful without blocking supply?
- How do clients reconcile conflicting manufacturer, laboratory, and independent-monitor feeds?
- Which metadata fields are mandatory for hardware, firmware, and attack-profile comparison?
- How are vendor and laboratory signing keys rotated after compromise?
- What does complete manufacturing and destructive evaluation cost at each production scale?

## Operator questions

- Which roles run on a companion box, regional server, or hosted infrastructure?
- What work qualifies for network revenue share?
- How are fake traffic and self-reported availability prevented from farming rewards?
- Which operator tiers need legal identity, signed receipts, bonds, or insurance?
- Is bundler margin meaningful after gas risk and competition?
- How should privacy relayers be separated from merchant acceptance data in practice?
- What non-Ethereum node and routing services belong in the later cross-network suite?

## Business and pilot questions

- What denomination keeps likely attack cost comfortably above recoverable value?
- Who buys initial empty coins, and who holds change inventory?
- How often do coins actually recirculate before claim?
- Can optional settlement pricing undercut existing acceptance after all costs and losses?
- How much liquidity is required for merchant credit before finality?
- What fraud rate follows from hidden key compromise, counterfeit cores, and malicious registers?
- What coin and register failure rates are acceptable?
- Which first market tests circulation rather than novelty gifting or immediate redemption?
- Which business line can subsidize early registers without becoming a mandatory protocol toll?

## Later research

- native Bitcoin or a noncustodial Bitcoin-specific bearer design;
- stronger reconfigurable physical key primitives;
- quantum money or quantum-lightning-style bearer objects when durable portable hardware and secure public verification are practical.

These later directions should remain visible without being used to overstate the first-generation design.
