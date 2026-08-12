# Register and checkout

The register is a transparent physical verifier and optional claim device. Its mechanical design should make the difference between inspection and transfer of control visible to both customer and merchant.

## Related docs

- [Master architecture](./master-architecture.md)
- [Coin hardware](./coin-hardware.md)
- [Key lifecycle and claim protocol](./key-lifecycle.md)
- [Verification and BSLRR](./verification-and-bslrr.md)
- [Operator network and business model](./operator-network-and-business.md)

## Physical paths

```text
input
  -> transparent side-button verifier
  -> visible waiting chamber
  -> authoritative visual and nonvisual basket terms
  -> customer basket-commit lever
  -> customer decision gate
       |-> return/change dish
       |-> one-way accept path
       |     `-> merchant active-coin inventory; no center press
       `-> one-way claim path
             -> one-coin horizontal chamber
             -> side rails remain pressed
             -> indexed center actuator presses and fully releases once
             -> all three buttons active
             -> merchant-controlled collection
```

The claim chamber handles one coin at a time. The customer-facing basket lever is
not the per-coin center actuator: one customer pull commits the fixed basket and
permits a bounded indexed sequence. The customer can see or receive nonvisual
confirmation that center activation does not occur during verification or
recirculation acceptance and occurs only after a selected claim coin crosses its
claim boundary.

## Register trust boundary

The register is split into at least two logical domains:

```text
general register computer
  -> catalog, exchange rates, networking, RPC, settlement services
  -> proposes canonical checkout terms

secure claim controller
  -> authoritative two-sided transaction display
  -> authoritative nonvisual terms output
  -> exact ClaimIntent digest
  -> basket-commit lever interlock and approval state
  -> waiting and one-way gate state
  -> bounded per-coin center-button actuator sequence
  -> coin authorization capture
  -> signed receipt
```

The general-purpose computer cannot release the basket lever, energize the claim
contacts, open the one-way claim gate, increase the approved cycle count, or
replace an armed intent. It submits proposed terms to the secure claim controller
through a canonical bounded interface. The secure controller renders those terms
visually and nonvisually, constructs or verifies the exact `ClaimIntent`, controls
the lever interlock, and controls the physical claim sequence.

Normal checkout trusts this evaluated controller, its display path, and its physical mechanism. The protocol does not claim that buttons alone prove what an arbitrary register displayed. A malicious replacement of the entire trusted register boundary can still deceive a customer and is addressed through register evaluation, merchant attribution, signed receipts, and optional independent verification.

### Optional independent verification

A customer may use an open verifier app to read the armed `ClaimIntent` digest and decoded terms before approval. The app compares the digest with the controller's displayed record and later receipt. This supplies an independent view for a customer who does not trust the register.

The phone path is optional. Standard checkout does not require a phone, account, network connection, or additional customer action beyond the existing approval flow.

## Customer basket-commit lever

The standard register uses one large, low-force, customer-facing physical lever
as the accessible basket-commit action. This is the ordinary initiation control,
not a lower-assurance alternative. It supports one-handed operation and an open
assistive attachment while preserving the coin's normal physical command states.

The secure claim controller keeps the lever mechanically or securely unavailable
until:

- the canonical basket, selected coins, routes, quote, fees, change, and remedies
  are fixed and rendered through the authoritative visual and nonvisual outputs;
- every selected coin is tracked in the waiting chamber;
- unselected and excess coins have a defined return route; and
- for any claim route, D-040's fresh chain check, working submission path,
  durable-storage reservation, and gas or sponsorship readiness all pass.

One pull records customer approval, locks those terms, and enables only the
approved routing sequence. It does not itself transfer ownership; D-037's secure
per-coin gate crossing remains the protocol acceptance event.

For each approved claim coin, an indexed cam, ratchet, or equivalently bounded
mechanism must:

```text
identify the tracked approved coin
  -> apply the required side-button state
  -> establish center released
  -> arm that coin's exact ClaimIntent
  -> after claim-gate crossing, press center once
  -> observe authorization commit
  -> fully release center
  -> consume exactly one approved cycle
```

The mechanism must not hold center continuously between coins. It cannot change
terms, substitute or append coins, reroute a verification-only coin through
claim, or produce more center cycles than the basket's approved claim count.
Verification-only coins receive no center stroke.

