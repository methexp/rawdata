setwd("l:/daten/ecolim7")

fs <- list.files(pattern="learning")

learning <- read.csv(fs[1])

for(i in 2:33){
  tmp <- read.csv(fs[i])
  learning <- rbind(learning,tmp)
}

learning$subject_rating <- ifelse(learning$subj_1=="yes",1
                                  ,ifelse(learning$subj_2=="yes",2
                                  ,ifelse(learning$subj_3=="yes",3
                                  ,ifelse(learning$subj_4=="yes",4
                                  ,ifelse(learning$subj_5=="yes",5
                                  ,6)))))


library("papaja")

subj <- subset(learning,task=="subjective")

apa_lineplot(data=subj,id="subject_nr",dv="subject_rating",factors=c("cs_duration","cs_set"))

aov_ez(data=subj,dv="subject_rating",within=c("cs_duration"),between=c("cs_set"),id="subject_nr")



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
aov_ez(data=cont,dv="eval_rating",within=c("us_valence"),between=c("learning_condition","cs_set"),id="subject_nr")
aov_ez(data=cc,dv="eval_rating",within=c("us_valence","type"),id="subject_nr")
