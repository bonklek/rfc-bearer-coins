# Trust, manufacturing, and compromise response

The product needs hardware provenance without turning one manufacturer, laboratory, repository, or application into a monetary authority.

Trust information is advisory. A recipient decides whether to accept a physical coin; a commercial service decides whether to acquire it. Neither decision changes the underlying ability to hand over the object or submit an otherwise valid onchain authorization.

## Related docs

- [Master architecture](./master-architecture.md)
- [Coin hardware](./coin-hardware.md)
- [Verification and BSLRR](./verification-and-bslrr.md)
- [Key lifecycle and claim protocol](./key-lifecycle.md)
- [Open questions](./open-questions.md)

## Fresh key versus fresh core

These are different claims:

```text
fresh monetary key != newly manufactured secure core
```

An existing core can generate a new key. It cannot certify itself as a newly manufactured core unless an accepted external manufacturing process has issued a credential for a new immutable core identity.

An exhausted finite core must not regain a fresh lifecycle identity through local reset.

## Candidate provisioning flow

1. Core establishes an immutable hardware identity or hardware-bound secret.
2. Core generates an attestation key internally.
3. Factory verifies model, secure application, lifecycle, and disabled debug state.
4. Per-core attestation public key or a privacy-preserving commitment enters a production batch manifest.
5. Manufacturer and any required independent witnesses sign the batch manifest.
6. Manifest enters one or more append-only transparency logs.
7. After an optional observation period, client policies may begin recommending the batch.
8. Core can later prove that its current monetary key originated from the certified core and lifecycle.

The exact physical-identity mechanism may use one-time-programmable state, a hardware unique key, a PUF-derived root, mask data, or a combination. The protocol should not claim those mechanisms are interchangeable without evaluating their attack models.

## Signing roles

One unrestricted "manufacturer key" is too large a failure domain. Candidate roles are:

### Ecosystem or policy roots

- offline or rarely used;
- threshold-controlled;
- authorize subordinate roles and metadata formats;
- replaceable through explicit root updates.

There need not be one ecosystem root. Different clients can trust different root sets.

### Manufacturer authorization key

Authorizes a narrow production scope:

- manufacturer and facility;
- model;
- firmware or secure-application hashes;
- time window;
- quantity ceiling;
- permitted batch-signing keys.

### Batch issuance key

- short-lived;
- bound to one batch and sequence number;
- unable to authorize another model, facility, or period.

### Laboratory report key

Signs an evaluation report and attack profile for a model or configuration. It should not issue per-core manufacturing credentials.

### Core attestation key

Generated inside a core and used to authenticate core-originated statements. A privacy-preserving implementation may replace direct exposure with class- or batch-membership proofs.

Role separation, expiration, thresholds, and rollback protection have useful precedent in The Update Framework, although a hardware minting pipeline is not a software-update repository.[^tuf]

## Batch precommitment

A batch manifest may commit to all planned core identities:

```text
batch_root = MerkleRoot(core_identity_commitment_1, ... core_identity_commitment_n)
```

The manifest includes:

- batch root and count;
- model and configuration;
- facility and production interval;
- firmware or secure-application hash;
- laboratory profile references;
- sequence number and previous-manifest hash;
- activation and expiry metadata;
- signatures required by the publisher's policy.

Batch precommitment prevents a stolen batch key from silently appending identities to an already fixed root. It does not prove that every committed identity corresponds to one physically produced secure core, that no extra uncertified cores exist, or that the factory did not collude. Factory audits and independent witnesses address different parts of that problem.

## Transparency logs

Append-only logs make issuance observable and can provide inclusion and consistency evidence. Sigstore's Rekor is a relevant example of a transparency log with inclusion-proof and integrity-verification interfaces.[^rekor]

Transparency does not automatically prevent:

- a log from withholding entries from some clients;
- equivocation without gossip or witness comparison;
- a validly logged but malicious batch;
- false physical-production claims;
- tracking if inclusion proofs expose stable core identities.

Independent mirrors, monitors, signed tree heads, gossip, and multiple witnesses are needed if the log becomes security-critical.

## Delayed activation

A client policy may recommend an observation delay between batch publication and routine acceptance. Monitors can compare expected model, facility, quantity, and laboratory references before the batch becomes broadly recommended.

The delay is advisory. A recipient may accept a newly published batch immediately.

## Client-selected trust feeds

