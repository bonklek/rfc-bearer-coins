# Key lifecycle and claim protocol

The coin's local lifecycle and the chain's backing state are related but independent. A sound design must avoid collapsing them into one `valid` bit.

## Related docs

- [Master architecture](./master-architecture.md)
- [Architecture B: hardware-held shielded notes](./architecture-b-commitment-pool.md)
- [Coin hardware](./coin-hardware.md)
- [Ethereum accounts and assets](./ethereum-accounts-and-assets.md)
- [Verification and BSLRR](./verification-and-bslrr.md)
- [Open questions](./open-questions.md)

## State dimensions

The reference fields below use Architecture A's account terminology. Architecture
B preserves the same local lifecycle but replaces the account binding with a
hidden note commitment and replaces finalized zero-balance/account-retirement
evidence with finalized nullifier-consumption evidence. It does not remove the
core's requirement to commit one exact authorization before releasing it.

| Dimension | Example states | Authority |
|---|---|---|
| Core lifecycle | empty, awaiting-load-proof, active, auth-pending, tamper-suspected, tamper-retired, exhausted | Secure core |
| Key epoch | unused, sealed-by-core, auth-pending, retired | Secure core |
| Account binding | expected key, previous key, unknown | Chain state |
| Backing | funded, zero, unknown, inconsistent | Chain state |
| Display | configured asset, amount, local status | Secure core's signed display payload |
| BSLRR | epoch, event count, handoff count, root | Secure core plus optional phone-carried records |

`sealed-by-core` means the device reports that the key was internally generated or
activated and has not undergone a claim transition or any export. Version 1 has
no monetary private-key export command or mode. The state is not proof that no
invasive attack ever observed the key.

## Reference lifecycle

```text
EMPTY
  -> verify finalized depletion of the previous represented balance and
     retirement of its bearer authority
  -> retire previous slot and reveal the next account, key, and challenge

AWAITING_LOAD_PROOF
  -> configure one AssetID and exact amount
  -> fund expected account with the slot-bound activation challenge
  -> verify finalized funding proof internally
  -> atomically commit ACTIVE and the active display state

ACTIVE
  -> verify: remain ACTIVE
  -> any monetary operation: AUTH_PENDING(kind, digest, epoch, semanticNonce)
  -> confirmed tamper event: TAMPER_SUSPECTED

Observed backing changes do not mutate core state. A verifier separately reports
`observedChainState = EXACT | SURPLUS | DEFICIT | CLAIMED | UNKNOWN` with its
block, source, observation time, and finality.

AUTH_PENDING
  -> reproduce only the same exact authorization
  -> verify finality-rooted completion of the authorized operation
  -> complete the authorized claim, rotation, migration, or private refresh
  -> or enter an explicit recovery protocol that first invalidates the old authorization

TAMPER_SUSPECTED
  -> verify: report irreversible tamper evidence
  -> all three buttons: AUTH_PENDING(kind = EVACUATE, exact intent)
  -> refuse load activation, ordinary rotation, and future key generation

AUTH_PENDING(kind = EVACUATE)
  -> reproduce only the stored evacuation authorization
  -> verify finalized zero represented-asset balance and retired authority
  -> TAMPER_RETIRED

TAMPER_RETIRED
  -> no local reset or next epoch
  -> replace secure core if refurbishing shell

RETIRED
  -> generate and commit the next finite epoch key
  -> return to EMPTY

EXHAUSTED
  -> no local reset
  -> replace secure core if refurbishing shell
```

## Fresh-key attestation

When a key epoch activates, the core may sign:

```text
attest(
  core_credential,
  monetary_public_key,
  epoch,
  origin = internal_generation_or_certified_slot,
  key_state = sealed_by_core,
  firmware_profile,
  reader_nonce
)
```

This establishes provenance under the verifier's chosen hardware trust policy. It does not establish current backing and does not eliminate the possibility of a successful physical attack.

