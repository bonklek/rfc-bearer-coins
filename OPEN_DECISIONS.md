# Open product decisions

These questions cannot be settled by editorial cleanup or implementation detail.
Until each has an explicit decision, the affected behavior is outside a
conformance claim.

| ID | Question | Current constraint | Decision required |
|---|---|---|---|
| OD-001 | What authorizes rotation, migration, and evacuation? | The canonical `ClaimIntent` has `operation = CLAIM`. All monetary operations share one nonce and `AUTH_PENDING` lane, but the non-claim schemas are not selected. | Choose separate typed intents or a shared `MonetaryIntent` envelope with operation-specific bodies. Define domains and vectors. |
| OD-002 | Can one account span multiple key epochs? | Depletion normally leads to a fresh account, while balance-preserving rotation is described as reusing the account with a new key. | Define the relationship among account, represented load, monetary slot, and key epoch—or remove balance-preserving rotation from version 1. |
| OD-003 | Who selects the residual beneficiary? | Loading fixes the address, and claim sends it same-asset surplus. The authorized selector and represented interest are unspecified. | Name the selector, consent record, disclosure, change rule, and behavior if the beneficiary becomes unable to receive the asset. |
| OD-004 | What legal effect follows register gate crossing? | The protocol can record an intended commercial acceptance event; it cannot determine title, bailment, or loss allocation by itself. | Define the reference agreements and jurisdictional assumptions, or keep all legal effects explicitly outside the protocol. |
| OD-005 | Which `AUTH_PENDING` outcomes are acceptable? | Exact retry exists, but general cancellation and completion are unresolved. | Decide whether permanent stranding is acceptable and select cancellation, forced completion, recovery destination, or another terminal policy. |

An accepted decision should receive a D-* identifier, identify the RFC clauses it
supersedes, update the [transcription ledger](./TRANSCRIPTION_LEDGER.md), and leave
the original complaint history intact.
