# U ovoj skripti ce biti obradeni podaci Uber pick-upova U New York Cityju.
# Podaci su koristeni u svrhu razvijanja intuicije za razumijevanje kupaca koji koriste Uber za prijevoz
# Za vizualizaciju cu koristiti uglavnom paket ggplot2 koji je spomenut na vjezbama.
# Podaci su zastarjeli jer su iz 2014., ali su lako dostupni (skinuti s Kaggle-a) 
####pa sam se odlucila iskoristiti taj dataset za demonstraciju

##### IZVOR, LITERATURA, REFERENCE  :::
################## https://blogs.mathworks.com/loren/2016/01/20/mapping-uber-pickups-in-new-york-city/ ; Loren Shure

## MOTIVACIJA --> Ovi podaci mogu biti korisni jer se iz njih da zakljuciti 
###u kojem godisnjem dobu, mjesecima,  danima u mjesecu ili danima u tjednu 
### ima vise odnosno manje voznji.
## Mozemo te podatke analizirati na razini baza Ubera pa znati koje lokacije imaju vecu(manju) potrebu za prijevozom
### Ovo moze biti korisno Uber vozacima kako bi se znali rasporediti po lokacijama u gradu. 
### Od znacaja je i kompaniji Uber jer zna kojim danima ce koliko zaraditi i kada bi mogli date popuste,
####a kada povecati cijene
## Takoder moze biti korisno onima kojima taxiranje nije jedini posao pa znaju kojim danima ce to raditi, a kojim ne.
### Moze biti korisno kompanijama da rasporede zaposlenike kojim danima rade od kuce, a kojim iz ureda 
### sto doprinosi uredenju prometa i smanjenju guzvi. 
## Naravno, korisno je imati sliku o prijevozima u gradu opcenito za kontroliranje prometa.



# ####BIBLIOTEKE :
# ggplot2
# najpopularnija biblioteka za vizualizaciju podataka koja se najvise koristi za stvaranje parcela estetske vizualizacije.
# 
# ggthemes
#  dodatak za glavnu ggplot2 bibliotekuu. 
  #Ovim mozemo stvoriti bolje stvaranje dodatnih tema i ljestvica pomocu mainstream ggplot2 paketa.
# 
# 
# lubridata
#  skup podataka ukljucuje razlicite vremenske okvire.
   #Da bismo razumjeli podatke u odvojenim vremenskim kategorijama, koristimo paket lubridata
# 
# dplyr
# Ovaj je paket lingua franca manipulacije podacima u R.
# 
# tidyr
# Osnovno nacelo uredenja je sredivanje stupaca u kojima je svaka varijabla prisutna u stupcu,
  #svako opazanje predstavljeno je retkom, a svaka vrijednost prikazuje celiju.
# 
# DT
# povezivanje s JavaScript bibliotekom pod nazivom - Datatables.
# 
# scales
# Pomocu grafickih ljestvica podatke mozemo automatski preslikati na ispravne ljestvice 
 # dobro postavljenim osima ilegendama.
# svaki paket sam ubacila u install.packages('imepaketa')
library(ggplot2)
library(ggthemes)
library(lubridate)
library(dplyr)
library(tidyr)
library(DT)
library(scales)

colors = c("#CC1011", "#665555", "#05a399", "#cfcaca", "#f5e840", "#0683c9", "#e075b0")

knitr::opts_chunk$set(echo=TRUE)
# Opcije za komade R koda. Prilikom izvodenja R koda, objekt opts_chunk (zadane opcije) 
# ne mijenjaju zaglavlja dijelova (lokalne dijelove opcija spajaju se sa zadanim opcijama), 
# dok se opts_current (trenutne opcije) mijenja s razlicitim zaglavljima dijelova 
#i uvijek odrazava opcije za trenutni komad .

# namjestam si radni direktorij u koji sam spremila .csv datoteke
setwd('C:\\Users\\Matea\\Desktop\\RUDARENJE PODATAKA\\RP_projekt_MateaLukic')
getwd()
#[1] "C:/Users/Matea/Desktop/RUDARENJE PODATAKA/RP_projekt_MateaLukic"


####################### Stvaranje vektora boja koje ce se implementirati u parcele #########################
# U ovom koraku stvorit cemo vektor  boja koje ce biti ukljucene u funkcije crtanja. 

