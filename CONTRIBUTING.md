# Contributing

This is an early specification and research project, not an implementation.
Contributions that make assumptions, failure modes, and evidence requirements
more precise are welcome.

## Before commenting

1. Read [Project status](./STATUS.md) and [Document authority](./DOCUMENT_AUTHORITY.md).
2. Search the [complaint log](./COMPLAINTS.md) for the underlying failure mode.
3. Check the [open questions](./docs/open-questions.md) and
   [transcription ledger](./TRANSCRIPTION_LEDGER.md).
4. Review the six [issue-ready feedback briefs](./FEEDBACK.md).

## Contribution types

- **New objection:** identify the direct failure mechanism, affected boundary,
  preconditions, impact, and why it is not already covered by a C-* complaint.
- **Evidence:** cite a primary specification, implementation, measurement, or
  peer-reviewed source and state exactly which claim it supports or contradicts.
- **Decision proposal:** name the D-* decision or version 1 boundary that would
  change, the trade-off, and the required superseding decision.
- **Editorial correction:** identify a stale transcription, broken link, unclear
  status, or wording that exceeds available evidence.
- **Implementation proposal:** use only valueless test networks and state which
  gates it does and does not address.

Use GitHub Issues or Discussions when enabled. A useful report includes a short
title, affected files/sections, reproduction or scenario, existing related C-/D-
IDs, evidence, smallest correction, and a proposed validation method. Pull
requests should not mark a complaint resolved merely because prose changed.
The repository includes structured templates for design findings, evidence, and
editorial corrections.

## Sensitive reports

Do not post credentials, private keys, personal data, private URLs, or details of
a live-value deployment. Follow [Security policy](./SECURITY.md).

## License

By contributing, you agree that your contribution is available under the
[Viral Public License](./LICENSE) and that you have the right to submit it.
Third-party quotations, figures, tables, or code must be clearly identified and
compatible with redistribution under that license.
