library("afex")
library("papaja")
setwd("l:/daten/Monster_3")
fs <- list.files(pattern="monster3_memory")

data_memory <- read.csv(fs[1])
for (i in fs[-1]){
  temp <- read.csv(i)
  data_memory <- rbind(data_memory, temp)
}

data_memory$paired_tone <- ifelse(data_memory$target_role=="starting_melody","melody",ifelse(data_memory$target_role=="ending_melody","melody",ifelse(data_memory$target_role=="starting_scream","scream","scream")))
data_memory$relation <- ifelse(data_memory$target_role=="starting_melody","starting",ifelse(data_memory$target_role=="ending_melody","ending",ifelse(data_memory$target_role=="starting_scream","starting","ending")))                                                                                             


data_memory$correct <- 0

for(i in 1:nrow(data_memory)){
  if(data_memory$target_role[i]=="starting_melody" & data_memory$start_melody[i]=="yes"){
    data_memory$correct[i] <- 1
  }
  if(data_memory$target_role[i]=="starting_scream" & data_memory$start_scream[i]=="yes"){
    data_memory$correct[i] <- 1
  }
  if(data_memory$target_role[i]=="ending_melody" & data_memory$end_melody[i]=="yes"){
    data_memory$correct[i] <- 1
  }
  if(data_memory$target_role[i]=="ending_scream" & data_memory$end_scream[i]=="yes"){
    data_memory$correct[i] <- 1
  }
}

data_memory$mem_time <- NA

data_memory$mem_time <- data_memory$time_mem_delay - data_memory$time_mem_form

aov_ez(id = "subject_nr", data=data_memory, dv="mem_time", within=c("paired_tone","relation"))
apa_barplot(id = "subject_nr",
            data=data_memory,
            dv="mem_time",
            factors=c("relation","paired_tone")
)