# colors = c("#CC1011", "#665555", "#05a399", "#cfcaca", "#f5e840", "#0683c9", "#e075b0") # estetika...

#######################Citanje podataka u njihovim oznacenim varijablama###############################
# Sada cu procitati nekoliko CSV datoteka koje sadrze podatke od travnja 2014. do rujna 2014.
# Pohranit cu ih u odgovarajuce okvire podataka kao sto su apr_data, may_data itd. 
# Nakon sto procitam datoteke, kombinirat cu sve te podatke u jedan okvir podataka nazvan 'data_2014'.
# Zatim cu u sljedecem koraku izvrsiti odgovarajuce oblikovanje stupca Date.Time.
#Zatim cu nastaviti stvarati cimbenike vremenskih objekata poput dana, mjeseca, godine itd.


 apr_data <- read.csv("uber-raw-data-apr14.csv")
 may_data <- read.csv("uber-raw-data-may14.csv")
 jun_data <- read.csv("uber-raw-data-jun14.csv")
 jul_data <- read.csv("uber-raw-data-jul14.csv")
 aug_data <- read.csv("uber-raw-data-aug14.csv")
 sep_data <- read.csv("uber-raw-data-sep14.csv")
 
data_2014 <- rbind(apr_data,may_data, jun_data, jul_data, aug_data, sep_data)

# rbind() ---> Kombiniranje R objekata po redovima -->
# Uzmimamo niz argumenata vektora, matrice ili okvira podataka i kombiniramo po stupcima ili redovima.


######################## POGLED NA PODATKE ####################################

str(data_2014)
# 'data.frame':	4534327 obs. of  12 variables:
#   $ Date.Time: POSIXct, format: "2014-04-01 00:11:00" "2014-04-01 00:17:00" "2014-04-01 00:21:00" "2014-04-01 00:28:00" ...
# $ Lat      : num  40.8 40.7 40.7 40.8 40.8 ...
# $ Lon      : num  -74 -74 -74 -74 -74 ...
# $ Base     : chr  "B02512" "B02512" "B02512" "B02512" ...
# $ Time     : chr  "00:11:00" "00:17:00" "00:21:00" "00:28:00" ...
# $ day      : Factor w/ 31 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ month    : Ord.factor w/ 6 levels "Apr"<"May"<"Jun"<..: 1 1 1 1 1 1 1 1 1 1 ...
# $ year     : Factor w/ 1 level "2014": 1 1 1 1 1 1 1 1 1 1 ...
# $ dayofweek: Ord.factor w/ 7 levels "Sun"<"Mon"<"Tue"<..: 3 3 3 3 3 3 3 3 3 3 ...
# $ hour     : Factor w/ 24 levels "0","1","2","3",..: 1 1 1 1 1 1 1 1 1 2 ...
# $ minute   : Factor w/ 60 levels "0","1","2","3",..: 12 18 22 29 34 34 40 46 56 2 ...
# $ second   : Factor w/ 1 level "0": 1 1 1 1 1 1 1 1 1 1 ...

head(data_2014)
# Date.Time     Lat      Lon   Base     Time day month year dayofweek hour minute second
# 1 2014-04-01 00:11:00 40.7690 -73.9549 B02512 00:11:00   1   Apr 2014       Tue    0     11      0
# 2 2014-04-01 00:17:00 40.7267 -74.0345 B02512 00:17:00   1   Apr 2014       Tue    0     17      0
# 3 2014-04-01 00:21:00 40.7316 -73.9873 B02512 00:21:00   1   Apr 2014       Tue    0     21      0
# 4 2014-04-01 00:28:00 40.7588 -73.9776 B02512 00:28:00   1   Apr 2014       Tue    0     28      0
# 5 2014-04-01 00:33:00 40.7594 -73.9722 B02512 00:33:00   1   Apr 2014       Tue    0     33      0
# 6 2014-04-01 00:33:00 40.7383 -74.0403 B02512 00:33:00   1   Apr 2014       Tue    0     33      0

