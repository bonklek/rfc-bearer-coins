# Request for comments: Physical Bearer Cryptocurrency

> [!CAUTION]
> This repository is an incomplete research specification, not an implementation
> or security-reviewed product. Do not use it with mainnet or assets of value.

Physical Bearer Cryptocurrency is a proposed physical cash form for digitally native assets. A coin carries one represented asset at a time, can circulate without recording every handoff, and can be checked with increasing levels of assurance ranging from physical inspection to immediate onchain claim.

The first reference design is intentionally narrow:

- batteryless NFC-powered hardware;
- a universal reusable shell;
- one represented asset per coin epoch;
- one exact represented amount and load-bound residual beneficiary per epoch;
- one supported chain per asset at launch, so the coin face shows asset and amount rather than chain;
- Ethereum mainnet smart accounts controlled by P-256 hardware keys;
- an initial policy set such as ETH, mainnet USDC, and mainnet WBTC;
- a finite ordered slot series in which each slot reveals a fresh account only after the previous represented load is depleted;
- proof-activated loading: a revealed slot remains inactive until the core verifies finalized exact-funding evidence;
- open operation-specific passive-power profiles, with phones targeted for stateless verification and powered registers or home pads used for persistent mutation unless a phone meets the same measured limits;
- two side buttons for verification and all three buttons for claim;
- optional local BSLRR continuity records;
- transparent key rotation first, with private refresh as a later compatible route;
- open verifier software and advisory trust feeds.

This smart-account design is the **version 1 Architecture A baseline**. The RFC
also tracks [Architecture B](./docs/architecture-b-commitment-pool.md) as a
first-class research candidate: a shared reserve contract holds exact denominations,
each physical coin controls one hidden Merkle commitment, and claim consumes the
note with a one-time nullifier. A composite proof may establish approved hardware,
fresh authorization, correct denomination, membership, and unspent status without
revealing the exact core or note. Architecture B is not yet selected; it must beat
Architecture A in a measured prototype and preserve destination-bound
non-exportable authorization, interruption recovery, unilateral exit, and honest
privacy disclosures before any later version can select it.

Verifier output keeps the coin-signed core state, a sourced and
finality-qualified chain observation, and each publisher's external risk opinion
as separate fields. No warning feed mutates the coin or creates protocol-wide
revocation.

## What is being proposed

The bearer object is not an ordinary hardware wallet. Version 1 exposes no
monetary private-key export command or mode. Instead, the secure core authenticates
its state, signs narrowly defined account operations, and advances through
irreversible key epochs. This is a target property, not evidence that current
hardware meets it.

```text
physical handoff
  -> optional side-button hardware verification
  -> optional online backing check
  -> optional BSLRR handoff
  -> continued physical circulation

merchant claim
  -> side-button verification
  -> customer-visible waiting chamber and tally
  -> authoritative visual and nonvisual basket terms
  -> customer pulls one basket-commit lever
  -> one-way claim chamber
  -> one fresh secure-controller center press-and-release cycle per approved claim coin
  -> all-three-button authorization of the displayed ClaimIntent
  -> onchain transfer or account operation
```

For the register profile, customer approval plus secure crossing of either the
verification-only accept gate or claim gate transfers ownership to the merchant.
Before crossing, the customer remains owner and the register is a bailee. A
settlement provider assumes risk only through a signed acquisition acceptance;
later provider or chain failure does not restore a customer payment obligation.

Normal checkout trusts a narrow evaluated claim controller that owns the authoritative two-sided display, armed `ClaimIntent`, approval state, one-way gate, actuator sequence, and signed receipt. An open customer verifier may independently check the same digest, but phones are not required for ordinary checkout.

The customer-facing basket-commit lever is the standard accessible initiation
control. It remains unavailable until the terms are fixed and, for claims, online
submission preconditions pass. One pull cannot continuously hold center; it
permits exactly one distinct center press-and-release cycle for each approved
claim coin while the mechanism applies the side-button state. It cannot alter the
basket, add coins, or exceed the approved cycle count, and it disarms on
completion, cancellation, or failure. Verification-only coins receive no center
stroke. The same canonical terms are presented nonvisually before activation.

The standard primary confirmation is risk-first: purchase total, merchant,
selected action, tender and change, customer fees, and every represented asset's
amount with a short approved-chain name and recognizable chain icon. Concrete
backing, settlement, custody, freezability, and upgradeability warnings are also
primary. Exact chain IDs, contracts, proxies, implementations, and other technical
metadata stay in secondary details unless they create a material warning; the
written chain name accompanies every icon and is included in nonvisual output.

