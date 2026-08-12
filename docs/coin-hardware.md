# Coin hardware

The hardware target is a passive token that can authenticate itself, maintain irreversible monetary state, and authorize a narrow operation while powered by an external reader.

This document separates features already common in adjacent hardware from the product-specific primitive that remains unproven.

## Related docs

- [Master architecture](./master-architecture.md)
- [Architecture B: hardware-held shielded notes](./architecture-b-commitment-pool.md)
- [Key lifecycle and claim protocol](./key-lifecycle.md)
- [Verification and BSLRR](./verification-and-bslrr.md)
- [Trust, manufacturing, and compromise response](./trust-and-manufacturing.md)
- [Open questions](./open-questions.md)

## Candidate component stack

```text
universal shell
|-- passive NFC antenna
|-- two side buttons
|-- center button
|-- secure core
|-- nonvolatile lifecycle state
|-- persistent display
`-- passive tamper-evident structures
```

The secure core may be one programmable secure MCU or a secure element paired with a host controller. GlobalPlatform defines a secure element as a tamper-resistant platform capable of hosting applications and confidential cryptographic data, but that general definition does not certify this coin's state machine.[^secure-element] A two-chip design is acceptable only if the host cannot request arbitrary monetary signatures or forge display and lifecycle state.

The monetary state machine must execute within the trusted boundary. A chip that merely stores a key and signs arbitrary host-provided bytes is insufficient.

Under Architecture A, the core's monetary key authorizes an identifiable smart
account. Under Architecture B, the core additionally retains or controls the
private material for one hidden note commitment and its deterministic nullifier.
The host may obtain narrowly bound signatures and proof witness material only as
defined by the selected profile; it must not be able to redirect a claim, create a
second note authority, or cause premature nullifier disclosure outside that
profile.

## Batteryless operation

The coin harvests energy from an NFC field during intentional use. Ordinary physical transfer and storage require no power.

Batteryless operation improves shelf life and removes charging and battery-replacement failure, but it creates constraints:

- no continuous active tamper monitoring while the coin is unpowered;
- no independent network connection;
- limited energy and time for display updates and cryptography;
- adversarial power interruption at any protocol step;
- two passive coins cannot directly power one another.

An app, verifier, register, or contact pad supplies the field.

### Operation-specific power profiles

The first profile distinguishes stateless inspection from persistent mutation:

```text
VERIFY_STATELESS   phone-compatible target; no persistent state change
HANDOFF_LOG        powered-reader profile when continuity state is written
CLAIM              powered-reader profile
LOAD_PROOF         powered-reader profile
KEY_GENERATION     powered-reader profile
ROTATE_OR_MIGRATE  powered-reader profile
DISPLAY_UPDATE     powered-reader profile
```

Each operation specification contains quantitative minimum harvested power,
coupling and field-stability bounds, reservoir capacity and margin, brownout
threshold, maximum duration, write and compute timing, retry limit, duty cycle,
and thermal limit. Before any persistent mutation, the core measures actual field
and reservoir conditions and refuses before state change if the complete operation
margin is unavailable.

A powered reader is an open conformance profile, not a licensed operator. It may
be a merchant register, USB home pad, or independently manufactured reader. A
phone may perform a heavier operation only after that model and coupling geometry
are shown to satisfy the same measurements. Reader qualification does not weaken
the requirement that removing power at any instruction boundary leaves a defined
recoverable old or new state.

## Deliberate activation and anti-skimming

At rest, the NFC antenna or the secure command path should be physically disconnected. Pressing both side buttons completes the verification path.

```text
no buttons: no powered monetary interface
side buttons: verification interface
side + center: claim interface
```

This is stronger than relying on proximity as consent. The NFC Forum's current roadmap explicitly treats relay-attack protection as ongoing standards work; deliberate mechanical activation is the actual user-presence signal.[^nfc-relay]

Before activation, the coin should expose no stable radio identifier. During verification it should respond to a fresh reader nonce so a recorded response cannot be replayed as a current inspection.

Mechanical activation and a fresh nonce do not prove that the responding core is inside the presented shell. A live relay may forward the session to another deliberately activated genuine coin. Version 1 treats this as a bounded and disclosed residual risk rather than removing offline transfer.

For register claim, the core requires an ordered physical-input ceremony within one bounded session:

```text
side inputs active and center input released
  -> receive and arm one exact ClaimIntent digest
  -> observe a fresh center released-to-pressed transition
  -> authorize only the armed digest
