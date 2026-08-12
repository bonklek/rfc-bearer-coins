# Physical Bearer Cryptocurrency master architecture

Physical Bearer Cryptocurrency is a proposed batteryless physical bearer token for cryptocurrency and other supported digital assets. It is meant to behave like cash during physical circulation while retaining optional cryptographic and onchain checks.

The token carries one represented asset at a time. Ownership during circulation is possession of the object, not an onchain record of every handoff. Any holder may pass it onward, inspect it, rotate its key, check its backing, or initiate claim according to the capabilities of the hardware and account.

The first design is a thought experiment and prototype target. Architecture A is
the version 1 baseline; Architecture B is a later research candidate. Statements
about what the hardware **must** do are requirements, not evidence that current
commodity hardware already does them. This design must not be used with mainnet
or assets of value.

## Related docs

- [Plain-language explainer](../EXPLAINER.md)
- [RFC-0001: version 1 profile](../rfcs/0001-physical-bearer-cryptocurrency/README.md)
- [Architecture at a glance](./architecture-at-a-glance.md)
- [Coin hardware](./coin-hardware.md)
- [Architecture B: hardware-held shielded notes](./architecture-b-commitment-pool.md)
- [Key lifecycle and claim protocol](./key-lifecycle.md)
- [Verification and BSLRR](./verification-and-bslrr.md)
- [Register and checkout](./register-and-checkout.md)
- [Ethereum accounts and assets](./ethereum-accounts-and-assets.md)
- [Privacy routes](./privacy-routes.md)
- [Trust, manufacturing, and compromise response](./trust-and-manufacturing.md)
- [Operator network and business model](./operator-network-and-business.md)
- [Open questions](./open-questions.md)
- [Project status](../STATUS.md)
- [Document authority and supersession](../DOCUMENT_AUTHORITY.md)
- [Decision transcription ledger](../TRANSCRIPTION_LEDGER.md)

## Design principles

### Physical transfer stays permissionless

No manufacturer, application, register operator, trust-feed publisher, or settlement provider can prevent two people from handing the object to each other. Each recipient chooses what evidence is sufficient.

An account contract or asset contract can still enforce its own onchain rules. A commercial counterparty can decline a coin. Neither fact turns an advisory hardware feed into protocol-wide invalidation.

### Hardware state and backing are separate

The coin may attest that it generated a key internally, that its own lifecycle says the key is sealed, and that no monetary authorization has been recorded since slot activation. A production slot enters `ACTIVE` only after the core verifies a slot-bound proof of finalized exact funding. This is historical proof-activation evidence, not a continuously current chain observation.

```text
hardware state: what the secure core reports about itself
backing state: what the selected chain currently records
```

The display is a human-readable label for signed coin state. An active label means the core accepted the required funding proof and has not since authorized a monetary operation; it is not a continuously refreshed guarantee that the backing remains present.

### Local attestation does not prove physical co-location

A fresh local response proves that an approved secure core answered the verifier's challenge and reported its local state. It does not by itself prove that the responding core is inside the physical shell presented to the recipient. A counterfeit object may attempt to relay the live exchange to a genuine activated coin elsewhere.

Fresh nonces prevent reuse of an old recorded response; they do not prevent a live relay. Deliberate side-button activation, complete RF disconnection at rest, short bounded sessions, and a constrained NFC profile make relay less convenient but are not treated as proof of distance.

The accepted version 1 assurance model is therefore progressive:

```text
physical inspection
  -> optional local core attestation
  -> optional BSLRR continuity
  -> optional online backing observation
  -> optional immediate claim
```

The recipient chooses the assurance level. Physical handoff and offline acceptance remain possible at every denomination; clients and commercial counterparties may recommend or require stronger evidence under their own policies. Immediate claim is the strongest ordinary merchant response because it transfers the backing instead of relying on continued physical authenticity.

### Verification and claim are physically distinct

The current physical mapping is:

```text
both side buttons: verify
both side buttons + center button: claim
```

The command distinction should be enforced in the coin's electrical and secure-core design. Register software alone is not the security boundary.

