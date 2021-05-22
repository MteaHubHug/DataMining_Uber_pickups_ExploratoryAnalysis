#PAKETI : 
library(pacman)
pacman::p_load(data.table, fixest, BatchGetSymbols, finreportr, ggplot2, lubridate)

# Ucitavanje dionica :
## Podesavanje parametara za funkciju BatchGetSymbols s kojom cu ucitati dionice 
first.date <- Sys.Date() - 2500
last.date <- Sys.Date()
freq.data <- "monthly"
tickers <- c("TSLA", "NIO", "PRPL", "AAPL", "SNAP", "MU", "AMD",
             "NVDA", "TWTR")

## Get Stock Prices

stocks <- BatchGetSymbols(tickers = tickers, 
                          first.date = first.date,
                          last.date = last.date, 
                          freq.data = freq.data,
                          do.cache = FALSE,
                          thresh.bad.data = 0)

## Postavljam da bude tablica; poredat cu podatke po dionici i datumu
stocks_DT <- stocks$df.tickers %>% setDT() %>%         
  .[order(ticker, ref.date)]                           

# mogu pogledati kako mi izgledaju podaci o dionicama

# ponovno cu narediti svoje parametre i ucitat cu samo informacije za dionice Tesle
tesla <- c("TSLA")
TSLA<- BatchGetSymbols(tickers = tesla, 
                                first.date = first.date,
                                last.date = last.date, 
                                freq.data = freq.data,
                                do.cache = FALSE,
                                thresh.bad.data = 0)
tesla_DT <- TSLA$df.tickers %>% setDT() %>%         
  .[order(ticker, ref.date)]      


head(tesla_DT)
# ticker   ref.date    volume price.open price.high price.low price.close price.adjusted ret.adjusted.prices ret.closing.prices
# 1:   TSLA 2014-07-16 257446500     44.364     46.400    42.720      44.660         44.660                  NA                 NA
# 2:   TSLA 2014-08-01 574236000     45.218     54.400    45.200      53.940         53.940         0.207792185        0.207792185
# 3:   TSLA 2014-09-02 664241500     55.100     58.284    48.024      48.536         48.536        -0.100185393       -0.100185393
# 4:   TSLA 2014-10-01 760262500     48.440     53.108    43.464      48.340         48.340        -0.004038219       -0.004038219
# 5:   TSLA 2014-11-03 538609000     48.600     51.998    45.700      48.904         48.904         0.011667336        0.011667336
# 6:   TSLA 2014-12-01 634731000     48.232     48.494    38.530      44.482         44.482        -0.090422074       -0.090422074

tail(tesla_DT)
# ticker   ref.date     volume price.open price.high price.low price.close price.adjusted ret.adjusted.prices ret.closing.prices
# 1:   TSLA 2020-12-01 1196346000     597.59     718.72    541.21      705.67         705.67          0.24325231         0.24325231
# 2:   TSLA 2021-01-04  705694800     719.46     900.40    717.19      793.53         793.53          0.12450586         0.12450586
# 3:   TSLA 2021-02-01  522857900     814.29     880.50    619.00      675.50         675.50         -0.14874047        -0.14874047
# 4:   TSLA 2021-03-01  942452400     690.11     721.11    539.49      667.93         667.93         -0.01120652        -0.01120652
# 5:   TSLA 2021-04-01  678467400     688.37     780.79    659.42      709.44         709.44          0.06214725         0.06214725
# 6:   TSLA 2021-05-03  427718900     703.80     706.00    546.98      563.46         563.46         -0.20576790        -0.20576790


str(tesla_DT)
# Classes 'data.table' and 'data.frame':	83 obs. of  10 variables:
#   $ ticker             : chr  "TSLA" "TSLA" "TSLA" "TSLA" ...
# $ ref.date           : Date, format: "2014-07-16" "2014-08-01" "2014-09-02" "2014-10-01" ...
# $ volume             : num  2.57e+08 5.74e+08 6.64e+08 7.60e+08 5.39e+08 ...
# $ price.open         : num  44.4 45.2 55.1 48.4 48.6 ...
# $ price.high         : num  46.4 54.4 58.3 53.1 52 ...
# $ price.low          : num  42.7 45.2 48 43.5 45.7 ...
# $ price.close        : num  44.7 53.9 48.5 48.3 48.9 ...
# $ price.adjusted     : num  44.7 53.9 48.5 48.3 48.9 ...
# $ ret.adjusted.prices: num  NA 0.20779 -0.10019 -0.00404 0.01167 ...
# $ ret.closing.prices : num  NA 0.20779 -0.10019 -0.00404 0.01167 ...
# - attr(*, ".internal.selfref")=<externalptr> 

# izbacit cu 1.12.2020. jer su mi tamo neke vrijednosti NA. 
tesla_DT<-tesla_DT[2:83,]


# recimo da me zanimaju cijene zatvaranja dionica na datume mjerenja

close <- cbind(tesla_DT[,2],tesla_DT[,7])

date=close[,1]
cl=close[,2]


close$newday = as.Date(close$ref.date,"%Y-%m-%d")
plot(close$newday,close$price.close)
plot(close$newday,close$price.close,type='l',xlab="vrijeme",ylab="cijena",col="blue")

# recimo da zelimo vidjeti podatke od 2020 -2021 

