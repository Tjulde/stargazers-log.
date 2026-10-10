# The Broken Basket

## Investigating Retail Basket Contraction Under Inflationary Pressure in Nigeria

**MySQL · SQL · Star Schema · Power BI · DAX · Retail Analytics**

The Broken Basket is a retail analytics case study exploring how purchasing behavior may change under inflationary pressure. It examines basket size, product and category performance, customer segments, and retailer opportunities across supermarkets in Southwest Nigeria.

The project uses synthetic transaction data and combines MySQL data modeling and analysis with an interactive Power BI dashboard.

> **Data note:** The transaction data is synthetic. It is for portfolio analysis and does not represent actual customers, stores, or supermarket sales.

## Business question

Are customers buying fewer items per visit, which products or categories are losing basket penetration, and what actions could retailers consider to protect customer spend?

## Project scope

The project context describes a dataset containing **30,000 customer tickets, 68,703 sales lines, 30 products, and 12 supermarket branches** across Lagos, Ogun, and Oyo. Confirm these counts against your final dataset before publishing.

The analysis is designed to examine:

- Changes in items per transaction and basket value
- Differences across products, categories, customer segments, and retailers
- Possible basket contraction or product substitution patterns
- Opportunities retailers could investigate to protect basket value

## Tools and methods

- **MySQL:** schema design, data loading, and analysis queries
- **Data modeling:** star schema with sales facts and descriptive dimensions
- **Power BI:** interactive report and dashboard
- **DAX:** measures for retail and basket performance

## Data model

The model uses a central sales fact table connected to descriptive dimensions which is an E-Commerce Order Management or Orders & Customer ERD.

**Fact table:** dim _fact_sales  
**Dimensions:** dim_date, dim_product, Dim_customer, dim_store, and dim inflation context 

## Key findings

1. **Basket Volume Retraction:** Identified a **6.5% contraction** in total basket size, dropping from early period Baseline of **46,000 items down to a recent baseline of **43,000 items**, signaling a dip cross-selling efficiency. 

2. **Product Penetration Imbalance:** Discovered a severe concentration risk where only **7 core Products** anchor customer baskets, while **23 Products experienced a decline in Basket penetration**, driving basket volume contraction from 46k to 43k units.

3. **Income-Bracket Value Variance:** Demographics analysis reveals a clear performance gradient across income brackets. The **High-Income customer segment anchors the highest transactional metrics (Basket size & Value)**, outperforming the medium and Low-income segments, which show progressive drops in multi-items cart adoption.

4. **Retailer & Geographic Performance Disparity:** Cross-channel analysis across retail brands revealed highly localized performance variances. while premium distributors like the **Prince Ebeano** anchored the highest revenue density, secondary channels (such as **Justrite Superstores** underperformed baseline expectations, demonstrating a clear drop-off in geographical basket size consitency.

## Recommendations

Since the Basket size is shrinking, reserving the friction causing customers to buy less, Investigating if recent Price Increases on low cost:

- **Frictionless Cross-Selling & Tiered Thresholds**: Addressing the 3K unit decline (46k to 43k) with the introduction of **Buy more 💰🧺 to get 10% off** prompt at checkout.

- **Tiered Incentive Structures & Affordability Adjustments For Low/Medium Brackets**: Leverage the strong performance of the High-Income bracket by introducing a premium "VIP Loyalty Tier" with exclusive perks to increase their lifetime value (LTV) even further. Counter the lower basket performance in the low- and Medium-Income brackets by introducing budget-friendly bundle kits, interest-free "Buy Now, pay later" (BNP) Financing configurations, or value-focused alternatively items.

- **Strategic Retailer Re-Alignment**: Prioritize high- Performing accounts like Prince Ebeano for exclusive product rollouts while launching collaborative multi-buy promotional campaigns with underperforming channels like Justrite Superstores to clear stock and reverse volume drops.

## Power BI report

The report is intended to include:

1. Overview
2. Customer Analytics
3. Product Analytics
4. Retailer Opportunity
5. Basket Exceptions

See the folder for report previews. Open `powerbi/The_Broken_Basket.pbix` with Power BI Desktop to explore the report, if that file is included in this repository.

<img width="800" height="444" alt="TheBrokenBasketVideo-ezgif com-video-to-gif-converter (1)" src="https://github.com/user-attachments/assets/b8f990fa-de65-4e40-8674-8d8e128cfee3" />


## Repository guide

```text
sql/          Database schema, data setup, and analysis queries
powerbi/      Power BI report file
screenshots/  Dashboard page previews
docs/         Supporting documentation, such as a data dictionary
```

## How to use

1. Review the SQL files in `sql/` and run them in the intended order.
2. Confirm the database and table names match your MySQL setup.
3. Open the Power BI file in Power BI Desktop.
4. Update its data source settings if your local database connection differs.

Add any required MySQL version, setup notes, or data-loading instructions here so another analyst can reproduce your work.

## Limitations

- The transaction data is synthetic and should not be treated as evidence about actual Nigerian consumers or retailers.
- [Add any other project-specific data or modeling limitations.]
- [State whether the analysis establishes correlation only or supports any stronger conclusions.]

## Author

**Julde Toheed**  
www.linkedin.com/in/julde-toheed-4441a8360 