Multi-coin checkout uses one approved canonical basket and signed evidence for
each sequential gate crossing. If only part of the basket crosses, the merchant
owns that accepted subset and owes the basket's precommitted exact remedy. A
complete same-chain authorization set may execute through one reverting
`BasketClaim`; incomplete physical routing is never represented as atomic, and a
pending coin is never returned as ordinary active tender.

The protocol mandates no exchange-rate oracle. Independent merchants may choose
their source, while an issuer or settlement provider may condition its optional
service on a specified source and spread. The exact source relationship, integer
rates, fees, rounding, selected tender, change, and remedies are committed before
approval. Quote expiry prevents late approval but never reprices an approved
basket.

Offline checkout uses the verification-only accept path. A standard register
does not begin all-three-button claim unless current chain checking, transaction
submission, durable retry storage, and gas or sponsorship are ready. If the
network disappears later, the register returns pre-gate customer property,
retains post-gate active merchant property, or queues the exact captured pending
authorization according to the stage reached.

The proposal does not make continuously current backing finality appear from nowhere. A slot enters `ACTIVE` only after the core verifies a slot-bound proof of finalized exact funding, so later offline verification can establish that proof-activated state and the absence of a subsequent monetary authorization. Only a current chain check establishes newer chain state.

Local attestation also does not prove that the responding core is physically inside the shell presented to the verifier. Fresh nonces stop replay of old responses, not live forwarding to a genuine coin elsewhere. Version 1 preserves offline acceptance, labels this limitation explicitly, measures relay resistance in the assembled prototype, and treats immediate claim as the strongest ordinary merchant response.

## Main architectural bet

Low denomination, deliberate physical activation, non-exportable keys, irreversible state evolution, optional online verification, and rapid merchant claim may together make classical physical bearer crypto practical even though each layer is imperfect.

This depends on a hardware result that has not yet been demonstrated for this product:

```text
no authorization leaves the core
unless the corresponding one-time state is durably committed

and

no revealed monetary slot becomes ACTIVE
unless finalized exact-funding evidence is verified and durably committed
```

The candidate implementation uses one recoverable `AUTH_PENDING` lane shared by claim, rotation, migration, and future private refresh. The core creates the normalized signature once, atomically persists its exact bytes with the canonical intent digest, operation, epoch, shared semantic nonce, and pending state, and only then releases it. After power loss a caller resupplies the canonical intent; the core verifies its digest and returns the stored signature without invoking the monetary key again. The account rechecks and consumes the same semantic nonce during execution. Whether available secure hardware can enforce this commit-before-output ordering under fault injection remains a central prototype question.

Onchain claim is one reverting transition. It enters an execution guard and
consumes the semantic nonce before external interaction, requires strict transfer
success and exact balance deltas, zeroes the represented-asset balance, retires
bearer authority, and emits completion only after every invariant holds. The coin
advances only after verifying finalized proof of the zero balance and retired
authority.

## Specific feedback requested

### Architecture choice

- Should a physical coin be represented by an identifiable smart account or by a
  hidden fixed-denomination commitment in a shared reserve?
- Can the commitment/nullifier construction use a fresh P-256 core signature as
  private proof witness without exporting reusable spending authority?
- What authenticated data structure supports private proof of both commitment
  membership and nullifier nonmembership at a recent finalized root?
- Which party can construct a fresh private presentation without learning a stable
  note identifier: the passive core, a holder-controlled device, or a formally
  analyzed delegated prover?
- Which contract, circuit, setup, upgrade, censorship, and exit assumptions make
  the shared pool safer or less safe than many small immutable accounts?

### Hardware primitive

- Which commercial secure element or secure MCU can execute the complete state machine, not merely store a signing key?
- Can the complete pending record, including the exact normalized signature, be committed safely before output and replayed without another key operation under arbitrary NFC field removal?
- Can a finite generate-on-advance core reliably enforce its maximum epoch count, generate each future monetary key only after the prior epoch closes, and commit the new key before public output?
- Under what evaluated attack boundary can it credibly claim that extracting the current monetary key does not expose a future key that has not yet been generated?
- Can a passive enclosure detect useful classes of tampering without overstating what it sees while unpowered?
- Can the consumer profile preserve one exact evacuation after irreversible tamper suspicion without permitting reload, flag clearing, or another monetary epoch?
- Can a persistent display be coupled closely enough to signed state to be useful without being treated as proof of backing?
- Can a passive core verify a finality-rooted slot-funding proof and atomically commit `ACTIVE` within the available power, memory, latency, and thermal envelope?

### Claim and rotation