## Claim semantics

Claim is an intentional authorization to move the represented asset or account authority to a specified destination.

The first protocol signs one canonical, versioned `ClaimIntent`; it does not
release the private key. This section is the sole canonical logical version 1
`ClaimIntent` schema. Other documents summarize it and must link here instead of
copying the field list. The normative logical fields are:

```text
ClaimIntent {
  protocolVersion
  schemaVersion
  operation = CLAIM

  chainId
  account
  accountImplementationId
  assetId
  representedAmount
  residualBeneficiary
  keyEpoch
  semanticNonce
  claimSessionId
  basketId
  basketTermsHash

  merchantId
  merchantBeneficiary
  claimDestination

  quoteAsset
  quoteAmount
  quoteSourceId
  quoteRelationship
  quoteTimestamp
  quoteAcceptUntil
  exchangeRate
  roundingMode
  merchantFee

  settlementProviderId
  settlementInstructionHash
  changeOrRefundTermsHash

  validAfter
  validUntil
}
```

An unused optional relationship is represented by the schema's canonical zero value, not by omitting or reordering a field. Variable-length basket, quote, settlement, or refund terms are separately canonicalized and committed by their hashes. Unknown protocol or schema versions are rejected.

The signed digest uses a domain-separated typed encoding, with reference test vectors required before interoperability. The same exact `intentDigest` identifies:

- the authorization persisted and signed by the coin;
- the account call and emitted claim event;
- the record rendered by the register;
- the customer's and merchant's receipt;
- any managed-settlement credit record.

Changing any bound term requires a new intent and a new deliberate claim authorization. A relayer may replace a transport wrapper only when the inner `ClaimIntent` remains byte-for-byte identical. Gas bidding and transport replacement require their own bounded transport rules; they cannot reinterpret the monetary, merchant, quote, or settlement terms.

The replaceable wrapper is a separately typed `TransportAuthorization`. It binds
the exact inner `intentDigest`, chain and fork domain, EntryPoint or direct relay,
gas and fee caps, validity window, paymaster terms, sponsor nonce, and loss
allocation. Represented value is never implicit gas authority. A later normative
RFC must fix the exact schema and provide vectors before implementation.

This wrapper does not yet solve same-chain-ID split replay. A fork identifier may
not exist or be stable when an intent is signed, and a pre-split authorization may
remain valid on both descendants. Version 1 needs an explicit freeze,
requalification, and warning policy before this is safe for value.

`quoteAcceptUntil` gates customer approval, not later execution of an already
authorized monetary operation. Submission, provider, or transport deadlines are
separate typed fields or separately signed terms. Expiry of a market quote cannot
make an `AUTH_PENDING` authorization unusable or reprice an accepted basket.

Constructing and signing this object does not add a per-coin customer action. The
register builds it from the authoritative visual and nonvisual checkout record,
the customer pulls the basket-commit lever once, and the bounded mechanism applies
one fresh all-three-button cycle to each approved claim coin. Verification-only
coins receive no center stroke.

Before signing in the register profile, the core observes the side-button claim session with the center released, arms exactly one `intentDigest`, and requires a fresh center released-to-pressed transition. A pre-active center input is rejected. This establishes deliberate activation under the evaluated register assumption; it does not let the coin prove what an arbitrary external display showed.

## Interrupted claim

`AUTH_PENDING` has no accepted general cancellation or liveness protocol. Exact
retry prevents destination substitution, but expiry, censorship, reorganization,
fee-market changes, token freezes, or lost transport state can strand a funded
coin permanently. Until a modeled invalidation/completion protocol exists, the
only version 1 behavior is exact retry and an honest warning that recovery is not
guaranteed.

The dangerous outcome is not merely a failed transaction. It is a conflicting authorization escaping while the coin remains able to authorize another destination.

