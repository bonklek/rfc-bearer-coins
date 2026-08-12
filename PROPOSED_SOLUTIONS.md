# Proposed solutions

This document proposes a coordinated response to every open issue in
[the complaints log](./COMPLAINTS.md). It is a design proposal, not evidence that
the complaints are resolved. A complaint should move from `Open` only after the
relevant RFC text, implementation, test, or operating policy exists.

The 96 complaints overlap heavily. Resolving them one at a time would produce a
larger and less coherent system. The approach here consolidates them into eleven
solution programs and then maps every complaint to a concrete disposition.

## Decision log

| Decision | Topic | Status | Accepted design | Complaints |
|---|---|---|---|---|
| D-001 | Local verification and relay | Accepted | Local attestation authenticates a responding approved core, not its physical co-location. Offline transfer remains unrestricted; stronger checks are optional and recipient-selected. Relay resistance is a measured hardware gate, and immediate claim is the strongest ordinary merchant response. | C-001 |
| D-002 | Complete claim authorization | Accepted | One canonical versioned `ClaimIntent` binds every material monetary, merchant, quote, fee, expiry, basket, settlement, and execution term. The same digest identifies the coin authorization, account call, display record, receipt, and settlement record. This changes no customer interaction. | C-002 |
| D-003 | Register consent boundary | Accepted | Normal checkout trusts a narrow evaluated claim controller that owns the authoritative two-sided display, exact `ClaimIntent`, customer approval state, one-way gate, fresh center-button transition, actuator, and receipt. A customer phone may verify the same digest independently but is never required. Buttons prove deliberate claim activation under this register trust assumption, not what an arbitrary display showed. | C-003 |
| D-004 | Global monetary serialization | Accepted | Claim, key rotation, account migration, and future private refresh share one core `AUTH_PENDING` lane and one account `semanticNonce`. Once an exact authorization is pending, the core may reproduce only that authorization; the account rechecks and consumes the nonce during execution before effects. This changes no normal interaction. | C-004 |
| D-005 | Proof-activated slot loading | Accepted | In the normal post-depletion path, a finite core and its onchain account bindings advance through one ordered slot series. Finalized proof that the old represented balance was depleted and its bearer authority retired closes the epoch. The coin then reveals the next fresh account and one-time activation challenge, remains `AWAITING_LOAD_PROOF`, and enters `ACTIVE` only after it verifies a slot-bound proof of finalized funding for the exact account, implementation, key, asset, and amount. Proof construction is permissionless and untrusted; proof verification and atomic local commitment are inside the core. Balance-preserving rotation remains a separate same-account path. | C-005 |
| D-006 | Exact authorization replay | Accepted | The core creates each normalized monetary signature once and atomically persists the exact signature bytes, canonical intent digest, operation, epoch, and semantic nonce with `AUTH_PENDING` before releasing any authorization byte. Retry rechecks caller-supplied canonical intent bytes against the stored digest and returns the stored signature without invoking the monetary key again. Transport wrappers may change; the inner authorization and settlement identity do not. | C-006 |
| D-007 | Exact represented value and zero-out claim | Accepted | Each epoch fixes one represented amount and a residual beneficiary at proof-activated loading. Standard claim requires at least that amount, sends exactly the represented amount to the claim destination, sends every remaining unit of the represented asset to the residual beneficiary, verifies a zero ending balance, and retires bearer authority in one reverting execution. Underfunding fails rather than silently underpaying. Unrelated unsolicited token contracts are not bearer value and are outside the zero-out invariant. | C-007 |
| D-008 | Generate-on-advance finite epochs | Accepted | Version 1 does not precompute or commit future monetary keys. The certified core contains an irreversible maximum epoch count and stores only the current monetary key. After finalized depletion closes an epoch, the core generates the next independent key internally, atomically commits that key and the advanced epoch before revealing its public key, and attests their same-core origin. Finite count is a lifecycle bound; stronger claims about physical compartmentalization or compromise blast radius remain hardware-gated. | C-008 |
| D-009 | Attributed status dimensions | Accepted | Verifiers never collapse signed `coreState`, sourced `observedChainState`, and publisher-specific `externalRiskStatus` into one validity bit. Every chain observation carries block, source, time, and finality; every risk opinion carries publisher, policy, issue time, and freshness. External warnings are advisory and cannot mutate the core, block authorization, or become protocol-wide revocation. | C-009 |
| D-010 | Atomic onchain claim execution | Accepted | Claim is one reverting account execution. It rechecks intent, epoch, status, and semantic nonce; enters an execution guard and consumes the nonce before external interaction; enforces strict transfer success and exact balance deltas; sends the represented amount and all same-asset surplus to their bound destinations; requires zero ending represented-asset balance; retires authority; and emits completion. Any failure reverts every effect. The coin advances only after finalized proof of zero balance and retired authority. | C-010 |
| D-011 | Operation-specific passive-power profiles | Accepted | Every operation has a measured harvested-energy, coupling, reservoir, brownout, timing, retry, duty-cycle, and thermal envelope. Ordinary stateless verification targets compatible phones. Persistent continuity writes and every monetary mutation use an open powered-reader profile unless a phone independently meets the same measured limits. The coin measures actual power conditions and refuses before mutation when margins are insufficient; reader branding or central permission is irrelevant. Interruption safety remains mandatory at every power level. | C-011 |
| D-014 | Evidence-first tamper response | Accepted | A confirmed tamper event irreversibly changes the consumer core to `TAMPER_SUSPECTED`, prevents it from reporting `ACTIVE` or accepting another load, and permits only one exact all-three-button evacuation authorization through the shared pending lane. Finalized zero-out evidence permanently retires the core rather than advancing it. Automatic monetary-key destruction is excluded from the ordinary profile; a separately labeled destructive profile requires explicit bearer-loss acceptance or a recovery authority configured before funding. | C-014 |
| D-037 | Physical acceptance and risk boundary | Accepted | Before customer approval and secure gate crossing, the customer owns each coin and the register operator is a bailee obligated to return that same coin. Approval plus crossing either the verification-only accept gate or the claim gate transfers ownership and ordinary coin risk to the merchant. Later claim, submission, freeze, reorganization, and counterfeit risk remain with the merchant until a provider issues a signed acquisition acceptance for the canonical settlement identity; risk then follows that provider's bound terms. Equipment failure is borne by the actor controlling custody. Fraud remedies are legal, not protocol clawbacks. | C-037 |
| D-038 | Multi-coin basket completion | Accepted | All selected coins bind one canonical basket and cross a secure gate individually. The sale completes only after every selected crossing is recorded. If routing stops early, crossed coins belong to the merchant and the merchant owes the basket's exact precommitted partial-acceptance remedy; uncrossed coins remain customer property. A complete same-chain authorization set may execute through one reverting `BasketClaim`. Pending coins are never returned as ordinary active tender. | C-038 |
| D-039 | Locked quote and change terms | Accepted | The quote source depends on the merchant's commercial relationship: an independent merchant may select its source, while an issuer or settlement provider may require a source and spread for use of its service. No source is protocol-wide. Exact integer arithmetic, source, rates, spread, customer fees, rounding, selected coins, change method, and remedies are displayed and bound before approval. Quote expiry prevents late approval but never reprices an approved basket. Excess coins return before approval; remaining change becomes an exact signed merchant obligation after acceptance. | C-039 |
| D-040 | Online precondition for register claim | Accepted | A standard register never initiates the all-three-button claim sequence without a fresh chain check, a working submission path, durable authorization storage, and available gas or sponsorship. Offline checkout uses verification-only acceptance and leaves the coin active. If connectivity fails after initiation, pre-gate coins return, post-gate pre-authorization coins remain active merchant property, and captured authorizations remain merchant-owned `AUTH_PENDING` records queued for exact retry. Provider credit still requires signed acceptance. | C-040 |
| D-044 | Customer basket-commit lever | Accepted | A customer-controlled physical lever is the standard accessible basket-commit action. It remains unavailable until the basket terms are fixed and, for any claim route, D-040's online preconditions pass. One pull locks the approved basket and permits exactly one distinct center press-and-release cycle for each approved claim coin while the secure mechanism applies the side-button state. It cannot hold center continuously, alter terms, add coins, or exceed the approved count; it disarms on completion, cancellation, or failure. Verification-only coins receive no center stroke. The authoritative terms remain available visually and nonvisually, and ownership still transfers at each secure gate crossing. | C-044 |
| D-045 | Risk-first confirmation hierarchy | Accepted | The primary visual and audio confirmation shows purchase total, merchant, tender and change, the selected action, customer fees, and each asset's amount with a short approved-chain name and recognizable chain icon. It elevates concrete material warnings about backing, settlement, custody, freezability, and upgradeability. Exact chain IDs, contract addresses, proxy and implementation data, and other technical metadata remain in secondary details unless they generate a material warning. The written chain name accompanies every icon and is included in nonvisual output. | C-045 |

