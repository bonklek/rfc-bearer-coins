# Physical Bearer Cryptocurrency

> [!CAUTION]
> **Unimplemented research RFC — valueless test networks only.** No implementation
> or independent security validation exists. Do not use this design on mainnet or
> with assets of value.

Physical Bearer Cryptocurrency is an RFC-stage thought experiment for a
batteryless, refillable physical token that carries one supported digital asset
at a time. It aims to circulate hand to hand without recording every transfer
onchain. Recipients can choose physical inspection, core authentication, chain
observation, or claim; those actions answer different questions.

The version 1 baseline, **Architecture A**, uses a finite generate-on-advance
hardware-key lifecycle and deployed immutable Ethereum smart accounts.
**Architecture B**—hardware-held shielded notes in a shared commitment/nullifier
pool—is a separate research candidate, not a selected or validated version 1
design.

This repository contains architecture prose, decisions, complaints, and research.
It contains no implementation, hardware prototype, normative wire encoding,
interoperability test vectors, or measured security evidence. It is not a
security, privacy, legal, regulatory, or investment assurance.

## Start here

- **New to the idea?** Read the one-page
  [plain-language explainer](./EXPLAINER.md).
- **Evaluating maturity or risk?** Read [Project status](./STATUS.md).
- **Reviewing the selected protocol target?** Read
  [RFC-0001](./rfcs/0001-physical-bearer-cryptocurrency/README.md).
- **Looking for a term?** Use the [glossary](./GLOSSARY.md).
- **Checking what remains undecided?** Read [Open product decisions](./OPEN_DECISIONS.md).
- **Ready to contribute?** Choose an issue-ready question from
  [Feedback wanted now](./FEEDBACK.md).

## Current state

- 96 recorded complaints: 77 Open, 18 Partially addressed, and one
  Resolved/rejected for version 1.
- Seven Critical complaints remain open or partial, including transport-fee
  authority, reset-safe ECDSA, and long-lived key entropy.
- Automated review produced the complaint log; it was not an independent security
  audit and did not resolve the complaints.
- Architecture A is the first prototype target. Architecture B has no selected
  proof system, circuit, or validated privacy boundary.

Read the complete [project status and critical gates](./STATUS.md) before the RFC.

## Version 1 components

The proposal combines:

- a passive NFC-powered coin with a persistent display;
- a monetary key that version 1 never exports by any command or exceptional mode;
- a physical distinction between verification and monetary authorization;
- a finite, irreversible generate-on-advance epoch budget;
- an immutable smart account with exact represented-value and claim invariants;
- open verifier clients and advisory hardware/asset trust feeds; and
- optional merchant settlement and local continuity records.

These are target requirements, not established properties. “Non-exportable” does
not establish key confidentiality until entropy,
reset-resistant signing, fault behavior, and physical attack boundaries are
specified, implemented, and independently tested.

## Privacy limits

Physical circulation can hide intermediate handoffs from the chain, but
Architecture A remains linkable at loading, online checks, account reuse, and
claim. Optional BSLRR records can correlate an epoch through roots, counts,
retained prefixes, participant inputs, and transport metadata; they are not
anonymous or unlinkable. Architecture B aims to improve privacy but has no
selected or validated construction. The project makes no production privacy
claim.

## Reading paths

### Five-minute orientation

1. [Plain-language explainer](./EXPLAINER.md)
2. [Architecture at a glance](./docs/architecture-at-a-glance.md)
3. [Project status](./STATUS.md)
4. [Request for comments](./REQUEST_FOR_COMMENTS.md)

### Current version 1 design

- [RFC-0001: canonical version 1 draft profile](./rfcs/0001-physical-bearer-cryptocurrency/README.md)
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
- [Open product decisions](./OPEN_DECISIONS.md)
- [Complaints log](./COMPLAINTS.md)
- [Complaint triage (C-012–C-096)](./ISSUE_TRIAGE.md)
- [Proposed solutions and accepted decisions](./PROPOSED_SOLUTIONS.md)
- [Research methodology](./AUDIT_METHODOLOGY.md)

## Feedback

The current priority questions are listed in
[Feedback wanted now](./FEEDBACK.md). See
[Contributing](./CONTRIBUTING.md) for report structure and
[Security policy](./SECURITY.md) for sensitive issues.

The GitHub description, topics, settings, and soft-launch sequence are in
the [publication guide](./PUBLICATION.md).

## License and provenance

The project is released under the [Viral Public License](./LICENSE). The VPL is
not a standard SPDX identifier, so hosting platforms may not classify it
automatically. External sources remain the property of their respective owners;
citations do not relicense third-party works. Contributors must have the right to
license submitted material under the VPL.
