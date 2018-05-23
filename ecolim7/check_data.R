setwd("L:/daten/ecolim7")

fs <- list.files(pattern="rating")
rating <- read.csv(fs[1])
for(i in 2:length(fs)){
  tmp <- read.csv(fs[i])
  rating <- rbind(rating,tmp)
}

fs <- list.files(pattern="valmem")
valmem <- read.csv(fs[1])
for(i in 2:length(fs)){
  tmp <- read.csv(fs[i])
  valmem <- rbind(valmem,tmp)
}

fs <- list.files(pattern="idmem")
idmem <- read.csv(fs[1])
for(i in 2:length(fs)){
  tmp <- read.csv(fs[i])
  idmem <- rbind(idmem,tmp)
}

fs <- list.files(pattern="objective")
objective <- read.csv(fs[1])
for(i in 2:length(fs)){
  tmp <- read.csv(fs[i])
  objective <- rbind(objective,tmp)
}

fs <- list.files(pattern="learning")
learning <- read.csv(fs[1])
for(i in 2:length(fs)){
  tmp <- read.csv(fs[i])
  learning <- rbind(learning,tmp)
}


# check exclusion criterion

long_target <- subset(learning, possible_target_trial_long != "no" & target_trial=="yes")
long_target$correct <- ifelse(long_target$response_target_response=="space",1,0)

agg_correct <- aggregate(data=long_target, correct ~ subject_nr, FUN = mean)

