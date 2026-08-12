# RFC-0001: Physical Bearer Cryptocurrency version 1 profile

| Field | Value |
|---|---|
| Status | Draft; incomplete; not implementation-ready |
| Profile | Version 1 / Architecture A |
| Last integrated | 2026-08-12 |
| Implementation | None |
| Security and privacy validation | None |
| Permitted prototype environment | Valueless test networks only |

> [!CAUTION]
> This RFC specifies a research target, not a safe implementation. It MUST NOT be
> used with mainnet or assets of value. No implementation may claim version 1
> conformance until the required encodings, test vectors, hardware profile,
> contracts, tests, and independent evaluations exist.

## Abstract

This RFC defines the current version 1 target for a batteryless physical bearer
token representing one digital asset and exact amount at a time. Possession of an
active object permits physical handoff without an account, application, network
request, or onchain transfer. Recipients may inspect the object, authenticate
core-reported state, observe chain state, or claim the represented value. These
actions answer different questions; they are not a single confidence scale.

Version 1 uses Architecture A: a finite generate-on-advance secure-core lifecycle
and deployed immutable Ethereum smart accounts. Architecture B is non-normative
research and is not part of this profile.

## 1. Conventions and status

The key words **MUST**, **MUST NOT**, **REQUIRED**, **SHOULD**, **SHOULD NOT**, and
**MAY** describe target requirements in this draft. They do not imply that a
conforming implementation presently exists.

