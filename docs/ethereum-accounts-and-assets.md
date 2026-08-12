# Ethereum accounts and assets

Ethereum is the reference execution model because a smart account can recognize
secure-element-friendly P-256 signatures, rotate authorization, sponsor gas, and
express a narrow migration policy. All prototypes use valueless test deployments.
Mainnet contracts and asset policies are analyzed only as possible future cases.

This document describes **Architecture A**, the version 1 per-coin smart-account
baseline.
[Architecture B](./architecture-b-commitment-pool.md) instead places exact
denominations in a shared commitment/nullifier reserve and treats the physical
coin as the bearer of a hidden shielded note. The two architectures must be
prototyped and compared; smart-account choices in this document are not assumed to
apply unchanged to the pool design.

This is a reference design, not an implementation or a requirement that every
future coin use Ethereum.

## Related docs

- [Master architecture](./master-architecture.md)
- [Architecture B: hardware-held shielded notes](./architecture-b-commitment-pool.md)
- [Key lifecycle and claim protocol](./key-lifecycle.md)
- [Register and checkout](./register-and-checkout.md)
- [Privacy routes](./privacy-routes.md)
- [Operator network and business model](./operator-network-and-business.md)

## Why P-256

P-256 is widely available in secure hardware. EIP-7951 specifies Ethereum's `P256VERIFY` precompile at address `0x100` with a gas cost of 6,900 gas and is Final.[^eip7951]

The account should still detect whether its deployed chain supports the expected precompile. A protocol document must not assume that every EVM-compatible network has identical support.

## Minimal account

Version 1 requires a deployed small immutable account or immutable core account
module before funding. It has no remote administrator that can replace validation
logic, freeze the account, or add surveillance. Counterfactual funding and
EIP-7702 accounts are excluded.

Candidate state:

```text
currentP256Key
keyEpoch
representedAssetId
representedAmount
residualBeneficiary
semanticNonce
accountStatus
activationChallenge
```

Candidate operations:

```text
claim(intent, signature)
evacuate(intent, signature)
rotateKey(newKey, intent, signature)
migrateTo(newAccount, intent, signature)
```

`migrateTo` is coin-authorized asset movement and retirement of the old account relationship. It is not administrator-controlled code replacement.

The exact interface remains open. Every extra recovery or sweeping path increases the account's attack surface.

`evacuate` has the same exact-amount, surplus-routing, zero-balance, nonce,
reentrancy, and authority-retirement invariants as claim. Its distinct operation
type lets clients and receipts identify that a tamper-suspected core is being
permanently retired. The account does not accept arbitrary token sweeping.

## Global monetary serialization

Claim, rotation, migration, and any later private-refresh entry point share the same `semanticNonce`. There is no operation-specific nonce namespace.

Account validation may check a signature and expected nonce, but validation alone does not consume monetary authority. During execution, before any external call or asset movement, the account:

1. Rechecks the current key epoch and `semanticNonce`.
2. Recomputes the canonical inner intent digest.
3. Enters an `EXECUTING` reentrancy guard and increments the shared nonce.
4. Records the required starting balances.
5. Performs the complete authorized effect with strict call-result and exact balance-delta checks.
6. Requires the operation-specific final balances and authority state.
7. Emits completion only after every invariant holds.
8. Reverts the guard, nonce, transfers, authority, status, and events if any required effect fails.

Two operations authorized from the same epoch and semantic nonce therefore cannot both execute successfully. ERC-4337 transport nonces remain separate delivery mechanics and cannot substitute for this account-level monetary nonce.

## Slot-bound account activation

In the normal post-depletion lifecycle, each finite monetary slot uses a fresh account binding. After finalized proof that slot `i`'s represented balance was depleted and its bearer authority retired, the coin retires it and reveals slot `i+1`'s monetary public key, fresh account, and one-time `activationChallenge`. The new slot remains locally `AWAITING_LOAD_PROOF`. Balance-preserving rotation is separate: it may install the next slot's key in the existing account and therefore retains that account address.

The loading transaction or atomic deployment-and-loading call records the expected slot, challenge, key, asset policy, represented amount, initial semantic nonce, and active account status while transferring the exact represented asset. The transition must not rely on a token symbol or an unauthenticated loader receipt.

An untrusted prover then constructs evidence that a finalized Ethereum state contains the exact expected account state. The proof's public inputs bind at least:

```text
chain and fork identity
finalized state reference
certified core commitment
slot and key epoch
activation challenge
account address and immutable implementation identity
monetary P-256 public key
AssetID and represented amount
residual beneficiary
semantic nonce and account status
exact asset balance or policy-defined funding condition
```

Only the coin's successful internal proof verification changes the physical slot to `ACTIVE`. The proof format may compress Ethereum finality and account-state verification, but its trust anchor cannot be merely a chain ID, RPC response, or unanchored storage proof.

## Represented asset invariant

Each epoch represents one exact AssetID:

```text
AssetID = (
  chain_id,
  asset_type,
  native_asset_or_contract_address
)
```

The ticker and display name are metadata, not identifiers.

For the prototype, each supported test asset maps to one deployment identity.
Every coin and verifier display must mark the environment `TESTNET / NO VALUE`.
Future mainnet policy would require a separate decision and full identity and risk
metadata.

Register primary confirmation shows the test asset amount, test-network name, and
`NO VALUE` warning. An icon is supplemental; the written network name is required
in visual and nonvisual presentation. `chain_id`, contract address, and proxy or
implementation records remain secondary technical details unless their state
generates a material warning under D-045.

Unexpected tokens can be sent to any account. They do not change the coin's
represented amount or display. Version 1 provides no
unsolicited-token sweep path because executing attacker-selected token code would
expand the attack surface. Clients may disclose such balances without treating
them as bearer value.

### Exact amount and zero-out claim

Proof-activated loading fixes both `representedAmount` and a
`residualBeneficiary`. Activation requires the represented-asset balance to equal
the represented amount exactly. Later same-asset deposits do not change the
displayed or bearer amount.

Standard claim executes one reverting sequence:

```text
recheck intent, key epoch, ACTIVE status, and semantic nonce
enter EXECUTING and consume semantic nonce
require represented-asset balance >= representedAmount
transfer exactly representedAmount to claimDestination
require strict call success and exact sender and recipient balance deltas
transfer the entire remaining represented-asset balance to residualBeneficiary
require strict call success and exact sender balance delta
require ending represented-asset balance == 0
retire bearer authority and account status
emit completed intentDigest and resulting state
```

Every required transfer, balance-delta check, zero-balance check, nonce update,
and authority retirement succeeds or the complete transaction reverts. A deficit
therefore cannot silently become a smaller payment, and a surplus cannot remain
behind when the physical coin advances. The residual beneficiary is fixed and
proved at loading and is included in the claim intent. Changing it requires a
separate serialized monetary authorization.

This invariant covers only the exact represented AssetID. Arbitrary unrelated
token contracts cannot be safely discovered or executed and do not become bearer
value merely because someone transfers them to the account.

Supported policies exclude fee-on-transfer, rebasing, callback-dependent, and
other assets for which exact sender and recipient deltas cannot be enforced. A
false or malformed token return, unexpected delta, callback reentrancy, nonzero
ending represented balance, or failure to retire authority reverts the claim.

## Initial asset policy

An app, register vendor, or settlement provider may publish a signed policy containing:

- exact AssetID;
- display name and decimals;
- issuer or custodian;
- native, wrapped, or bridged status;
- proxy and implementation information;
- upgrade authority;
- freeze or blacklist controls;
- known transfer peculiarities;
- policy version and expiry.

There is no global protocol whitelist. For the first hardware profile, loaders
and coin firmware should allow configuration only from a signed AssetID policy
selected by that implementation or user; this prevents an arbitrary contract
from receiving a recognized display label. Another client may subscribe to a
different policy. Managed settlement providers may apply narrower commercial
policies.

The policy also supplies the D-045 primary risk class and warning inputs. It must
distinguish, at minimum, native, issuer-controlled, wrapped or custodian-dependent,
transfer-restricted or freezable, and upgradeable assets. A client may keep exact
control addresses and implementation records in secondary details, but it must
elevate a material current condition to the primary confirmation.

### Native asset class

A native test asset models value that avoids token-contract issuer controls. ETH
is the corresponding future mainnet case; it remains price-volatile and requires
denomination or quote handling at checkout.

### Issuer-controlled token class

A test token with pause, freeze, upgrade, and issuer controls models this class.
USDC is a possible future mainnet case and adds issuer, contract, reserve, and
redemption-policy dependencies. No live contract is selected for version 1.

### Wrapped or custodial token class