Completion, cancellation before ownership transfer, loss of a required claim
precondition, object-tracking mismatch, jam, power fault, or other mechanism
failure disarms the sequence. Restart never reuses the customer's lever act to
authorize a different basket or an additional cycle. D-037, D-038, and D-040
govern return, quarantine, partial-basket remedies, and interrupted submission.

The nonvisual output is generated from the same canonical basket record and
secure controller as the screen. It presents at least the amount, assets,
merchant, selected action, fees, change, material warnings, and whether any coin
will be claimed. Optional personal-device rendering may verify the same digest,
but cannot be required for the lever to provide an accessible standard flow.

## Checkout sequence

1. Merchant states the price and unit of account, normally a local fiat amount.
2. Customer inserts one or more coins.
3. Each coin passes side-button verification and enters the visible waiting chamber.
4. The register returns `EMPTY`, `AWAITING_LOAD_PROOF`, `AUTH_PENDING`, exhausted, or otherwise unacceptable local states under the merchant's advisory policy; only `ACTIVE` coins proceed as ordinary tender.
5. For an offline `ACTIVE` coin, the register reports the core's proof-activation reference and absence of later monetary authorization separately from any current online backing observation.
6. The register applies the merchant's asset and assurance policy.
7. The primary visual and nonvisual confirmation presents the purchase total, merchant, selected action, and each coin's represented asset, amount, short approved-chain name, recognizable chain icon, quoted purchase value, and material warnings.
8. The same primary view presents quote time and expiry, customer fees, total accepted tender, and any amount still due or owed as change.
9. The register constructs canonical basket terms, per-coin acceptance records, and a `ClaimIntent` only for coins selected for online claim. This is an internal protocol step and adds no customer interaction.
10. For any claimed coin, the secure claim controller checks online-claim preconditions and arms that digest while the center input is observed released. An optional customer verifier may inspect it.
11. After reviewing the authoritative visual or nonvisual terms, the customer pulls the basket-commit lever once to approve that canonical basket.
12. Unselected, rejected, or excess coins return visibly to the customer.
13. Selected coins move one at a time through their approved verification-only accept or online claim path.
14. Only for each approved claim coin, and only after its one-way gate crossing, does the indexed mechanism cause one fresh center released-to-pressed-to-released cycle while applying the side-button state.
15. The merchant issues a receipt showing the signed intent digest, the authorized terms, and current onchain status.

Example prototype confirmation:

```text
TESTNET / NO VALUE
DEMO TOTAL:                47.00 TEST-USD
TO:                             Merchant example
ACTION:                         2 coins accepted, 1 coin claimed

20 TEST-USD     Testnet [icon]: 20.00   Issuer-controlled; freezable
0.00022 TEST-W  Testnet [icon]: 14.82   Wrapped; custodian-dependent
0.0038 TEST-N   Testnet [icon]: 12.31   Native asset

Tendered at demo rates:          47.13
Demo change due:                  0.13
Demo fees:                         0.00
Quote expires in:                  18 s
```

The prototype coin and register always show `TESTNET / NO VALUE`. The primary
register summary and audio output use the short test-network name beside every
asset. Icons are supplemental: the written network name is mandatory and must be
spoken or otherwise rendered through the nonvisual path.

The secondary detail view must show the exact chain ID, contract or native-asset
identity, issuer or custody model, proxy and implementation identity,
upgradeability, freeze controls, and wrapped/native status. A fact from those
details becomes a primary warning when it materially affects the current
transaction, such as a stale or absent backing observation, a transfer restriction
or pause, an unknown implementation change, a custodial or wrapped claim, or
settlement support limited to a named provider.

For online checks, the register distinguishes exact backing, surplus, and deficit.
A surplus does not increase the tender value: the customer tenders the fixed
represented amount, and claim routes the excess to the load-bound residual
beneficiary. A deficit is `observedChainState = DEFICIT`; it does not alter the
coin-signed `coreState`, but it cannot produce a standard partial claim. Offline
acceptance remains a merchant-selected risk decision because no
current balance check is mandatory for physical handoff.

## One asset per coin