tail(data_2014)
# Date.Time     Lat      Lon   Base     Time day month year dayofweek hour minute second
# 4534322 2014-09-30 22:57:00 40.7300 -73.9565 B02764 22:57:00  30   Sep 2014       Tue   22     57      0
# 4534323 2014-09-30 22:57:00 40.7668 -73.9845 B02764 22:57:00  30   Sep 2014       Tue   22     57      0
# 4534324 2014-09-30 22:57:00 40.6911 -74.1773 B02764 22:57:00  30   Sep 2014       Tue   22     57      0
# 4534325 2014-09-30 22:58:00 40.8519 -73.9319 B02764 22:58:00  30   Sep 2014       Tue   22     58      0
# 4534326 2014-09-30 22:58:00 40.7081 -74.0066 B02764 22:58:00  30   Sep 2014       Tue   22     58      0
# 4534327 2014-09-30 22:58:00 40.7140 -73.9496 B02764 22:58:00  30   Sep 2014       Tue   22     58      0

#### Dakle, radi se o okviru podataka koji sadrzi :
# Lat - Zemljopisna sirina Uber-ovih preuzimanja (latitude)
# Lon - Zemljopisna duzina preuzimanja Ubera (longitude)
# Base - Baza tj. TLC osnovni kod tvrtke povezan s Uberovim preuzimanjem
# Ostalo je ocito vrijeme, dan, mjesec, godina...



 
### Pomocu summary() se 


data_2014$Date.Time <- as.POSIXct(data_2014$Date.Time, format = "%m/%d/%Y %H:%M:%S")
# as.POSIXct je funkcija za datum-vrijeme konverziju --> sluzi za manipulaciju objekata koji predstavljaju datum(vrijeme)

data_2014$Time <- format(as.POSIXct(data_2014$Date.Time, format = "%m/%d/%Y %H:%M:%S"), format="%H:%M:%S")
# format() je funkcija koju koristimo da za formatiranje R objekta koji nam je zgodan za ispis

data_2014$Date.Time <- ymd_hms(data_2014$Date.Time)

data_2014$day <- factor(day(data_2014$Date.Time))
data_2014$month <- factor(month(data_2014$Date.Time, label = TRUE))
data_2014$year <- factor(year(data_2014$Date.Time))
data_2014$dayofweek <- factor(wday(data_2014$Date.Time, label = TRUE))
#factor() se koristi za enkodiranje vektora u faktor ('category' i 'enumerated type' se takoder koriste kao faktori)
# funkcije day(), month(), year() su za izoliranje odgovarajucih datumskih segmenata iz standardnog datumskog formata
data_2014$hour <- factor(hour(hms(data_2014$Time)))
data_2014$minute <- factor(minute(hms(data_2014$Time)))
data_2014$second <- factor(second(hms(data_2014$Time)))

# hms() je funkcija koja parsira sate,minute,sekunde


###########################Planiranje putovanja po satima u danu########################################
# U sljedecem koraku koristit cu funkciju ggplot za crtanje broja putovanja koja su putnici obavili u danu.
# Takoder cu upotrijebiti dplyr za prikupljanje podataka.
# U vizualizacijama koje su rezultirale mozemo razumjeti kako se broj putnika vozi tijekom dana. 
# Primjecujemo da je broj putovanja veci navecer oko 17:00 i 18:00.

hour_data <- data_2014 %>%    group_by(hour) %>%   dplyr::summarize(Total = n()) 
# grupirala sam podatke po satima
datatable(hour_data)
# datatable() daje tablicu podataka iz argumenta?
#### tri stranice podataka ---> treba pokrenuti kod da ih vidimo

#################### ggplot -->
# ggplot () inicijalizira ggplot objekt.
# Moze se koristiti za deklariranje okvira ulaznih podataka za grafiku i 
# za odredivanje skupa estetike radnje koja je namijenjena zajednistvu u svim sljedecim slojevima,
# osim ako je to posebno nadjacano.
# Kako mi je ovo vazna funkcija, malo cu objasniti argumente ::::
## 1. argument su podaci
## 2. mapiranje --> aes() --> aesthetic mappings --> 
#################### objasnjava kako su varijable u podacima mapirane vizualnim svojstvima geoma
## geom_bar() -->sluzi za trakaste grafikone

ggplot(hour_data, aes(hour, Total)) + 
  geom_bar( stat = "identity", fill = "steelblue", color = "red") +
  ggtitle("Trips Every Hour") +
  theme(legend.position = "none") +
  scale_y_continuous(labels = comma)
# Graf na x-osi ima sate, a na y-osi putovanja
# Najmanje voznji je u 2 i 3 ujutro dok je najvise voznji izmedu 16 i 20 sati 
## Voznji je opcenito vise satima kada ljudi idu na posao ili se vracaju s posla
# Graf skoro pa ima "oblik normalne distribucije"
month_hour <- data_2014 %>%
  group_by(month, hour) %>%
  dplyr::summarize(Total = n())
