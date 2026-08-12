# Operator network and business model

Offline handoff and local verification should not depend on a fee-charging protocol operator. Revenue comes from optional hardware, settlement, liquidity, privacy, support, and infrastructure services.

## Related docs

- [Master architecture](./master-architecture.md)
- [Register and checkout](./register-and-checkout.md)
- [Ethereum accounts and assets](./ethereum-accounts-and-assets.md)
- [Privacy routes](./privacy-routes.md)
- [Trust, manufacturing, and compromise response](./trust-and-manufacturing.md)
- [Open questions](./open-questions.md)

## Commercial boundary

Users can:

- hand coins to one another;
- verify locally with open software;
- query their own node or provider;
- rotate or claim through compatible infrastructure;
- choose their own trust and asset policies;
- self-settle.

A company may charge for:

- coins and verifier hardware;
- merchant registers and support;
- managed claim submission;
- immediate merchant credit;
- fiat or crypto conversion;
- private refresh and proving services;
- enterprise software;
- certification and conformance services;
- optional operator infrastructure.

No one provider is presumed exclusive.

## Managed merchant settlement

A merchant may choose to surrender claimed coin value to a settlement provider.

```text
customer coin
  -> register verifies and obtains claim authorization
  -> represented asset transfers onchain to provider treasury
  -> provider credits merchant in selected fiat or crypto asset
  -> provider later consolidates, converts, or rebalances
```

Calling this "offchain settlement" can be misleading. The merchant credit may be offchain and immediate, but acquisition of the represented asset still relies on an onchain account operation unless the chosen asset system provides another settlement mechanism.

The merchant can bypass the provider and keep, recirculate, or self-claim coins.

### Provider acquisition boundary

The merchant owns the active coin or pending claim after the customer-approved
physical acceptance gate. A provider assumes risk only when it issues a signed
`ProviderAcceptance` bound to:

```text
settlementId
merchant beneficiary
accepted claim or coin references
payout asset and amount
fees and quote
acceptance time and expiry
accepted status and finality policy
```

Before that signed event, submission, chain, freeze, and counterfeit risk remain
with the merchant. After it, the provider bears the acquisition and payout risks
described by those terms. A provider failure does not recreate a customer
obligation or authorize a bearer-protocol clawback.

For a multi-coin basket, provider acceptance identifies either the complete
atomic `BasketClaim` or an explicit accepted subset. It never silently converts a
partial physical basket into a completed provider acquisition. Any customer
remedy for partial gate crossing remains the merchant's obligation unless the
provider separately and explicitly accepts that obligation in the signed terms.

### Quote-source relationship

No provider becomes the protocol's exchange-rate authority. A merchant that
self-settles may choose its own disclosed source. A merchant requesting issuer or
managed-settlement service may be required by that commercial relationship to
use the issuer's or provider's source, maximum age, spread, and fee policy. The
provider binds those conditions into its signed terms; the register binds the
resulting source, rates, spread, fees, and quote-acceptance deadline into the
customer-approved basket.

The customer may reject the quote, and another merchant or provider may publish a
different policy. Once approved before the deadline, the commercial value and
change obligation remain locked even if later submission, conversion, or payout
occurs at a different market rate. The merchant or provider bears that later
price risk according to their agreement.

## Settlement risk

If a provider credits the merchant before sufficient finality, it assumes short-duration principal risk:

- earlier hidden key compromise or conflicting authorization;
- failed or stale claim operation;
- chain reorganization or finality policy;
- smart-account defect;
- token freeze, upgrade, pause, or transfer behavior;
- price movement and conversion slippage;
- merchant or register fraud;
- banking and payout delay.

This differs from card chargeback risk but is not automatically smaller. It is concentrated around hardware authenticity, claim execution, and chain finality rather than disappearing.

Risk policy may vary by:

- coin denomination;
- hardware model and warning status;
- verification level;
- asset and contract;
- merchant history;
- register identity, bond, or insurance;
- broadcast and confirmation status;
- current liquidity and volatility.

The pilot should test several policies rather than hardcode one.

Standard-register offline acceptance does not create a claim authorization or a
provider credit request. A provider may accept an active physical coin under its
own terms, but managed claim credit requires the online preflight and signed
`ProviderAcceptance`. If connectivity fails after authorization capture, the
merchant retains the pending claim until the provider explicitly accepts it or
the merchant settles it independently.

## Register-operator roles

The proposed operator suite has four independent roles.

### Light or proof verifier

Verifies chain evidence locally or serves verified results to attached registers.

- Improves assurance.
- Does not earn Ethereum protocol rewards merely by verifying.
- Can run on a companion device rather than the mechanical controller.
- Remains experimental while production light-client support is immature.

### ERC-4337 bundler

