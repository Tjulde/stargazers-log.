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
**Dimensions:** dim_date, dim_product, Dim_customer, and dim_store
**Multi Dimensions:** dim inflation context 

## Key findings

1. **Basket size:** [Decrease from Basket size, with Early Basket Size 46K and Recent Basket Size 43k]
2. **Product or category pattern:** [Verified finding]
3. **Customer segment pattern:** [Verified finding]
4. **Retailer or location pattern:** [Verified finding]

Avoid interpreting a change as caused by inflation unless your analysis supports that conclusion. Describe it as an association or pattern when causation has not been established.

## Recommendations

Add recommendations tied directly to your verified findings.

- [Recommendation linked to a finding]
- [Recommendation linked to a finding]
- [Recommendation linked to a finding]

## Power BI report

The report is intended to include:

1. Overview
2. Customer Analytics
3. Product Analytics
4. Retailer Opportunity
5. Basket Exceptions

See the [`screenshots/`](screenshots/) folder for report previews. Open `powerbi/The_Broken_Basket.pbix` with Power BI Desktop to explore the report, if that file is included in this repository.

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

**[Your name]**  
[LinkedIn profile] · [Portfolio link, if available]
