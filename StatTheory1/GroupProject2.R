# Control Groups Probs
groupAprobControl  <- c(0.2,0.2,0.2,0.2,0.2)
groupBprobControl  <- c(0.2,0.2,0.2,0.2,0.2)

# Test group Probs 
groupAprobTest  <- c(0.2,0.2,0.2,0.2,0.2)
groupBprobTest  <- c(0.1,0.1,0.1,0.3,0.4)


# Dictionary for ratings
ratingDict <- c("t","p","f","g","e")

# Parameters
nn <- 10
sample_size <- 10000

# Function for generating samples
get_sample <- function(n, probs){
  
  ratingDict[ sample.int(5,n,replace = TRUE,prob = probs) ]
  
}

# Function for getting the distance metric from each sample
get_distance_metric <- function(ag, bg, nn){
  
  vals <- c(
    sum(ag == 't')/nn - sum(bg == 't')/nn, # t group
    sum(ag %in% c('t','p'))/nn - sum(bg %in% c('t','p'))/nn, # p group
    sum(ag %in% c('t','p','f'))/nn - sum(bg %in% c('t','p','f'))/nn, # f group
    sum(ag %in% c('t','p','f', 'g'))/nn - sum(bg %in% c('t','p','f', 'g'))/nn # g group
  )
  
  vals[which(abs(vals) == max(abs(vals)))][1] # Get most extreme value
  
}

# Function that uses sample and distance metric functions to generate samples and calculate
# power for a specific nn and sample_size
get_power <- function(nn, sample_size){
  
  # Generate controls
  groupAcontrol <- replicate(sample_size, get_sample(n = nn, probs = groupAprobControl))
  groupBcontrol <- replicate(sample_size, get_sample(n = nn, probs = groupBprobControl))
  
  # Generate tests
  groupATest <- replicate(sample_size, get_sample(n = nn, probs = groupAprobTest))
  groupBTest <- replicate(sample_size, get_sample(n = nn, probs = groupBprobTest))
  
  # Get the distance metrics
  control_distances <- lapply(1:sample_size, function(x) get_distance_metric(groupAcontrol[,x], groupBcontrol[,x], nn = nn)) |> 
    unlist()
  test_distances <- lapply(1:sample_size, function(x) get_distance_metric(groupATest[,x], groupBTest[,x], nn = nn)) |> 
    unlist()
  
  # What are the rejection values
  reject_vals <- quantile(control_distances, c(0.025, 0.975))
  
  # how many test values are rejected under the control
  power <- ( sum(test_distances < reject_vals[[1]]) + sum(test_distances > reject_vals[[2]]) ) / sample_size
  
  # Output the power
  power
  
}

# apply the power function to each nn to find the power
powers <- lapply(seq(20,50), function(x) get_power(nn = x, sample_size = sample_size)   )

# create dataframe and see which power > 0.8
data.frame(cbind(seq(20,50), powers))
