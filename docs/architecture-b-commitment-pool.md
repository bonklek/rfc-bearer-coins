# Architecture B: hardware-held shielded notes

Architecture B is a first-class research candidate, not part of version 1. The
version 1 baseline is Architecture A's per-coin Ethereum smart accounts. This
candidate represents each funded physical
coin as a hidden, one-use note in a shared onchain commitment pool.

This is an architecture candidate, not an accepted production design. Its purpose
is to test whether a commitment/nullifier system can improve privacy while also
removing enough per-account machinery to justify its proof-system and shared-pool
costs.

## Related docs

- [Master architecture](./master-architecture.md)
- [Coin hardware](./coin-hardware.md)
- [Key lifecycle and claim protocol](./key-lifecycle.md)
- [Verification and BSLRR](./verification-and-bslrr.md)
- [Ethereum accounts and assets](./ethereum-accounts-and-assets.md)
- [Privacy routes](./privacy-routes.md)
- [Open questions](./open-questions.md)

## Architectural choice

The two candidates differ primarily in how backing is represented onchain.

```text
Architecture A
physical coin -> non-exportable key -> identifiable smart account -> asset

Architecture B
physical coin -> non-exportable authority -> hidden note commitment
                                      -> shared reserve contract -> asset
```

Architecture A keeps each coin's backing in a separately identifiable account.
Architecture B pools backing and records commitments to notes. Physical possession
transfers control of a note without an onchain transfer for every handoff.

## Core construction

A deposit creates a commitment `C` to a note. The exact construction is not yet
selected, but it must bind at least:

```text
note domain
chain and pool identity
exact AssetID and denomination
coin-controlled authorization material
fresh note randomness
note and circuit version
```

The pool appends `C` to a canonical Merkle tree and holds the corresponding asset.
The physical coin retains the non-exportable authority and any private note
material required by the selected circuit.

Each note has exactly one valid nullifier `N`. Claim publishes `N`; the pool
rejects a nullifier that has already been used. A zero-knowledge proof relates the
public nullifier to one hidden committed note without revealing which commitment
was consumed.

The basic invariant is:

```text
accepted commitment root
AND hidden membership of one correctly denominated note
AND correct coin authorization
AND unused nullifier
AND exact destination-bound claim terms
    -> one successful claim
```

The commitment, nullifier, hash, Merkle-tree, signature, and proof constructions
are a single versioned cryptographic profile. Domain separation, canonical
encoding, public-input ordering, circuit identifiers, verifying keys, chain and
contract identities, expiry, and fee bounds must all be bound explicitly.

## Loading

A candidate load flow is:

```text
coin closes the previous monetary epoch
  -> core generates fresh authorization material and note randomness
  -> loader selects an exact supported AssetID and denomination
  -> deposit transaction funds the shared pool and appends commitment C
  -> untrusted prover constructs finalized inclusion and funding evidence
  -> core verifies evidence bound to its fresh activation challenge
  -> core atomically commits ACTIVE and the authenticated display state
```

The loader and prover receive no authority to create another destination-bound
claim. The exact witness interface remains open: note material may not be exported
merely because an external machine performs proving.

Architecture B naturally favors fixed or common denominations. Unique amounts,
isolated pools, unusual deposit timing, and prompt claim can collapse the practical
anonymity set even when the proof is cryptographically zero knowledge.

## Private verification presentation

A future verifier should learn predicates, not the coin's raw identity and note
data. A composite presentation, if implemented and validated, could prove:

- a fresh core response is bound to the verifier challenge and presentation
  context;
- the responding core is a member of an accepted manufacturing class or batch;
- the core controls the authorization material in one hidden note;
- the note is included in an accepted commitment root;
- its exact asset and denomination match the disclosed display state;
- its nullifier is absent from an authenticated spent set at the selected finalized
  chain state;
- the core reports `ACTIVE` and no monetary authorization is pending; and
- optional private continuity state satisfies disclosed acceptance predicates.

Public inputs may include the verifier challenge, proof profile, accepted policy
and manufacturing roots, finalized chain reference, pool identity, AssetID,
denomination, and narrowly selected predicate results. The commitment, account or
key binding, batch leaf, exact attestation identity, nullifier, Merkle paths, local
state details, and continuity values should remain private unless disclosure is
required by the selected profile.

If the construction and its deployment boundary validate, this presentation may
combine anonymous hardware attestation and backing
verification into one statement. It does not prove that the responding core is
physically inside the shell; a live presentation can still be relayed.

## Proving boundary

Zero knowledge hides the witness from the proof verifier, not from the machine
that runs the prover. The proving arrangement therefore changes the privacy claim:

