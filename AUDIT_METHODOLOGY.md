# Automated adversarial drafting methodology

The complaint and research logs were developed through repeated automated review
passes followed by editorial deduplication and classification. The process sought
new failure mechanisms across hardware, protocol/state machine, Ethereum,
privacy/trust, register/human factors, and business/ecosystem surfaces.

The historical stopping rule was three consecutive review passes in a category
that produced no new accepted complaint. In this repository, that means only that
the bounded automated prompt loop reached discovery saturation under its existing
context and methods. It does **not** mean:

- the design passed a security or privacy audit;
- the complaint list is complete;
- an implementation was reviewed;
- a cryptographer, hardware evaluator, safety laboratory, accessibility expert,
  lawyer, or regulator approved the work; or
- any complaint was resolved.

The public repository retains the curated append-only complaint log and durable
research summaries. Raw orchestration queues, local paths, model/provider details,
and reviewer-control instructions are intentionally excluded because they add no
public assurance and can disclose local workflow state.

Complaint novelty was assessed by underlying failure mechanism rather than source
count. A new citation reinforcing an existing failure did not create a duplicate
complaint. Proposed solutions and triage never changed complaint state by
themselves; each complaint records remaining specification, implementation,
testing, evidence, policy, or decision work.

The project welcomes independent review. See [Contributing](./CONTRIBUTING.md).