```

A center contact active at session initialization is rejected. This detects a static bridge; it cannot prove that a malicious register did not synthesize the electrical transition. Normal merchant claim therefore trusts the evaluated secure register controller, while optional customer-device verification can independently inspect the armed intent.

The standard register's customer-facing basket-commit lever does not change this
coin-level ceremony. One customer pull may enable several approved claim coins,
but the register must apply a separate bounded session and one complete
`center released -> pressed -> released` cycle to each tracked approved coin. A
continuously held center, missing final release, extra cycle, or center stroke on a
verification-only coin is a mechanism fault. The coin exposes no software command
that substitutes for the required physical inputs.

The assembled prototype must characterize relay behavior using adversarial forwarding equipment, not only ordinary NFC range tests. The test report should cover response timing, session timeout, field interruption, protocol negotiation, reader classes, relay media, false accepts, false rejects, and the maximum demonstrated separation. No version 1 local-attestation result may claim physical co-location unless a separately evaluated distance-bounding profile supports it.

## Display

A bistable e-paper or similar display can retain a label without battery power. Passive NFC-powered evaluation products demonstrate that wireless display refresh is possible, although their size, power, and ruggedness do not establish feasibility for this coin.[^epaper] The first-generation face shows:

- represented asset;
- amount or denomination;
- relevant local status such as empty, warning, or claim pending;
- optionally remaining finite key epochs.

The first product supports one chain per asset, so the chain is not required on the physical display. The verifier client always shows chain ID and exact asset metadata.

The display is not authoritative. It can become stale after compromise or external asset-contract action, and an attacker may attempt a physical overlay or bus substitution. The secure core should authenticate the corresponding display payload, and a verifier should compare that signed payload with what the user sees.

The coin does not observe the chain continuously. During loading, however, it accepts a finality-rooted proof supplied by an untrusted reader and verifies that proof internally. It commits `ACTIVE` and the corresponding active display record only after complete proof verification. This makes the activation transition atomic locally; it does not turn the display into a perpetual live view of chain state.

## Two cryptographic roles

### Attestation key

The attestation key identifies a core or hardware class that a verifier may
accept under its selected hardware policy. It signs statements about:

- firmware or secure-application profile;
- current key epoch;
- represented-asset metadata;
- local lifecycle state;
- counters and optional BSLRR root;
- a fresh verifier nonce.

This key must not control funds.

### Monetary key

The monetary key controls the smart account for the current epoch. Version 1 has
no command or mode that exports it. The core uses it only for account operations
permitted by the state machine. Non-exportability is a security target rather
than a demonstrated property until the complete evaluated configuration exists.

### Required version 1 cryptographic profile

The first hardware profile must use P-256 signatures compatible with EIP-7951,
produce a canonical 64-byte `r || s` encoding, and reject non-canonical public
keys and signatures. ECDSA nonce generation must be deterministic under RFC 6979
or an equivalently analyzed FIPS 186-5 method, with any required state committed
across reset before signature output. Long-lived key generation requires a
profiled entropy source, continuous health tests, startup tests, fail-closed
behavior, and per-device/per-epoch uniqueness evidence. These requirements do
not close C-055 or C-059; implementation and destructive evaluation are still
required.

Separating these roles allows a retired monetary slot to disappear without necessarily destroying the credential needed to report the core's status. Whether retaining attestation after invasive tamper is safe depends on the hardware design.

## Tamper resistance, response, and evidence

These are different properties:

- **Resistance** raises the cost of probing, extraction, fault injection, and state modification.
- **Response** destroys or disables sensitive state after a detected event.
- **Evidence** records or reveals that a possible event occurred.

A batteryless coin can use passive conductive loops, frangible structures, potting, and chip-level sensors. A passive loop is checked only when powered and may be bypassed by a capable attacker; it is evidence, not continuous surveillance. ST documents conductive tamper detection in passive NFC tags, including the simple open/closed loop model.[^st25]

Chip-level secure hardware may add voltage, clock, temperature, light, side-channel, debug-lock, and fault-injection defenses. Exact protections and evaluated configurations are vendor-specific.

### Consumer tamper-state policy

The ordinary profile does not automatically destroy a funded monetary key when a
sensor fires. A confirmed event irreversibly commits a core-signed
`TAMPER_SUSPECTED` record containing the event class, evidence digest, and
monotonic event counter. The core then:

- never reports `ACTIVE` again;
- refuses load-proof activation and future key generation;
- cannot clear the event locally;
- permits the current key to create only one exact all-three-button `EVACUATE`
  authorization through the shared `AUTH_PENDING` mechanism; and
- becomes `TAMPER_RETIRED` after it verifies finalized zero-out and authority
  retirement.

Evacuation preserves recoverable backing after a false positive. It does not make
an extracted key secret again, so the holder may race an attacker. If damage made
the key unusable, the backing remains a bearer loss. The tamper-retired secure
core is replaced and never reset or reloaded.

A destructive-response profile is separate from the consumer baseline. It must
state that sensor activation can destroy funded bearer value and either obtain
explicit acceptance of that risk or bind an onchain recovery authority before
funding.

## Read-once research versus the product primitive

PUF read-once-key research proposes hardware in which reading a key changes the physical feedback state so the same key cannot be reconstructed again.[^pufrok] That is relevant prior art, not a commodity component selection and not evidence that a production coin can meet the requirement.

The first product does not need to output the private key. Its narrower primitive is:

```text
prepare one complete typed ClaimIntent authorization
  -> durably commit the corresponding one-time state
  -> release that authorization
  -> never authorize a conflicting destination from the retired state