# podaci grupirani prema mjesecima pa prema satima

ggplot(month_hour, aes(hour, Total, fill = month)) + 
  geom_bar( stat = "identity") +
  ggtitle("Trips by Hour and Month") +
  scale_y_continuous(labels = comma)
#  Graf na x-osi ima sate, a na y-osi putovanja; Boje odgovaraju mjesecima
# Odavdje zakljucujemo da se s proljeca na ljeto povecava broj voznji

################### Ucrtavanje podataka po putovanjima tijekom svakog dana u mjesecu ########################
# Sastavljanje podataka na temelju svakog dana u mjesecu. 
# Iz vizualizacije koja proizlazi se da uociti da je 30. u mjesecu imao 
# najvise putovanja u godini, cemu je najvise pridonio mjesec travanj.

day_group <- data_2014 %>%
  group_by(day) %>%
  dplyr::summarize(Total = n()) 
datatable(day_group)
# koristim datatable za prikaz brojeva voznji po danima u mjesecu, podaci grupirano prema danima

ggplot(day_group, aes(day, Total)) + 
  geom_bar( stat = "identity", fill = "steelblue") +
  ggtitle("Trips Every Day") +
  theme(legend.position = "none") +
  scale_y_continuous(labels = comma)
# Koristim ggplot() za crtanje grafa -> vizualizacija putovanja po danima u mjesecu
# Na x-osi su dani u mjesecu, a na y-osi broj voznji
# Generalno, najmanje voznji je 31. u mjesecu,  najvise 30.,ostali dani imaju podjednak broj voznji.
##Neki mjeseci niti nemaju 31 dan. Ocekujemo da ce za 31. dan stupac biti upola manje.

######## VOZNJE PO DANIMA I MJESECIMA
day_month_group <- data_2014 %>%
  group_by(month, day) %>%
  dplyr::summarize(Total = n())
#podaci grupirani prema mjesecu pa prema danu u mjesecu


ggplot(day_month_group, aes(day, Total, fill = month)) + 
  geom_bar( stat = "identity") +
  ggtitle("Trips by Day and Month") +
  scale_y_continuous(labels = comma) +
  scale_fill_manual(values = colors)
# Graf kojem je argument gore navedeni objekt - "day_month_group"
# Graf na x-osi ima dane u mjesecu, a na y-osi putovanja; Boje odgovaraju mjesecima
# Odavdje zakljucujemo da se s proljeca na ljeto povecava broj voznji, a na kraju mjeseca je najveci broj voznji.

######################### Broj putovanja koja se odvijaju tijekom mjeseci u godini ######################
# Vizualizacija  broja putovanja koja se odvijaju svakog mjeseca u godini.
# U vizualizaciji rezultata da se uociti da je vecina putovanja obavljena tijekom mjeseca rujna. 
#Nadalje, dobivamo i vizualna izvjesca o broju putovanja koja su obavljena svakog dana u tjednu.
month_group <- data_2014 %>%
  group_by(month) %>%
  dplyr::summarize(Total = n()) 
datatable(month_group)
# grupiram prema mjesecu sve podatke iz 2014

ggplot( month_group, aes(month, Total, fill = month)) + 
  geom_bar( stat = "identity") +
  ggtitle("Trips by Month") +
  theme(legend.position = "none") +
  scale_y_continuous(labels = comma) +
  scale_fill_manual(values = colors)
# Graf koji na x-osi ima mjesece od travnja do rujna, a na y-osi broj voznji.
# Najvise voznji je u rujnu, a najmanje u travnju s tim da je broj voznji od travnja do rujna rastao.
# Mozemo to interpretirati na nacin da se promet povecava kako dolazi ljeto.
## No, Uber je osnovan 2009. u San Franciscu, tako da u travnju 2014. u NYC-u jos bio u razvoju.
## Prema ovim podacima "rasirio" u pola godine. 
## Dodala bih i da je Uberov konkurent Lyft osnovan 2012. godine
#### te da zbog Lyfta, Uber u 2014. nije imao nagli porast i velike razlike medu susjednom mjesecima.

#########

month_weekday <- data_2014 %>%
  group_by(month, dayofweek) %>%
  dplyr::summarize(Total = n())
# grupiram prema mjesecu, zatim prema danima u tjednu

