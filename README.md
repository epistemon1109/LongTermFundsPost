# LongTermFundsPost
[OC] Mutual Funds: Which are Worth the Risk In the Long Term?

Prospectus documents typically provide the annualized rate of return over the last 10 years and over the life of the fund to allow investors to judge long-term performance. However, nearly everything has performed well in the last 10 years, and growth-since-inception figures cannot be directly compared unless the funds were started around the same time. Even the Sharpe ratios provided by brokers are usually calculated using short-term bonds as the risk-free rate. As a better measure of long term performance, I used the month-by-month 20-year returns between 1980 and 2020 to compare funds of varying ages. I ranked mutual funds over 30 years old from 14 brokerages and selected the 100 with the highest returns since inception. I also included a few mentioned in “25 Best Mutual Funds”-type articles. I also calculated a Sharpe ratio using the long term composite of US Treasury bonds (>10 years) as the risk-free rate (black dots indicate a negative Sharpe ratio). Funds were excluded if Yahoo Finance data was not available for 1990-2020.
The funds with the ten greatest median 20-year returns or ten greatest Sharpe ratios, along with three major indices, are labeled with tickers (Google those letters for more info).
Results: 
Of the three major indices, the NASDAQ has the highest returns, while the Dow (DJIA) is the least volatile over 20-year periods. 
Most of the apparently high-performing funds (54 out of 105) tend to have smaller 20-year returns than long-term Treasury bonds, which are risk-free.
The Rowe Price International Discovery Fund (PRIDX) appears to be the only international fund here with competitive returns.
A note on data availability: I have not been able to find historical data prior to 1980 for most funds. The US Treasury website only has bond yields going back to 2000. If there are better historical data sources, please comment.
A note on practicality: I am aware my advisor can pick better funds than me, and she does. My goal as an amateur is to understand the practical differences between funds as best as I can.
Sharpe ratio calculated as median of excess returns divided by standard deviation of said returns.
Tools used: RStudio (R 3.6.3), R packages: reshape2 (data wrangling), ggplot2 (plotting), gridExtra (plot arrangement)
Data Sources: Yahoo Finance (Closing Prices), www.treasury.gov (Treasury Bond Yields)
