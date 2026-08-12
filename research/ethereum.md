# Ethereum research log

## Covered areas

- ERC-4337 EntryPoint nonce consumption after included execution failure.
- ERC-4337 canonical-mempool handling of signed claim expiry.
- Replay of offchain account authorization across a same-chain-ID contentious split.
- EIP-7951 P-256 precompile eligibility during canonical ERC-4337 validation.
- Shared counterfactual-factory reputation as an ERC-4337 claimability dependency.
- Shared-paymaster reputation and aggregate deposit admission in the canonical ERC-4337 mempool.
- Residual secp256k1 authority in ERC-4337 accounts using EIP-7702 delegation.
- ERC-4337 signature aggregators as authorization and shared canonical-mempool dependencies.
- ERC-4337 optional `executeUserOp` dispatch and direct-relay equivalence.
- EIP-1153 transient-storage lifetime across ERC-4337 validation and execution.

## Research entries

### 2026-07-16 - Review 1

- **Area:** EntryPoint nonce consumption and retry after included account or paymaster execution failure.
- **Investigation:** Inspected ERC-4337 ordering and the released v0.8 EntryPoint and NonceManager implementations.
- **Primary sources:** [ERC-4337](https://eips.ethereum.org/EIPS/eip-4337), [EntryPoint v0.8](https://github.com/eth-infinitism/account-abstraction/blob/releases/v0.8/contracts/core/EntryPoint.sol), [NonceManager v0.8](https://github.com/eth-infinitism/account-abstraction/blob/releases/v0.8/contracts/core/NonceManager.sol).
- **Material facts:** `userOpHash` binds transport fields. EntryPoint increments nonce before execution and can record an execution failure without reverting that nonce update.
- **RFC implication:** Exact transport authorization is not a retryable artifact after an included revert.
- **Disposition:** Produced C-061.

### 2026-07-16 - Review 002

- **Area:** ERC-4337 canonical-mempool handling of signed claim expiry.
- **Investigation:** Compared the RFC's signed `validUntil` checks with ERC-4337 validity-window encoding, EntryPoint enforcement, and ERC-7562 validation-phase restrictions.
- **Primary sources:** [ERC-4337](https://eips.ethereum.org/EIPS/eip-4337), [ERC-7562](https://eips.ethereum.org/EIPS/eip-7562), [EntryPoint v0.8](https://github.com/eth-infinitism/account-abstraction/blob/releases/v0.8/contracts/core/EntryPoint.sol).
- **Material facts:** ERC-4337 encodes `validUntil` and `validAfter` in returned `validationData`. ERC-7562 forbids `TIMESTAMP` and `NUMBER` during canonical-mempool validation, although execution is unrestricted. An account that directly reads those values while validating expiry can execute correctly through EntryPoint yet be rejected by conforming bundlers; direct relay also needs equivalent expiry enforcement.
- **RFC implication:** Define a normative profile that authenticates signed bounds, returns them through `validationData`, passes ERC-7562 tracing, and aligns direct-relay boundary behavior.
- **Disposition:** Accepted as C-065.

### 2026-07-16 - Review 003

- **Area:** Replay of offchain account authorization across a same-chain-ID contentious split.
- **Investigation:** Compared the RFC's `chainId` domains with EIP-155, EIP-712, EIP-1344, and ERC-4337, then traced identical pre-split account, EntryPoint, balance, and nonce state onto two same-ID descendants.
- **Primary sources:** [EIP-155](https://eips.ethereum.org/EIPS/eip-155), [EIP-712](https://eips.ethereum.org/EIPS/eip-712), [EIP-1344](https://eips.ethereum.org/EIPS/eip-1344), [ERC-4337](https://eips.ethereum.org/EIPS/eip-4337).
- **Material facts:** EIP-712 leaves replay protection to applications, and EIP-1344 identifies same-ID contentious descendants as unsafe for transaction and typed-data replay protection. ERC-4337's `userOpHash` remains identical when the operation, EntryPoint, and `chainId` match. Replicated nonces serialize execution only within each descendant ledger, so one authorization can execute once on both.
- **RFC implication:** Specify a contentious-split policy that pauses authorization during ambiguity or binds new intents to a finalized post-split domain, and treats still-live pre-split authorizations as replayable across descendants.
- **Disposition:** Accepted as C-066.

### 2026-07-16 - Review 004

- **Area:** EIP-7951 P-256 precompile eligibility during canonical ERC-4337 validation.
- **Investigation:** Compared ERC-7562's accepted-precompile rules with EIP-7951's RIP-7212-compatible interface and Ethereum execution-spec tests for activation, call behavior, gas, and invalid signatures.
- **Primary sources:** [ERC-7562](https://eips.ethereum.org/EIPS/eip-7562), [EIP-7951](https://eips.ethereum.org/EIPS/eip-7951), [Ethereum execution specifications](https://github.com/ethereum/execution-specs), [EIP-7951 execution-spec tests](https://eest.ethereum.org/main/tests/osaka/eip7951_p256verify_precompiles/test_p256verify/).
- **Material facts:** ERC-7562 permits known stateless accepted precompiles, including secp256r1 where active. EIP-7951 uses address `0x100`, costs 6,900 gas, returns a 32-byte `1` only for success, and returns empty data without reverting for invalid input or signatures. A post-Fusaka P-256 validation call is therefore not inherently excluded, but stale tracers and checks based only on call success or code presence are insufficient.
- **RFC implication:** Require chain-aware bundler/tracer support and exact positive-output compatibility tests for P-256 validation.
- **Disposition:** No new complaint; reinforces C-024.

### 2026-07-16 - Review 005

- **Area:** Shared counterfactual-factory reputation as an ERC-4337 claimability dependency.
- **Investigation:** Compared counterfactual deployment verification with ERC-4337 bundler validation, factory caller requirements, ERC-7562 staking and entity-reputation rules, and account-abstraction release behavior.
- **Primary sources:** [ERC-4337](https://eips.ethereum.org/EIPS/eip-4337), [ERC-7562](https://eips.ethereum.org/EIPS/eip-7562), [eth-infinitism account-abstraction releases](https://github.com/eth-infinitism/account-abstraction/releases).
- **Material facts:** ERC-7562 subjects staked factories to bundler-local reputation, refuses banned entities, removes operations referencing them, and attributes undeployed-account validation rejection to the referenced staked factory. Unrelated counterfactual accounts can therefore share a propagation failure despite correct keys, balances, nonces, deterministic addresses, and deployment simulation; the `senderCreator` caller rule prevents copied-`initCode` deployment but does not remove this reputation dependency.
- **RFC implication:** Distinguish onchain deployability from canonical-mempool claimability: deploy and finalize before funding or activation, or define a pinned factory profile, live eligibility reporting, abuse controls, and a tested ETH-funded direct-`handleOps` recovery route.
- **Disposition:** Accepted as C-075.

### 2026-07-16 - Review 006

- **Area:** Shared-paymaster reputation and aggregate deposit admission in the canonical ERC-4337 mempool.
- **Investigation:** Compared sponsored-claim and bundler-switching behavior with ERC-4337 paymaster validation, deposits, stake, `postOp`, replacement behavior, and ERC-7562 reputation and aggregate gas-reservation rules.
- **Primary sources:** [ERC-4337](https://eips.ethereum.org/EIPS/eip-4337), [ERC-7562](https://eips.ethereum.org/EIPS/eip-7562), [EntryPoint v0.9](https://github.com/eth-infinitism/account-abstraction/blob/releases/v0.9/contracts/core/EntryPoint.sol).
- **Material facts:** Paymaster deposits are separate from stake and withdrawable; bundlers repeatedly validate operations, apply local reputation and banned-entity eviction to paymasters, and reserve all referenced operations' aggregate maximum gas exposure against the current deposit. Thus an individually affordable, correctly signed operation can lose admission because of unrelated use, deposit movement, or local reputation, while the paymaster remains liable for reverted execution.
- **RFC implication:** Treat sponsorship as a live transport condition, with deposit and eligibility monitoring plus tested sponsorship replacement or direct submission that preserves the monetary intent.
- **Disposition:** No new complaint; reinforces C-075, C-064, C-061, C-020, and C-049.

### 2026-07-16 - Review 007

- **Area:** Residual secp256k1 authority in ERC-4337 accounts using EIP-7702 delegation.
- **Primary sources:** [EIP-7702](https://eips.ethereum.org/EIPS/eip-7702), [ERC-4337](https://eips.ethereum.org/EIPS/eip-4337), [ERC-7769](https://eips.ethereum.org/EIPS/eip-7769).
- **Material facts:** EIP-7702 lets a secp256k1 EOA authority replace or clear its delegation indicator, and delegated code executes in that authority account's context; processed delegation changes survive later outer-transaction execution failure. ERC-4337 supports this account form and binds the desired delegate into the operation hash, but does not transfer delegation authority to the RFC's P-256 key.
- **RFC implication:** The first profile should reject EIP-7702 senders and require verified immutable runtime code; any later EIP-7702 profile must bring the EOA key into the secure-core lifecycle and monetary serialization model.
- **Disposition:** Accepted as C-083.

### 2026-07-16 - Review 008

- **Area:** ERC-4337 signature aggregators as authorization and shared canonical-mempool dependencies.
- **Primary sources:** [ERC-4337](https://eips.ethereum.org/EIPS/eip-4337), [ERC-7562](https://eips.ethereum.org/EIPS/eip-7562), [ERC-7766](https://eips.ethereum.org/EIPS/eip-7766), [EntryPoint v0.9](https://github.com/eth-infinitism/account-abstraction/blob/releases/v0.9/contracts/core/EntryPoint.sol).
- **Material facts:** Accounts may delegate operation authentication to a staked aggregator whose support and reputation are bundler-local; aggregator state can invalidate many operations, and EntryPoint v0.9 reverts an aggregate call when aggregate-signature validation fails. ERC-7766 is withdrawn for lack of production adoption.
- **RFC implication:** The first profile should use in-account P-256 validation without an aggregator; future aggregation must preserve complete coin-intent enforcement and specify authority, code, support, recovery, and measured gas behavior.
- **Disposition:** No new complaint; reinforces C-083, C-075, C-065, C-024, and C-025.

### 2026-07-16 - Review 009

- **Area:** ERC-4337 optional `IAccountExecute.executeUserOp` dispatch and direct-relay equivalence.
- **Primary sources:** [ERC-4337](https://eips.ethereum.org/EIPS/eip-4337), [EntryPoint v0.9](https://github.com/eth-infinitism/account-abstraction/blob/releases/v0.9/contracts/core/EntryPoint.sol), [IAccountExecute v0.9](https://github.com/eth-infinitism/account-abstraction/blob/releases/v0.9/contracts/interfaces/IAccountExecute.sol).
- **Material facts:** In ordinary mode EntryPoint forwards `userOp.callData`; when its prefix is the `executeUserOp` selector, EntryPoint instead reconstructs a call containing the complete operation and computed hash. The selector marker is therefore not an equivalent direct call, and the execution hook must authenticate EntryPoint rather than trust caller-supplied transport context.
- **RFC implication:** Pin one execution ABI, protect `executeUserOp` with an EntryPoint-only boundary, independently enforce the complete inner intent and persistent semantic nonce, and provide a separately tested direct-relay method.
- **Disposition:** No new complaint; reinforces C-002, C-004, C-010, C-020, C-025, C-061, C-064, C-065, and C-083.

### 2026-07-16 - Review 010

- **Area:** EIP-1153 transient storage across ERC-4337 bundle-wide validation and later per-operation execution.
- **Primary sources:** [EIP-1153](https://eips.ethereum.org/EIPS/eip-1153), [ERC-4337](https://eips.ethereum.org/EIPS/eip-4337), [ERC-7562](https://eips.ethereum.org/EIPS/eip-7562), [EntryPoint v0.9](https://github.com/eth-infinitism/account-abstraction/blob/releases/v0.9/contracts/core/EntryPoint.sol).
- **Material facts:** Transient state is contract-private but shared for the outer transaction and cleared only at transaction end; ERC-4337 validates the bundle before executing its operations. Validation-set flags or hashes can therefore be overwritten, consumed by another operation, or remain visible later, while ERC-7562 applies canonical storage-access rules to `TLOAD` and `TSTORE` as it does to persistent storage.
- **RFC implication:** Do not use transient state as monetary authorization or replay state. Namespace and clear any transient lock or optimization, test nested calls, reverts, and multi-operation bundles, and retain complete-intent authentication plus persistent execution-time nonce consumption.
- **Disposition:** No new complaint; reinforces C-004, C-010, C-020, C-061, C-065, C-075, and C-083.
