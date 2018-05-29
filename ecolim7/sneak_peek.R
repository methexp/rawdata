setwd("l:/daten/ecolim7")
fs <- list.files(pattern="rating")

rating <- read.csv(fs[1])

for(i in 2:33){
  tmp <- read.csv(fs[i])
  rating <- rbind(rating,tmp)
}

crit <- subset(rating,type=="critical")
cont <- subset(rating,type=="control")
cc <- subset(rating,type!="filler")

library("afex")
library("papaja")

apa_lineplot(data=crit,dv="eval_rating",factors=c("us_valence"),id="subject_nr")
apa_lineplot(data=cont,dv="eval_rating",factors=c("us_valence"),id="subject_nr")
apa_lineplot(data=cc,dv="eval_rating",factors=c("us_valence","type"),id="subject_nr")

aov_ez(data=crit,dv="eval_rating",within=c("us_valence"),id="subject_nr")
aov_ez(data=cont,dv="eval_rating",within=c("us_valence"),id="subject_nr")
aov_ez(data=cc,dv="eval_rating",within=c("us_valence","type"),id="subject_nr")