ggplot(month_weekday, aes(month, Total, fill = dayofweek)) + 
  geom_bar( stat = "identity", position = "dodge") +
  ggtitle("Trips by Day and Month") +
  scale_y_continuous(labels = comma) +
  scale_fill_manual(values = colors)
# Na x-osi su prikazani mjeseci [travanj, rujan] , a na y-osi broj voznji.
# Stupci odgovaraju danima u tjednu, svaki dan ima svoju boju.
# Nedjeljom i ponedjeljkom, u pravilu uvijek ima manje voznji u odnosu na ostale dane.
# U svibnju su Njujorzani najcesce petkom birali Uber za prijevoz,
### dok su u ostalim mjesecima se nesto cesce vozili cetvrtkom

######################## Doznavanje broja putovanja po bazama #############################
# U sljedecoj vizualizaciji ucrtavam broj putovanja koja su putnici obavili iz svake baze. 
# Svega je pet baza, primijetili smo da je B02617 imao najveci broj putovanja.
# Nadalje, ova baza imala je najveci broj putovanja u mjesecu B02617.
# U cetvrtak su zabiljezena najvisa putovanja u tri baze - B02598, B02617, B02682.

### Najpopulatnije Uber- baze u NYC (prvih 5 prikazujem na grafu)  : 
# Baza    Ime Baze
# B02512:	Unter
# B02598:	Hinter
# B02617:	Weiter
# B02682:	Schmecken
# B02764:	Danach-NY

# B02765:	Grun
# B02835:	Dreist
# B02836:	Drinnen

# Vidimo da baze oznacavaju prijedloge na njemackom jeziku pa mozemo zakljuciti koja baza odgovara kojem dijelu grada.
# (Unter= ispod; Hinter= iza; Weiter= sljedeci ili nastavak itd, Danach= nakon toga)

ggplot(data_2014, aes(Base)) + 
  geom_bar(fill = "darkred") +
  scale_y_continuous(labels = comma) +
  ggtitle("Trips by Bases")
# Ovo je stupcasti graf u kojem koristimo data_2014$Base (baze) za  mapiranje
# Na x-osi su prikazane baze, a na y-osi broj voznji.
# Iz grafa vidimo da je B02617 (Weiter) najpopularnija baza s gotovo 1.5M voznji, 
### a slijede ju Hinter (1.4M) i Unter (1.2M) 

##########

ggplot(data_2014, aes(Base, fill = month)) + 
  geom_bar(position = "dodge") +
  scale_y_continuous(labels = comma) +
  ggtitle("Trips by Bases and Month") +
  scale_fill_manual(values = colors)
# X-os su baze, y-os broj voznji, stupci predstavljaju mjesece, a svaki mjesec je oznacen drugom bojom.
# Sto se tice baze Unter, u svim mjesecima je imala podjednak broj voznji, kao i Hinter i Schmecken
###########

ggplot(data_2014, aes(Base, fill = dayofweek)) + 
  geom_bar(position = "dodge") +
  scale_y_continuous(labels = comma) +
  ggtitle("Trips by Bases and DayofWeek") +
  scale_fill_manual(values = colors)
# X-os su baze, y-os broj voznji, stupci predstavljaju dane tjedna, a svaki dan je oznacen drugom bojom.
# Sto se tice baze Unter, u svim danima je imala podjednak broj voznji, kao i Danach
# Ostale tri baze su imale manje prometa nedjeljom i ponedjeljkom,  vise ostalim danima, a najvise cetvrtkom i petkom.
# Bilo bi zanimljivo provjeriti kakvo je stanje sada cetvrtkom i 
### petkom s obzirom na to da je u mnogim firmama u NYC petak dan za rad od kuce i to se popularno zove "Petak u papucama"


############################################################
##############Stvaranje Heatmap vizualizacije dana, sata i mjeseca########################
# Ucrtat cu pet parcela toplotne karte -
#   
#   Prvo cu nacrtati toplinsku kartu po satima i danima.
# Drugo, sastavit cu toplinsku kartu po mjesecima i danima.
# Trece, toplotna karta po mjesecima i danima u tjednu.
# Cetvrto, toplinska karta koja ocrtava mjesec i baze.
# Na kraju cu ucrtati toplotnu kartu prema bazama i danima u tjednu.

day_and_hour <- data_2014 %>%
  group_by(day, hour) %>%
  dplyr::summarize(Total = n())
