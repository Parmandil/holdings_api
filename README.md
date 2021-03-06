# README

This is a simple API for some bond holdings using Rails 6.
It follows the JSON API standard.

Some sample holding data is already included in the repo.
In order to initialize the data, start a rails console and run:
`DataImporter.run`
and it will automatically import the data from data/holdings-list.csv into the
database.

Note that there is one data error in the sample CSV.
In row 257, the market value does not match the price times the par value,
like it should for valid data.
The par value and market value are also ridiculously low.
I suspect that there is something wrong with the data.
The DataImporter currently handles invalid data just by logging it and moving on,
so the other 699 holdings still import successfully.

Then you can start the rails server and use normal JSON API requests to interact
with the data. For example, you can run:
```
curl -i -H "Accept: application/vnd.api+json" "http://localhost:3000/holdings"
```
to get a list of all holdings in the database in JSON API format.

You can sort on any available field by passing in a sort parameter to the index.
For example, you can query "http://localhost:3000/holdings?sort=par-value,-price"
to sort by par value ascending and secondarily by price descending.

Note that quality is currently just an alphabetical sort. Eventually it will sort
based on whether a rating is better or worse.

For create, update, and sort requests, here are the attribute names you can pass in
(and in the case of create, must pass in):
* cusip
* description
* par-value
* coupon
* maturity
* sector
* quality
* price
* accrued
* currency
* market-value
* weight
* yield
* dur
* cov
* oas
* sprd-dur
* pd
See notes below for what those attributes mean.

## Notes on what the attributes of a holding mean

* CUSIP: A unique bond identifier
* Par Value: The face value of the bond - how much will be repaid when it reaches maturity
* Coupon: Basically, the interest rate. The sum of the annual interest / "coupon" payments divided by the bond's par value.
* Maturity: How long until the bond will be paid back. I'm not sure what the units are on it in this spreadsheet.
* Sector: What industry the bond represents. I don't know what the abbreviations in the spreadsheet stand for; I couldn't find a comprehensive list.
* Quality: Rating of the bond; basically, how great the risk is of default. AAA > AA1 > AA2 > AA3 > A1 > A2 > A3 > BAA1 > BAA2 > BAA3. One in the spreadsheet is marked "NR", not rated; I'll sort that below BAA3 though that's arguable. Other ratings exist, but not in "investment grade" bonds.
* Price: How much investors are willing to pay for it, as a percentage of face value. If the same as face value, price will be 100.
* Accrued: Interest accrued on the bond but not yet paid. I.e. if it pays every six months and it has been five months since it was last paid, 5/6 of the interest payment is "accrued." I'm not sure if the units in the spreadsheet are a dollar amount or a percentage of par value, but the numbers are small enough I am guessing a percentage of par value.
* Currency: In this spreadsheet, always USD (US Dollars); could theoretically be in a different currency.
* Market value: How much investors are willing to pay for it, in absolute terms. Should be equal to price * par value.
* Weight: How much of the portfolio the investment is, as a percentage. (Total weight adds to about 100, with rounding errors.)
* Yield: Most likely the yield to maturity? Rate of return given current market price, amount of all remaining coupon payments, and repayment due at maturity.
* Dur: Macaulay or modified duration, I don't know which... rather messy calculation which is "the weighted average of the times until fixed cash flows are received". Also measures the bond's price sensitivity to interest rate changes.
* Cov: I don't know, maybe the coverage ratio? which would be a measure of company's ability to cover its debt.
* OAS: Option-Adjusted Spread. Compares the price of the bond to the price of a risk-free security. Generally, riskier bonds have higher OAS.
* Sprd dur: Spread duration. An estimate of how much the price of the bond will change when the spread changes.
* PD: Probability of default
