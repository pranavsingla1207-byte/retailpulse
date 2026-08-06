# RetailPulse - Insights & Recommendations

Business conclusions from the analysis of **1,021,128 cleaned transactions** (£19.64M net revenue,
39,516 orders, 5,852 identified customers) for a UK online gift retailer, Dec 2009 – Dec 2011.

Each recommendation follows the same structure: **the finding**, **the evidence**, and **the action**.

---

## 1. Launch a win-back campaign for the At-Risk segment - a £1.6M–£2.9M opportunity

**Finding.** A large, valuable slice of the customer base has stopped buying but hasn't necessarily
left for good.

**Evidence.** RFM segmentation flags **£1.59M of revenue (9.3% of the total)** in the strict *At-Risk*
segment; a broader reading of lapsing customers reaches **£2.88M (16.9%)**. Both the rule-based and
K-Means methods independently identify this group, so it is not an artefact of one technique. These are
customers with real purchase history and high past spend whose recency has slipped.

**Action.** Target the At-Risk list with a reactivation offer (personalised discount or a
"we miss you" campaign). Because these customers have already demonstrated value, the cost of winning
one back is far lower than acquiring a new one. Even a **10% reactivation rate recovers ~£160K–£290K**.
The customer-level drill-through in the dashboard produces the exact list to hand to marketing.

---

## 2. Protect the concentrated high-value core before chasing growth

**Finding.** Revenue is extraordinarily concentrated in a small number of customers - which is both the
company's strength and its single biggest risk.

**Evidence.** The **top 20% of customers generate 77% of revenue, and the top 1% alone drive 32%**.
The *Champions* segment - a minority of customers - accounts for roughly **70% of revenue**
(69.2% rule-based / 73.3% K-Means). Median customer value is £856, but the mean is £2,917 and the top
account is £580,987 - a long, heavy tail. Losing even a handful of top accounts would materially dent
the P&L.

**Action.** Stand up a **key-account retention programme** for Champions and high-value Loyal customers
(dedicated service, early access, loyalty perks). Retention spend on this group has the highest return
because it defends the majority of revenue. Growth initiatives should come *after* the core is secured.

---

## 3. Fix the first-purchase retention cliff

**Finding.** The business acquires customers well but loses most of them immediately after their first
order.

**Evidence.** The cohort retention heatmap shows retention falling to **~20% one month after first
purchase**, then stabilising in the **15–20%** range for those who remain - a loyal core forms, but only
after a steep early drop. Reinforcing this, **27.6% of customers (1,618) ordered exactly once** and
never returned. The plateau proves the problem is *early*: customers who survive month one tend to stay.

**Action.** Invest in **onboarding for first-time buyers** - a post-purchase email sequence, a
second-order incentive, and a satisfaction check in the first 30 days. Converting even a few percent of
one-and-done buyers into repeat customers compounds, because repeat customers already drive **82.8% of
identified revenue**.

---

## 4. Treat UK and product concentration as a strategic risk to manage

**Finding.** Revenue depends heavily on one country and a narrow band of products.

**Evidence.** The **UK alone is 85.5% of revenue** across 43 countries. On the product side the 80/20
rule holds almost exactly: **1,040 of 4,878 products (21%) generate 80% of revenue**. A shock to the UK
market or to a few hero SKUs (e.g. the Regency Cakestand, £330K) would hit disproportionately.

**Action.** Two-track. **(a) Defend** the hero products - protect stock availability and margin on the
top SKUs, and monitor them closely. **(b) Diversify** deliberately - the best-performing non-UK markets
(EIRE, Netherlands, Germany, France) are the natural expansion targets to reduce single-market
dependence over time.

---

## Bonus finding - a data-quality flag worth £168K

Cancellations cost **£716K (3.6% of gross revenue)**, but **a single reversed 80,995-unit "Paper Craft"
order accounts for £168K of that** - and the *same* order also ranks #3 in gross sales, so its net
contribution is roughly zero. This is a reminder to read cancellations net, not gross: one data point
distorts both the "top products" and "lost revenue" stories if taken at face value. Worth confirming
with the business whether that order was a genuine bulk return or a data-entry reversal.

---

### The through-line

RetailPulse is a **stable, retention-driven, highly concentrated** business - concentrated in the UK, in
a fifth of its products, in its top customers, and in a Q4 seasonal peak (**Sep–Nov = 37% of annual
revenue**). The strategic priority is therefore clear: **protect and reactivate the existing high-value
base** rather than chase broad new acquisition. Every recommendation above serves that priority.