At checkout, one large customer-facing basket-commit lever is the standard
accessible initiation control. The secure controller keeps it unavailable until
the basket terms are fixed and, for claims, D-040's online preconditions pass.
One pull locks the approved basket and enables a bounded indexed sequence, but
each approved claim coin still receives its own fresh center
released-to-pressed-to-released cycle while the mechanism applies both side
inputs. The actuator fully retracts between coins. It cannot add coins, alter
terms, exceed the approved claim count, or stroke a verification-only coin, and
it disarms on completion, cancellation, or failure. Authoritative terms are
available visually and nonvisually before the lever unlocks.

### Physical acceptance transfers ownership

Before customer approval and secure gate crossing, the customer owns the coin and
the register operator holds it as bailee. Approval plus crossing either the
verification-only accept gate or the claim gate transfers ownership and ordinary
coin risk to the merchant. Claim submission and confirmation are the merchant's
chosen settlement process, not a condition that keeps risk with the customer.

A managed provider assumes acquisition or payout risk only after issuing a signed
acceptance bound to the canonical settlement identity and terms. Equipment failure
follows the actor controlling custody. Fraud remedies are attributable commercial
or legal claims, not protocol clawbacks.

### Version 1 has no private-key export path

The secure core signs the complete destination-bound `ClaimIntent` and
irreversibly advances its local state. Version 1 exposes no command or mode that
exports a monetary private key. This remains an unproven hardware security target
until the key-generation, entropy, nonce, firmware, and extraction-resistance
gates are demonstrated.

This is narrower and safer than releasing the private key. An optional raw-key redemption mode is not part of the first reference protocol.

The account executes claim as one reverting, reentrancy-guarded transition. It
consumes the semantic nonce before external interaction, strictly checks transfer
results and exact balance deltas, reaches zero represented-asset balance, retires
bearer authority, and only then emits completion. Any failed invariant reverts the
entire execution. The coin advances only after verifying finalized proof of the
zero balance and retired authority.

### Tamper suspicion preserves evacuation, not reuse

The ordinary consumer profile treats a confirmed sensor event as irreversible
evidence, not an instruction to destroy a funded key. The core enters
`TAMPER_SUSPECTED`, stops reporting `ACTIVE`, refuses future loading and key
generation, and permits only one exact all-three-button evacuation authorization.
After finalized zero-out evidence it becomes permanently `TAMPER_RETIRED` and its
secure core must be replaced. A separately labeled destructive profile must
explicitly accept bearer loss or establish recovery authority before funding.

### One represented asset per epoch

A universal shell may carry different supported assets over its life, but one epoch represents exactly one asset identifier and amount.

The internal identifier includes chain ID and exact native-asset or contract identity. The first launch supports one chain per represented asset, so the passive display need show only asset, amount, and relevant status. Verifier clients still show the underlying chain and contract metadata.

At a register, the primary confirmation and audio output add a short approved
chain name and recognizable chain icon beside each represented asset. The icon
does not replace text or the exact identifier: exact chain IDs, contracts, and
implementation metadata remain secondary unless their current state creates a
material warning. The primary view elevates plain-language backing, settlement,
custody, freezability, and upgradeability risks.

Proof-activated loading also fixes a residual beneficiary. Claim sends the exact
displayed amount to the claim destination and every remaining unit of that same
represented asset to the residual beneficiary, verifies a zero ending balance,
and retires bearer authority atomically. Underfunding fails rather than silently
reducing the payment. Unrelated token contracts are not part of the represented
value.

### Open clients and plural trust

Baseline verifier clients should be open source, free to use, and functional without a mandatory service. Manufacturers, laboratories, monitors, asset-policy publishers, and application maintainers may publish signed feeds. Users and commercial operators choose which feeds and policies to use.

## First reference product

The initial target is:

- a universal coin-sized or token-sized shell;
- passive NFC power with deliberate mechanical activation;
- a secure core that owns the monetary and attestation keys;
- a persistent e-paper or equivalent bistable display;
- Ethereum mainnet as the first chain;
- ETH, mainnet USDC, and mainnet WBTC as illustrative initial policy entries;
- a minimal P-256-controlled smart account;
- transparent rotation and direct claim;
- optional online backing verification;
- optional BSLRR handoff continuity;
- a low-throughput transparent register prototype.

