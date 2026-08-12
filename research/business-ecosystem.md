# Business and ecosystem research log

## Covered areas

- Stablecoin access-denial contagion in a shared managed-settlement treasury.
- Idempotency and duplicate-credit prevention in managed settlement.
- Shared-treasury receipt attribution to the correct merchant beneficiary.
- UCC Article 12 control, purchaser rights, and physical possession.
- ERC-4337 paymaster liability and controls for reverted sponsored claims.
- FinCEN classification of CVC merchant settlement and commercial loading.
- OFAC sanctions controls for virtual-currency loading and managed settlement.
- Federal tax and digital-asset broker reporting for physical payments and managed settlement.

## Research entries

### 2026-07-16 - Review 1

- **Area:** Address-level USDC access denial and contagion from a shared settlement treasury.
- **Investigation:** Reviewed Circle's terms, access-denial policy, and deployed stablecoin contract controls.
- **Primary sources:** [Circle USDC Terms](https://www.circle.com/legal/usdc-terms), [Circle Stablecoin Access Denial Policy](https://6778953.fs1.hubspotusercontent-na1.net/hubfs/6778953/Blog%20Posts/Circle%20Stablecoin%20Access%20Denial%20Policy_pdf.pdf), [Circle stablecoin-evm](https://github.com/circlefin/stablecoin-evm).
- **Material facts:** Address-level denial can affect all controlled Circle stablecoins, blacklisted addresses cannot send or receive, contracts can be globally paused, and direct USD redemption is conditional.
- **RFC implication:** A shared provider treasury creates correlated issuer-control and merchant-obligation risk, suggesting segregation and explicit provider policy.
- **Disposition:** Duplicate of C-022, C-037, and C-053. The same review separately produced C-057 from RFC incentive analysis.

### 2026-07-16 - Review 2

- **Area:** Idempotency and duplicate-credit prevention in managed merchant settlement.
- **Investigation:** Compared retry, timeout, concurrent submission, key scope, and regional deduplication guidance from major payment providers.
- **Primary sources:** [Stripe idempotent requests](https://docs.stripe.com/api/idempotent_requests), [Adyen API idempotency](https://docs.adyen.com/development-resources/api-idempotency/), [PayPal idempotency guidelines](https://developer.paypal.com/reference/guidelines/idempotency/).
- **Material facts:** Payment APIs persist mutation identity to make retries safe; omission or regional scope gaps can duplicate mutations.
- **RFC implication:** Chain nonce protection does not deduplicate the provider's separate merchant-credit ledger.
- **Disposition:** Produced C-058.

### 2026-07-16 - Review 3

- **Area:** Shared-treasury receipt attribution to the correct merchant beneficiary.
- **Investigation:** Compared the RFC's claim and treasury flow with ERC-20 transfer evidence, ERC-4337 operation fields, and Stripe Connect's linked platform-collection and merchant-transfer model.
- **Primary sources:** [ERC-20](https://eips.ethereum.org/EIPS/eip-20), [ERC-4337](https://eips.ethereum.org/EIPS/eip-4337), [Stripe separate charges and transfers](https://docs.stripe.com/connect/separate-charges-and-transfers).
- **Material facts:** An ERC-20 transfer identifies source, destination, and value but no merchant-ledger beneficiary; ERC-4337 adds merchant attribution only when application call data deliberately commits it. Stripe requires an explicit destination account and can link the merchant transfer to its source charge.
- **RFC implication:** Credit-once deduplication is insufficient: settlement needs an authenticated, unique source-to-beneficiary instruction so a valid treasury receipt cannot be credited once to the wrong merchant.
- **Disposition:** Candidate BE-003-01 accepted as C-063.

### 2026-07-16 - Review 4

- **Area:** UCC Article 12 control, purchaser rights, and physical possession.
- **Investigation:** Examined the Uniform Law Commission and American Law Institute's final Article 12 text and comments, especially Sections 12-104 and 12-105, against the RFC's possession and payment-boundary claims.
- **Primary sources:** [2022 UCC amendments with comments](https://www.uniformlaws.org/HigherLogic/System/DownloadDocumentFile.ashx?DocumentFileKey=879c6538-ab03-6b13-137d-63f79ae931ac&forceDialog=0), [ULC Uniform Commercial Code overview](https://www.uniformlaws.org/acts/ucc).
- **Material facts:** Article 12 defines control functionally but leaves acquisition of property rights to other law. Qualifying-purchaser protection requires value, good faith, no notice of a property claim, and control; the UCC remains state law subject to jurisdiction-specific enactment.
- **RFC implication:** Physical custody and signing power alone do not establish title, take-free status, or loss allocation; production design requires governing-law, transaction-role, receipt, and recourse analysis.
- **Disposition:** No new complaint; reinforces C-037 and C-053.

### 2026-07-16 - Review 5

- **Area:** ERC-4337 paymaster liability and controls for reverted sponsored claims.
- **Investigation:** Compared the RFC's sponsored-gas modes with ERC-4337 paymaster validation, execution, charging, and deposit rules, plus primary project guidance on griefing defenses and sponsorship patterns.
- **Primary sources:** [ERC-4337](https://eips.ethereum.org/EIPS/eip-4337), [Paymaster security and griefing](https://docs.erc4337.io/paymasters/security-and-griefing), [Paymaster design patterns](https://docs.erc4337.io/paymasters/design-patterns.html).
- **Material facts:** A paymaster commits deposit funds during validation and still pays when account execution later reverts. Documented defenses include short-lived signed approvals over sender and call-data, deadlines, quotas, and transaction or gas budgets.
- **RFC implication:** Moving gas cost to a paymaster does not remove fee risk; sponsorship needs authenticated one-use, cost-bounded authorization, deposit limits, and an explicit failed-execution loss policy.
- **Disposition:** Candidate BE-005-01 accepted as C-064.

### 2026-07-16 - Review 6

- **Area:** FinCEN classification of CVC merchant settlement and commercial loading.
- **Investigation:** Compared FinCEN's 2013 and 2019 CVC guidance with the RFC's self-use, commercial loading, provider-treasury acquisition, merchant-credit, conversion, and payout flows.
- **Primary sources:** [FinCEN 2013 CVC guidance](https://www.fincen.gov/resources/statutes-regulations/guidance/application-fincens-regulations-persons-administering), [FinCEN 2019 CVC business-model guidance](https://www.fincen.gov/resources/statutes-regulations/guidance/application-fincens-regulations-certain-business-models), [FinCEN 2019 CVC guidance PDF](https://www.fincen.gov/system/files/2019-05/FinCEN%20Guidance%20CVC%20FINAL%20508.pdf).
- **Material facts:** FinCEN distinguishes self-use from administering or exchanging CVC as a business; accepting fiat to fund a user's CVC account can be money transmission, CVC transmission is not prepaid access, and CVC payment processors generally cannot use the conventional payment-processor exemption. Mere delivery, communications, and network-access services are treated differently.
- **RFC implication:** Optional or hardware-based deployment does not characterize the commercial role. U.S. loader and managed-settlement designs must map actual acceptance, transmission, exchange, control, and payout functions and include resulting identity, records, reporting, monitoring, registration, and cost boundaries.
- **Disposition:** No new complaint; reinforces C-053, C-050, and C-052.

### 2026-07-16 - Review 7

- **Area:** OFAC sanctions controls for virtual-currency loading and managed settlement.
- **Investigation:** Compared OFAC's virtual-currency guidance and blocked-property FAQ with the RFC's commercial loading, treasury acquisition, immediate merchant credit, conversion, payout, and pilot flows.
- **Primary sources:** [OFAC virtual-currency guidance](https://ofac.treasury.gov/system/files/126/virtual_currency_guidance_brochure.pdf), [OFAC virtual-currency FAQs](https://ofac.treasury.gov/faqs/topic/1626), [OFAC FAQ 646](https://ofac.treasury.gov/faqs/646).
- **Material facts:** OFAC sanctions obligations apply to virtual currency as they do to fiat; risk-based controls can include sanctions and geographic screening, customer and counterparty data, blockchain analytics, monitoring, lookbacks, testing, training, and reporting. Blocked virtual currency must remain inaccessible and controlled, with initial and annual reporting; controlled omnibus custody is permitted. OFAC says risk should be evaluated during beta testing and before launch.
- **RFC implication:** A value-bearing loader or managed-settlement provider needs pre-service screening, withheld settlement authorization, blocked-property custody and ledger procedures, frozen credit or payout states, records, reporting, and explicit privacy, latency, liquidity, support, pilot, and cost treatment.
- **Disposition:** No new complaint; reinforces C-053, C-037, C-050, C-052, and C-054, with treasury effects already covered by the first entry.

### 2026-07-16 - Review 8

- **Area:** Federal tax and digital-asset broker reporting for physical payments and managed settlement.
- **Investigation:** Compared IRS property and payment guidance, Treasury's broker-reporting regulations, and Form 1099-DA instructions with offline bearer transfers and the RFC's managed merchant-settlement flow.
- **Primary sources:** [IRS digital-asset FAQs](https://www.irs.gov/individuals/international-taxpayers/frequently-asked-questions-on-digital-asset-transactions), [IRS Notice 2014-21](https://www.irs.gov/pub/irs-drop/n-14-21.pdf), [Treasury Decision 10000](https://www.federalregister.gov/documents/2024/07/09/2024-14004/gross-proceeds-and-basis-reporting-by-brokers-and-determination-of-amount-realized-and-basis-for), [Form 1099-DA instructions](https://www.irs.gov/instructions/i1099da), [IRS broker-reporting regulations overview](https://www.irs.gov/newsroom/final-regulations-and-related-irs-guidance-for-reporting-by-brokers-on-sales-and-exchanges-of-digital-assets).
- **Material facts:** Digital assets are treated as property, payment can be a taxable disposition, and taxpayers must retain supporting value and basis records. A processor that regularly receives digital assets from one party and pays another in assets or cash can be a digital-asset broker; covered gross-proceeds reporting began for 2025 transactions and some custodial basis reporting begins with assets acquired and disposed of from 2026. PDAP and qualifying-stablecoin thresholds reduce reporting volume but do not remove classification and record-design needs.
- **RFC implication:** A U.S. commercial pilot must classify each provider and its customer relationship before launch and design provider-specific onboarding, settlement, valuation, aggregation, statements, retention, correction, and support processes outside permissionless coin handoff; pilot and unit-economics models must include the resulting friction and cost.
- **Disposition:** No new complaint; reinforces C-053, C-039, C-041, C-050, C-052, and C-054.
