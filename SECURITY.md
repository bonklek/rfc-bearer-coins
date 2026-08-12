# Security policy

## Supported versions

There is no supported implementation or production version. This repository is
an unvalidated protocol proposal. Do not use it with mainnet or assets of value.

## Reporting specification vulnerabilities

If the repository enables GitHub private vulnerability reporting, use it for a
report that contains sensitive details. Otherwise, open a minimal public issue
requesting a private channel without including credentials, personal data,
private infrastructure, live wallet/account identifiers, or an exploit against a
real-value deployment.

Non-sensitive design objections should be filed publicly and should reference
related C-* and D-* identifiers where possible.

## Scope

In scope:

- contradictions that could cause unsafe implementation;
- missing authorization, replay, recovery, privacy, or trust boundaries;
- misleading security/privacy claims;
- accidental disclosure of private repository data; and
- flaws in future reference code, test vectors, or hardware profiles.

There is currently no bounty, response-time guarantee, production incident
process, deployed endpoint, or custody system. Never test against third-party
systems, real assets, or people without their explicit authorization.

## Current high-risk areas

See [Project status](./STATUS.md#critical-gates). Acknowledged open findings are
not evidence that no related or more severe issue exists.
