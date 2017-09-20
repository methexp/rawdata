## EP

library("afex")
library("papaja")
library("plyr")

setwd("l:/daten/Monster_3")
fs <- list.files(pattern="monster3_ep_main")
data_ep <- read.csv(fs[1])
for (i in fs[-1]){
  temp <- read.csv(i)
  data_ep <- rbind(data_ep, temp)
}


table(data_ep$response_first_response)
table(data_ep$correct_first_response)

data_ep<-subset(data_ep,response_first_response!="None")
data_ep$response_time_first_response<-as.numeric(data_ep$response_time_first_response)
data_ep<-subset(data_ep,correct_first_response==1)

data_ep$filter<-as.integer((data_ep$response_time_first_response<=1000) & (data_ep$response_time_first_response>=300))
data_ep_new<-subset(data_ep,filter==1)

table(data_ep$filter)

agg_ep <-aggregate(formula = response_time_first_response ~ subject_nr * prime_role * target_valence * prime_valence * prime_us *prime_relation + color_counter, data=data_ep_new, FUN=mean)
agg_ep_diff<- dcast(data=agg_ep, subject_nr   + prime_role + prime_valence + prime_us + prime_relation + color_counter  ~ target_valence, value.var="response_time_first_response")
agg_ep_diff$diff<-agg_ep_diff$negative-agg_ep_diff$positive


lisa <- agg_ep_diff
lisa$negative <- NULL
lisa$positive <- NULL

aov_ez(id = "subject_nr", data=lisa, dv="diff", within=c("prime_us","prime_relation"),between=c("color_counter"))
apa_lineplot(id = "subject_nr",data=lisa, dv="diff", factors=c("prime_us","prime_relation","color_counter"))



### ep error

library("afex")
library("papaja")
library("plyr")

setwd("l:/daten/Monster_3")
fs <- list.files(pattern="monster3_ep_main")
data_ep <- read.csv(fs[1])
for (i in fs[-1]){
  temp <- read.csv(i)
  data_ep <- rbind(data_ep, temp)
}

xxx <- subset(data_ep,response_first_response!="None")
xxx$trialnr <- NULL
xxx$trial_prime <- NULL

xxx <- aggregate(formula = correct_first_response ~ subject_nr * prime_us * prime_relation * target_valence + color_counter, data= xxx, FUN = mean)
#xxx <- dcast(data= xxx, subject_nr ~ prime_role * target_valence, value.var="correct_first_response")
xxx <- dcast(data= xxx, subject_nr * prime_us * prime_relation + color_counter ~ target_valence, value.var="correct_first_response")
xxx$diff<-xxx$positive-xxx$negative

aov_ez(id = "subject_nr", data=xxx, dv="diff", within=c("prime_us","prime_relation"),between=c("color_counter"))
apa_lineplot(id = "subject_nr",data=xxx, dv="diff", factors=c("prime_us","prime_relation"))
apa_lineplot(id = "subject_nr",data=xxx, dv="diff", factors=c("prime_us","prime_relation","color_counter"))

zz <- subset(xxx,prime_relation=="ending")
aov_ez(id = "subject_nr", data=zz, dv="diff", within=c("prime_us"),between=c("color_counter"))
apa_lineplot(id = "subject_nr",data=zz, dv="diff", factors=c("prime_us","color_counter"))
