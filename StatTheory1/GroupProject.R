# (t)errible   (p)oor  (f)air  (g)ood  (e)xcellent

# Create our bag of possible outcomes
bag <- c('t','t','t','p','p','p','f','f','f','g','g','g','g','g','e','e','e','e','e','e')

# get all possible groups for group A
groupA <- combn(bag,10)

# bag - group A = group B
groupB <- apply(groupA, 2, function(x) vecsets::vsetdiff( bag, x ))

# if you want to turn it into tables (not necessary)
# all_tables <- lapply(1:184756, function(x) tibble(groupA[,x], groupB[,x]) )

# create function for distance metric
get_distance_metric <- function(x){

ag <- groupA[,x]
bg <- groupB[,x]

vals <- c(
sum(ag == 't')/10 - sum(bg == 't')/10, # t group
sum(ag %in% c('t','p'))/10 - sum(bg %in% c('t','p'))/10, # p group
sum(ag %in% c('t','p','f'))/10 - sum(bg %in% c('t','p','f'))/10, # f group
sum(ag %in% c('t','p','f', 'g'))/10 - sum(bg %in% c('t','p','f', 'g'))/10 # g group
)

vals[which(abs(vals) == max(abs(vals)))][1] # Get most extreme value

}

# get all possible distance metrics
distance_metrics <- lapply(1:184756, get_distance_metric)

# our primary distance metric is 0.3
# make a plot showing values as extreme
library(tidyverse)
ggplot() +
  geom_histogram(aes(x = distance_metrics |> unlist(),
                     fill = distance_metrics |> unlist() |> abs() >= 0.3), 
                 binwidth = 0.1, color = 'black') +
  theme_bw() +
  xlab("Distance Metric") +
  scale_fill_manual(values = c("royalblue", "firebrick3"), name = "At Least as Extreme")

# All outcomes are equally likely so p value is the number 
# of outcomes as extreme as ours / total outcomes
p_value <- sum(abs(unlist(distance_metrics)) >= 0.3) / length(distance_metrics)

