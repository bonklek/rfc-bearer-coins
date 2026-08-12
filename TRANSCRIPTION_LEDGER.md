# Decision transcription ledger

This ledger separates accepted direction from specification integration and
evidence. `Integrated` means the public documents state the accepted boundary;
it does not mean implemented, tested, validated, or resolved.

[RFC-0001](./rfcs/0001-physical-bearer-cryptocurrency/README.md) is the canonical
integrated profile. The domain destinations below own the detailed clauses it
incorporates by reference.

| Decision | Accepted boundary | Canonical destination | Integration | Evidence state |
|---|---|---|---|---|
| D-001 | Local response authenticates a core, not physical co-location | `docs/verification-and-bslrr.md` | Integrated | Prototype gate |
| D-002 | Complete canonical `ClaimIntent` | `docs/key-lifecycle.md` | Integrated logical schema | Encoding/test vectors absent |
| D-003 | Trusted register/display/actuation boundary | `docs/register-and-checkout.md` | Integrated | Implementation/evaluation absent |
| D-004 | One `AUTH_PENDING` lane and semantic nonce | `docs/key-lifecycle.md` | Integrated | Recovery/model/tests absent |
| D-005 | Proof-activated finite loading | `docs/key-lifecycle.md` | Integrated | Proof/hardware profile absent |
| D-006 | Commit exact authorization before output | `docs/key-lifecycle.md` | Integrated | Storage/fault evidence absent |
| D-007 | Exact represented value and zero-out claim | `docs/ethereum-accounts-and-assets.md` | Integrated | Contract/tests absent |
| D-008 | Finite generate-on-advance epochs | `docs/coin-hardware.md` | Integrated | Entropy/isolation evidence absent |
| D-009 | Three attributed status dimensions | `docs/verification-and-bslrr.md` | Integrated | UI/conformance evidence absent |
| D-010 | One reverting atomic claim execution | `docs/ethereum-accounts-and-assets.md` | Integrated | Contract/tests absent |
| D-011 | Operation-specific power profiles | `docs/coin-hardware.md` | Integrated | Measurements absent |
| D-014 | Evidence-first tamper response and evacuation | `docs/coin-hardware.md` | Integrated | Sensor/fault evidence absent |
| D-037 | Ownership changes at approved secure gate crossing | `docs/register-and-checkout.md` | Integrated | Legal/operational evidence absent |
| D-038 | Basket with per-coin physical acceptance | `docs/register-and-checkout.md` | Integrated | Encoding/contract/tests absent |
| D-039 | Locked quote, fees, rounding, and remedy | `docs/register-and-checkout.md` | Integrated | Profiles/tests absent |
| D-040 | Online precondition for standard-register claim | `docs/register-and-checkout.md` | Integrated | Controller/reconciliation tests absent |
| D-044 | Customer basket-commit lever | `docs/register-and-checkout.md` | Integrated | Mechanical/accessibility tests absent |
| D-045 | Risk-first visual and nonvisual hierarchy | `docs/register-and-checkout.md` | Integrated | Vocabulary/UI studies absent |

Accepted safeguards from complaint triage that do not yet justify complaint
closure remain tracked in the complaint entry's `Remaining work` field.