- **Holder-controlled local proving:** a holder phone, PC, or home pad may receive
  non-secret witness material and fresh core signatures. This can hide the note
  from the recipient while keeping reusable signing authority in the core.
- **Verifier-controlled proving:** if the recipient or merchant receives the raw
  witness and constructs the proof, the proof does not hide those inputs from that
  verifier.
- **Remote proving:** a server may learn the coin-to-commitment relationship even
  if it cannot redirect a claim. A production profile needs confidential,
  distributed, or blinded delegation, or must disclose this linkage.
- **Core-native proving:** this gives the cleanest boundary but may exceed passive
  power, memory, latency, and cost limits.

One candidate interface commits a note to a P-256 public key and fresh randomness.
The core signs the complete fresh verification or claim statement; an external
prover privately checks the signature, commitment opening, and Merkle witnesses.
The signature is bound to the verifier challenge or complete claim terms, so
possession of it is not reusable spending authority. Whether disclosure of the
commitment opening and deterministic nullifier material is acceptable depends on
who runs the prover.

## Claim and retirement

A claim proof must bind:

- pool, chain, AssetID, denomination, note and circuit versions;
- the public nullifier;
- the exact destination and complete monetary intent;
- any relayer, fee, expiry, basket, refund, or settlement bounds that can affect
  value or execution; and
- a fresh semantic state accepted by the core before authorization leaves it.

The pool verifies the proof, rejects an already-used nullifier, records the
nullifier, and transfers the exact denomination in one reverting transaction.
The coin retains the complete authorized record across interruption. It retires
the local note only after verifying finalized evidence that the nullifier was
accepted and the claim completed.

The nullifier supplies onchain one-use enforcement but does not by itself replace
the core's `AUTH_PENDING` rule. Without commit-before-output, a faulted or cloned
core might authorize two different claim proofs; only one could settle, but two
recipients could temporarily receive conflicting physical or offchain evidence.

## What Architecture B may replace

If validated, the pool can eliminate or reduce:

- public per-coin account addresses and direct balance queries;
- persistent-account key-rotation history;
- fresh-account migration solely for unlinking;
- per-account implementation and storage-proof diversity;
- residual same-asset balances, if the pool accepts only exact denominations; and
- a separate deposit-withdrawal privacy step for every refresh.

It does not automatically eliminate asset-contract dependencies, safe transfer
handling, gas sponsorship, relayers, finality verification, interrupted-operation
recovery, manufacturing trust, or secure-core lifecycle enforcement.

## What Architecture B does not solve

- **Physical cloning:** duplicated authority can support conflicting physical
  presentations until one nullifier is accepted. The pool prevents two successful
  claims, not two counterfeit objects from circulating beforehand.
- **Co-location:** a fresh proof can still be relayed from a genuine remote core.
- **Staleness:** unspent status is only as current as the authenticated root used by
  the proof.
- **Traffic analysis:** deposits, claims, relayers, network paths, denominations,
  and timing may correlate a note even when the circuit does not.
- **Prover privacy:** a prover that receives raw private inputs learns them unless a
  separate delegation protocol prevents it.
- **Revocation:** precise individual hardware revocation can conflict with
  anonymous presentation and backward unlinkability.
- **Circuit risk:** a soundness bug, compromised setup, unsafe upgrade, or incorrect
  public-input binding can affect an entire pool.
- **Shared-state availability:** users inherit the pool contract's censorship,
  upgrade, emergency, liveness, and exit assumptions.

## Nullifier policy outside claim

Routine private verification should not expose a stable nullifier. A
verifier-chosen nullifier domain or basename can become a tracking oracle.

Rate-limited actions may use a separately domain-separated nullifier only when the
linkability is intentional and disclosed, for example one issuance per inventory
leaf, one operator reward per epoch, or one merchant acquisition attempt per
defined settlement context. Offline handoff remains possible without consulting a
global nullifier registry.

## Evaluation gate

Architecture B should advance beyond research only after a prototype demonstrates:

1. a complete fixed-denomination deposit, private presentation, claim, retry, and
   exit lifecycle on a valueless test network;
2. destination-bound P-256 authorization without exporting reusable authority;
3. measured proving time and memory on holder-controlled commodity devices;
4. measured proof verification under the passive core's powered-reader profile;
5. an authenticated finalized-root and nullifier-set update path;
6. explicit anonymity-set and traffic-correlation analysis;
7. circuit and contract test vectors, independent review, and upgrade containment;
8. a recovery path that does not depend on one relayer, prover, operator, or user
   interface; and
9. a side-by-side security, cost, and complexity comparison with Architecture A.

Until those gates close and an explicit later version decision supersedes the
baseline, Architecture A remains the reference prototype and Architecture B
remains a research candidate rather than a claimed upgrade.