A checkout may use multiple assets, but each physical coin represents one AssetID and amount during its current epoch.

The register should never aggregate several token balances inside one coin into one displayed value. Unsupported or unsolicited tokens at the account are not represented tender.

## Commercial acceptance boundary

Verification and presence in the waiting chamber are not acceptance events. The
protocol records customer approval plus secure crossing of either the one-way
accept gate or one-way claim gate as the intended commercial acceptance event.
The table below is a reference operating allocation, not a legal determination;
applicable agreements and law control title, bailment, and loss allocation.

| Physical or settlement state | Reference treatment | Operational rule |
|---|---|---|
| Input, verification, or visible waiting | Treat as customer property | Return the same coin on rejection, cancellation, or failure. |
| Approved, gate not crossed | Treat as customer property | Equipment-caused loss or damage follows the operator agreement. |
| Return path | Treat as customer property | No protocol acceptance event occurred. |
| Accept gate crossed | Treat as merchant property | Record the active coin as inventory or recirculating tender. |
| Claim gate crossed, before authorization | Treat as merchant property | Quarantine on failure rather than returning it as ordinary customer tender. |
| Authorization captured or submitted | Treat as a merchant pending claim | Track submission and chain risk unless a provider signs an acceptance. |
| Provider signed acquisition acceptance | Apply the provider's signed terms | Record the identified acquisition and payout obligation. |
| Direct claim finalized to merchant | Treat as merchant settlement | Record the finalized backing transfer. |

A post-gate jam quarantines the coin under the merchant-property treatment. A pre-gate jam invokes the
same-coin return procedure. Intentional customer fraud may create ordinary legal
recourse supported by receipts and tracking evidence, but no protocol clawback
reverses a completed physical acceptance.

The screen should commit the merchant to:

- item price;
- exchange rates and source;
- quote expiry;
- processing or network fees;
- selected coins;
- change method;
- settlement status vocabulary.

These terms, along with merchant identity and beneficiary, claim destination, asset, amount, chain, account implementation, coin epoch and nonce, basket identity, settlement provider, and validity window, are bound into the canonical `ClaimIntent`. The same digest appears in the register's pre-claim record and final receipt.

Exact consumer-dispute rules are outside the protocol, but the machine should produce a signed receipt for registered commercial operation.

## Risk-first primary presentation

The register's primary screen and authoritative nonvisual output are standardized
as a compact payment-decision hierarchy:

1. purchase total and unit of account;
2. merchant or recipient;
3. selected action for each coin: `accept and recirculate` or `claim and retire`;
4. asset amount, short approved-chain name, and recognizable chain icon;
5. tender total, change, customer fees, and quote expiry; and
6. plain-language material warnings.

Material warnings state the concrete fact and its effect. The first profile uses
at least these categories:

| Category | Primary wording example |
|---|---|
| Backing | `Backing not checked live` or `Observed deficit; standard claim unavailable` |
| Settlement | `No managed settlement offer` or `Settlement offer limited to Provider X` |
| Custody | `Wrapped asset; custodian-dependent` or `Issuer-controlled asset` |
| Freezability | `Issuer may freeze or pause transfers` or `Transfer currently restricted` |
| Upgradeability | `Upgradeable contract` or `Implementation changed; current policy does not recognize it` |

The primary view does not promise that these warnings invalidate physical transfer.
They state the register's current observation and policy. Merchant acceptance,
provider acquisition, and direct handoff remain separate choices under the
existing permissionless and advisory model.

Exact IDs, proxy records, implementation hashes, source blocks, issuer documents,
and full policy data are secondary details. The icon cannot carry meaning alone;
the written chain name and nonvisual chain name are required. Color alone cannot
encode a warning, action, or risk class.

## Canonical quote, fees, and change

The bearer protocol does not select a universal price oracle. The applicable
quote authority follows the commercial relationship:

- a self-settling independent merchant may select and disclose its own source;
- an issuer may publish conversion or redemption terms for direct use of its
  service;
- a settlement provider may require a source, spread, fee schedule, and maximum
  quote age as a condition of its signed acquisition acceptance.

These policies affect whether the merchant or provider accepts the basket, not
whether the coins remain physically transferable. The customer-facing total and
detail view identify the applicable source or commercial policy, quote time,
effective rates, spread, and every customer-paid fee.

