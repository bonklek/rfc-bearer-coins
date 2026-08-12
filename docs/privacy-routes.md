# Privacy routes

Physical circulation creates a useful privacy boundary because intermediate handoffs need not appear onchain. It does not make loading, online checks, account reuse, claim, or network access private by default.

This repository makes no production privacy claim. Architecture A is linkable by
its account and transaction graph. Architecture B's proposed private presentation
is unimplemented and unproven, and network, prover, denomination, timing, and
hardware metadata can still collapse its practical anonymity set.

## Related docs

- [Master architecture](./master-architecture.md)
- [Architecture B: hardware-held shielded notes](./architecture-b-commitment-pool.md)
- [Verification and BSLRR](./verification-and-bslrr.md)
- [Ethereum accounts and assets](./ethereum-accounts-and-assets.md)
- [Trust, manufacturing, and compromise response](./trust-and-manufacturing.md)
- [Open questions](./open-questions.md)

## Baseline leakage

A transparent first-generation coin may expose:

- funding account and transaction;
- stable smart-account address across fast rotations;
- asset and amount;
- time between funding and claim;
- treasury or merchant destination at claim;
- RPC queries made by verifier clients;
- stable hardware attestation identifiers, if the first attestation design uses them;
- BSLRR roots and counts disclosed during local verification.

Offline circulation hides intermediate physical transfers from the chain, but people and devices involved can still observe or record them.

## Fast refresh

Fast refresh rotates the key inside the same smart account.

```text
Account A: key P_i -> key P_(i+1)
```

It protects future authorization from compromise of the retired key once the onchain rotation confirms. It does not unlink the coin's account history.

The client should call this **key refresh**, not **private refresh**.

## Private refresh

Private refresh aims to move the represented asset from an old public account or note into a fresh account or note without making the old-to-new relationship obvious.

```text
old account or note
  -> privacy system
  -> fresh account or note
  -> new key epoch
```

No privacy protocol is selected.

## Minimum compatibility requirements

A compatible route should provide:

- a fresh destination controlled by the next coin key;
- no reusable monetary private key disclosed to the phone, register, relayer, or prover;
- replay protection and exact binding to asset, amount, and destination;
- a path to recover or exit if the preferred relayer disappears;
- explicit disclosure of censorship, allow-set, upgrade, and custody assumptions;
- interchangeable relayers or self-submission where the underlying protocol permits;
- defenses or honest warnings for amount and timing correlation;
- no requirement that the accepting merchant operate the privacy service.
- use of the same core `AUTH_PENDING` lane and account `semanticNonce` as claim, rotation, and public migration, with no parallel privacy-specific authorization lane.

"Unilateral exit" must be defined relative to the chosen privacy system. It cannot be promised generically if a specific pool or rollup lacks that property.

## External proof generation

Zero-knowledge proving is likely too expensive for the passive coin. A phone, PC, home verifier, register companion, or remote proving service may do the heavy computation.

The unresolved interface is how the prover obtains enough witness material without receiving reusable spending authority.

Possible patterns include:

- the coin signs a one-use commitment that the proof circuit verifies;
- the coin holds the note secret while an external prover receives blinded intermediate values;
- a privacy account validates a P-256 signature directly;
- a secure coprocessor participates in proving.

No one of these is selected. A conventional pool whose proof requires the phone to know the complete note secret may conflict with the non-exportable-key model.

## Deposit-withdrawal privacy

Moving from a public account into a pool and then to a fresh account can reduce direct linkage, but privacy depends on:

- anonymity-set size;
- equal or common denominations;
- time between deposit and withdrawal;
- relayer and network metadata;
- whether the same device identifiers appear on both sides;
- pool admission or association policy;
- unusual amounts or fee patterns.

Standard physical denominations may help amount privacy. Immediate withdrawal of a unique amount can remain readily correlatable.

## Permanently shielded backing

A competing architecture can keep backing in a private note system rather than a
transparent per-coin smart account. It is now tracked as **Architecture B**, not
merely as an optional privacy layer. The physical coin controls a hidden note in a
shared reserve contract; verification proves membership and unspent status without
revealing which commitment belongs to the coin, while claim publishes a one-time
nullifier.

See [Architecture B: hardware-held shielded notes](./architecture-b-commitment-pool.md)
for the complete candidate lifecycle and its comparison with the smart-account
baseline.

This is substantially harder than private rotation:

- the note secret and nullifier lifecycle must live within or be safely delegated by the coin;
- online verification needs current commitment and nullifier state;
- external proof generation must not clone spending authority;
- the coin inherits the privacy system's availability, upgrade, and exit assumptions.

It remains a gated research path, but it must be evaluated as a possible
replacement for the per-coin account layer rather than postponed automatically
until after that layer is fixed.

## Privacy relayers

A register operator may run an optional privacy relayer on separate infrastructure. Separation should include:

- different processes and keys;
- different network endpoints;
- no shared merchant acceptance logs;
- delayed or batched submission;
- routing a register's own accepted coins through unrelated relayers when practical;
- user-selectable relayer policy.

Operational separation reduces easy correlation but does not make two services controlled by the same entity cryptographically independent.

## Hardware attestation privacy

A unique per-core attestation public key can track the same physical object even across monetary-key rotations. The long-term target is a batch- or class-membership proof that does not reveal the exact core.

Possible mechanisms include shared batch credentials, direct anonymous attestation, group signatures, or zero-knowledge membership proofs. Each changes revocation and compromise handling. The first-generation choice remains open.

## BSLRR privacy

BSLRR is optional and local by default. Its record format is designed to omit
intentional names, account identifiers, location, and stable phone keys, but it is
not identity-free, anonymous, or unlinkable. It reveals current-epoch counts and a
continuity root; participant-controlled values, retained prefixes, and discovery
traffic can tag or correlate participants.

Applications can delete their own copy at epoch closure, but cannot force previous holders to erase retained data.

## Network privacy

An online backing check can reveal the account of interest to an RPC provider. Options include:

- user-selected RPC providers;
- queries through a privacy relay;
- local full nodes;
- downloading broader data and filtering locally;
- proof providers separated from merchant identity;
- private information retrieval in later systems.

The verifier should not claim transaction privacy merely because the physical handoff was offline.