The specific assets are operator policy, not universal protocol law. WBTC must be described as wrapped and custody-dependent, not as native Bitcoin.[^wbtc]

## Competing onchain architectures

The smart-account design above is **Architecture A** and remains the first
reference prototype. **Architecture B** is now a first-class competing design:

```text
Architecture A: one identifiable P-256 smart account per active coin
Architecture B: one hidden hardware-authorized note in a shared commitment pool
```

Architecture B proposes a Merkle commitment tree and one-time nullifiers. If a
construction is selected, implemented, and validated, a private presentation
would aim to prove that the responding approved core controls a correctly
denominated, currently unspent note without revealing the exact hardware identity,
commitment, or backing account. Claim publishes the note's nullifier and transfers
the exact denomination; the contract rejects reuse of that nullifier.

This may replace public per-coin accounts, linkable key-rotation histories, and a
separate private-refresh hop. It also introduces a proof circuit and shared pool as
system-wide dependencies, does not prevent live relay or physical cloning, and
does not by itself solve confidential external proving. See [Architecture B:
hardware-held shielded notes](./architecture-b-commitment-pool.md).

## Major components

```text
physical coin
|-- passive power and activation
|-- secure core
|   |-- attestation key
|   |-- monetary key epoch
|   |-- one shared monetary AUTH_PENDING state machine
|   `-- counters and optional BSLRR root
|-- persistent display
`-- tamper-evident or tamper-responsive construction

verifier client
|-- fresh challenge-response
|-- hardware and firmware policy
|-- asset metadata policy
|-- optional chain query or proof verification
`-- optional BSLRR handoff

Ethereum account
|-- P-256 authorization
|-- represented asset and amount policy
|-- claim
|-- key rotation
`-- coin-authorized migration

merchant register
|-- visible verification path
|-- waiting chamber and two-sided tally
|-- customer-approved claim boundary
|-- one-coin claim chamber
|-- secure claim controller binding display, intent, gate, actuator, and receipt
`-- optional settlement and operator services
```

## Baseline flows

### Offline handoff

```text
Alice gives the coin to Bob
  -> Bob inspects the asset and amount label
  -> Bob may press both side buttons against a verifier
  -> verifier authenticates a responding core and reports that co-location is unproven
  -> Bob may request an offline BSLRR handoff
  -> Bob accepts or declines under his own policy
```

No chain state changes merely because possession changes.

### Online check

```text
local hardware verification
  -> resolve exact AssetID and expected account
  -> obtain current chain data
  -> verify balance, account code, current key, and nonce/state
  -> report data source and finality level
```

The client must distinguish a single RPC response from proof-checked, light-client, or full-node verification.

### Merchant checkout

```text
merchant enters price
  -> coins pass side-button verification
  -> verified coins remain in a visible waiting chamber
  -> authoritative visual and nonvisual output presents the complete basket
  -> register commits one canonical basket and per-coin ClaimIntents
  -> basket lever unlocks only after fixed terms and any claim preconditions pass
  -> customer pulls the basket-commit lever once
  -> selected coins cross their accept or claim gates one at a time
  -> each crossing creates signed ownership evidence
  -> each claimed coin receives one fresh bounded center press-and-release cycle
  -> verification-only coins receive no center stroke
  -> complete same-chain authorization sets may execute in one reverting BasketClaim
  -> partial physical routing invokes the basket's exact merchant remedy
  -> merchant settles independently or uses an optional provider
```

Standard checkout trusts the evaluated secure claim controller and authoritative two-sided display. A customer may independently inspect the armed intent with an open verifier app, but no phone or app is required for normal use.

There is no protocol-wide exchange-rate source. A self-settling merchant selects
and discloses its source; an issuer or settlement provider may require a source,
spread, and fee policy as a condition of its optional service. The quote uses
canonical integer arithmetic and locks when the customer approves. Quote expiry
can stop a late approval but cannot reprice an approved basket. Unselected coins
return before approval, and exact change and failure remedies are bound into the
basket.

The standard register permits offline verification-only acceptance but does not
begin all-three-button claim without a fresh chain check, a working submission
path, durable retry storage, and available gas or sponsorship. If connectivity
later fails, ownership follows the physical gate and monetary state follows the
last durable core transition: return before crossing, retain an active
merchant-owned coin before authorization, or queue the exact pending
authorization after capture.

### Transparent refresh

```text
coin prepares next key
  -> current key enters the shared AUTH_PENDING lane for key rotation
  -> operation confirms onchain
  -> old local key epoch retires
  -> BSLRR epoch closes