- Which typed encoding and test vectors should implement the accepted complete `ClaimIntent` while allowing separately bounded transport replacement?
- What exact recovery protocol can make an existing `AUTH_PENDING` authorization unusable before permitting a different monetary operation?
- Can the stored signature be safely replayed only for digest-identical intent bytes and only until its intended onchain effect succeeds?
- During balance-preserving rotation, when may the old slot be retired without risking stranded funds?
- What conformance evidence is sufficient to support version 1's absolute
  no-private-key-export requirement?

### Ethereum account

- What is the smallest immutable account interface that supports P-256 validation, one represented asset, key rotation, claim, and coin-authorized migration?
- Can claim atomically send the exact represented amount to its destination, route all same-asset surplus to the load-bound residual beneficiary, verify a zero ending balance, and retire authority without introducing token-specific failure ambiguity?
- Should ERC-4337 be the preferred transport while direct relaying remains available?
- How should clients disclose unsupported tokens, given that version 1 provides
  no unsolicited-token sweep path?
- What state should be visible to online verifiers without linking physical circulation more than necessary?

### Offline assurance

- Which statements can a verifier safely show as hardware claims rather than facts about the world?
- What screen design best communicates the accepted `coreState`,
  `observedChainState`, and `externalRiskStatus[]` dimensions under retail time
  pressure?
- What relay-resistance measurements are sufficient to describe local attestation responsibly without claiming physical co-location?
- Is a verification-event counter useful enough to justify memory wear and denial-of-service risk?
- Does BSLRR provide meaningful continuity once its inability to prove distinct bearers or unrecorded transfers is made explicit?
- What is the least misleading assurance vocabulary for offline, RPC-checked, proof-checked, light-client, and full-node checks?

### Manufacturing trust

- How should batch credentials be scoped so compromise of one manufacturer or laboratory key has a bounded blast radius?
- Can batch membership be proven without exposing a stable per-core identifier?
- Which combination of manufacturer signatures, independent witnesses, laboratory profiles, and transparency logs is practical?
- How should clients combine conflicting advisory feeds without creating a de facto central revocation authority?

### Register

- Can one-coin-at-a-time mechanical continuity reliably bind a verified coin to the coin entering the claim chamber?
- Which quote-source and relationship identifiers, currency profiles, and change-method schemas provide interoperable receipts without creating a protocol-wide oracle?
- What must the customer be able to see before the irreversible claim boundary?
- How should the secure claim-controller boundary and optional independent intent-verification exchange be evaluated?
- Which optional node, bundler, relayer, and mirror roles belong on a companion operator device rather than the register controller?

### Economics

- What coin denomination keeps likely attack cost comfortably above recoverable value?
- What manufacturing cost and useful life are plausible for the selected finite
  generate-on-advance version 1 core, and what evidence would justify a later
  renewable profile?
- Can optional managed settlement undercut existing payment acceptance after fraud, liquidity, network, hardware, and support costs?
- Which first market produces enough repeated local circulation to test the bearer premise rather than only one-time redemption?

## Current documents

- [Master architecture](./docs/master-architecture.md)
- [Coin hardware](./docs/coin-hardware.md)
- [Key lifecycle and claim protocol](./docs/key-lifecycle.md)
- [Verification and BSLRR](./docs/verification-and-bslrr.md)
- [Register and checkout](./docs/register-and-checkout.md)
- [Ethereum accounts and assets](./docs/ethereum-accounts-and-assets.md)
- [Privacy routes](./docs/privacy-routes.md)
- [Trust, manufacturing, and compromise response](./docs/trust-and-manufacturing.md)
- [Operator network and business model](./docs/operator-network-and-business.md)
- [Open questions](./docs/open-questions.md)
- [Project status](./STATUS.md)
- [Document authority and supersession](./DOCUMENT_AUTHORITY.md)
- [Proposed solutions to the complaint log](./PROPOSED_SOLUTIONS.md)
- [Complaint triage (C-012–C-096)](./ISSUE_TRIAGE.md)

## Current status

The concept is internally developed but not implementation-ready. There is no
hardware, contract, register, reference client, interoperability suite, or
production evidence in this repository. Seven critical complaints remain open or
partially addressed, including key-generation and signature-nonce safety,
transport-fee authority, same-chain-ID fork replay, and `AUTH_PENDING` liveness.
Architecture A is linkable by design; BSLRR is not anonymous or unlinkable; and
Architecture B's privacy claims remain unproven.

The first milestone should be a batteryless test device that performs valueless one-time authorization under repeated power cuts, followed by fault-injection review. Smart-account and register prototypes can proceed in parallel, but they cannot validate the physical security claim by themselves.
