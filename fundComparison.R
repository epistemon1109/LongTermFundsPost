#
#
# Plot Data
#
#

rm(list=ls())
library(ggplot2)
library(gridExtra)
library(reshape2)
datDir <- "/Users/Marc Ferrell/Documents/FundData/HistoricalData"

csvs <- grep("csv", list.files(datDir, full.names = TRUE, recursive=TRUE),
             value=TRUE)

csvs <- c(csvs,
          "/Users/Marc Ferrell/Documents/FundData/ReferenceReturns/SP500.csv",
          "/Users/Marc Ferrell/Documents/FundData/ReferenceReturns/DJIA.csv",
          "/Users/Marc Ferrell/Documents/FundData/ReferenceReturns/NASDAQ.csv")

Tbill_returns <- read.table("/Users/Marc Ferrell/Documents/FundData/ReferenceReturns/LT-CompositeTreasuryRate.txt",
                            sep="\t", header=TRUE, stringsAsFactors = FALSE)
Tbill_returns$Date <- sapply(Tbill_returns$Date, function(x) {
  if(grepl("/", x)){
    day <- strsplit(x, "/")[[1]][2]
    month <- strsplit(x, "/")[[1]][1]
    year <- paste("20", strsplit(x, "/")[[1]][3], sep="")
    (paste(year, month, day, sep="-"))
  }
  else{
    (x)
  }
})

plts <- list()
or <- c()
risk_adjusted_returns <- data.frame(Fund=character(),
                                    Sharpe = numeric(),
                                    Y30med = numeric(),
                                    Y20med = numeric())

c=1
for(i in csvs){
  nm <- strsplit(i, "/")[[1]]
  nm <- nm[length(nm)]
  nm <- substring(nm, 1, nchar(nm)-4)
  p <- HistoricalPerformance2(i, nm)
  c=c+1
  shared <- intersect(p$rdat$Date, Tbill_returns$Date)
  Sh <- Sharpe(p$rdat[p$rdat$Date %in% shared, "Y20"],
            as.numeric(Tbill_returns[Tbill_returns$Date %in% shared, "LT.COMPOSITE...10.Yrs."]))
  risk_adjusted_returns <- rbind(risk_adjusted_returns,
                                 data.frame(Fund=nm,
                                            Sharpe = Sh["sharpe"], VolatiltyRatio = Sh["Vol_Ratio"],
                                            Y20med = median(p$rdat$Y20,na.rm=TRUE),
                                            SD = Sh["SD"]
                                 )
  )
}

SP500 <- HistoricalPerformance2(grep("SP500", csvs, value=T), "S&P 500 Index")

scp <- ggplot(risk_adjusted_returns, 
              aes(x = SD, y=Y20med, fill=Sharpe)) + 
  geom_point(shape = 21, color="black", size=1.3) + 
  geom_text(aes(label=ifelse(Sharpe >= Sharpe[order(Sharpe, decreasing=TRUE)][10] |
                             Y20med >= Y20med[order(Y20med, decreasing=TRUE)][10] |
                             Fund %in% c("DJIA", "NASDAQ", "SP500"),
                             as.character(Fund), '')),
            hjust=-0.1,vjust=0, color="black") +
  scale_fill_gradient2(low="blue", high="red",  midpoint=1.5,
                       limits=c(0,3),breaks=c(0,1.5,3), na.value = "black") +
  scale_y_continuous(name="Median Annualized 20-Year Return (%)", limits=c(0,30),
                     breaks=seq(0,30,10)) +
  scale_x_continuous(name="Volatility (Standard Deviation of Annualized Returns)",
                     limits=c(1,1000), trans="log10", 
                     breaks=c(1,10,100,1000)) +
  annotation_logticks(side="b") +
  ggtitle("Mutual Funds: Long Term Risk vs. Rewards") +
  theme_classic(base_size = 20) +
  theme(plot.title = element_text(hjust=0.5))

pfinal <- grid.arrange(SP500$Price +
                         scale_y_continuous(name="Value at Close", limits=c(0,4000)),
                       SP500$Y20lin, 
                       SP500$Y20hist + 
                         scale_x_continuous(name="Annualized 20 Year Returns", 
                                            limits=c(0,70), 
                                            breaks=seq(0,70,10)),
                       scp,
                       layout_matrix = rbind(c(1,2,3),c(4,4,4),c(4,4,4),c(4,4,4))
)



save_plot("/Users/Marc Ferrell/Documents/FundData/plots/rpost.png", pfinal, dpi=700,
          base_height = 10)


