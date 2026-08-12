# Feedback wanted now

These six issue-ready questions are the highest-value contributions for the
current draft. Before filing, search the [complaint log](./COMPLAINTS.md) and use
the repository's GitHub issue templates when available.

## 1. Specify the ClaimIntent and TransportAuthorization boundary

**Suggested issue title:** `Specify canonical ClaimIntent and transport encodings`

Define deterministic typed encodings and shared test vectors for the canonical
logical [`ClaimIntent`](./docs/key-lifecycle.md#claim-semantics) and the separate
replaceable `TransportAuthorization`. Show which terms remain stable across
resubmission and which fee, sponsor, relay, fork, and validity fields may change.

**Useful deliverable:** schema, domain separation, canonicalization rules,
positive vectors, rejection vectors, and digest-equivalence tests for two
independent implementations.

**Related findings:** C-002, C-020, C-039, C-061, C-064, C-065, C-066.

## 2. Model AUTH_PENDING completion and permanent failure

**Suggested issue title:** `Model AUTH_PENDING liveness and safe invalidation`

Determine whether every committed authorization can complete or reach a bounded
safe terminal state without permitting a conflicting destination. Cover expiry,
censorship, fee changes, reorganization, account or token freezes, lost transport
state, and replacement races.

**Useful deliverable:** executable state model, stated invariants, counterexample
traces, and a proposed onchain completion/invalidation protocol—or a proof that
version 1 must disclose permanent stranding.

**Related findings:** C-004, C-049, C-061, C-065.

## 3. Define reset-safe P-256 signing and key generation

**Suggested issue title:** `Define passive-hardware P-256 entropy and reset profile`

Specify deterministic or equivalently analyzed ECDSA nonce generation, long-lived
key entropy, conditioning, startup and continuous health tests, persistent state,
failure behavior, and environmental limits under arbitrary NFC power removal and
fault injection.

**Useful deliverable:** normative profile, device requirements, fault campaign,
duplicate-`r` tests, key-correlation analysis, and fail-closed evidence.

**Related findings:** C-055, C-059, C-060.

## 4. Decide the same-chain-ID split policy

**Suggested issue title:** `Define authorization behavior across same-chain-ID splits`

State what happens to active coins and pre-split pending authorizations when two
descendant ledgers retain the same chain ID, account address, nonce, and prior
state. Chain ID alone does not isolate replay.

**Useful deliverable:** product policy, stable fork-domain analysis, freeze and
requalification behavior, user warnings, and fork simulation covering pre-split
authorizations.

**Related finding:** C-066.

## 5. Measure passive proof verification and atomic activation

**Suggested issue title:** `Prototype proof-activated loading under passive power`

Test whether a passive core can receive, verify, and crash-consistently commit a
finality-rooted funding proof within declared energy, memory, latency, storage,
and thermal limits.

**Useful deliverable:** proof profile, public inputs, hardware/BOM, measurement
fixtures, traces for arbitrary field removal, and evidence that every interruption
leaves exactly `AWAITING_LOAD_PROOF` or fully committed `ACTIVE`.

**Related findings:** C-005, C-006, C-011, C-018.

## 6. Analyze BSLRR transport and Architecture B privacy

**Suggested issue title:** `Threat-model continuity transport and private proving boundaries`

For BSLRR, cover participant tagging, discovery identifiers, peer binding,
retained prefixes, and deletion limits. For Architecture B, identify what the
core, holder device, verifier, remote prover, chain observer, and setup or opening
authority can correlate.

**Useful deliverable:** adversary matrix, data-flow diagram, transcript-bound
transport proposal, anonymity-set assumptions, retention horizons, and testable
privacy claims with explicit non-claims.

**Related findings:** C-034, C-035, C-062, C-070, C-077, C-092, C-093, C-094,
C-096.

## Filing checklist

Include the affected files and C-/D- identifiers, concrete failure mechanism,
preconditions, expected impact, smallest proposed correction, and a validation
method. Do not include credentials, personal data, private infrastructure, or
details of a live-value deployment; follow the [security policy](./SECURITY.md).