All normative arithmetic uses integers and exact rational rates. Asset quantities
use their canonical smallest units; the purchase unit uses its defined minor unit.
Implementations must not use binary floating point for tender, fees, or change.
The register sums full-precision basket contributions and rounds the final basket
once using the quote-currency profile's deterministic mode. Version 1 uses
round-half-even to the purchase unit's minor unit unless a separately disclosed
legal cash-rounding profile applies. Displayed line-item residuals are allocated
deterministically so their sum equals the rounded basket total.

`quoteAcceptUntil` is the last time at which the customer may approve the shown
terms. If it passes first, the register refreshes and redisplays the basket. Once
the customer approves in time, the source, rates, spread, fees, tender value,
change, and remedies are locked. Market movement or quote expiry during physical
routing, claim submission, confirmation, or provider processing cannot reprice
that basket. Any transport or provider deadline is separately named and cannot
reinterpret the locked monetary terms.

Before approval, the register returns every unselected or unnecessary whole coin.
For any remaining overpayment, `BasketTerms` binds:

```text
change amount in the purchase unit
change method and destination, if applicable
availability evidence or merchant commitment
dispense condition
failure remedy
```

The register verifies that the selected change method is available before
approval. It may visibly stage physical change, but does not have to surrender it
before the customer transfers the tender. After every selected gate crossing, the
merchant owes and dispenses the exact locked change. A dispense failure creates a
signed merchant obligation for that amount; it never reduces the accepted tender
or shifts equipment failure to the customer. D-038's partial-basket remedy uses
the same locked arithmetic rather than a later market rate.

Gas, claim submission, treasury, provider, and conversion costs incurred after
acceptance are merchant costs unless an exact customer fee was displayed and
approved in `BasketTerms`. No dynamic fee or spread may be added afterward.

## Binding verification to claim

The register must ensure that the coin entering the claim chamber is the same object that was verified and approved.

Candidate controls include:

- a mechanically continuous one-coin path;
- optical tracking and shape/position checks;
- a fresh local attestation at the verifier and claim chamber;
- a short-lived internal object token bound to both observations;
- no user-accessible substitution gap;
- jam handling that preserves the identity and location of every coin.

This is a mechanical security problem as much as a software problem.

## Claim behavior

Before each indexed center stroke, the register supplies the exact canonical
`ClaimIntent` corresponding to the committed basket. The coin commits that exact
digest and authorization in its pending record, then returns the signed
authorization described in [Key lifecycle and claim protocol](./key-lifecycle.md).

The standard register releases the basket lever for a claim route only after it has completed a fresh
chain-state check, confirmed a working transaction-submission path, reserved
durable storage for the exact authorization and canonical intent, and established
available gas or sponsorship. A connectivity indicator alone is insufficient.
Without these preconditions, only the verification-only accept path is available.

The claim controller must not synthesize, omit, or substitute terms after customer approval. Any quote, fee, destination, beneficiary, basket, provider, or validity change creates a new digest and requires a new approval and claim authorization. This rule changes protocol processing, not the ordinary customer interaction.

For each claim session, the secure controller and coin enforce this order:

```text
side-button verification active
  -> center input observed released
  -> exact ClaimIntent digest armed
  -> customer basket-commit lever approval recorded
  -> coin crosses one-way gate
  -> center input makes one fresh released-to-pressed-to-released cycle
  -> coin authorizes only the armed digest
  -> exactly one approved basket cycle is consumed
  -> controller signs the receipt for that digest
```

A center input already active when the session starts, failure to observe complete
release after a stroke, or an attempted cycle beyond the approved count is a
fault. Loss of intent, lever approval, object tracking, gate state, or
input-transition state cancels before gate crossing or quarantines after crossing.
Software outside the secure controller cannot bypass this sequence.

The register should retain the coin and the prepared authorization until it has either:

- submitted the operation;
- delivered a durable copy to the merchant;
- or returned the coin with an explicit pending/warning state under a defined failure procedure.

The machine must not claim onchain finality merely because it obtained a signature.

## Multi-coin basket completion