novo<-close[close$newday>='2020-01-01']
close[close$newday>='2020-01-01']
# ref.date price.close     newday
# 1: 2020-01-02     130.114 2020-01-02
# 2: 2020-02-03     133.598 2020-02-03
# 3: 2020-03-02     104.800 2020-03-02
# 4: 2020-04-01     156.376 2020-04-01
# 5: 2020-05-01     167.000 2020-05-01
# 6: 2020-06-01     215.962 2020-06-01
# 7: 2020-07-01     286.152 2020-07-01
# 8: 2020-08-03     498.320 2020-08-03
# 9: 2020-09-01     429.010 2020-09-01
# 10: 2020-10-01     388.040 2020-10-01
# 11: 2020-11-02     567.600 2020-11-02
# 12: 2020-12-01     705.670 2020-12-01
# 13: 2021-01-04     793.530 2021-01-04
# 14: 2021-02-01     675.500 2021-02-01
# 15: 2021-03-01     667.930 2021-03-01
# 16: 2021-04-01     709.440 2021-04-01
# 17: 2021-05-03     563.460 2021-05-03

plot(novo$newday,novo$price.close,type='l',xlab="vrijeme",ylab="cijena",col="blue")
plot(novo$newday,novo$price.close)
#zelim nac datum kad je bio nagli pad

novije<-novo[8:17]
novije
# ref.date price.close     newday
# 1: 2020-08-03      498.32 2020-08-03
# 2: 2020-09-01      429.01 2020-09-01
# 3: 2020-10-01      388.04 2020-10-01
# 4: 2020-11-02      567.60 2020-11-02
# 5: 2020-12-01      705.67 2020-12-01
# 6: 2021-01-04      793.53 2021-01-04
# 7: 2021-02-01      675.50 2021-02-01
# 8: 2021-03-01      667.93 2021-03-01
# 9: 2021-04-01      709.44 2021-04-01
# 10: 2021-05-03      563.46 2021-05-03

min<-which.min(novije$price.close)
min
# [1] 3
novije[3]
# ref.date price.close     newday
# 1: 2020-10-01      388.04 2020-10-01
# To je datum 1.10.2020. - sjecam se da su tada pale cijene dionica zbog pandemije



library(tidyverse)
library(caret)

set.seed(123)
model<-lm(close$price.close   ~poly(close$price.close,degree=5,data=close$price.close))

ggplot(close, aes(close$ref.date, price.close) ) + geom_point() + 
  stat_smooth(method = lm, formula = y ~ poly(x, 5, raw = TRUE))


# tako mozemo pomocu grafa predvidjeti na koji datum je kolika cijena zatvaranja
###################

# ovako mozemo predvidjeti kolika ce biti cijena zatvaranja ako znamo cijenu otvaranja... 

model<-lm(tesla_DT$price.close   ~poly(tesla_DT$price.open,degree=5,data=tesla_DT$price.close))

ggplot(tesla_DT, aes(price.open, price.close) ) + geom_point() +     stat_smooth(method = lm, formula = y ~ poly(x, 5, raw = TRUE))


############################ ARIMA ###############################################

install.packages("MASS")
install.packages("forecast")
install.packages("tseries")

library(MASS)
library(tseries)
library(forecast)
podaci<-cbind(tesla_DT[,2],tesla_DT[,8])
price <- cbind(tesla_DT[,8])

train<-price[1:65]
test<-price[66:82]

lnstock<-log(train)

# Vremenski niz i auto.arima :
pricearima<-ts(lnstock,start=c(2014,07),frequency = 12)
fitlnstock<-auto.arima(pricearima)
fitlnstock
plot(pricearima ,type="l")
title("Tesla - cijene")
exp(lnstock)


# Cijene koje ARIMA predvida : 

predvidjenecijene_ln<-forecast(fitlnstock,h=17)
predvidjenecijene_ln
plot(predvidjenecijene_ln)


predvidjenecijene_extracted<-as.numeric(predvidjenecijene_ln$mean)
konacne_predvidjene_cijene=exp(predvidjenecijene_extracted)
konacne_predvidjene_cijene

okvir<-data.frame(test,konacne_predvidjene_cijene)
col_headings<-c("Prava cijena","Predvidjena cijena")
names(okvir)<-col_headings

###################### od 2019. godine - svjezi podaci : 



train<-price[57:77]
test<-price[78:82]

lnstock<-log(train)

# Vremenski niz i auto.arima :
pricearima<-ts(lnstock,start=c(2019,04),frequency = 12)
fitlnstock<-auto.arima(pricearima)
fitlnstock
plot(pricearima ,type="l")
title("Tesla - cijene")
exp(lnstock)


# Cijene koje ARIMA predvida : 

predvidjenecijene_ln<-forecast(fitlnstock,h=5)
predvidjenecijene_ln
plot(predvidjenecijene_ln)


predvidjenecijene_extracted<-as.numeric(predvidjenecijene_ln$mean)
konacne_predvidjene_cijene=exp(predvidjenecijene_extracted)
konacne_predvidjene_cijene

okvir<-data.frame(test,konacne_predvidjene_cijene)
col_headings<-c("Prava cijena","Predvidjena cijena")
names(okvir)<-col_headings

okvir
# Prava cijena Predvidjena cijena
# 1       793.53           807.3996
# 2       675.50           923.7945
# 3       667.93          1056.9690
# 4       709.44          1209.3420
# 5       586.78          1383.6811



#### BUDUCNOST : - predvidanje za 2022. i 2023. godinu. 



predvidjenecijene_ln<-forecast(fitlnstock,h=29)
predvidjenecijene_ln
plot(predvidjenecijene_ln)


