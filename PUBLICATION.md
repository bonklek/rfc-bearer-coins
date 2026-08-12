# GitHub publication guide

The repository is ready for a quiet public WIP launch after a GitHub repository
and remote exist. It is not ready for a production announcement or real-value
prototype.

## Repository subtitle

Use this immediately below the project name and in announcement copy:

> Unimplemented research RFC — valueless test networks only.

## GitHub About description

> Research RFC for a batteryless physical bearer token. Unimplemented, without
> independent validation, and restricted to valueless test networks.

## Suggested topics

- `cryptocurrency`
- `ethereum`
- `hardware-security`
- `nfc`
- `privacy`
- `protocol-design`
- `rfc`
- `security-research`
- `testnet-only`

GitHub stores the About description and topics outside the Git repository. Apply
these values in the repository's About settings after the remote is created.

## Recommended repository settings

- Enable Issues and Discussions.
- Enable private vulnerability reporting.
- Keep the default branch named `main`.
- Do not publish a release or production package.
- Do not add a deployment environment or mainnet configuration.
- Require pull-request review for changes to RFC-0001 once outside contributions
  begin.
- Keep raw internal review queues and old Git metadata outside the repository.

## Suggested pinned issues

Create these from [Feedback wanted now](./FEEDBACK.md):

1. `Specify canonical ClaimIntent and transport encodings`
2. `Model AUTH_PENDING liveness and safe invalidation`
3. `Define passive-hardware P-256 entropy and reset profile`
4. `Define authorization behavior across same-chain-ID splits`
5. `Prototype proof-activated loading under passive power`
6. `Threat-model continuity transport and private proving boundaries`

## Launch order

1. Create the public repository without adding an auto-generated license or
   README, because both already exist here.
2. Add the remote and push only `main` from this sanitized Git repository.
3. Apply the About description and topics above.
4. Enable private vulnerability reporting, Issues, and Discussions.
5. Open and pin a welcome discussion linking the
   [plain-language explainer](./EXPLAINER.md), [project status](./STATUS.md), and
   [feedback list](./FEEDBACK.md).
6. Create the six feedback issues without marking any complaint resolved.
7. Clone the public repository into a new directory and rerun
   `scripts/validate-public-repo.ps1` against the clone.

The first announcement should invite review of an incomplete research proposal,
not users, investors, asset deposits, or production implementations.