Receives `UserOperation`s, simulates validation, groups valid operations, submits `EntryPoint.handleOps`, fronts transaction gas, and receives the configured beneficiary fees and reimbursement.[^erc4337]

A production bundler needs:

- reliable execution RPC with tracing and simulation;
- persistent network connectivity;
- a gas-funded transaction sender;
- nonce, replacement, and inclusion management;
- monitoring and abuse controls;
- correct support for the chosen EntryPoint and mempool rules.

It need not be an Ethereum validator and does not require 32 ETH. It may use a local full node or suitable remote infrastructure.

Bundler revenue is not guaranteed. Margins depend on user fees, gas estimation, competition, failed inclusion, and service volume. Product-defined revenue share may be more material than native bundling margin.

### Privacy relayer

Submits private-refresh transactions or proofs for a fee without receiving the monetary private key.

It should be isolated from merchant acceptance logs and should not preferentially relay the same register's newly accepted coins without delay or mixing.

### Trust-feed mirror

Mirrors manufacturer, laboratory, monitor, firmware, and asset-policy manifests.

This improves availability but has no native protocol reward. A commercial network may subsidize measurable mirror service, while the data remains freely replicable.

## Deployment tiers

```text
base register
  -> mechanical verification and claim
  -> ordinary network provider

advanced register + companion
  -> proof verification or experimental light client
  -> local policy and feed mirror

operator deployment
  -> full node or high-assurance provider
  -> bundler
  -> isolated privacy relayer
  -> managed settlement services
```

The companion boundary protects the register's security-critical mechanical and secure-command functions from a large general-purpose software stack.

## Cross-network operator suite

The same companion platform may later host Bitcoin nodes, Lightning routing or liquidity services, proof servers, privacy relayers, and other chain-specific infrastructure. These services are optional modules with separate trust and resource requirements; installing one must not change the coin's physical verification and claim semantics.

## Revenue sharing

An optional network may share managed-settlement revenue with operators that provide measurable work, such as:

- included bundles;
- valid proof service;
- relay capacity;
- mirror availability;
- regional uptime;
- merchant support.

The design must avoid easy reward farming through fake traffic or self-reported availability. Qualification, measurement, bonds, and penalties are later commercial choices, not protocol requirements.

## Hardware economics

Registers may be:

- subsidized or leased to merchants;
- sold at cost for basic acceptance;
- sold at a margin for home or hobbyist verification;
- offered as premium operator hardware with companion compute.

Coins may be sold separately from represented value. Empty functional coins can be repurchased cheaply for redistribution or refurbishment.

A finite core makes useful life and replacement cost explicit. A renewable core may lower recycling frequency but requires a different security case.

## Fee location

Natural fee points are optional services:

- claim submission and gas sponsorship;
- immediate merchant credit;
- asset conversion;
- private refresh;
- enterprise software and support;
- certification and conformance testing.

There should be no protocol fee on physical handoff or local verification.

## Fee-band treasury policy

A settlement provider or self-settling merchant may define cost bands for queued operations:

```text
green: submit or consolidate now
amber: submit urgent claims, defer optional maintenance
red: preserve liquidity, use alternative sponsor or wait where safe
```

The bands are operational policy, not a recurring protocol charge. ERC-4337 bundling can amortize some shared overhead, but each account operation still consumes gas.

## Investor and pilot model

The business is viable only if:

```text
service revenue
  > network and payout cost
  + fraud and failure loss
  + liquidity and conversion cost
  + hardware subsidy and depreciation
  + support, certification, and operations
```

Variables worth modeling before a pilot:

- coin and register bill of materials by volume;
- secure-core useful life and failure rate;
- average denomination and coins per purchase;
- physical circulation count before claim;
- recirculation versus managed-settlement rate;
- gas per claim, rotation, deployment, and migration;
- bundler and paymaster cost;
- merchant payout and banking cost;
- fraud and false-reject rates;
- price volatility and hedge cost;
- empty-coin recovery rate;
- support and replacement cost;
- revenue share paid to operators.

Pilot measurements should include customer comprehension, time per coin, jam rate, quote expiry, partial claim failure, offline acceptance behavior, and which assurance levels merchants actually use.

## First-market constraint

The first market must test repeated physical circulation. A market where every recipient immediately claims the asset validates a hardware redemption token, not physical bearer cash.

Candidate pilots should therefore have:

- concentrated local users;
- repeated small payments;
- enough crypto familiarity to tolerate an experimental verifier;
- controlled denominations and test exposure;
- merchants willing to recirculate at least some coins.

## References

[^erc4337]: [ERC-4337: Account Abstraction Using Alt Mempool](https://eips.ethereum.org/EIPS/eip-4337), including bundler simulation, EntryPoint, and paymaster behavior.