```

This remains difficult because a hostile reader can remove power or inject faults between any two observable events.

## Persistent state and power loss

Java Card provides transactions that restore persistent fields to their pre-transaction values after an incomplete update, including power loss.[^javacard] That establishes useful adjacent capability, but rollback-on-tear is not sufficient by itself.

If an authorization leaves the chip before the persistent state commits, transaction rollback is exactly the wrong outcome. The protocol must ensure output follows durable state change.

A candidate implementation is:

1. Canonically hash the complete typed `ClaimIntent` internally.
2. Invoke the monetary key once to create the profile-normalized signature.
3. Atomically store the exact signature bytes, digest, operation, signature profile, epoch, semantic nonce, and `AUTH_PENDING(kind = CLAIM)`, while making the old slot unavailable for every different monetary intent.
4. Commit the transaction.
5. Only then output the stored signature.
6. After power loss, require caller-resupplied canonical intent bytes to match the stored digest and output only the stored signature. Do not invoke the monetary key again.

Whether a selected chip can enforce this sequence against fault injection is a prototype and laboratory question.

The P-256 profile's normalized raw signature is 64 bytes (`r || s`), but the complete pending record also includes its digest, operation and profile identifiers, epoch, semantic nonce, integrity metadata, and transactional-storage overhead. Hardware selection must use the complete worst-case record rather than assuming that a hash alone is resumable.

## Proof-activated loading

A finite-slot core exposes only the next slot after the previous represented load has finality-rooted depletion evidence. The new slot begins as:

```text
AWAITING_LOAD_PROOF(
  slot,
  account,
  monetaryPublicKey,
  assetPolicy,
  representedAmount,
  residualBeneficiary,
  activationChallenge
)
```

The activation challenge is generated inside the core, unique to the slot, and revealed only with that slot. A proof is accepted only when it binds that challenge and every expected account and funding field to authenticated finalized chain state.

Proof bytes may be received in chunks and staged outside the monetary state transaction. No staged byte changes lifecycle or display state. After complete verification, the core atomically commits the proof digest, finalized chain reference, `ACTIVE` state, and authenticated active display payload before returning success. Power loss before commit leaves `AWAITING_LOAD_PROOF`; power loss after commit leaves `ACTIVE`. Replaying the same proof is idempotent, while any different slot or challenge is rejected.

The exact proof system remains a hardware gate. Proof-activated refillability is
a target requirement whose passive feasibility is unproven. Candidate profiles
include direct verification of compressed Ethereum finality and state evidence
or a succinct proof whose public inputs include the pinned chain and fork identity
and complete expected account state. A computational puzzle by itself is
insufficient because an attacker could solve it without producing an onchain
transition.

## Finite versus renewable cores

### Selected version 1 finite profile

A finite core contains an irreversible maximum epoch count and storage for the
current monetary key. It contains no future monetary keys.
After finalized depletion retires the current epoch, its internal entropy source
generates the next key and one crash-consistent transaction installs that key,
advances the epoch, and makes the old key inaccessible. The public key is released
only after this transaction commits.

This architecture prevents a simple read of a preloaded key bank because no such
bank exists. It remains dependent on secure key generation, irreversible counting,
old-key destruction, firmware integrity, and resistance to an attacker who can
control the complete core. A finite count is therefore a lifecycle bound, not by
itself evidence of physically separate one-time cells.

Future hardware profiles may use independently protected physical cells. They may
claim a narrower compromise blast radius only after evaluation demonstrates that
attacking the current cell does not expose or control later cells.

### Later renewable profile

A renewable core generates fresh keys indefinitely and relies on non-exportability, secure deletion, firmware policy, and rollback-resistant lifecycle state.

This may be easier to source but places more trust in the secure operating system and implementation. It is not the accepted version 1 lifecycle. Hardware experiments should still compare its security, cost, energy, memory endurance, and manufacturing access with the finite profile.

## Physical prototype tests

The first device should be tested for:

- arbitrary NFC field removal during every instruction boundary;
- voltage and clock glitching;
- repeated claim and rotation requests;
- replay and command reordering;
- host-controller compromise;
- display substitution and stale display state;
- side-button bridging and partial activation;
- passive tamper-loop bypass;
- live NFC relay using wired, radio, and network forwarding paths;
- key-slot rollback;
- counter exhaustion and memory wear;
- side-channel leakage during signing and key activation;
- debug, factory, and reprovisioning paths.

## References

[^pufrok]: Michael Kirkpatrick et al., [PUF ROKs: a hardware approach to read-once keys](https://docs.lib.purdue.edu/ccpubs/434/), ASIACCS 2011.
[^javacard]: Oracle, [Java Card Platform Runtime Environment Specification 3.2](https://docs.oracle.com/en/java/javacard/3.2/jc-re-spec/F74157_03.pdf), section 7, Transactions and Atomicity.
[^st25]: STMicroelectronics, [Best practices for security and privacy with ST25 NFC/RFID tags](https://www.st.com/resource/en/application_note/an5493-best-practices-for-security-and-privacy-with-st25-nfcrfid-tags-stmicroelectronics.pdf).
[^epaper]: Waveshare, [Passive NFC-powered e-paper evaluation kit](https://www.waveshare.com/product/displays/e-paper/7.5inch-nfc-e-paper-eval-kit.htm), an existence proof for batteryless display refresh rather than a coin-ready component.
[^nfc-relay]: NFC Forum, [Technology Roadmap 2026](https://nfc-forum.org/uploads/nfcforum-roadmapbooklet-final.pdf), which identifies relay-attack protection as an area for technical-specification work.
[^secure-element]: GlobalPlatform, [Introduction to Secure Elements](https://globalplatform.org/wp-content/uploads/2018/05/Introduction-to-Secure-Element-15May2018.pdf).