A custodial test token models an asset whose claim depends on an external reserve.
WBTC is a possible future mainnet case. It is wrapped, custody-dependent, and not
equivalent to native BTC. Current WBTC materials describe 1:1 backing and a
multi-institutional custody structure.[^wbtc]

Clients must display those dependencies prominently.

## Claim intent

The account validates the canonical coin-signed `ClaimIntent` defined only in
[Key lifecycle and claim protocol](./key-lifecycle.md#claim-semantics), rather than
accepting arbitrary calls or a destination-only signature. The onchain
representation contains those complete typed fields or their canonically committed
substructure hashes. The field list is incorporated by reference to prevent
diverging copies.

The account checks:

- P-256 signature by the current key;
- recognized protocol, schema, and claim operation;
- matching chain, account implementation, account, epoch, and nonce;
- matching represented asset;
- exact represented amount and claim destination;
- matching load-bound residual beneficiary and complete represented-asset zero-out rule;
- replay protection;
- validity window;
- status that permits claim.

The account emits the `intentDigest`, basket ID, merchant beneficiary, and destination in the claim event. It does not need to enforce offchain quote or refund performance to make those terms cryptographically attributable; their canonical commitments remain part of what the coin authorized and what the receipt identifies.

Successful claim transfers the exact represented amount, routes all same-asset surplus to the load-bound residual beneficiary, verifies a zero represented-asset balance, and retires the old account authorization in the same onchain execution.

## Key rotation

Fast refresh retains the account address and replaces the current P-256 key. This is cheaper and operationally simple, but permanently linkable.

```text
same account
old P-256 key -> new P-256 key
```

The intent must bind the new key, next epoch, account, chain, and nonce. The coin should retain a resumable path until the change confirms.

## Fresh-account migration

Migration moves the represented asset to a new account controlled by a new key. It supports:

- account-implementation changes;
- deliberate public unlinking when combined with a privacy route;
- replacement hardware;
- retirement of an endangered account relationship.

A direct public transfer from old account to new account is still linkable. A new address alone is not privacy.

## ERC-4337

ERC-4337 defines `UserOperation`s, bundlers, an `EntryPoint`, factories, and optional paymasters.[^erc4337]

It is useful for:

- sponsoring gas for token-only coins;
- allowing a merchant or third party to pay execution fees;
- aggregating operational submission through bundlers;
- standard wallet and bundler interfaces.

The account's monetary authorization should not depend on one commercial bundler or paymaster. A user should be able to use another compatible bundler, self-fund, or relay an equivalent account call through a supported path.

Bundling does not make per-account validation or token transfer free. It amortizes some shared transaction overhead while each operation still consumes validation and execution gas.

## Gas policy

Version 1 never treats represented native value as implicit gas authority. The baseline is
caller- or paymaster-funded execution. Every replaceable submission uses the
separate typed `TransportAuthorization` described in the key-lifecycle document,
binding the inner intent digest, chain and fork domain, EntryPoint or direct relay,
gas and fee caps, validity, paymaster terms, sponsor nonce, and an identifier or
digest for the applicable fee-failure policy. The signature records those terms;
it does not enforce legal loss allocation.

An independent holder may submit through a compatible bundler or direct relay by
supplying gas outside the represented value. Any later account-funded mode must
segregate an explicit gas reserve from represented value and obtain separately
bounded authority; it is not part of version 1.

## Account deployment

Version 1 permits a deployed persistent account for transparent key rotation and
a separately deployed fresh account for migration. Proof-activated funding occurs
only after the expected immutable runtime code and initial key binding are
observable. Counterfactual funding, EIP-7702, arbitrary execution, and private
refresh are later-profile work.

## Chain verification

An online verifier checks at least:

- chain ID and finalized or selected block context;
- account code hash or implementation identity;
- current P-256 key and epoch;
- shared semantic nonce and account status;
- exact token contract;
- represented token balance;
- token proxy/implementation metadata under the selected policy.

A single RPC response is the simplest implementation but carries provider trust. Proof checking, light clients, and full nodes provide stronger options, as described in [Verification and BSLRR](./verification-and-bslrr.md).

## References

[^eip7951]: [EIP-7951: Precompile for secp256r1 Curve Support](https://eips.ethereum.org/EIPS/eip-7951).
[^erc4337]: [ERC-4337: Account Abstraction Using Alt Mempool](https://eips.ethereum.org/EIPS/eip-4337).
[^wbtc]: [WBTC: About](https://wbtc.network/about).
