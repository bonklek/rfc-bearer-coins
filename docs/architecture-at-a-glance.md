# Architecture at a glance

This diagram compares the selected version 1 baseline with the later privacy
research candidate. Both are unimplemented.

```mermaid
flowchart TB
    Coin["Batteryless physical coin<br/>finite secure-core lifecycle"]
    Intent["Exact destination-bound authorization<br/>no private-key export path"]
    Coin --> Intent

    Intent --> AKey
    Intent --> BNote

    subgraph A["Architecture A — version 1 baseline"]
        AKey["Current P-256 monetary key"] --> Account["One deployed immutable<br/>smart account per epoch"]
        Account --> AssetA["Exact represented asset<br/>and amount"]
        Account --> ClaimA["Atomic zero-out claim<br/>or transparent rotation"]
    end

    subgraph B["Architecture B — research candidate"]
        BNote["Hidden note authority"] --> Commitment["Commitment in shared pool"]
        Commitment --> AssetB["Fixed denomination<br/>in shared reserve"]
        Commitment --> ClaimB["Private proof plus<br/>one-time nullifier"]
    end

    ALeak["Public account and transaction graph<br/>linkable by design"]
    BGate["Circuit, setup, proving boundary,<br/>anonymity set, and exit unproven"]
    ClaimA --> ALeak
    ClaimB --> BGate
```

| Question | Architecture A | Architecture B |
|---|---|---|
| Status | Version 1 reference prototype target | Later research candidate |
| Backing location | Separate identifiable smart account | Shared commitment/nullifier reserve |
| Coin authority | P-256 key authorized by the account | Hardware-held authority bound to a hidden note |
| Ordinary verification | Core attestation plus optional chain observation | Proposed composite private presentation |
| Claim | Exact account transition and authority retirement | Nullifier consumption and exact pool withdrawal |
| Principal benefit | Narrower and easier to reason about | Potentially less public per-coin linkage |
| Principal cost | Public account graph is linkable | Shared-pool, circuit, proving, setup, and exit complexity |
| Current evidence | No implementation or hardware evidence | No selected construction or implementation |

Architecture B cannot replace or interoperate with Architecture A in version 1
without a later explicit superseding decision and completion of its
[evaluation gates](./architecture-b-commitment-pool.md#evaluation-gate).