In the standard register profile, authorization begins only after a fresh chain
check, a working submission path, durable storage reservation, and gas or sponsor
readiness. These checks reduce intentional offline capture but do not assume that
connectivity will persist. If it fails after `AUTH_PENDING` is committed, the
register durably queues the exact stored authorization and canonical intent for
later reconciliation and identical retry.

A candidate state machine is:

```text
ACTIVE
  -> construct canonical intent digest
  -> create one normalized monetary signature
  -> atomically store operation kind, signature profile, exact signature bytes,
     digest, epoch, semanticNonce, and AUTH_PENDING
  -> only after commit, release the stored authorization

AUTH_PENDING(kind = CLAIM)
  -> hash caller-resupplied canonical intent and require the stored digest
  -> re-release the identical stored signature without invoking the key
  -> accept only finalized proof of zero represented-asset balance and retired
     bearer authority, then retire the local epoch
  -> or use a recovery protocol that makes the old authorization unusable first
```

The coin does not accept another claim, rotation, migration, sweep, or private-refresh intent from `AUTH_PENDING`. It may reproduce only the exact authorization already committed for that epoch and semantic nonce.

The canonical intent may be larger than the core's pending record. It can be
retained by the register, user client, or other transport participant because the
stored digest authenticates it. The protected core record contains at least the
exact normalized signature and every field needed to identify and safely release
it. A retry with absent, non-canonical, or digest-mismatched intent bytes fails.

The stable monetary operation identifier is derived from chain, account, epoch,
semantic nonce, and canonical intent digest. A transaction hash, UserOperation
hash, bundler wrapper, or newly quoted gas parameter is not the monetary identity.

Simply issuing a competing recovery rotation is not a safe recovery protocol because both authorizations would remain live. Recovery details are intentionally separate, but any accepted design must invalidate or make unexecutable the pending authorization before a different monetary authorization is released. Until then, the client reports the exact pending operation rather than presenting the coin as generally active.

An earlier draft treated any interrupted claim as evidence that the raw key may have been exposed. That is too broad for the non-exporting protocol. The accurate statement is that the old epoch may have emitted a still-live authorization or may have suffered a fault at a security-critical boundary.

## Transparent balance-preserving rotation

Rotation while funds remain in the account requires chain state change.

```text
1. Prepare next key and attest it as sealed-by-core.
2. Current key enters `AUTH_PENDING(kind = ROTATE)` for one rotate intent using the shared semantic nonce.
3. Submit and confirm the account update.
4. Retire the old local key epoch.
5. Close the old BSLRR epoch.
```

The implementation must preserve a retry path until the onchain update is confirmed. Retiring the old slot immediately after signing a fee-sensitive transaction can strand the account if that transaction never executes.

Using a relayer-independent rotate intent or retaining a resumable pending record are candidate solutions.

## Offchain advance after redemption

If the represented asset has left the old account and its bearer authority is retired, no separate key-rotation transaction is needed. The coin verifies finalized evidence of those facts, retires that slot, and reveals the next slot's account, public key, and one-time activation challenge. Funding the new account is the next chain action. This is distinct from balance-preserving rotation, which may consume a new key slot while retaining the existing account address.

The core does not advance a production finite-slot profile on a reader's assertion or an unauthenticated RPC result. It advances only after verifying the selected finality-rooted proof profile. A weaker development profile may permit manual abandonment, but it cannot label the resulting slot as production `ACTIVE`.

## Generate-on-advance finite epochs

The version 1 finite profile does not precompute monetary keypairs or commit a
list of future public keys. Its externally certified state contains the core
identity, hardware and firmware profile, and an irreversible maximum epoch count.
Only the current monetary key exists in protected storage.

After finalized evidence establishes that the represented balance and bearer
authority for epoch `i` are retired, the core performs:

```text
RETIRED(i)
  -> generate independent monetary key internally
  -> atomically commit key, epoch i+1, and old-key destruction
  -> reveal public key and fresh activation challenge
  -> AWAITING_LOAD_PROOF(i+1)
```

