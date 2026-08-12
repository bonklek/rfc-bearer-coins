# Document authority and supersession

The repository began without commit history, so file timestamps cannot establish
reliable chronological supersession. Explicit status controls.

## Authority order

When two passages conflict, apply this order:

1. An accepted later D-* decision that explicitly states it supersedes a version
   1 RFC boundary, until its transcription is integrated.
2. [RFC-0001](./rfcs/0001-physical-bearer-cryptocurrency/README.md), the canonical
   integrated version 1 draft profile.
3. Accepted D-* decisions in the [decision log](./PROPOSED_SOLUTIONS.md#decision-log)
   and the [recommended version 1 profile](./PROPOSED_SOLUTIONS.md#recommended-version-1-profile)
   as decision rationale and gap interpretation.
4. Sections explicitly incorporated by RFC-0001, especially the logical
   [`ClaimIntent`](./docs/key-lifecycle.md#claim-semantics).
5. Integrated domain documents in `docs/`.
6. README, request-for-comments summaries, and open-question lists.
7. The append-only complaint log and research logs as rationale and evidence,
   not current specification.

RFC-0001 identifies the selected version 1 profile. Conformance remains
unavailable until its required encodings, implementations, tests, and evidence
exist.

An accepted decision does not resolve its complaint. Complaint state changes only
when the required specification, implementation, test, evidence, policy, or
explicit accepted-risk record exists.

## Resolved transcription conflicts

- **Finite versus renewable:** version 1 uses a finite, irreversibly bounded,
  generate-on-advance logical epoch budget. Physical-cell isolation remains an
  unproven future hardware profile; an unbounded renewable lifecycle is later work.
- **Private-key export:** version 1 has no export path of any kind. Earlier questions
  asking whether export should be excluded are superseded.
- **Architecture A versus B:** A is the version 1 baseline. B is a research
  candidate, not a second selected version 1 architecture.
- **Status names:** the accepted dimensions are `coreState`,
  `observedChainState`, and `externalRiskStatus[]`.
- **Core lifecycle:** `EMPTY`, `AWAITING_LOAD_PROOF`, `ACTIVE`, `AUTH_PENDING`,
  `TAMPER_SUSPECTED`, `TAMPER_RETIRED`, and `EXHAUSTED`. `RETIRED` describes a
  slot/key transition, not the whole-core state. `POSSIBLE_EXPOSURE` is obsolete.
- **Claim schema:** `docs/key-lifecycle.md` owns the one canonical logical
  `ClaimIntent`. Other documents may summarize or link to it but must not create
  independent field lists.
- **Transport:** transport authorization is distinct from the inner intent and
  may be replaced within its bounds without changing the stable monetary identity.
- **BSLRR privacy:** local-by-default does not mean anonymous, unlinkable, or
  erasable from prior holders.

Proposed changes to an accepted boundary should identify the decision being
superseded and introduce a new versioned decision rather than silently editing a
summary.
