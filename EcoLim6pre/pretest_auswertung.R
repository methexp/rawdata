setwd("l:/daten/EcoLim6pre")
fs <- list.files(pattern="learning")
learning <- read.csv(fs[1])

for (i in fs[-1]){
  temp <- read.csv(i)
  learning <- rbind(learning, temp)
}

learning$chosen_number <- NA
learning$chosen_file   <- NA

for (i in 1:nrow(learning)){
  if(learning$trial_task[i]=="subjective"){
    if (learning$subj_1[i]=="yes"){
      learning$subjective_rating[i] <- 1
    }
    if (learning$subj_2[i]=="yes"){
      learning$subjective_rating[i] <- 2
    }
    if (learning$subj_3[i]=="yes"){
      learning$subjective_rating[i] <- 3
    }
    if (learning$subj_4[i]=="yes"){
      learning$subjective_rating[i] <- 4
    }
    if (learning$subj_5[i]=="yes"){
      learning$subjective_rating[i] <- 5
    }
    if (learning$subj_6[i]=="yes"){
      learning$subjective_rating[i] <- 6
    }
  }
  if(learning$trial_task[i]=="objective"){
    if (learning$opt_1[i]=="yes"){
      learning$chosen_number[i] <- 1
    }
    if (learning$opt_2[i]=="yes"){
      learning$chosen_number[i] <- 2
    }
    if (learning$opt_3[i]=="yes"){
      learning$chosen_number[i] <- 3
    }
    if (learning$opt_4[i]=="yes"){
      learning$chosen_number[i] <- 4
    }
    if (learning$opt_5[i]=="yes"){
      learning$chosen_number[i] <- 5
    }
    if (learning$opt_6[i]=="yes"){
      learning$chosen_number[i] <- 6
    }
  }
}

for (i in 1:nrow(learning)){
  if(learning$trial_task[i]=="objective"){
    if (learning$chosen_number[i]==1){
      learning$chosen_file[i] <- learning$id_opt_1[i]
    }
    if (learning$chosen_number[i]==2){
      learning$chosen_file[i] <- learning$id_opt_2[i]
    }
    if (learning$chosen_number[i]==3){
      learning$chosen_file[i] <- learning$id_opt_3[i]
    }
    if (learning$chosen_number[i]==4){
      learning$chosen_file[i] <- learning$id_opt_4[i]
    }
    if (learning$chosen_number[i]==5){
      learning$chosen_file[i] <- learning$id_opt_5[i]
    }
    if (learning$chosen_number[i]==6){
      learning$chosen_file[i] <- learning$id_opt_6[i]
    }
  }
}


learning$id_correct <- NA

for(i in 1:nrow(learning)){
  if(learning$trial_task[i]=="objective"){
    learning$id_correct[i] <- ifelse(learning$chosen_file[i]==learning$cs_numbers[i],1,0)
  }
}


learning$cs_contrast <- ifelse(learning$cs_contrast==1,"dunkel",ifelse(learning$cs_contrast==2,"hell","mittel"))
                                                                                                                                     
apa_beeplot(data = learning, id = "subject_nr", dv = "subjective_rating", factors = c("cs_duration","cs_contrast"))






                                                                                                                                     
fs <- list.files(pattern="rate")
rating <- read.csv(fs[1])
for (i in fs[-1]){
  temp <- read.csv(i)
  rating <- rbind(rating, temp)
}

apa_beeplot(data = rating, id = "subject_nr", dv = "eval_rating", factors = c("cs_filename"))


fs <- list.files(pattern="famil")
familiarity <- read.csv(fs[1])

for (i in fs[-1]){
  temp <- read.csv(i)
  familiarity <- rbind(familiarity, temp)
}

familiarity$eval_rating <- NA
for(i in 1:nrow(familiarity)){
  if(familiarity$s_bek[i]=="yes"){
    familiarity$eval_rating[i] <- 4
  }
  if(familiarity$e_bek[i]=="yes"){
    familiarity$eval_rating[i] <- 3
  }
  if(familiarity$e_unbek[i]=="yes"){
    familiarity$eval_rating[i] <- 2
  }
  if(familiarity$s_unbek[i]=="yes"){
    familiarity$eval_rating[i] <- 1
  }
}

apa_beeplot(data = familiarity, id = "subject_nr", dv = "eval_rating", factors = c("cs_filename"))

familiarity$type <- "famil"
rating$type <- "eval"

famil <- familiarity
famil$s_bek <- NULL
famil$e_bek <- NULL
famil$s_unbek <- NULL
famil$e_unbek <- NULL

both <- rbind(rating,famil)

apa_lineplot(data = both, id = "subject_nr", dv = "eval_rating", factors = c("cs_filename","type"))

tapply(rating$eval_rating,data.frame(rating$cs_filename),mean,na.rm=TRUE)
tapply(rating$eval_rating,data.frame(rating$cs_filename),sd,na.rm=TRUE)

tapply(famil$eval_rating,data.frame(famil$cs_filename),mean,na.rm=TRUE)
tapply(famil$eval_rating,data.frame(famil$cs_filename),sd,na.rm=TRUE)



tapply(learning$subjective_rating,data.frame(learning$cs_contrast,learning$cs_duration),mean,na.rm=TRUE)
tapply(learning$subjective_rating,data.frame(learning$cs_contrast,learning$cs_duration),sd,na.rm=TRUE)

tapply(learning$id_correct,data.frame(learning$cs_contrast,learning$cs_duration),mean,na.rm=TRUE)
tapply(learning$id_correct,data.frame(learning$cs_contrast,learning$cs_duration),sd,na.rm=TRUE)



cs_1 <- subset(learning,cs_numbers==10)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==11)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==15)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==16)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==18)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==2)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==22)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==23)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==24)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==25)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==37)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==39)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==4)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==40)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==5)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==9)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==7)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_1 <- subset(learning,cs_numbers==22)

tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),mean,na.rm=TRUE)
tapply(cs_1$subjective_rating,data.frame(cs_1$cs_contrast,cs_1$cs_duration),sd,na.rm=TRUE)

cs_10 <- subset(learning,cs_numbers==10)
cs_11 <- subset(learning,cs_numbers==11)
cs_15 <- subset(learning,cs_numbers==15)
cs_16 <- subset(learning,cs_numbers==16)
cs_18 <- subset(learning,cs_numbers==18)
cs_2 <- subset(learning,cs_numbers==2)
cs_23 <- subset(learning,cs_numbers==23)
cs_24 <- subset(learning,cs_numbers==24)
cs_25 <- subset(learning,cs_numbers==25)
cs_37 <- subset(learning,cs_numbers==37)
cs_39 <- subset(learning,cs_numbers==39)
cs_4 <- subset(learning,cs_numbers==4)
cs_40 <- subset(learning,cs_numbers==40)
cs_5 <- subset(learning,cs_numbers==5)
cs_9 <- subset(learning,cs_numbers==9)
cs_7 <- subset(learning,cs_numbers==7)
cs_22 <- subset(learning,cs_numbers==22)

cs_select <- rbind(cs_10,cs_11,cs_15,cs_16,cs_18,cs_2,cs_23,cs_24,cs_25,cs_37,cs_39,cs_4,cs_40,cs_5,cs_9,cs_7,cs_22)

tapply(cs_select$subjective_rating,data.frame(cs_select$cs_contrast,cs_select$cs_duration),mean,na.rm=TRUE)
tapply(cs_select$subjective_rating,data.frame(cs_select$cs_contrast,cs_select$cs_duration),sd,na.rm=TRUE)