This RFC is the canonical integrated version 1 profile. The sole canonical
logical `ClaimIntent` field list remains in
[Key lifecycle and claim protocol](../../docs/key-lifecycle.md#claim-semantics),
which is incorporated by reference to prevent diverging copies.

An accepted later D-* decision that explicitly says it supersedes this RFC takes
temporary precedence until the RFC and
[transcription ledger](../../TRANSCRIPTION_LEDGER.md) are updated. Historical
complaints and research never silently change the profile.

## 2. Scope

Version 1 covers:

- a batteryless NFC-powered bearer object with persistent local state and display;
- physical handoff without mandatory protocol participation;
- optional local verification and online backing observation;
- proof-activated loading of one exact represented asset and amount;
- a finite generate-on-advance monetary-key lifecycle;
- deployed immutable smart accounts for active represented loads;
- destination-bound `ClaimIntent` authorization;
- one serialized lane for claim and other monetary operations, whose non-claim
  authorization schemas remain unspecified;
- optional local BSLRR continuity; and
- open verifier software and advisory trust policies.

It does not standardize commercial fees, asset listings, mandatory trust roots,
custodial recovery, production hardware, or a production privacy system.

## 3. Architecture

### 3.1 Bearer transfer

An `ACTIVE` coin MUST remain physically transferable without an application,
account, issuer, register, or network connection. Ordinary handoff MUST NOT create
an onchain transaction or monetary authorization. A recipient chooses which
available evidence is sufficient and MAY decline the object under a local policy.

No manufacturer, trust-feed publisher, settlement provider, or application may
remotely mutate the core or create protocol-wide invalidation. Asset and account
contracts may still enforce their own onchain rules.

### 3.2 Hardware authority

Version 1 MUST expose no command, recovery, debug, migration, redemption, or
exceptional mode that exports a monetary private key. The core MUST use monetary
authority only for operations allowed by the serialized lifecycle.

This requirement does not prove key confidentiality. A profile remains
non-conforming until key entropy, signature nonce behavior, reset state, firmware,
fault response, extraction resistance, and evaluated configuration are specified
and independently tested.

The physical command boundary MUST distinguish verification from monetary
authorization. The target mapping is:

```text
both side buttons: verification
both side buttons plus a fresh center-button cycle: monetary authorization
```

Register software alone MUST NOT be the boundary enforcing this distinction.

### 3.3 Finite lifecycle

The core MUST enforce an irreversible maximum epoch count. It MUST retain only
the current monetary key and MUST generate the next key only after finalized
evidence closes the previous represented load and retires its bearer authority.
The next public key MUST NOT leave the core before the new key and advanced epoch
are durably committed.

The version 1 core lifecycle is:

```text
EMPTY
AWAITING_LOAD_PROOF
ACTIVE
AUTH_PENDING
TAMPER_SUSPECTED
TAMPER_RETIRED
EXHAUSTED
```

`RETIRED` describes a key or slot transition, not an additional whole-core state.
An unbounded renewable lifecycle and physically isolated one-time cells are not
part of version 1.

### 3.4 Proof-activated loading

A newly revealed epoch MUST remain `AWAITING_LOAD_PROOF` until the core verifies
finalized evidence bound to its fresh activation challenge and the complete
expected chain/fork, account, immutable implementation, monetary public key,
AssetID, represented amount, residual beneficiary, semantic nonce, and status.

Proof construction MAY occur outside the core and is untrusted. Proof verification
and the transition to `ACTIVE` MUST occur inside the core. Arbitrary power removal
MUST leave exactly the prior `AWAITING_LOAD_PROOF` state or the fully committed
`ACTIVE` state. The proof system and passive feasibility remain unselected gates.

### 3.5 Account and represented asset

Each active represented load MUST use an already deployed immutable Architecture
A account whose runtime code and initial P-256 key binding are observable before
funding.
The account MUST have no remote administrator capable of replacing validation,
freezing bearer authority, or adding surveillance.

Each epoch MUST bind one exact AssetID, represented amount, and residual
beneficiary. Unexpected assets do not become bearer value. Version 1 MUST provide
no arbitrary execution or unsolicited-token sweep path.

The draft does not decide whether balance-preserving rotation creates a new key
epoch while retaining the same account and represented load. Until the
account/load/key-epoch relationship is specified, implementations cannot claim
conformance for balance-preserving rotation.

Claim execution MUST be one reverting, reentrancy-guarded transition that:

1. rechecks the intent, account, epoch, status, and semantic nonce;
2. consumes the shared nonce before external interaction;
3. transfers exactly the represented amount to the claim destination;
4. routes same-asset surplus to the load-bound residual beneficiary;
5. enforces strict call success and exact balance deltas;
6. requires zero ending represented-asset balance;
7. retires bearer authority; and
8. emits the completed `intentDigest` and resulting state.

Any failed condition MUST revert every effect.

### 3.6 Monetary authorization

Claim, rotation, migration, evacuation, and any future private-refresh operation
MUST share one semantic nonce and one `AUTH_PENDING` lane. The canonical
`ClaimIntent` applies only to claim. Rotation, migration, and evacuation require
typed, domain-separated authorizations, but their schemas are not selected.

Before authorization bytes leave the core, it MUST durably commit the exact
operation, digest,
normalized signature, epoch, nonce, and signature profile. After interruption it
MUST reproduce only those exact bytes without invoking the monetary key again.

The canonical logical `ClaimIntent` binds every material monetary, merchant,
beneficiary, quote, fee charged to the customer, basket, settlement, expiry, and
execution term. Changing a bound term requires a new deliberate authorization.

Version 1 also requires a separate typed `TransportAuthorization` binding the
stable `intentDigest` to chain and fork domain, EntryPoint or direct relay, gas and
fee caps, validity, paymaster terms, sponsor nonce, and an identifier or digest for
the applicable fee-failure policy. Signing that policy identifier records the
terms; it does not enforce legal loss allocation. Represented value MUST NOT be
implicit gas authority. Caller- or paymaster-funded execution is the baseline.

The exact transport schema and test vectors remain unfinished. The fork field
does not by itself solve same-chain-ID split replay, particularly for pre-split
authorizations.

### 3.7 Interrupted authorization

Exact retry prevents reinterpretation but does not guarantee liveness. The current
draft has no accepted general cancellation or invalidation protocol for an
`AUTH_PENDING` authorization. Expiry, censorship, fee changes, reorganization,
token or account freezes, or lost transport state may strand a funded coin.

A conforming profile MUST NOT claim recoverability until a modeled protocol proves
completion or a terminal state with all of these properties:

- the stored authorization is executable exactly once or provably unusable;
- no conflicting authorization can execute;
- the represented value has a defined disposition; and
- clients can distinguish the terminal state from a retryable pending state.

Whether permanent stranding is an acceptable terminal disposition remains a
product decision. Until then, version 1 defines exact retry only and MUST disclose
the possibility of permanent stranding.

### 3.8 Verification result

Verifier output MUST preserve three separately attributed dimensions:

- `coreState` from the secure core;
- `observedChainState` from a named and finality-qualified chain source; and
- `externalRiskStatus[]` from identified policy publishers.

Clients MUST NOT collapse them into one `valid` bit. Fresh local attestation means
a core accepted under the verifier's selected hardware policy answered the
challenge; it MUST NOT be described as proof that the core is inside the physical
shell. Verifier challenges MUST contain at least
128 unpredictable bits and follow the single-use, rollback-resistant behavior in
the verification document.

### 3.9 Register claim

A standard register MUST NOT initiate the irreversible claim sequence without a
fresh chain check, working submission path, durable authorization storage, and
available external gas or sponsorship. The evaluated claim-controller boundary
MUST own the authoritative visual and nonvisual terms, armed intent, customer
approval state, one-way gate, center-button actuation, and signed receipt.

The customer MUST have access to complete basket terms before the basket-commit
control becomes available. Each claimed coin requires its own fresh physical
authorization cycle even when the basket has one customer approval action.

The protocol records approval plus secure gate crossing as the intended
commercial acceptance event. Applicable agreements and law determine title,
bailment, and loss allocation; this RFC does not determine them.

### 3.10 BSLRR

BSLRR MAY be omitted. When present it MUST remain optional and local by default.
It MAY authenticate that the coin accepted a sequence of root-update ceremonies;
it MUST NOT be described as proving distinct bearers, every physical handoff,
continued backing, deletion by prior participants, anonymity, or unlinkability.

## 4. Required flows

### 4.1 Load

```text
close prior epoch
  -> generate and durably install next key
  -> reveal account, public key, and activation challenge
  -> deploy or confirm immutable account
  -> fund exact represented load on a valueless test network
  -> core verifies finalized slot-bound proof
  -> atomically enter ACTIVE and update display state
```

### 4.2 Handoff and verification

```text
physical inspection
  -> optional local core attestation
  -> optional local continuity check
  -> optional current chain observation
  -> recipient-selected acceptance or immediate claim
```

### 4.3 Claim

```text
construct and display exact ClaimIntent
  -> satisfy online register preconditions when using a register
  -> deliberate three-button authorization
  -> durably enter AUTH_PENDING before output
  -> submit under bounded TransportAuthorization
  -> account atomically zeroes represented asset and retires authority
  -> core verifies finalized completion before closing epoch
```

## 5. Version 1 exclusions

Version 1 excludes:

- monetary private-key export;
- counterfactual funding;
- EIP-7702 accounts;
- arbitrary account execution;
- unsolicited-token sweeping;
- implicit account-funded gas from represented native value;
- an unbounded renewable key lifecycle;
- private refresh and production anonymous attestation;
- Architecture B commitment-pool operation;
- pooled operator rewards; and
- production security or privacy claims.

Introducing an excluded feature requires a later explicit superseding decision
and a new or revised RFC profile.

## 6. Conformance and evidence gates

No implementation may claim version 1 conformance until, at minimum, the project
publishes and independently validates:

1. canonical `ClaimIntent` and `TransportAuthorization` encodings and vectors;
2. an executable lifecycle/account model including interruption behavior;
3. reset-safe P-256 signing and long-lived key-generation profiles;
4. a selected proof system and measured passive verification/commit envelope;
5. immutable account contracts and adversarial asset/transport tests;
6. same-chain-ID split policy and fork simulations;
7. evaluated register consent, custody, accessibility, and mechanical behavior;
8. electrical, thermal, RF, materials, mechanical, and fault testing of the
   assembled coin and register;
9. privacy threat models for local transport, network observers, and retained
   records; and
10. independent cryptographic, hardware, contract, privacy, and human-factors
    review.

The current complaint and evidence state is maintained in
[Project status](../../STATUS.md). Passing one gate does not imply that another
gate, or the complete system, is safe.

The unresolved choices that block profile closure are listed in
[Open product decisions](../../OPEN_DECISIONS.md).

## 7. Security considerations

The principal unresolved hazards include live relay, key extraction through
entropy or signature failure, malicious register behavior, replay and concurrency,
transport-fee authority, permanent pending-state stranding, chain splits,
unclaimable or mutable assets, supply-chain compromise, parser attacks, and
physical safety. The [complaint log](../../COMPLAINTS.md) is part of the required
review record, not evidence that the list is complete.

## 8. Privacy considerations

Architecture A exposes a public account and transaction graph. Funding, online
checks, repeated account use, claim, RPC access, exact denominations, hardware
metadata, BSLRR roots/counts, participant inputs, and local discovery traffic may
correlate a coin, holder, or counterparty. Physical circulation hides some
intermediate handoffs from the chain but does not make the system anonymous.

Architecture B is outside this profile and has no validated privacy claim.

## 9. Change control

Every normative change MUST identify the affected D-* decision, complaint IDs,
canonical section, compatibility impact, and required validation. Silent changes
to duplicated summaries are invalid. The
[decision transcription ledger](../../TRANSCRIPTION_LEDGER.md) records integration
without implying implementation or complaint closure.

## 10. Informative reading

- [Plain-language explainer](../../EXPLAINER.md)
- [Architecture comparison](../../docs/architecture-at-a-glance.md)
- [Master architecture](../../docs/master-architecture.md)
- [Coin hardware](../../docs/coin-hardware.md)
- [Verification and BSLRR](../../docs/verification-and-bslrr.md)
- [Ethereum accounts and assets](../../docs/ethereum-accounts-and-assets.md)
- [Register and checkout](../../docs/register-and-checkout.md)
- [Privacy routes](../../docs/privacy-routes.md)
- [Feedback wanted now](../../FEEDBACK.md)