All proposed coins are verified and tallied in the visible waiting chamber before
approval. The approved canonical `BasketTerms` contains at least:

```text
basketId
ordered coin and contribution commitments
purchase amount and quote terms
selected return, accept, or claim route for each coin
partial-acceptance remedy
expiry and receipt policy
```

Each selected coin's intent binds `basketId` and `basketTermsHash`. Because coins
move one at a time, physical acceptance cannot be instantaneous across the whole
basket. Each secure gate crossing therefore creates a signed per-coin acceptance
event. The checkout is complete only after all selected crossings are recorded.

If routing stops after a strict subset crosses, the reference commercial model
applies D-037 independently to each coin: crossed coins are treated as merchant
property and uncrossed coins as customer property. The merchant must perform the
refund, return, or credit remedy committed by `BasketTerms`. The receipt identifies
the accepted subset and unresolved remedy. A crossed `AUTH_PENDING` coin is
quarantined or retained under the merchant treatment and is never returned as
ordinary active tender.

For a complete authorization set on one supported chain, an immutable
`BasketClaim` contract calls every account claim in one Ethereum transaction. Any
failed validation, stale nonce, token failure, transfer-delta mismatch, gas
failure, or other subclaim revert reverts every subclaim and transfer. The
register must not describe independent submissions, incomplete physical routing,
or a cross-chain basket as atomically claimed.

If authorization collection stops before the complete set exists, no atomic
`BasketClaim` is asserted. Already crossed coins and authorizations remain the
merchant's responsibility under the signed partial-acceptance remedy. The
customer-facing flow remains one tally and one approval, followed by either a
completed basket or an exact recorded remedy.

## Offline operation

Without internet, the register may still perform:

- physical inspection;
- fresh coin attestation;
- cached hardware and asset-policy checks;
- BSLRR continuity;
- local tally based on cached or manually entered exchange rates.

It cannot honestly perform:

- current backing verification;
- current contract-code or policy-feed checks;
- onchain claim submission;
- managed settlement;
- current exchange-rate verification.

The merchant may still accept coins under a lower assurance policy.

The standard register does not initiate an all-three-button claim while offline.
Offline checkout accepts through the verification-only path, leaving the coin
`ACTIVE` and available for merchant inventory or recirculation. This restriction
is a register safety profile, not a limitation on physical handoff.

If connectivity disappears after an online claim has begun, recovery follows the
last durable state:

| Failure point | Result |
|---|---|
| Before customer approval or gate crossing | Cancel and return the same coin under the customer-property treatment. |
| After claim-gate crossing, before authorization commit | Treat the `ACTIVE` coin as merchant property; retain it for recirculation or a later online claim. |
| After durable authorization commit | Merchant retains the `AUTH_PENDING` coin and exact authorization in a durable retry queue. |
| After submission with unknown outcome | Reconcile account state and replay only the identical authorization if still executable. |

No pending coin returns as active tender, no replacement authorization is
requested, and no provider credit is implied until the provider issues its own
signed acceptance. A reconnect target may trigger warnings and operator
escalation, but it does not expire or reinterpret the monetary authorization.

## Register tiers

### Base register

- transparent mechanical paths;
- coin attestation;
- powered-reader conformance for claim and other enabled persistent mutations;
- one or more ordinary RPC providers when online;
- local merchant policy;
- signed receipts;
- optional managed settlement client.

### Advanced verifier

- proof checking or experimental light-client support;
- load-proof, key-generation, rotation, and display-update power profiles;
- multiple provider selection;
- home or merchant bulk verification;
- local trust-feed mirrors;
- richer diagnostics.

### Operator system

- companion full node or proof service;
- ERC-4337 bundler;
- isolated privacy relayer;
- cross-network services;
- managed settlement and liquidity software.

Optional network services should run on a separate companion computer or operator infrastructure. They should not enlarge the trusted computing base of the mechanical claim controller.

## Remaining mechanical questions

- coin dimensions, orientation, and throughput;
- jam and contamination behavior;
- button force tolerance and counterfeit shells;
- display visibility through the path;
- customer cancellation timing;
- secure handling after claim;
- maintenance access without creating a substitution path;
- evidence when the register itself is modified.

These remain prototype questions, not fixed industrial design.