## Non-negotiable product invariants

Remediation must not turn the product into a card network, custodial wallet, or
online authorization system. The following are requirements, not optional
preferences:

1. **Physical possession remains sufficient for transfer.** A person can hand an
   active coin to another person without an app, account, issuer, register, or
   network connection.
2. **Offline acceptance remains possible.** A recipient may accept physical and
   local cryptographic evidence without checking a chain. The interface must say
   what was and was not established, but must not prohibit the transfer.
3. **Assurance is progressive and recipient-selected.** Physical inspection,
   local attestation, optional BSLRR continuity, online backing verification, and
   immediate claim are increasing assurance levels. None is a protocol-wide
   permission gate.
4. **Verification does not spend.** Two side buttons enable verification. All
   three buttons are required for a monetary authorization. A normal handoff
   never creates an onchain transaction.
5. **The coin remains batteryless.** Readers supply energy only during deliberate
   interaction. At rest, the RF path is physically disconnected.
6. **One represented asset exists per coin epoch.** At launch, each supported
   asset maps to one chain and one approved asset policy. The face shows asset and
   amount; clients expose the exact chain, contract, controls, and policy.
7. **Trust information is advisory.** Manufacturers, laboratories, apps,
   merchants, and settlement providers may publish or apply policies. No feed can
   remotely invalidate possession or prevent a conforming coin from authorizing
   its asset.
8. **Local data minimization is the default.** Verification and BSLRR data are
   not uploaded automatically. BSLRR remains optional and local by default, but
   it is not anonymous or unlinkable and retained copies cannot be revoked.
   Transparent refresh ships before private refresh.
9. **No universal recovery authority exists.** Lost or irrecoverably damaged
   bearer assets remain bearer losses. A functioning coin may migrate its own
   recoverable balance; an administrator cannot move it.
10. **Open implementations remain possible.** Verifier clients, formats, trust
    feeds, account code, and conformance tests are public. Commercial services
    compete above the bearer protocol.

These invariants deliberately retain cash-like residual risk. A receiver may
accept a coin on less evidence than a professional merchant. That is a feature of
bearer transfer, provided the assurance level is stated accurately.

## Resolution states

- **Adopt:** place the solution in the first normative profile.
- **Gate:** retain the feature, but prohibit production claims until specified
  evidence passes a prototype, evaluation, or economic threshold.
- **Defer:** omit the feature from version 1 while preserving an extension point.
- **Disclose:** retain an unavoidable residual risk because eliminating it would
  defeat offline bearer transfer; bound and communicate it instead.

## Program 1: Explicit assurance model

The coin must never claim to know facts outside its security boundary.

### Evidence layers

Every verifier result is a structured bundle of separately attributed facts:

```text
physicalEvidence       appearance, dimensions, seals, visible display
coreEvidence           nonce-bound local attestation and core lifecycle state
continuityEvidence     optional BSLRR epoch, count, and root
observedChainState     account state at block, source, and finality level
policyObservation      selected vendor, laboratory, asset, and risk policies
claimEvidence          signed intent, submission identifier, receipt, finality
```

The client presents a short primary result and allows technical expansion. It
must not collapse these layers into a single `valid` bit.

### Relay limitation

Fresh NFC attestation proves that an accepted core answered. It does not, by
itself, prove that the core is inside the shell being inspected. Version 1:

- uses complete RF disconnection at rest and deliberate side-button activation;
- minimizes the response window and measures practical relay behavior;
- makes relay and distance-bounding tests a hardware gate;
- labels ordinary local attestation `core authenticated`, not `object uncloneable`;
- permits recipients to require online verification or immediate claim;
- keeps purely offline acceptance available for cash-like risk decisions.

Distance bounding may become a later hardware profile if it can fit the passive
power and cost envelope. Immediate claim remains the strongest ordinary merchant
response because it transfers the backing rather than predicting future behavior.

### Advisory policy

Core lifecycle state, observed chain state, and external risk policy are distinct.
An endangered-model warning can recommend claim or migration, but cannot alter
the core state or invalidate a transfer.

Every verifier result uses three separately attributed dimensions:

```text
coreState = {
  value: EMPTY | AWAITING_LOAD_PROOF | ACTIVE | AUTH_PENDING |
         TAMPER_SUSPECTED | TAMPER_RETIRED | EXHAUSTED,
  signedBy: core credential,
  epoch: integer
}

observedChainState = {
  value: EXACT | SURPLUS | DEFICIT | CLAIMED | UNKNOWN,
  chain: identifier,
  block: hash and height,
  source: RPC | proof profile | light client | full node,
  observedAt: time,
  finality: level
}

externalRiskStatus[] = {
  value: ACCEPTED | CAUTION | ENDANGERED | REJECTED_BY_POLICY | UNKNOWN,
  publisher: signed identity,
  policy: identifier and version,
  issuedAt: time,
  freshUntil: time
}
```

The primary UI may summarize these fields, but technical details preserve their
authorities and freshness. `No warning from subscribed feeds` is not the same as
a core attestation or a claim that no other publisher has warned.

**Primary complaints:** C-001, C-009, C-022, C-045, C-060.

## Program 2: One irreversible monetary state machine

All monetary operations use one semantic authorization lane. There is no special
nonce for claim, another for rotation, and another for migration.

### Core state

```text
EMPTY(epoch, nextSlot)
AWAITING_LOAD_PROOF(epoch, slot, account, assetPolicy, representedAmount, residualBeneficiary, activationChallenge)
ACTIVE(epoch, account, assetPolicy, representedAmount, residualBeneficiary, semanticNonce)
AUTH_PENDING(kind, exactAuthorization, intentDigest, epoch, semanticNonce)
TAMPER_SUSPECTED(epoch, eventEvidence, exactAuthorization?)
TAMPER_RETIRED(epoch)
EXHAUSTED(finalEpoch)
```

`coreState`, `observedChainState`, and `externalRiskStatus` are never merged.

### Authorization rule

For claim, rotation, migration, normalization, or private refresh:

1. Parse a canonical bounded request.
2. Confirm the required physical activation mode.
3. Check the current epoch and semantic nonce.
4. Construct the exact deterministic authorization bytes.
5. Atomically persist `AUTH_PENDING` and those exact bytes.
6. Only after durable commit, release the authorization.
7. During interruption, reproduce only those exact bytes.
8. Never authorize a second digest from that epoch and nonce.