#grupiranje prema danima i satima
datatable(day_and_hour)

######

ggplot(day_and_hour, aes(day, hour, fill = Total)) +
  geom_tile(color = "white") +
  ggtitle("Heat Map by Hour and Day")
# toplotna mapa kojoj su na x-osi dani, na y-osi sati, a jacina boje odgovara broju voznji
# Iz toplotne karte vidimo da je najvise voznji izmedu 17 i 20hm a najmanje u intervalu od 1 do 5h 
##########

ggplot(day_month_group, aes(day, month, fill = Total)) +
  geom_tile(color = "white") +
  ggtitle("Heat Map by Month and Day")
# toplotna mapa gdje su dani u mjesecu na x-osi, a mjeseci na y-osi...dok jacina boje odgovara broju voznji
# vidimo daje nekako najvise voznji bilo u rujnu u razmacima od 7 dana, a najmanje u travnju
#opcenito se da zakljuciti da preko proljeca bude manje voznji u odnosu na ljetne mjesece!
############

ggplot(month_weekday, aes(dayofweek, month, fill = Total)) +
  geom_tile(color = "white") +
  ggtitle("Heat Map by Month and Day of Week")
#toplotna mapa sto na x-osi ima dane u tjednu, a na y-osi mjesece...jacina boje oznacava broj voznji
# najmanje voznji je bilo nedjeljama u travnju i svibnju, a najvise petkom i subotom u kolovozu i rujnu
# mozemo zakljuciti da bude manje voznji pocetkom tjedna u proljetnim mjesecima, pa se to povecava
####kako ide ljeto, radni tjedan i vikend
#################################

month_base <-  data_2014 %>%
  group_by(Base, month) %>%
  dplyr::summarize(Total = n()) 

day0fweek_bases <-  data_2014 %>%
  group_by(Base, dayofweek) %>%
  dplyr::summarize(Total = n()) 

ggplot(month_base, aes(Base, month, fill = Total)) +
  geom_tile(color = "white") +
  ggtitle("Heat Map by Month and Bases")
# na x-osi je 5 Uber baza, a na y-osi mjeseci od travnja do rujna; jacina boje oznacava broj voznji
# baze B02512 i B02764 imaju manje voznji tokom mjeseci koje promatramo u odnosu na ostale tri baze
## baza B02617 ima znatno vise voznji tijekom ljetnih mjeseci u odnosu na druge baze
#########

ggplot(day0fweek_bases, aes(Base, dayofweek, fill = Total)) +
  geom_tile(color = "white") +
  ggtitle("Heat Map by Bases and Day of Week")

# na x-osi je 5 Uber baza, a na y-osi dani u tjednu; jacina boje oznacava broj voznji
# baze B02512 i B02764 imaju manje voznji tokom cijelog tjedna u odnosu na ostale tri baze
## baze B02617 i B02598 imaju jako puno voznji cetvrtkom i petkom
###################### Stvaranje vizualizacije karte u New Yorku ########################################
# U posljednjem cemo dijelu vizualizirati voznje u New Yorku stvaranjem geo-parcele koja ce nam 
# pomoci da vizualiziramo voznje tijekom 2014. (travanj - rujan) i baza u istom razdoblju.

min_lat <- 40.5774
max_lat <- 40.9176
min_long <- -74.15
max_long <- -73.7004

ggplot(data_2014, aes(x=Lon, y=Lat)) +
  geom_point(size=1, color = "blue") +
  scale_x_continuous(limits=c(min_long, max_long)) +
  scale_y_continuous(limits=c(min_lat, max_lat)) +
  theme_map() +
  ggtitle("NYC MAP BASED ON UBER RIDES DURING 2014 (APR-SEP)")

ggplot(data_2014, aes(x=Lon, y=Lat, color = Base)) +
  geom_point(size=1) +
  scale_x_continuous(limits=c(min_long, max_long)) +
  scale_y_continuous(limits=c(min_lat, max_lat)) +
  theme_map() +
  ggtitle("NYC MAP BASED ON UBER RIDES DURING 2014 (APR-SEP) by BASE")

############################  Sazetak #######################################

# Ovime bismo mogli zakljuciti kako je vrijeme utjecalo na putovanja kupaca.
# Konacno, imamo geo-parcelu New York Cityja koja nam je pruzila detalje o tome 
# kako su razliciti korisnici putovali iz razlicitih baza.
