# Protocol and state-machine research log

## Covered areas

- ECDSA nonce generation as signing state under reset, retry, and recovery operations.
- Verifier challenge entropy, single-use handling, and rollback behavior.
- Replacement-key proof of possession and same-core origin binding during authority rotation.
- Replay separation between semantic monetary intents and ERC-4337 transport authorization.
- P-256 verification, malleability, public-key validity, possession, and owner binding.
- Authorization-key cryptoperiods, lifecycle states, usage association, compromise, and destruction.

## Research entries

### 2026-07-16 - Review 1

- **Area:** P-256 ECDSA nonce generation under adversarial reset, retry, and recovery signing.
- **Investigation:** Distinguished persistent-state atomicity from cryptographic signer state using NIST, RFC, and Java Card specifications.
- **Primary sources:** [NIST FIPS 186-5](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-5.pdf), [RFC 6979](https://www.rfc-editor.org/rfc/rfc6979.html), [RFC 9053](https://www.rfc-editor.org/rfc/rfc9053.html), [Java Card Runtime Environment 3.2](https://docs.oracle.com/en/java/javacard/3.2/jc-re-spec/F74157_03.pdf).
- **Material facts:** Repeated ECDSA `k` values disclose the signing key. Java Card transaction semantics protect selected persistent updates but do not define nonce generation or atomically bind signer state to response transport.
- **RFC implication:** Crash consistency must include signer nonce behavior as well as lifecycle fields and stored authorization bytes.
- **Disposition:** Independently produced the failure mode recorded as C-055.

### 2026-07-16 - Review 2

- **Area:** Verifier-generated challenge entropy, unpredictability, single-use handling, and lifecycle across reboot.
- **Investigation:** Compared the RFC's reader nonce with WebAuthn challenge rules and NIST cryptographic-authenticator requirements.
- **Primary sources:** [WebAuthn Level 3](https://www.w3.org/TR/webauthn-3/#sctn-cryptographic-challenges), [NIST SP 800-63B-4](https://pages.nist.gov/800-63-4/sp800-63b/authenticators/).
- **Material facts:** WebAuthn requires trusted random generation, issued-challenge matching, temporary retention, and at least 16 bytes. NIST requires unique or statistically unique challenges from an approved random generator.
- **RFC implication:** Freshness needs a normative generation and session profile for resettable offline verifiers.
- **Disposition:** Produced C-060.

### 2026-07-16 - Review 3

- **Area:** Replacement-key proof of possession and authenticated same-core origin during account-key rotation.
- **Investigation:** Compared the RFC's old-key authorization of `newKey` with certificate-enrollment proof-of-possession and authenticator-bound credential registration.
- **Primary sources:** [RFC 4211](https://www.rfc-editor.org/rfc/rfc4211.html), [RFC 9733](https://www.rfc-editor.org/rfc/rfc9733.html), [WebAuthn Level 3](https://www.w3.org/TR/webauthn-3/).
- **Material facts:** An old-key signature authorizes replacement bytes but does not prove control of the corresponding new private key or bind that key to the intended secure core. Enrollment standards distinguish possession from authenticated origin; WebAuthn attestation can bind a generated credential key to authenticator data.
- **RFC implication:** Rotation must install only the core's durably staged next key and require account-verifiable proof of new-key possession and same-core origin before authority changes.
- **Disposition:** Candidate PSM-003-001 accepted as C-072.

### 2026-07-16 - Review 4

- **Area:** Replay separation between relayer-independent EIP-712 monetary intents and ERC-4337 transport signatures, nonce lanes, validation, and execution.
- **Investigation:** Compared EIP-712 and ERC-4337 requirements with the RFC's semantic nonce, pending-intent retry, wrapper authorization, and direct-relay path, including the reference EntryPoint v0.9 implementation.
- **Primary sources:** [EIP-712](https://eips.ethereum.org/EIPS/eip-712), [ERC-4337](https://eips.ethereum.org/EIPS/eip-4337), [EntryPoint v0.9](https://github.com/eth-infinitism/account-abstraction/blob/develop/contracts/core/EntryPoint.sol).
- **Material facts:** EIP-712 supplies typed domain separation but no replay protection. ERC-4337 transport nonces have independent keyed lanes, and validation precedes execution, so they cannot replace a globally serialized semantic nonce rechecked and consumed during execution.
- **RFC implication:** Keep one global monetary-operation nonce, bind wrapper-specific authorization to calldata, EntryPoint, and account-paid costs, and permit a new bounded wrapper for the identical pending intent after transport-only failure.
- **Disposition:** No new complaint; reinforces C-002, C-004, C-020, and C-061.

### 2026-07-16 - Review 5

- **Area:** P-256 mathematical verification, application-level malleability, public-key validity, private-key possession, and owner binding.
- **Investigation:** Compared EIP-7951's exact precompile contract with FIPS 186-5 validation assurances at smart-account verification and replacement-key installation boundaries.
- **Primary sources:** [EIP-7951](https://eips.ethereum.org/EIPS/eip-7951), [NIST FIPS 186-5](https://doi.org/10.6028/NIST.FIPS.186-5).
- **Material facts:** EIP-7951 accepts a canonical 160-byte input, returns exactly a 32-byte `1` only on success, permits both valid ECDSA `s` forms, and leaves non-malleability to applications. A valid signature under an on-curve point does not establish private-key possession or bind that key to an owner.
- **RFC implication:** Pin encoding, prehash, exact success handling, invalid-point vectors, and an explicit low-`s` policy where signature bytes affect identity; separately require possession and same-core origin proof for rotation.
- **Disposition:** No new complaint; reinforces C-024 and C-072, with C-058 covering offchain signature-byte deduplication.

### 2026-07-16 - Review 6

- **Area:** Authorization-key cryptoperiods and pre-activation, active, deactivated, compromised, and destroyed states, including integrity of key usage and application associations.
- **Investigation:** Mapped NIST's system-level asymmetric-key lifecycle model to the RFC's monetary-key states and tested cryptoperiod expiry, suspected compromise, pre-activation misuse, metadata substitution, and premature destruction against C-001 through C-074.
- **Primary sources:** [NIST SP 800-57 Part 1 Revision 5](https://doi.org/10.6028/NIST.SP.800-57pt1r5).
- **Material facts:** Pre-activation authorization keys are limited to possession or confirmation uses; active private keys create authorizations only within their cryptoperiod; deactivated or compromised keys must not create new protection; suspected confidentiality or integrity loss requires compromise handling and revocation. Key compromise includes substitution, deletion, wrong-purpose or wrong-application use, and loss of metadata association. Destruction of key material is distinct from retention of lifecycle metadata.
- **RFC implication:** Formally distinguish staged, active, pending or deactivating, compromised, retired, and destroyed monetary-key states; bind keys to account, asset, epoch, operation domain, and permitted use; define measurable exposure limits; and defer destruction until recoverable completion. These requirements are already represented by C-002, C-004, C-005, C-008, C-009, C-018, C-047, C-059, and C-072; a compromise label alone cannot revoke bearer authority or distinguish a genuine core from a clone.
- **Disposition:** No new complaint; reinforces existing lifecycle, serialization, retirement, compromise-exposure, and replacement-key complaints.