The coin enters `AUTH_PENDING` before releasing an authorization, so it does not
need chain evidence to protect against conflicting output. It does require
finality-rooted evidence before treating that operation as complete, retiring the
old slot, or activating a funded replacement slot. A pending authorization is
safe to replay because the account consumes its semantic nonce exactly once.
Local freshness cannot create value.

### Proof-activated slot transition

The finite core and the chain advance through the same ordered monetary epochs:

```text
ACTIVE(i)
  -> AUTH_PENDING(kind = CLAIM, i)
  -> finalized proof that represented balance and bearer authority i are retired
  -> RETIRED(i)
  -> reveal account, key, and activation challenge for slot i+1
  -> AWAITING_LOAD_PROOF(i+1)
  -> finalized exact-funding proof for account i+1
  -> ACTIVE(i+1)
```

The funding proof is bound to the certified core commitment, slot index, fresh
activation challenge, account, immutable implementation, monetary public key,
asset policy, represented amount, semantic nonce, chain identity, and finalized
state root. A reader, register, full node, or proving service may construct it,
but the prover has no authority: the core verifies the selected proof profile.

The proof is staged in untrusted memory, completely checked, and then committed
with `ACTIVE` and the corresponding display state in a crash-consistent local
transaction. A power interruption leaves either `AWAITING_LOAD_PROOF` or
`ACTIVE`; it never leaves an active-looking partial state. The same proof may be
resubmitted after interruption, but it is accepted only for its exact unconsumed
slot and challenge.

### Smart-account execution rule

The account rechecks and consumes the shared semantic nonce during execution,
before any external call. Every operation either completes as one reverting
Ethereum transaction or leaves account state unchanged. Validation alone never
consumes the monetary nonce.

Claim additionally follows one strict execution sequence:

```text
recheck canonical intent, signature, epoch, status, and semantic nonce
enter EXECUTING reentrancy guard and consume semantic nonce
record represented-asset starting balances
strictly transfer representedAmount to claimDestination
require exact sender and recipient balance deltas
strictly transfer all same-asset surplus to residualBeneficiary
require exact sender balance delta and zero ending account balance
retire monetary authority and account status
emit completed intentDigest and resulting state
```

The asset policy excludes fee-on-transfer, rebasing, callback-dependent, or other
semantics for which exact deltas cannot be enforced. Native-asset calls and token
calls use the same execution guard. A false return, malformed return, revert,
unexpected delta, reentrancy attempt, nonzero ending balance, or retirement
failure reverts transfers, nonce consumption, status, and events together.

The physical core remains `AUTH_PENDING` after a failed submission and may replay
only D-006's stored authorization. It retires the epoch only after D-005's
finality-rooted proof establishes both zero represented-asset balance and retired
bearer authority.

### Exact replay and recovery

The core creates the normalized P-256 signature exactly once. Before any
authorization byte leaves the core, one crash-consistent transaction stores:

```text
operation kind
protocol and signature profile
canonical intent digest
exact normalized signature bytes
epoch and semantic nonce
AUTH_PENDING
```

The potentially larger canonical intent remains externally reproducible. On
retry, the caller resupplies those bytes; the core hashes them, compares the
result with its stored digest, and returns the stored signature only on an exact
match. It does not invoke the old monetary key again. Power loss before commit
releases nothing; power loss after commit can only reproduce the same artifact.

ERC-4337 or direct-transaction transport wrappers may be replaced around the
same inner intent. Receipts and settlement deduplication identify the monetary
operation by chain, account, epoch, semantic nonce, and canonical intent digest,
not by a replaceable transaction hash or signature instance. A direct
caller-paid transaction remains the universal retry path.

BSLRR mutation uses a separate idempotent continuity journal because it cannot
authorize money. Stateless verification remains available when no journal update
is desired.

**Primary complaints:** C-004, C-005, C-006, C-010, C-017, C-028, C-058, C-061,
C-065, C-066, C-072.

## Program 3: Cryptographic and key-generation profile

Version 1 uses a single fully specified P-256 signature profile, not generic
`hardware P-256 support`.

### Required profile

- EIP-7951-compatible P-256 verification with fixed coordinate and signature
  encodings, exact prehash rules, low-`s` normalization, and exact success-value
  checking.
- Deterministic ECDSA under FIPS 186-5/RFC 6979 or a reset-safe equivalent with
  test vectors.
- At least 128-bit verifier challenges generated inside the trusted verifier
  boundary, one outstanding challenge at a time, and fail-closed randomness.
- A defined entropy source, conditioning, startup and continuous health tests,
  cold-start behavior, environmental range, and key-generation algorithm.
- Unique attestation and monetary secrets. Shared batch private keys are forbidden.
- Old-key authorization, new-key proof of possession, and same-core attestation
  over one canonical rotation transcript.
- An immutable measurement root, measured boot, anti-rollback firmware state,
  debug locking, torn-update recovery, and versioned attestation profile.

### Finite slots

Version 1 uses a finite epoch budget, not a preloaded bank of monetary keys. The
core certificate binds an irreversible maximum epoch count. Only the current
monetary key exists in protected storage; future monetary addresses are neither
generated nor committed at manufacture.

After finalized depletion closes epoch `i`, the core:

1. enters a non-active key-generation transition;
2. generates an independent key with its evaluated internal entropy source;
3. atomically stores that key, epoch `i+1`, and retirement of the old key;
4. reveals the new public key only after durable commit; and
5. attests the public key, epoch, internal-generation origin, and core profile.

Power loss before commit reveals nothing and may restart generation. Power loss
after commit returns the same stored public key. A future key is never derived
from the old monetary key, attestation key, or a common monetary master seed.

This reduces the blast radius of ordinary monetary-key extraction because future
keys do not yet exist. It does not prove that a complete core compromise cannot
control later key generation. Finite count remains a lifecycle and wear bound
until physical compartmentalization, independent one-time cells, or a narrower
attack-boundary claim passes hardware evaluation.

### No private-key export

Version 1 never exports a monetary private key. Claim transfers the represented
asset to a destination. This removes an avoidable exposure path without changing
physical bearer circulation.

**Primary complaints:** C-008, C-016, C-024, C-031, C-055, C-059, C-060, C-068,
C-072, C-086.

## Program 4: Passive hardware and human-readable state

### Operation-specific power profiles

Every operation has a measured energy and time envelope:

```text
VERIFY_STATELESS   phone-compatible target, no persistent mutation
HANDOFF_LOG        powered-reader profile if persistent continuity is requested
CLAIM              powered-reader profile
LOAD_PROOF         powered-reader profile
KEY_GENERATION     powered-reader profile
ROTATE_OR_MIGRATE  powered-reader profile
DISPLAY_UPDATE     powered-reader profile
```

Each profile specifies coupling, field, reservoir margin, brownout threshold,
write timing, signature or proof-verification timing, maximum retries, duty cycle,
thermal limits, and interrupted-operation behavior. Before persistent mutation,
the core measures actual field stability, coupling, stored reservoir energy,
brownout margin, and temperature. It refuses before state change when any margin
is insufficient.

`Powered-reader profile` is an open electrical and protocol conformance target,
not an operator license. Registers, USB home pads, and third-party readers may
implement it. A phone may perform a heavier operation only if that phone and
coupling arrangement satisfy the identical measured profile; the RFC does not
assume this in advance. Adequate power reduces failures but never replaces the
crash-consistency and arbitrary-field-removal requirements.

### Display contract

The display is human-readable evidence, not proof of backing. Its controller:

- accepts only core-authenticated display records;
- includes asset policy, amount, epoch, and display sequence;
- uses a two-image commit in which an interrupted waveform leaves an unmistakable
  invalid pattern;
- never presents a partially updated image as authoritative;
- is inspected optically during verification and by register cameras where used;
- cannot defeat an overlay, so apps and registers compare visible and signed state.

At launch, one chain per asset lets the face show `USDC 20` rather than a chain
name. The cryptographic asset-policy identifier remains exact, and clients show
mainnet, contract, upgradeability, freeze, custody, and wrapped status.

### Tamper and refurbishment

The ordinary consumer profile uses irreversible evidence rather than automatic
monetary-key zeroization. A confirmed event commits:

```text
TAMPER_SUSPECTED(eventClass, evidenceDigest, eventCounter)
```

The core no longer reports `ACTIVE`, cannot clear the flag locally, cannot verify
a new load into active state, and cannot generate another monetary epoch. It may
use the current key for one exact all-three-button `EVACUATE` authorization through
the same D-004 pending lane and D-006 persisted-signature retry. The evacuation
zeroes the represented asset under D-007 and D-010. Finalized proof then changes
the core to permanent `TAMPER_RETIRED`; it does not advance to another slot.

This path preserves recoverable backing after a false alarm but cannot reverse a
key extraction that already occurred; the legitimate holder may still face a
race. If damage made the key unusable, value remains a bearer loss. Destructive
zeroization is permitted only in a separately labeled profile whose holder
explicitly accepts that loss or whose onchain recovery authority was configured
before funding.

The full assembly is security-relevant. Refurbishment replaces or requalifies the
antenna, activation mechanism, display, shell, seals, bonding, and secure core,
then issues a new assembly credential. A tamper-retired core is replaced, not
reset.

### Product qualification

Qualification covers retention, write endurance, display life, button cycles,
seals, bend, abrasion, washing, temperature, humidity, corrosion, drop, sharp
edges, small parts, materials, and aging. These are production gates, not later
support tasks.

**Primary complaints:** C-011 through C-019, C-067, C-076, C-081, C-082, C-089.

## Program 5: Minimal Ethereum account and exact asset invariant

### Version 1 account

Use an already deployed immutable contract account before funding. Do not use a
counterfactual account or EIP-7702 delegation in the first profile.

```text
currentKey
keyEpoch
semanticNonce
representedAssetPolicy
representedAmount
residualBeneficiary
status
```

Supported calls are deliberately narrow:

```text
claim(intent, signature)
rotate(rotationIntent, oldSignature, newProof)
migrate(migrationIntent, oldSignature, newProof)
normalizeRepresentedSurplus(intent, signature)
```

There is no arbitrary execution and no unsolicited-token sweep in version 1.

### Exact represented value

The account records the represented amount and a residual beneficiary selected and
bound in the loading receipt. A claim moves exactly the represented amount to the
claim destination and routes any same-asset surplus to that residual beneficiary
in the same reverting transaction. It then verifies that the represented-asset
balance is zero and retires bearer authority. Any failed required transfer or
nonzero ending balance reverts the entire claim, so the physical slot cannot
advance on partial withdrawal. Underfunding is shown as `chain inconsistent` and
reverts rather than silently reducing payment.

This prevents an unsolicited same-asset deposit from becoming displayed bearer
value while ensuring it is not stranded when the coin advances. The residual
beneficiary is fixed during proof-activated loading and included in the activation
proof, display metadata, and `ClaimIntent`; changing it is itself a monetary
operation. A separate serialized normalization authorization may remove surplus
before claim. Unsupported token contracts are not enumerable bearer value, are
ignored by the account, and may remain stranded.

### Asset policy

Each policy is versioned and identifies chain genesis, chain ID, contract,
implementation and proxy expectations, storage/proof method, decimals, transfer
semantics, administrative controls, and display name. Policy publishers are
advisory; the account's immutable identifiers determine what it can move.

Live verification distinguishes balance from claimability. Paused, frozen,
blacklisted, upgraded, or unknown implementations reduce the observation to
`funded but not currently proven claimable`. Offline handoff remains possible.

### Chain verification

Assurance levels are explicit:

- one RPC observation;
- redundant RPC observation;
- locally verified state proof against an authenticated checkpoint;
- consensus light-client verification;
- full-node verification.

Counterfactual assurance is deferred because funded deployed accounts avoid the
factory-liveness and absent-code problems.

### Gas and transport

The represented asset never pays gas implicitly. A caller or paymaster funds
execution. A typed transport authorization binds chain/fork domain, EntryPoint,
inner intent digest, gas and fee caps, validity bounds, paymaster, and sponsor
nonce. Direct caller-paid execution remains available if ERC-4337 infrastructure
fails. Launch requires measured gas ceilings as a fraction of denomination.

**Primary complaints:** C-007, C-010, C-020 through C-026, C-061, C-064 through
C-066, C-075, C-083.

## Program 6: Claim intent, checkout, and settlement

### Canonical claim intent