Manufacturers, laboratories, auditors, asset-policy maintainers, applications, and independent monitors may publish signed manifests.

Clients can obtain them through:

- ordinary HTTPS mirrors;
- Git repositories;
- content-addressed storage;
- register gossip;
- application bundles;
- offline update packages.

Each application may ship a recommended policy set. Users can add or remove publishers. FIDO's metadata architecture is useful precedent for model metadata and relying-party policy, but this proposal deliberately avoids one required metadata service.[^fido]

## Advisory status model

Feeds may describe:

- accepted;
- warning;
- endangered;
- suspected batch compromise;
- firmware vulnerability;
- laboratory-report problem;
- manufacturer-key compromise;
- recommended migration;
- certificate cutoff time.

The correct relationship is:

```text
signed security information
  -> recipient-selected or provider-selected policy
```

It is not:

```text
signed security information
  -> protocol-wide invalidation
```

Applications may recommend live backing checks, immediate claim, migration, or avoiding offline acceptance. Recipients may ignore those recommendations.

## Scoped compromise response

Different failures should have different blast radii.

| Compromise | Likely effect | Candidate containment |
|---|---|---|
| Lab report key | Fraudulent evaluation reports | Withdraw affected reports; cross-check other labs; do not automatically condemn unrelated batches. |
| Batch key | Fraudulent manifest inside its allowed scope | Short validity, fixed batch root/count, sequence monitoring, witness signatures. |
| Manufacturer authorization key | Unauthorized batches within apparent scope | Independent approval, transparency monitoring, facility/time/quantity constraints. |
| App recommendation key | Misleading local policy | Competing clients and feeds; key rotation; signed update history. |
| Register operator key | Fraudulent receipts or service activity | Legal attribution, bond/insurance where chosen, operator-key revocation. |
| Hardware design | Possible monetary-state compromise | Model warning, live-check recommendation, migration campaign, lower acceptance limits. |

Time cutoffs can distinguish previously logged batches from later suspicious issuance, but only if log timestamps and compromise timing are trustworthy enough for the selected policy.

## Privacy-preserving attestation

A unique attestation public key disclosed at every verification is a tracking identifier. Long-term designs should prove:

```text
this core is a member of accepted class or batch R
```

without revealing which exact core it is.

Candidate mechanisms include:

- shared batch attestation credentials;
- group signatures;
- direct anonymous attestation;
- zero-knowledge Merkle membership;
- short-lived unlinkable credentials derived under hardware control.

Privacy and precise per-core revocation are in tension. The first-generation choice must state its tracking and revocation tradeoffs plainly.

## Endangered-coin migration

A migration program preserves recoverable backing; it does not compensate losses.

```text
recoverable backing = x
  -> replacement coin receives x

recoverable backing = 0
  -> replacement coin receives 0
```

The old coin must still be able to authorize movement or the funds must be recoverable under a policy chosen before failure. Adding a universal manufacturer recovery key would weaken bearer ownership and is not part of the baseline design.

Migration can be performed by any compatible provider. A participating vulnerability-response program should replace its functioning endangered hardware and move recoverable backing without charging the holder for the replacement; this is a warranty policy, not value compensation. Returned endangered cores should be retired and analyzed where lawful and useful.

A core that reports `TAMPER_SUSPECTED` follows the same recoverable-backing rule:
if its one exact evacuation can move `x`, a replacement may be loaded with `x`;
if the key cannot operate or the backing was already taken, no balance is
created. The returned core becomes permanently tamper-retired and is never reset.

## Refurbishment

Reusable parts may include the shell, display, antenna, buttons, and other non-security-critical components if inspection and resealing are credible.

The exhausted finite secure core is replaced, not reset. The replacement core receives a new external manufacturing credential and begins empty.

An empty functional coin may carry a small repurchase or recycling value. Lost coins and irrecoverably damaged backing are bearer losses.

## References

[^tuf]: Justin Cappos et al., [Survivable Key Compromise in Software Update Systems](https://theupdateframework.io/papers/survivable-key-compromise-ccs2010.pdf), the security basis for role separation used by The Update Framework.
[^rekor]: Sigstore, [Rekor transparency log overview](https://docs.sigstore.dev/logging/overview/).
[^fido]: FIDO Alliance, [FIDO Metadata Service](https://fidoalliance.org/specs/mds/fido-metadata-service-v3.0-ps-20210518.html).