No public-key or challenge output occurs before the new key-and-epoch record is
durable. A power interruption before commit may discard an unexposed candidate
and restart generation. After commit, every retry returns the same stored public
key. The new key is not derived from the old monetary key, permanent attestation
key, or a common monetary master seed.

The attestation key signs the new public key, epoch, internal-generation origin,
and current core profile. This establishes provenance under the selected hardware
policy; it does not prove that complete compromise of the core could not influence
later generation.

## No reset after exhaustion

A finite core advances only forward through its certified epoch budget:

```text
S1 -> S2 -> ... -> SN -> EXHAUSTED
```

There is no software transition from `EXHAUSTED` to a fresh core identity. An exhausted shell may be refurbished only by installing a new externally certified secure core.

Anyone holding the object may intentionally consume slots or retire it early. This can destroy hardware utility but cannot create backing.

## Proof-activated loading and display state

Loading has four distinct moments:

1. The old slot is retired and the coin reveals the next fresh account, public key, and activation challenge.
2. The coin records an expected AssetID and exact amount in `AWAITING_LOAD_PROOF`.
3. A transaction deploys or confirms the expected immutable account, records the residual beneficiary and slot-bound challenge, and funds the exact represented amount.
4. An untrusted prover constructs finality-rooted evidence and the coin verifies it internally.

Conceptually, the proof establishes that finalized chain state contains:

```text
chain and fork identity
certified core commitment and slot index
coin-generated activation challenge
expected account and immutable implementation
current monetary public key and epoch
expected semantic nonce and account status
exact AssetID and represented amount
load-bound residual beneficiary
exact finalized funding state
```

Proof construction may occur on a phone, register, full node, or specialized proving service. The prover is untrusted. The coin verifies the proof against a profile-pinned verification key and chain anchor, stages the result, and atomically commits `ACTIVE` before acknowledging success or showing active value. If power fails, the coin remains either `AWAITING_LOAD_PROOF` or fully `ACTIVE`; the same exact proof can safely resume the transition.

The active display records that the core accepted a finalized funding proof at a particular chain state. It is not a live guarantee forever. Its offline meaning also depends on the core having emitted no monetary authorization since that activation.

## Core invariants

- No version 1 command or mode exports a monetary private key.
- A verifier never infers backing solely from coin attestation.
- A slot never enters `ACTIVE` without internally verified, slot-bound evidence of finalized exact funding.
- A previous slot does not retire as successfully depleted without internally verified finalized depletion evidence.
- Successful claim leaves a zero balance of the represented asset, routes any same-asset surplus to the load-bound residual beneficiary, and retires bearer authority atomically.
- Failed or partial onchain claim execution reverts its nonce, status, transfers, authority changes, and completion event together.
- Underfunding never becomes a silent partial claim.
- A pending claim cannot authorize a second destination.
- A pending authorization retry never invokes the old monetary key or creates a second signature.
- Claim, rotation, migration, and private refresh cannot occupy separate pending lanes or authorize concurrently.
- Every monetary operation uses the same monotonically advancing semantic nonce in the core and account.
- A claim authorization cannot be interpreted under merchant, quote, fee, basket, settlement, or execution terms different from its signed `ClaimIntent`.
- Every coin in a multi-coin checkout binds the same canonical basket identity and terms hash; complete same-chain execution may be atomic, but sequential physical ownership events remain individually recorded.
- A pending coin from an incomplete basket is never presented or returned as ordinary active tender.
- Old account authority remains recoverable until rotation has a reliable completion path.
- Retired finite slots do not reactivate.
- A tamper-suspected core cannot clear its event, activate another load, or generate another monetary epoch.
- Tamper evacuation uses one exact serialized authorization and ends in permanent core retirement.
- A new monetary key is not confused with a new certified core.
- Local advancement never creates or preserves value by itself.

The unresolved details are collected in [Open questions](./open-questions.md).