```

The old key must not be irreversibly discarded before there is a recoverable path to complete or retry the onchain transition.

### Post-redemption reload

```text
exact claim sends the represented amount to its destination,
routes same-asset surplus to the residual beneficiary,
verifies zero represented-asset balance, and retires bearer authority
  -> coin verifies finalized evidence of both facts
  -> old key epoch retires permanently
  -> coin reveals the next slot's fresh account, key, and challenge
  -> slot remains AWAITING_LOAD_PROOF
  -> loader selects one supported AssetID and exact amount
  -> new account is deployed or confirmed and funded
  -> any untrusted prover constructs finalized slot-bound funding evidence
  -> coin verifies the proof and atomically commits ACTIVE plus display state
```

The next monetary key is generated only after the previous epoch has finality-rooted depletion evidence and retires. Future accounts remain unknowable because their monetary keys do not yet exist. The permanent core certificate binds the irreversible maximum epoch count, not a list of future addresses. This does not prove physical compartmentalization against complete core compromise.

## Product generations

### First generation

- classical tamper-resistant hardware;
- transparent Ethereum smart accounts;
- one chain per asset on the physical display;
- online checks optional but straightforward;
- direct non-private claim and key rotation;
- advisory trust feeds.

### Later generations

- a decision, based on prototypes, between Architecture A plus private refresh and
  Architecture B's hardware-held shielded notes;
- privacy-preserving hardware attestation;
- native Bitcoin or a noncustodial Bitcoin-specific design;
- stronger physical one-time key cells if feasible;
- genuine quantum bearer tokens if durable, publicly verifiable quantum-money primitives become practical.

These are separate research tracks. The classical design does not claim quantum security, and the quantum roadmap does not validate the classical hardware assumptions.

## Terminology

| Term | Meaning |
|---|---|
| Monetary key | Current non-exportable key authorized by the represented-asset account under Architecture A or bound to the hidden note authority under Architecture B. |
| Attestation key | Persistent core credential used to authenticate hardware-originated statements. |
| Key epoch | One monetary-key lifecycle inside the secure core. |
| Sealed-by-core | The core reports that the key was internally generated or activated and has not undergone a claim transition or any export (which version 1 forbids). This is a hardware claim, not an absolute proof of non-exposure. |
| Claim | Deliberate all-three-button authorization to transfer the represented asset or account authority, or consume a shielded note, for a specified destination. |
| Backing check | Online check of current chain state for the represented account and asset or proof that an Architecture B note is included and unspent. |
| Local attestation | Fresh proof that an approved core answered and reported its own state. It does not by itself prove that the core is inside the presented shell. |
| BSLRR | Optional Bearer-Since-Last-Rotation Record, described in the verification document. |
| Retired slot | A monetary slot that the core will not activate again. |
| Exhausted core | A finite-slot core with no unused certified slots. |
| Refurbished coin | Reused non-security-critical hardware fitted with a new externally certified secure core. |

## What is deliberately unresolved

The architecture does not yet select:

- a production secure element or secure MCU;
- physical isolation for the selected finite generate-on-advance logical epoch
  budget; an unbounded renewable lifecycle belongs to a later profile;
- a complete interrupted-claim recovery protocol;
- a private-refresh proof system;
- whether Architecture B should replace or remain interoperable with the per-coin
  smart-account baseline;
- a first-generation anonymous attestation scheme;
- a mandatory trust root or asset list;
- a fixed register hardware specification;
- a fee or revenue-sharing schedule.

Those questions are tracked in [Open questions](./open-questions.md).

## References

[^wbtc]: [WBTC: About](https://wbtc.network/about), describing the current custody and cross-chain structure of WBTC.
