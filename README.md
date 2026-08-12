# Physical Bearer Cryptocurrency

> [!CAUTION]
> No implementation or security validation exists. Do not use this design on
> mainnet or with assets of value. Any prototype must use valueless test networks
> until the documented security, privacy, hardware, and safety gates close.

Physical Bearer Cryptocurrency is an RFC-stage thought experiment for a
batteryless, refillable physical token that carries one supported digital asset
at a time. It aims to circulate hand to hand without recording every transfer
onchain, while allowing progressively stronger checks or an eventual claim.

The version 1 baseline, **Architecture A**, uses a finite generate-on-advance
hardware-key lifecycle and one deployed immutable Ethereum smart account per
active epoch. **Architecture B**—hardware-held shielded notes in a shared
commitment/nullifier pool—is a first-class research candidate, not a selected or
validated version 1 design.

This repository contains architecture prose, decisions, complaints, and research.
It contains no implementation, hardware prototype, schemas, test vectors, or
measured security evidence. It is not a security, privacy, legal, regulatory, or
investment assurance.

## Current state

- 96 recorded complaints: 77 Open, 18 Partially addressed, and one
  Resolved/rejected for version 1.
- Seven Critical complaints remain open or partial, including transport-fee
  authority, reset-safe ECDSA, and long-lived key entropy.
- Automated adversarial drafting reached its bounded discovery stopping rule; it
  was not an independent security audit and did not resolve the complaints.
- Architecture A is the first prototype target. Architecture B has no selected
  proof system, circuit, or validated privacy boundary.

Read the complete [project status and critical gates](./STATUS.md) before the RFC.

## Main design bet

The proposal combines:

- a passive NFC-powered coin with a persistent display;
- a monetary key that version 1 never exports by any command or exceptional mode;
- a physical distinction between verification and monetary authorization;
- a finite, irreversible generate-on-advance epoch budget;
- an immutable smart account with exact represented-value and claim invariants;
- open verifier clients and advisory hardware/asset trust feeds; and
- optional merchant settlement and local continuity records.

These are target requirements, not established properties. In particular,
“non-exportable” does not establish key confidentiality until entropy,
reset-resistant signing, fault behavior, and physical attack boundaries are
specified, implemented, and independently tested.

## Privacy in one paragraph

Physical circulation can hide intermediate handoffs from the chain, but
Architecture A remains linkable at loading, online checks, account reuse, and
claim. Optional BSLRR records can correlate an epoch through roots, counts,
retained prefixes, participant inputs, and transport metadata; they are not
anonymous or unlinkable. Architecture B aims to improve privacy but has no
selected or validated construction. The project makes no production privacy
claim.

## Reading paths

### Five-minute orientation

1. [Project status](./STATUS.md)
2. [Request for comments](./REQUEST_FOR_COMMENTS.md)
3. [Master architecture](./docs/master-architecture.md)

### Current version 1 design

- [Document authority and supersession](./DOCUMENT_AUTHORITY.md)
- [Decision transcription ledger](./TRANSCRIPTION_LEDGER.md)
- [Coin hardware](./docs/coin-hardware.md)
- [Key lifecycle and canonical claim intent](./docs/key-lifecycle.md)
- [Ethereum accounts and represented assets](./docs/ethereum-accounts-and-assets.md)
- [Verification and BSLRR](./docs/verification-and-bslrr.md)
- [Register and checkout](./docs/register-and-checkout.md)

### Competing research and unresolved work

- [Architecture B: hardware-held shielded notes](./docs/architecture-b-commitment-pool.md)
- [Privacy routes](./docs/privacy-routes.md)
- [Open questions](./docs/open-questions.md)
- [Complaints log](./COMPLAINTS.md)
- [Complaint triage (C-012–C-096)](./ISSUE_TRIAGE.md)
- [Proposed solutions and accepted decisions](./PROPOSED_SOLUTIONS.md)
- [Research methodology](./AUDIT_METHODOLOGY.md)

## Feedback

The current priority questions are listed in
[Feedback wanted now](./STATUS.md#feedback-wanted-now). See
[Contributing](./CONTRIBUTING.md) for report structure and
[Security policy](./SECURITY.md) for sensitive issues.

## License and provenance

The project is released under the [Viral Public License](./LICENSE). The VPL is
not a standard SPDX identifier, so hosting platforms may not classify it
automatically. External sources remain the property of their respective owners;
citations do not relicense third-party works. Contributors must have the right to
license submitted material under the VPL.
