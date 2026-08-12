# Project status

Last reviewed: 2026-08-12

> [!CAUTION]
> This repository contains an unimplemented, unvalidated protocol proposal.
> Do not use it on mainnet or with assets of value. Any prototype must use
> valueless test networks until the security, privacy, hardware, and safety gates
> below are closed with implementation evidence and independent expert review.

## Snapshot

| Dimension | Current state |
|---|---|
| Product | RFC-stage thought experiment |
| Canonical profile | [RFC-0001](./rfcs/0001-physical-bearer-cryptocurrency/README.md), draft and incomplete |
| Version 1 baseline | Architecture A: finite generate-on-advance keys and deployed immutable smart accounts for active represented loads; account reuse across key rotation is unresolved |
| Competing research | Architecture B: hardware-held shielded notes; no proof system or circuit selected |
| Normative specification | Incomplete; the logical `ClaimIntent` is canonical, but encodings and test vectors do not exist |
| Implementation | None |
| Hardware evidence | None |
| Security validation | None; automated adversarial drafting is not an independent security audit |
| Privacy validation | None; no production privacy claim is made |
| Complaint remediation | 77 Open, 18 Partially addressed, 1 Resolved/rejected for version 1 |
| Product decisions | Five explicit questions remain in [Open product decisions](./OPEN_DECISIONS.md) |

Accepted product decisions are not the same as resolved complaints. A decision
may establish direction while its specification, implementation, tests, measured
evidence, and expert review remain unfinished. See [Document authority](./DOCUMENT_AUTHORITY.md)
and the [transcription ledger](./TRANSCRIPTION_LEDGER.md).

## Critical gates

Seven complaints are currently Critical:

| Complaint | State | Gate |
|---|---|---|
| [C-001](./COMPLAINTS.md#c-001-live-relay-can-authenticate-the-wrong-physical-object) | Partially addressed | Measure relay behavior; do not claim physical co-location |
| [C-002](./COMPLAINTS.md#c-002-claim-authorization-is-not-bound-to-all-customer-visible-terms) | Partially addressed | Canonical encoding and interoperable test vectors |
| [C-003](./COMPLAINTS.md#c-003-mechanical-button-actuation-does-not-itself-prove-informed-consent) | Partially addressed | Implement and evaluate the trusted register/display boundary |
| [C-004](./COMPLAINTS.md#c-004-monetary-operations-are-not-globally-serialized) | Partially addressed | Implement, model, and test serialization and safe recovery |
| [C-020](./COMPLAINTS.md#c-020-erc-4337-transport-fees-are-insufficiently-authorized) | Open | Prevent transport fees from consuming represented value |
| [C-055](./COMPLAINTS.md#c-055-ecdsa-nonce-behavior-is-unsafe-unless-reset-resistant) | Open | Specify and test reset-safe deterministic signing |
| [C-059](./COMPLAINTS.md#c-059-long-lived-private-key-generation-lacks-an-entropy-profile) | Open | Specify entropy, health tests, environmental limits, and failure behavior |

Other launch-blocking questions include permanent `AUTH_PENDING` liveness,
same-chain-ID fork replay ([C-066](./COMPLAINTS.md#c-066-chain-id-does-not-isolate-authorizations-across-same-id-chain-splits)),
passive proof verification; electrical, RF, thermal, materials, mechanical, and
fault testing of the assembled coin and register; and economic viability.

## Accepted version 1 boundaries

- Architecture A is the baseline. Architecture B is a separate research
  candidate and requires a later, explicit superseding decision.
- The logical epoch budget is finite and irreversible. The next monetary key is
  generated only after the prior epoch closes. Physical compartmentalization is
  not established.
- Version 1 defines no command, recovery, debug, migration, or redemption path
  that exports the monetary private key. This is a target property, not evidence
  that an implementation protects key confidentiality.
- Counterfactual funding, EIP-7702 accounts, arbitrary execution, unsolicited-token
  sweeping, implicit account-funded gas, and production privacy claims are excluded.
- `ClaimIntent` is the stable claim/customer authorization. Rotation, migration,
  and evacuation authorization schemas are not yet selected. A replaceable
  `TransportAuthorization` binds a claim digest to chain/fork, EntryPoint, fee and
  gas caps, validity, paymaster, sponsor nonce, and a fee-failure policy digest.
- The accepted evidence dimensions are `coreState`, `observedChainState`, and
  `externalRiskStatus[]`; they must never be collapsed into a single validity bit.

## Privacy boundary

Architecture A is linkable at funding, online checking, account reuse, and claim.
BSLRR is optional and local by default, but its roots, counts, retained prefixes,
participant inputs, and transport metadata can correlate people or devices. It is
not identity-free, anonymous, or unlinkable, and prior copies cannot be revoked.
Architecture B aims to improve privacy but has no selected or validated proof
construction. See [Privacy routes](./docs/privacy-routes.md).

## Feedback wanted now

The most useful near-term contributions are:

1. review of the canonical `ClaimIntent` and separate `TransportAuthorization` boundary;
2. a model for `AUTH_PENDING` completion, invalidation, and permanent failure;
3. reset/fault-resistant P-256 signing and key-generation profiles for passive hardware;
4. same-chain-ID fork policy and treatment of pre-split authorizations;
5. passive proof-verification and atomic-commit feasibility evidence; and
6. privacy analysis for BSLRR transport and Architecture B's proving boundary.

See [Contributing](./CONTRIBUTING.md) for how to structure feedback.
Each item is expanded into an issue-ready brief in
[Feedback wanted now](./FEEDBACK.md).
