# Verification and BSLRR

These checks are complementary, not a single confidence score. Each result must
identify its source, freshness, and the question it answers. A recipient chooses
which checks to use for the denomination, counterparty, connectivity, and risk.

## Related docs

- [Master architecture](./master-architecture.md)
- [Architecture B: hardware-held shielded notes](./architecture-b-commitment-pool.md)
- [Coin hardware](./coin-hardware.md)
- [Key lifecycle and claim protocol](./key-lifecycle.md)
- [Trust, manufacturing, and compromise response](./trust-and-manufacturing.md)
- [Register and checkout](./register-and-checkout.md)

## Available checks

| Check | What it can establish |
|---|---|
| Physical inspection | Appearance, display, obvious damage, and possession only. |
| Fresh local attestation | A core accepted under the verifier's selected hardware policy signed the response and reported local state. This does not establish physical co-location with the shell. |
| Proof-activated offline state | The core reports that the slot entered `ACTIVE` after verifying its configured funding-proof profile and that it has emitted no later monetary authorization. This is historical core evidence, not a current chain query. |
| BSLRR continuity | The coin authenticated a sequence of local root-update ceremonies for the current key epoch. It does not identify the participants or prove that every handoff was recorded. |
| Live RPC query | A named provider reported account, asset, balance, key, and nonce state at a named block. |
| Redundant queries | Several selected providers returned the same observation. Agreement reduces provider error but is not consensus verification. |
| Proof-checked state | The client verified relevant state proofs against authenticated headers under a specified profile. |
| Light-client check | The client verified headers through a stated light-client design and checked state evidence. |
| Full-node check | The verifier used its own execution and consensus clients. |
| Claim | The coin authorized a typed `ClaimIntent`. A successful finalized execution transfers value; authorization alone does not. |

The client should report the checks performed and their sources. "Online verified"
is too vague if it hides reliance on one RPC endpoint.

## Attributed status result

A verifier never emits one protocol-level `valid` bit. Its result keeps three
authorities separate:

```text
coreState
  value, epoch, signed response, core credential

observedChainState
  value, chain, block hash and height, source, observation time, finality

externalRiskStatus[]
  value, publisher, policy version, issue time, freshness deadline
```

`coreState` is what the responding core signed. `observedChainState` is what the
identified RPC, proof verifier, light client, or full node established at a
particular block. Each `externalRiskStatus` is an opinion from one subscribed
publisher under one policy. It cannot alter either of the other fields.

A concise result may read:

```text
Coin state:       ACTIVE
Backing:          Not checked
Hardware notice:  Caution from Lab A
```

The detail view identifies Lab A, its signed notice, and freshness. Absence of a
warning means only that the selected fresh subscriptions supplied none.

No check guarantees that the physical object cannot be counterfeit. Online chain
evidence can establish an account balance at a named block, but it does not place
the responding core inside the shell. A successful claim transfers backing to the
recipient's destination; authorization or submission alone does not.

Ethereum's own documentation currently says known combined light-client implementations are not considered production-ready. The first register should therefore treat embedded light verification as experimental and preserve provider and full-node options.[^lightclients]

## Local verification response

Pressing both side buttons against a reader produces a fresh challenge-response over fields such as:

```text
protocol_version
hardware_profile
firmware_profile
attestation_credential_or_membership_proof
key_epoch
monetary_public_key_or_account_binding
represented_asset_id
represented_amount
residual_beneficiary
local_key_state
load_proof_profile
load_proof_digest
load_finalized_chain_reference
event_counter_summary
bslrr_root
reader_nonce
```

The verifier must label self-reported fields as hardware claims.
`Proof-activated offline` means the core reports that it verified funding evidence
under its configured profile when the slot activated and has emitted no later
monetary authorization. It does not mean the verifier performed a current chain
check. `Backing observed now` is reserved for a check that obtains current chain
state and reports its source and block.

Architecture B may, in a later profile, replace disclosure of the raw response
fields with a composite private presentation. If validated, that proof could bind
the fresh reader nonce, accepted
manufacturing and chain roots, hardware membership, hidden note membership,
denomination, unspent status, and selected lifecycle predicates without revealing
the exact core, commitment, nullifier, BSLRR root, or counters. The client must
still disclose the proof's chain reference, freshness, proving arrangement, and
co-location limitation. If the verifier itself receives the private inputs to
construct the proof, those inputs are not private from that verifier.

An online balance check compares the represented-asset balance with the fixed
`represented_amount`:

```text
equal       exact represented backing observed
greater     represented backing plus same-asset surplus; claim zeroes both outputs
less        deficit; standard claim cannot complete
```

The client does not add surplus to the displayed bearer amount. It shows the
load-bound residual beneficiary in technical details because claim routes surplus
there. Unrelated token contracts do not change the represented-value result.

## Offline activation status

The monetary status vocabulary is:

```text
EMPTY                  no represented active load
AWAITING_LOAD_PROOF    next account revealed; active value must not be displayed
ACTIVE                 slot-bound finalized funding proof verified and committed
AUTH_PENDING           one exact monetary authorization committed; warning state
TAMPER_SUSPECTED       irreversible core evidence; one evacuation authorization only
TAMPER_RETIRED         core cannot reload or generate another monetary epoch
EXHAUSTED              no unused certified slots
```

An offline verifier can authenticate `ACTIVE`, the proof profile and digest, the finalized chain reference accepted at activation, and the absence of a later monetary authorization in core state. It need not trust the phone or loader that constructed the proof. It still relies on the proof system, the core implementation, Ethereum finality assumptions, and resistance to physical compromise.