The sole canonical logical `ClaimIntent` schema is in
[Key lifecycle and claim protocol](./docs/key-lifecycle.md#claim-semantics).
Every material customer-visible monetary, merchant, quote, fee, basket,
settlement, execution, and refund term is included directly or by canonical
substructure hash. This document intentionally does not repeat the field list.

Replaceable delivery authority is not part of the inner claim intent. A separate
typed `TransportAuthorization` binds the exact `intentDigest`, chain and fork
domain, EntryPoint or direct relay, gas and fee caps, validity, paymaster terms,
sponsor nonce, and loss allocation. Represented value never pays gas implicitly.

The coin signs this intent. The secure register display renders the same decoded
record. The register and customer receive pre-claim and post-claim receipts keyed
by the intent digest.

### Consent without mandatory phones

Ordinary retail UX does not require a customer app. The standard register profile
places the two-sided and nonvisual terms presentation, customer-facing
basket-commit lever, and all-three-button claim path inside an evaluated register
trust boundary. The lever is mechanically or securely blocked until the complete
basket is fixed and, when any coin will be claimed, the online preconditions pass.
One customer pull commits the basket and starts its bounded routing sequence.

An optional customer-phone confirmation independently verifies the intent digest
for users who do not trust the register. The RFC does not claim that buttons alone
authenticate electronic terms.

### Risk-first confirmation hierarchy

The primary visual and nonvisual presentation is a short payment decision, not a
contract explorer. It presents, in this order:

1. purchase total and unit of account;
2. merchant or recipient and the selected action (`accept and recirculate` or
   `claim and retire`);
3. each tendered asset's amount, short approved-chain name, and recognizable
   chain icon;
4. tender total, change, customer fees, and quote expiry; and
5. every material warning that affects backing, settlement, custody,
   freezability, or upgradeability.

An icon is never the only chain signal: the written approved-chain name accompanies
it and is spoken by the nonvisual output. Exact chain IDs, contract addresses,
proxy and implementation records, issuer documentation, and other technical
metadata stay in secondary details unless their current state creates a material
warning. The primary presentation names the risk in plain language rather than
hiding it behind a generic safety badge.

### Multi-coin basket

The waiting chamber verifies and tallies every proposed coin before customer
approval. The register then commits one canonical `BasketTerms` object containing
the basket ID, ordered coin contributions, quote and expiry, total, and the
partial-acceptance remedy. Every selected coin intent binds the basket ID and
`basketTermsHash`.

Physical routing remains sequential. Each secure accept- or claim-gate crossing
creates a signed per-coin acceptance event. The sale is complete only after every
selected crossing has been recorded. If routing stops partway, crossed coins are
merchant property under D-037, uncrossed coins remain customer property, and the
merchant owes the exact remedy committed in `BasketTerms`. This failure does not
restore an `AUTH_PENDING` coin to ordinary tender.

When the complete authorization set exists on one supported chain, an immutable
`BasketClaim` executes all account claims in one transaction and reverts the
entire transaction if any subclaim fails. A physically incomplete basket is not
misrepresented as an atomic onchain basket. Merchant-owned authorizations already
captured from that basket remain governed by their exact signed intents and the
partial-acceptance remedy.

If the merchant chooses offline acceptance, no atomic onchain claim is asserted.
The receipt labels the transaction `UNVERIFIED_OFFLINE`, and the merchant assumes
bounded bearer-credit risk. This preserves offline multi-coin payment rather than
prohibiting it.

### Online precondition for standard-register claim

The standard register does not intentionally capture a claim authorization while
offline. Before it can arm the all-three-button mechanism, it requires a fresh
chain check, a working submission path, durable local authorization storage, and
available gas or sponsorship. Without these conditions it offers only the
verification-only accept and recirculate path.

Connectivity can still fail after initiation. Failure handling follows the last
durable boundary: return before gate crossing; retain an `ACTIVE` merchant-owned
coin after crossing but before authorization; persist and queue the exact
`AUTH_PENDING` authorization after capture; and reconcile chain state before
replaying only that identical authorization after an uncertain submission. A
provider owes no credit without its separate signed acceptance.

### Custody and ownership boundary

The register uses one cash-like rule:

```text
customer approval + secure acceptance-gate crossing = merchant ownership
```

Before that event, the customer remains owner and the register operator is a
bailee obligated to return the same coin on rejection, cancellation, or failure.
After that event, the merchant owns the coin or its pending authorization and
bears ordinary backing, counterfeit, submission, freeze, and reorganization risk.
The boundary is the same for the verification-only accept path and the exceptional
claim path; claim does not make the customer finance the merchant's chosen
settlement operation.

```text
input, verification, waiting      customer owner; register bailee
approved but gate not crossed     customer owner; register bailee
return gate                       customer retains ownership
accept gate crossed               merchant owns active recirculating coin
claim gate crossed                merchant owns coin and subsequent claim risk
post-gate jam or failure          merchant-owned property is quarantined
provider signed acceptance        provider assumes only its bound acquisition risk
provider payout failure           provider obligation under settlement terms
```

A settlement provider assumes risk only through a signed `ProviderAcceptance`
bound to the provider-wide `settlementId`, merchant beneficiary, payout terms,
fees, expiry, and accepted status. Until then the merchant owns the claim. An
equipment operator bears loss caused while it controls custody under its merchant
or operator agreement. Intentional fraud may create legal recourse, but the bearer
protocol supplies no customer clawback after accepted gate crossing.

### Settlement identity

Managed settlement derives one provider-wide `settlementId` from chain, account,
epoch, semantic nonce, and intent digest. An atomic unique record prevents duplicate
credit across retries. A provider-signed settlement instruction binds the treasury
to the merchant beneficiary, payout asset, amount, fees, expiry, and quote.

### Broadcast and finality

Instant credit requires immediate submission under a published SLA and gas reserve.
Deferred treasury consolidation is separate from claim submission. Deliberately
queued claims do not receive final credit unless the provider explicitly assumes
and prices the risk.

**Primary complaints:** C-002, C-003, C-037 through C-043, C-049, C-058, C-063,
C-064.

## Program 7: Register trust boundary, mechanics, and safety

### Split architecture

The register has three isolated domains:

1. A safety and motion controller with fixed bounded commands.
2. A claim controller with secure boot, protected keys, bounded parsers, coin
   tracking, and the authoritative transaction display.
3. A networked application computer for quotes, RPC, settlement, optional nodes,
   bundling, and relaying.

Untrusted coin bytes terminate in a disposable least-privileged parser. Only a
fixed-size authenticated result crosses into the claim controller. Optional node
software cannot command motors or claim contacts directly.

### Mechanical custody

Each coin receives a local tracking handle at entry and is re-attested at the
verification, waiting, and claim checkpoints. One-coin rails, optical tracking,
double-feed sensors, and inaccessible continuous paths bind the inspected object
to the claimed object.

Every physical location has a recovery rule:

- before customer approval: return the same coin;
- waiting chamber: retain visible custody or return on cancellation;
- after irreversible gate crossing: quarantine inside the register;
- after authorization: never return as active tender;
- service access: disabled while any ownership state is unresolved.

### Accessible equivalent interaction

The standard interaction is itself accessible rather than relegating users to a
weaker alternate command. A large, low-force, customer-facing basket-commit lever
supports one-handed and assistive actuation. The same secure controller presents
the authoritative basket through visual and nonvisual output before releasing the
lever interlock.

One lever pull may drive the first claim stroke directly and arm an indexed cam or
ratchet for later approved claim coins, but it never leaves the center actuator
depressed. For every approved claim coin the mechanism must establish one fresh
`released -> pressed -> released` center cycle while applying the required side
inputs. It consumes exactly one indexed cycle, binds it to the tracked coin and
armed intent, and fully retracts before the next coin. Verification-only coins
follow the accept path without a center stroke.

The mechanism cannot change basket terms, admit an unselected coin, or produce
more strokes than the approved claim count. Completion, cancellation, loss of a
required precondition, object-tracking failure, or any mechanical fault disarms
the sequence. Gate crossing remains the per-coin ownership boundary, so D-037 and
D-038 continue to govern partial routing and remedies.

### Complete-equipment qualification

The production register receives motion-risk, pinch/force, jam-clear, unexpected
restart, RF exposure, implant EMC, foreign-object heating, touch temperature,
electrical shock, fire, ingress, EMC, spectrum, stability, mounting, transport,
and service-state testing. Safety functions are allocated and validated separately
from payment correctness.

### Administration and evidence

Merchant enrollment, beneficiaries, quote sources, policies, feeds, limits,
endpoints, receipt keys, and maintenance use least privilege, strong authentication,
dual approval for critical changes, signed monotonic configuration, and off-device
audit records. Registered operators may add legal identity, bond, or insurance.

**Primary complaints:** C-003, C-012, C-037, C-041 through C-045, C-056, C-073,
C-074, C-080, C-087, C-088, C-090, C-091, C-095.

## Program 8: Offline circulation, loading, and BSLRR

### Two merchant paths

The register supports both:

- **Accept and recirculate:** verify, issue a receipt, inventory the active coin,
  and later give it as change.
- **Accept and claim:** move the coin through the one-way claim path and settle it.

Merchants choose by denomination, age, hardware profile, history, online evidence,
inventory needs, and risk policy. The protocol does not force claim.

### Permissionless loading

Any holder can load an empty fresh epoch:

1. Present finalized evidence that the previous represented balance was depleted
   and its bearer authority retired.
2. Let the core retire that slot and reveal the next fresh account, public key,
   and one-time activation challenge.
3. Select one accepted asset policy and exact represented amount.
4. Deploy and initialize the immutable account if deployment is not atomic with
   funding.
5. Fund the exact represented amount while recording the slot and challenge.
6. Construct a proof rooted in finalized chain state for the complete expected
   account and funding state.
7. Present the proof to the coin; only successful internal verification changes
   it from `AWAITING_LOAD_PROOF` to `ACTIVE` and updates the persistent face.
8. Produce a loading receipt referencing the same proof and activation state.

Commercial loaders may perform these steps for a fee, but have no exclusive role.
Proof construction and submission remain permissionless. The display cannot show
active value before the core verifies and durably commits the finalized funding
proof. Later online checks can establish newer chain state, but ordinary offline
verification can rely on the core's attested proof-activated state plus the fact
that it has emitted no monetary authorization since activation.

### BSLRR profile

BSLRR remains optional and local. It proves attested handoff ceremonies, not
distinct owners or absence of unrecorded transfer.

- NFC bootstraps an ephemeral authenticated key exchange.
- The transcript binds both phone keys, carrier session, roles, coin epoch, prior
  root, participant contributions, and new root.
- Bluetooth/Wi-Fi discovery uses per-session identities, no names, no bonding, and
  bounded advertising where platforms permit.
- Participant inputs are generated in constrained form and cannot carry arbitrary
  identifiers.
- The coin journals a root update idempotently; the full optional record remains on
  the phones.
- Redemption or rotation closes the epoch. No protocol can force third parties to
  delete copies they retained, and the UI says so.

### Adverse selection

Recirculation remains a hypothesis to test, not a promise. Acceptance policy may
use age and exposure limits, but cannot prevent a holder from transferring a coin.
The pilot must compare recirculated and immediately claimed cohorts for later
conflicts and rejection behavior.

**Primary complaints:** C-017, C-034, C-040, C-046, C-047, C-050, C-077, C-092.

## Program 9: Privacy as a pluggable later profile

Transparent same-account rotation ships first. The account and core reserve typed
migration interfaces, but no production privacy claim is made until a complete
profile exists.

### Private-refresh requirements

A compatible profile must define:

- proof system, circuit, parameters, verifying key, public inputs, chain, privacy
  contract, asset, amount, destination, nullifier domain, expiry, and fee bounds;
- the complete deposit, note, proving, withdrawal, retry, exit, and key-retirement
  lifecycle;
- holder-controlled proving by default;
- a formally analyzed blinded, distributed, or confidential delegation mode if a
  remote prover is used;
- a unilateral exit that does not depend on the original relayer;
- timing and amount batching options;
- a transparent disclosure when an association provider, opener, prover, relayer,
  or setup ceremony can link, censor, or forge.

### Anonymous hardware attestation

Exact-core privacy requires an unopenable or explicitly traceable profile, uniform
group parameters, selective disclosure, no verifier basename, same-member binding
to the complete fresh evidence digest, reset-safe core-controlled randomness, and
one logged inventory lineage per member.

Revocation uses a uniform authenticated checkpoint, not verifier-selected entries.
The profile must have bounded passive-device cost, rollover before exhaustion, and
a stated post-compromise backward-unlinkability property. If those properties are
not achievable, the client qualifies the privacy claim instead of hiding the risk.

### Trusted setup

Prefer transparent proof systems. A setup-dependent profile binds the full public
ceremony transcript and treats suspected trapdoor compromise as profile-wide
endangerment.

**Primary complaints:** C-027, C-028, C-034 through C-036, C-062, C-069, C-070,
C-077, C-084 through C-086, C-092 through C-094, C-096.

## Program 10: Federated manufacturing trust without central revocation

### Typed trust metadata

Every signed object uses a canonical envelope containing statement type, namespace,
schema, issuer key ID, role, scope, subject, version, validity, critical fields,
and predecessor hash. Verifiers reject a key used outside its delegated role.

### Batch issuance

1. Each core generates a unique attestation member secret internally.
2. A challenged enrollment transcript proves same-core generation, possession,
   firmware, policy, and non-exportability.
3. A canonical Merkle tree commits to unique indexed leaves and exact tree size.
4. Manufacturer grants have immutable IDs and cumulatively consumed one-use ranges.
5. Anonymous credential issuance consumes exactly one committed leaf lineage.
6. Manufacturer, laboratory, production witness, and log witness represent distinct
   administrative domains and sign only the facts they observed.
7. A fresh witnessed transparency checkpoint, inclusion proof, and consistency
   proof are mandatory for any policy claiming batch or cutoff containment.

### Configuration and production

Credentials bind exact secure-core, package, ROM, library, antenna, display,
button, enclosure, firmware, and process profiles. Supplier or process changes
receive impact analysis and delta requalification. Volume production adds process
windows, per-unit functional and margin tests, destructive sampling, genealogy,
yield alarms, quarantine, and controlled rework.

### Root and compromise recovery

Offline threshold roots use monotonic versions, old/new cross-signing, separately
held recovery anchors, expiring subordinate grants, and public emergency metadata.
Status is advisory and granular: accepted, endangered, cutoff, batch, model, or
publisher warning. Existing functioning coins retain the ability to migrate their
recoverable backing.

Different open clients may trust different publishers. Bulk mirrored snapshots,
not per-coin queries, are the baseline distribution method.

**Primary complaints:** C-029 through C-033, C-036, C-062, C-067 through C-071,
C-076, C-078, C-079, C-084 through C-086, C-093, C-094.

## Program 11: Economics, operations, and staged evidence

### Threat economics

Denomination is only one control. The model includes:

```text
fixed exploit discovery cost
marginal per-coin compromise cost
batch and model population
detection and warning delay
offline circulation duration
merchant claim latency
migration throughput
provider confirmation exposure
reserves, bond, and insurance
```

Denomination, batch size, instant-credit limits, and migration capacity are tied to
stress scenarios rather than a single attack-cost estimate.

### Operator economics

Version 1 allows transaction-specific customer-paid fees. Pooled operator rewards
are deferred until there are qualified identities, independently measurable work,
third-party demand, anti-self-dealing rules, caps, and objective penalties. Node,
bundler, relayer, and mirror software remains optional and isolated from the claim
controller.

### Business model

A parameterized model covers manufacturing, register subsidy, network fees,
conversion, payout, liquidity duration, fraud, replacement, support, compliance,
and capital. It reports pessimistic sensitivity ranges and explicit go/no-go gates.

### Nontechnical gates

The RFC maps acquisition, instant credit, custody, exchange, stablecoin handling,
fiat payout, certification, operator identity, privacy services, and data retention
to jurisdiction-specific analysis. These gates apply to optional commercial actors,
not physical transfer itself.

### Evidence ladder

1. **Protocol models:** state-machine and smart-contract invariants with valueless
   assets.
2. **Hardware test rigs:** power interruption, fault injection, side channel,
   entropy, relay, display, and lifecycle testing.
3. **Adversarial-value trial:** enough real value and bounty to create attack
   incentives, with bounded participants and exposure.
4. **Circulation trial:** repeated handoff and merchant recirculation, not only
   loading and redemption.
5. **Commercial pilot:** ordinary users, support burden, fraud loss, comprehension,
   settlement choice, and unit economics.

Each phase states which conclusions it cannot support.

**Primary complaints:** C-019, C-025, C-037, C-040, C-043, C-046 through C-054,
C-057, C-058, C-063, C-064.

## Complaint-by-complaint traceability

The table below gives every complaint a primary proposed disposition. Cross-cutting
complaints also appear in more than one program above.

| ID | Proposed disposition | State |
|---|---|---|
| C-001 | Bound the claim honestly: measured relay resistance, deliberate activation, optional stronger verification, and immediate claim for high assurance; preserve offline acceptance as disclosed cash-like risk. | Gate + Disclose |
| C-002 | Canonical `ClaimIntent` binds every customer-visible, execution, quote, fee, beneficiary, and settlement term. | Adopt |
| C-003 | Put standard register display and actuation in an evaluated attributable trust boundary; offer optional independent phone confirmation and stop claiming buttons alone authenticate terms. | Adopt + Disclose |
| C-004 | Serialize every monetary operation through one durable semantic nonce and exact `AUTH_PENDING` record, rechecked during account execution. | Adopt |
| C-005 | Require slot-bound, finality-rooted depletion and funding proofs before local retirement and activation. The core verifies the proof and commits the active state atomically; proof-system selection and passive-power feasibility remain gated. | Adopt + Gate |
| C-006 | Generate the normalized signature once, atomically persist its exact bytes and intent identity with `AUTH_PENDING`, and retry without invoking the monetary key again. | Adopt |
| C-007 | Fix the represented amount and residual beneficiary at activation; atomically send the exact amount to the claim destination, route all same-asset surplus to the residual beneficiary, require zero ending represented-asset balance, and reject underfunding. | Adopt |
| C-008 | Do not precompute future monetary keys. Generate one independent key only after irreversible epoch advance, commit before reveal, and describe finite count as a lifecycle bound until stronger isolation claims pass hardware evaluation. | Adopt + Gate |
| C-009 | Separate and attribute signed core state, sourced block/finality-qualified chain observation, and publisher-specific external risk opinions in protocol and UI. | Adopt |
| C-010 | Execute claim as one reentrancy-guarded reverting transaction with pre-call nonce consumption, strict transfer results, exact balance deltas, zero ending represented balance, authority retirement, and completion event. | Adopt |
| C-011 | Define measured power, coupling, reservoir, brownout, timing, retry, duty-cycle, and thermal profiles; require an open powered-reader profile for persistent mutation unless a phone meets the same limits; retain interruption safety. | Adopt + Gate |
| C-012 | Use authenticated display records, torn-update invalid images, optical comparison, and explicit overlay limitations. | Adopt + Gate |
| C-013 | Physically disconnect the entire RF path at rest and qualify lower-layer randomized/non-identifying NFC behavior. | Gate |
| C-014 | Make tamper suspicion irreversible and visible, disable future loading, preserve one exact serialized evacuation path, and retire after finalized zero-out; exclude automatic key destruction from the ordinary profile. | Adopt |
| C-015 | Treat the complete assembly as security-relevant and requalify or replace it during refurbishment with a new assembly credential. | Adopt |
| C-016 | Specify immutable measured boot, anti-rollback update, debug, isolation, and torn-update behavior. | Adopt + Gate |
| C-017 | Keep verification stateless or journal BSLRR mutation with exact idempotent retry and endurance bounds. | Adopt |
| C-018 | Define and test the full storage, mechanical, optical, environmental, and aging mission profile. | Gate |
| C-019 | Define attacker resources and success criteria, then derive denomination and batch limits from measured fixed and marginal costs. | Gate |
| C-020 | Separate typed transport authorization from monetary intent; cap fees, identify EntryPoint, prefer paymasters, and preserve caller-paid submission. | Adopt |
| C-021 | Deploy immutable accounts before funding; defer counterfactual coin funding. | Defer |
| C-022 | Verify live transfer restrictions separately from balance and display `funded but not currently claimable` without blocking handoff. | Adopt |
| C-023 | Version proxy, implementation, storage, and proof rules per asset policy; downgrade unknown upgrades. | Adopt |
| C-024 | Publish exact EIP-7951 hashing, encoding, malleability, nonce, and success-value tests. | Adopt |
| C-025 | Require gas benchmarks and fee-to-denomination launch ceilings for every supported route. | Gate |
| C-026 | Remove unsolicited-token sweeping from version 1. | Defer |
| C-027 | Bind private authorization to the entire proof-system and transaction instance. | Defer + Adopt interface |
| C-028 | Require a resumable private migration state machine and unilateral exit before enabling private refresh. | Defer + Gate |
| C-029 | Use monotonic, expiring, snapshot-bound trust metadata with visible stale state and rollback protection. | Adopt |
| C-030 | Define threshold root rotation, cross-signing, independent recovery anchors, and compromise procedure. | Adopt |
| C-031 | Require unique hardware-bound attestation membership secrets and granular compromise handles. | Adopt + Gate |
| C-032 | Count independently controlled organizations and type the fact each signature attests. | Adopt |
| C-033 | Make witnessed checkpoints, inclusion, consistency, and split-view detection mandatory for containment claims. | Adopt |
| C-034 | Constrain BSLRR contributions, disclose retained-prefix linkability, and defer zero-knowledge continuation if stronger privacy is required. | Adopt + Disclose |
| C-035 | Use selective disclosure and predicates; hide exact counters and roots by default under an unlinkable profile. | Defer + Gate |
| C-036 | Distribute trust status as bulk mirrored cohorts and prohibit baseline per-core lookup. | Adopt |
| C-037 | Transfer ownership at customer-approved secure accept or claim gate crossing; treat the pre-gate register as bailee, assign post-gate risk to the merchant, and move risk to a provider only on signed acquisition acceptance. | Adopt |
| C-038 | Use an atomic same-chain `BasketClaim`; label offline baskets as merchant credit rather than pretending onchain atomicity. | Adopt |
| C-039 | Canonicalize quote source, decimals, rounding, spread, fees, expiry, exact tender, and refund/change obligations. | Adopt |
| C-040 | Keep standard offline checkout verification-only. Require fresh chain, submission, durable-storage, and gas readiness before claim; recover a later network cut from the exact physical and durable authorization stage reached. | Adopt |
| C-041 | Standardize signed pre-claim and post-claim receipts covering terms, evidence, status, identifiers, and remedies. | Adopt |
| C-042 | Track and re-attest one coin through every location; return pre-claim and quarantine post-gate under a fail-closed recovery machine. | Adopt + Gate |
| C-043 | Specify latency, basket, chamber, throughput, timeout, and quarantine service envelopes. | Gate |
| C-044 | Make a customer-facing basket-commit lever the standard accessible initiation control; preserve authoritative nonvisual terms and fresh bounded per-coin center cycles under the existing gate and claim-controller rules. | Adopt + Gate |
| C-045 | Standardize a risk-first visual and audio confirmation view with short approved-chain names and icons, then keep exact technical metadata secondary unless it produces a material warning. | Adopt |
| C-046 | Add a first-class accept-and-recirculate path, inventory records, change handling, and circulation metrics. | Adopt |
| C-047 | Measure adverse selection and allow recipient-selected age/history/exposure policy without preventing transfer. | Gate + Disclose |
| C-048 | Model fixed exploit cost, marginal cost, fleet exposure, warning delay, migration, and reserves; cap both denomination and batch. | Adopt + Gate |
| C-049 | Separate immediate claim submission from later treasury consolidation and publish a broadcast SLA for instant credit. | Adopt |
| C-050 | Specify permissionless loading plus optional commercial loader ordering, receipts, display transition, fees, and liability. | Adopt |
| C-051 | Rejected for the first-generation profile. Retain one chain per displayed asset, the reusable asset/amount/status e-paper face, D-045 register chain presentation, and exact client metadata; do not add an Asset Profile marker. Any later relaxation requires a new product decision. | Reject |
| C-052 | Build a parameterized unit-economics and capital-risk model with pessimistic sensitivities and go/no-go thresholds. | Gate |
| C-053 | Map optional commercial roles to jurisdiction-specific legal gates without making them protocol permissions. | Adopt + Gate |
| C-054 | Separate engineering, adversarial-value, circulation, and commercial pilots and bound each claim. | Adopt |
| C-055 | Require deterministic reset-safe ECDSA and test repeated power cycles, faults, and side channels for nonce reuse. | Adopt + Gate |
| C-056 | Parse all pre-authentication data in bounded disposable isolation and expose only a fixed authenticated interface to claim control. | Adopt + Gate |
| C-057 | Defer pooled rewards; permit transaction fees until qualified, measurable, Sybil-resistant attribution exists. | Defer |
| C-058 | Use one provider-wide canonical `settlementId` and atomic credit-once ledger record across all retries and regions. | Adopt |
| C-059 | Define entropy source, conditioning, health tests, key-generation method, environmental limits, and failure behavior. | Adopt + Gate |
| C-060 | Generate and consume one 128-bit-or-greater trusted challenge with restart and randomness-failure rules. | Adopt |
| C-061 | Keep inner intent replayable while replacing ERC-4337 transport wrappers; provide direct caller-paid recovery. | Adopt |
| C-062 | Include issuer/opener collusion in the threat model and require an unopenable profile for unqualified anonymity claims. | Defer + Disclose |
| C-063 | Bind provider treasury and merchant beneficiary in a provider-signed instruction included in the claim intent and settlement event. | Adopt |
| C-064 | Use one-use sponsor authorization, reserved budget, quotas, deposit caps, circuit breakers, and explicit revert-loss allocation. | Adopt |
| C-065 | Express ERC-4337 validity through `validationData` and test canonical-mempool conformance; mirror semantics in direct calls. | Adopt |
| C-066 | Freeze automatic settlement on same-chain-ID contentious splits until a distinct fork domain exists; flag old intents replayable. | Adopt |
| C-067 | Bind credentials to exact evaluated configuration and require impact analysis and requalification for every relevant change. | Adopt + Gate |
| C-068 | Use challenged same-core enrollment, hardware-root certification, proof of possession, and transcript-bound batch leaves. | Adopt + Gate |
| C-069 | Bind anonymous membership one-to-one to logged leaves or make no quantity-containment claim. | Defer + Gate |
| C-070 | Keep anonymity randomness and transcript construction in the evaluated core boundary or qualify host-trusted privacy. | Defer + Gate |
| C-071 | Define canonical typed envelopes with role, scope, namespace, delegation, critical fields, and cross-type rejection. | Adopt |
| C-072 | Require core-selected replacement key, old-key authorization, new-key possession proof, and same-core transcript. | Adopt |
| C-073 | Add protected merchant enrollment, least privilege, dual approval, signed configuration, alerts, and off-device audit. | Adopt + Gate |
| C-074 | Perform complete motion-risk assessment and validate interlocks, force limits, stop, restart, maintenance, and fault behavior. | Gate |
| C-075 | Deploy accounts before funding and retain a direct transaction path; counterfactual operation remains later work. | Defer |
| C-076 | Add volume-line process control, per-unit tests, destructive sampling, genealogy, yield alarms, quarantine, and rework rules. | Gate |
| C-077 | Use ephemeral discovery identities, no names or bonding, private addressing, bounded advertising, and packet-capture qualification. | Adopt + Gate |
| C-078 | Allocate immutable grant IDs and disjoint cumulatively consumed production ranges in one consistency domain. | Adopt |
| C-079 | Version hash, leaf encoding, domain separation, ordering, tree shape, index, size, duplicate, and path rules. | Adopt |
| C-080 | Define hardware-anchored boot, monotonic updates, recovery, debug restriction, isolated components, protected keys, and support lifetime. | Adopt + Gate |
| C-081 | Set market-specific token geometry and component-retention limits after foreseeable abuse. | Gate |
| C-082 | Test sharp edges and points after realistic damage, aging, and refurbishment; quarantine damaged tokens. | Gate |
| C-083 | Reject EIP-7702 coin accounts in version 1 and use ordinary immutable deployed contracts. | Adopt |
| C-084 | Prefer transparent proofs; otherwise bind a public multiparty setup transcript and treat trapdoor suspicion as profile-wide compromise. | Defer + Gate |
| C-085 | Select bounded-complexity revocation, benchmark passive worst case, and roll credentials before limits. | Defer + Gate |
| C-086 | Authenticate the complete fresh evidence digest with the same enrolled member secret or prove same-core derivation. | Defer + Gate |
| C-087 | Bound and test RF field, duty, geometry, fault-on time, human exposure, and implant compatibility; offer a separated workflow. | Gate |
| C-088 | Add field timeout, foreign-object and abnormal-load detection, temperature limits, cooling, and quarantine. | Gate |
| C-089 | Control and test all accessible materials, restricted substances, migration, sensitization, aging, refurbishment, and recycling. | Gate |
| C-090 | Qualify complete-equipment energy, insulation, earthing, wiring, faults, fire, ingress, and routine production safety. | Gate |
| C-091 | Qualify complete-register emissions, spectrum, immunity, ports, modes, and fail-closed behavior under disturbance. | Gate |
| C-092 | Bind NFC and bulk transport in one ephemeral authenticated key exchange with mutual confirmation and canonical transcript. | Adopt + Gate |
| C-093 | Require backward-unlinkable revocation or evolving erased credentials; otherwise disclose retrospective traceability and minimize retention. | Defer + Disclose |
| C-094 | Require one uniform authenticated revocation checkpoint, prohibit verifier-tailored entries, and audit admission globally. | Defer + Gate |
| C-095 | Test complete-register stability, mounting, loads, doors, trays, cables, relocation, and misuse; require rated anchorage where needed. | Gate |
| C-096 | Prefer holder-controlled proving; otherwise use analyzed blinded/distributed/confidential delegation and disclose the prover's linkage authority. | Defer + Disclose |

## Recommended version 1 profile

The smallest profile that preserves the guiding purpose is not an online-only or
claim-at-every-handoff system. It is:

- batteryless universal coins;
- physical offline handoff without protocol participation;
- two-side-button optional local verification;
- one Ethereum mainnet asset policy per displayed asset;
- one deployed immutable account and exact represented amount per coin epoch;
- proof-activated finite slots with a fresh account and challenge per epoch;
- P-256 non-exportable monetary keys under one serialized state machine;
- all-three-button typed claim authorization;
- transparent rotation and migration;
- optional local BSLRR;
- both merchant recirculation and immediate-claim paths;
- open advisory trust feeds;
- optional online backing checks and managed settlement;
- no private-key export, counterfactual funding, EIP-7702, arbitrary execution,
  unsolicited-token sweep, pooled operator rewards, or production privacy claims.

This profile retains offline peer-to-peer bearer transfer. It narrows mechanisms
that add hidden authority or unbounded complexity, not the central user experience.

## Implementation order

1. Specify and model the canonical intents, state machines, account invariants,
   exact replay, and receipt formats.
2. Implement the immutable testnet account, direct transport, paymaster transport,
   and atomic basket contract.
3. Build a powered hardware test rig for deterministic authorization, persistent
   commit, key generation, display update, and interruption recovery.
4. Build the passive prototype and measure energy, entropy, relay, fault, side
   channel, lifecycle, and physical safety properties.
5. Implement open verifier clients with layered assurance and advisory policy.
6. Build the split-controller register and test custody, hostile inputs, consent,
   accessibility, safety, and receipts.
7. Establish typed manufacturing metadata, enrollment, canonical batch trees,
   transparency, and production conformance.
8. Run the staged evidence program before making retail security or business
   claims.
9. Add private refresh and anonymous attestation only as separately reviewed later
   profiles.

## Definition of resolved

An issue is not resolved because this document proposes an answer. Resolution
requires one or more of:

- normative RFC language and interoperable test vectors;
- a model-checked state or contract invariant;
- implementation and adversarial tests;
- measured hardware evidence under a defined attacker and mission profile;
- complete-equipment safety and conformance evidence;
- an operating, custody, legal, or economic policy with accountable ownership;
- an explicit accepted-risk decision that preserves offline bearer behavior and
  accurately describes the remaining exposure.
