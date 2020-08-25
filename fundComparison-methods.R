#
#
# Support Functions For Mutual Fund Comparison
#
#


Sharpe <- function(returns, risk_free_returns){
  er  <- returns - risk_free_returns # excess returns
  rfr <- risk_free_returns
  
  (c(
    Vol_Ratio = sd(er, na.rm=TRUE) / sd(rfr),
    sharpe    = median(er, na.rm=TRUE) / sd(er, na.rm=TRUE),
    SD        = sd(returns, na.rm=TRUE)
  ))
  
}

X.year.returns <- function(YFdat, X){
  # Requires sorted monthly data
  sapply(c(1:nrow(YFdat)), function(x){
    if(x < 12*X + 1) {(NA)}
    else{
      a <- YFdat[x,"Close"]
      b <- YFdat[x-12*X,"Close"]
      chg <- (a - b) / b
      (100*chg / X)
    }
  })
}

HistoricalPerformance2 <- function(YFdat_path, name){
  YFdat <- read.csv(YFdat_path, header = TRUE)
  YFdat <- YFdat[as.Date(YFdat$Date, "%Y-%m-%d") >= as.Date("1980-01-01", "%Y-%m-%d"),]
  YFdat$Close <- as.numeric(YFdat$Close)
  
  YFdat$Y30 <- X.year.returns(YFdat, 30)
  YFdat$Y20 <- X.year.returns(YFdat, 20)
  YFdat$Y10 <- X.year.returns(YFdat, 10)
  YFdat$Y1  <- X.year.returns(YFdat, 2)
  
  YFdatm <- melt(YFdat[,c("Date","Y30","Y20","Y10", "Y1")], variable.name = "Type", 
                 value.name = "Avg.Ann.Ret",id.vars = "Date")
  YFdatm <- YFdatm[!is.na(YFdatm$Avg.Ann.Ret),]
  
  
  p1 <- ggplot(YFdat, aes(x=as.Date(Date, "%Y-%m-%d"), y=Close)) +
    geom_line(size=1.3) +
    ylab("Share Price at Close (USD)") + ylim(0,NA) +
    scale_x_date(name="",
                 breaks=as.Date(c('1980-01-01','1990-01-01','2000-01-01',"2010-01-01",'2020-01-01')),
                 labels=c("1980", "1990","2000","2010","2020"),
                 # labels=c("","","",""),
                 limits = as.Date(c('1980-01-01','2020-01-01'))) +
    theme_classic() + xlab("Year") +
    ggtitle(name) + theme(plot.title = element_text(hjust=0.5))
  
  p2 <- ggplot(YFdat, aes(x=as.Date(Date, "%Y-%m-%d"), y=Y20)) +
    geom_line( size=1.3) + 
    scale_color_viridis(discrete=TRUE,end =0.7) +
    theme_classic() + ylim(0,NA) +
    ggtitle(paste(name,"\n20 Year Returns",sep="")) + theme(plot.title = element_text(hjust=0.5)) +
    ylab("Average Annual Return (%)") + 
    scale_x_date(name="",
                 breaks=as.Date(c('2000-01-01',"2010-01-01",'2020-01-01')),
                 labels=c("2000","2010","2020"),
                 # labels=c("","","",""),
                 limits = as.Date(c('2000-01-01','2020-01-01')))
  
  p3 <- ggplot(YFdat, aes(x=Y20)) +
    geom_histogram(binwidth=1) +
    scale_fill_viridis(discrete=TRUE,end =0.7) +
    scale_color_viridis(discrete=TRUE, end=0.7) +
    ggtitle(paste(name,"\n20 Year Returns",sep="")) + ylim(0,NA) +
    theme_classic() + theme(plot.title = element_text(hjust=0.5)) +
    scale_x_continuous(name ="", limits=c(-5, 100),
                       breaks=seq(-5,100,5)) 
  (
    list(Price=p1, Y20lin=p2, Y20hist=p3, rdat=YFdat, datm=YFdatm)
  )
}