`TAMPER_SUSPECTED` is core-signed lifecycle evidence, not an external feed
opinion. The verifier presents it prominently, identifies that evacuation may
still be possible, and never relabels it `ACTIVE`. A policy may decline the coin,
but physical possession and the exact evacuation path remain permissionless.

## Live relay and physical co-location

The verifier challenge must contain at least 128 unpredictable bits generated
inside the trusted verifier boundary. Exactly one outstanding challenge is
retained and consumed; restart or rollback must not make it reusable, and the
verifier fails closed if secure randomness is unavailable. This stops reuse of an
old recorded attestation. It does not stop an attacker from forwarding the live
challenge to a genuine coin and returning the genuine response.

Version 1 therefore uses the following normative language:

- `core authenticated` means an approved responding core produced the fresh evidence;
- `backing observed` means the stated chain source reported or proved the selected account state;
- neither statement means `core proven inside this shell`;
- `claim submitted` and `claim confirmed` describe the separate transfer of backing.

Clients must show the co-location limitation in the technical detail for local attestation. A concise primary display may use `Core authenticated`, but must not use `Genuine physical coin`, `Unclonable`, or equivalent language.

Recipients remain free to accept the coin offline. A policy may recommend online observation or immediate claim for higher amounts, endangered hardware, or unknown counterparties, but the protocol does not enforce that recommendation.

Future hardware profiles may add distance-bounding or another measured relay-resistance mechanism. Such a profile must publish its attacker model, timing resolution, false-accept rate, false-reject rate, maximum demonstrated relay distance, passive-power requirements, and complete assembled-device test results before making a co-location claim.

## Event counters

A coin may count deliberate verification and handoff events in rollback-resistant nonvolatile state. The usefulness is limited:

- one person can inflate counts;
- physical transfers can occur without a recorded event;
- repeated verification can consume memory endurance or be used for denial of service;
- a counter says nothing about current backing;
- an invasive attacker may target the counter separately from the monetary key.

A hardware monotonic counter normally does not reset. Per-epoch counts should be represented as a global monotonic value plus an epoch baseline:

```text
epoch_verifications = global_verification_counter - epoch_start_counter
```

An implementation may instead use high-endurance transactional storage if its rollback and wear properties are demonstrated.

Routine challenge-response need not increment a counter. The standard should allow:

- stateless verification;
- counted verification;
- counted explicit handoff only.

Which mode is useful enough for the first hardware generation remains open.

## BSLRR

BSLRR means **Bearer-Since-Last-Rotation Record**. It is an optional local continuity mechanism for people who want an app-mediated handoff.

It is not a bearer registry and does not prove a number of distinct owners.

### Coin-held state

The coin stores a compact current value:

```text
epoch
handoff_count
event_count_or_baseline
latest_root
```

### Phone-carried record

The optional record may contain a hash chain of handoff events:

```text
h_i = H(
  domain,
  epoch,
  i,
  h_(i-1),
  sender_ephemeral_nonce,
  receiver_ephemeral_nonce
)
```

The coin signs or authenticates the updated root after deliberate side-button
activation. The receiver compares the phone-carried chain with the fresh coin-held
root. This authenticates only the coin's root update; it does not authenticate
the sending or receiving phone or prove that the same nearby peer participated in
both discovery and bulk transfer.

Phone-to-phone transport can use an offline local channel. NFC can bootstrap proximity and exchange ephemeral data; Bluetooth or peer-to-peer Wi-Fi can carry a larger record. Cross-platform feasibility requires a prototype.

### What BSLRR establishes

- The presented record is consistent with the coin's current root.
- The coin authenticated the recorded number of root-update ceremonies during
  the current epoch. This does not establish who exchanged the associated record
  or whether the same nearby peer completed both transport phases.
- Truncating the presented record without changing the root is detectable.

### What BSLRR does not establish

- Distinct people participated.
- Every physical handoff was recorded.
- Nobody accessed or attacked the coin between handoffs.
- An earlier participant deleted a retained copy.
- The backing remained present.
- The coin was never verified through another unrecorded interface.

A holder may decline BSLRR. Another holder may make BSLRR continuity a personal acceptance condition. The protocol does not require it.

## Epoch closure

Rotation or successful claim closes the current BSLRR epoch. The coin starts a new root and baseline for the next key epoch.

Phone clients should delete their active local record when asked, but the protocol cannot force prior participants to erase copies. "Deleted on redemption" can describe application behavior, not a guaranteed privacy property.

## Privacy

BSLRR should omit:

- names or account identifiers;
- location;
- stable phone identifiers;
- wall-clock time unless explicitly requested;
- merchant identity;
- public upload by default.

These are data-minimization goals, not anonymity guarantees. Participant-chosen
nonces, roots, counts, retained prefixes, and discovery metadata can correlate or
deliberately tag participants. Fresh ephemeral keys and constrained nonces may
reduce linkability, but retained copies cannot be revoked. A verifier should
request only the minimum fields needed by the user's policy.

## Failure and fork behavior

If a phone lacks part of the record but the coin root has advanced, the client should report incomplete continuity rather than invalid currency.

If two phones present chains ending at different roots, only the chain matching the current coin response is current. This does not prove the older chain was fraudulent; it may simply be stale.

If the coin's optional history storage fails while monetary state remains sound,
a verifier may accept the coin without BSLRR if its policy allows.

## References

[^lightclients]: Ethereum.org, [Light clients](https://ethereum.org/developers/docs/nodes-and-clients/light-clients), including the current implementation-status caveat.
