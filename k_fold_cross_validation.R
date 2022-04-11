argv <- commandArgs(TRUE)


if (length(argv)==0) {
  stop("You need to add some arguments.")
}


# detect missing flag
if (!"--input" %in% argv) {
  stop("Miss the flag '--input'.")
} else if (!"--output" %in% argv) {
  stop("Miss the flag '--output'.")
} else if (!"--fold" %in% argv) {
  stop("Miss the flag '--fold'.")
}


i <- 1
while (i < length(argv)) {
  if (argv[i] == "--fold") {
    fold <- as.numeric(argv[i+1])   # convert string to numeric
    i <- i + 1
  } else if (argv[i] == "--output") {
    output_path <- argv[i+1]
    i <- i + 1
  } else if (argv[i] == "--input") {
    input_path <- argv[i+1]
    i <- i + 1
  } else {
    stop(paste("Unknown flag.", args[i]), call.=FALSE)
  }
  i <- i + 1
}


if(!require('rpart')){
  install.packages('rpart', repos = "http://cran.us.r-project.org")
}
library('rpart')


df <- read.csv(input_path, header = F)


# add a column of random variable from uniform distribution
df$gp <- runif(dim(df)[1])


train_accuracy <- c()
vali_accuracy <- c()
test_accuracy <- c()
set_vector <- c()


for (k in 1:fold) {

  set_vector <- c(set_vector, paste("fold", k, sep = ""))

  # split three sets
  test_set <- subset(df, subset = (df$gp <= k / fold & df$gp > (k - 1) / fold))

  if (k == fold) {
    vali_set <- subset(df, subset = (df$gp <= 1 / fold))
    traing_set <- subset(df, subset = (df$gp > 1 / fold & df$gp <= (k - 1) / fold))
  } else{
    vali_set <- subset(df, subset = (df$gp <= (k + 1) / fold & df$gp > k / fold))
    traing_set <- subset(df, subset = (df$gp > (k + 1) / fold | df$gp <= (k - 1) / fold))
  }


  # model using decision tree
  # drop column 1, 5603, 5604
  model <- rpart(V2 ~. - V1 - V5603 -gp,
                 data=traing_set, control=rpart.control(maxdepth=4),
                 method="class")
  
  
  
  # make confusion matrix table of training set
  resultframe <- data.frame(truth=traing_set$V2,
                            pred=predict(model, newdata = traing_set,type="class"))
  rtab <- table(resultframe)

  # compute training accuracy
  train_accuracy <- c(train_accuracy, round(sum(diag(rtab)) / sum(rtab), digits = 2))
  
  
  
  # make confusion matrix table of validation set
  resultframe <- data.frame(truth=vali_set$V2,
                            pred=predict(model, newdata = vali_set,type="class"))
  rtab <- table(resultframe)

  # compute validation accuracy
  vali_accuracy <- c(vali_accuracy, round(sum(diag(rtab)) / sum(rtab), digits = 2))
  
  
  
  # make confusion matrix table of testing set
  resultframe <- data.frame(truth=test_set$V2,
                            pred=predict(model, newdata = test_set,type="class"))
  rtab <- table(resultframe)

  # compute training accuracy
  test_accuracy <- c(test_accuracy, round(sum(diag(rtab)) / sum(rtab), digits = 2))
}

ave_vector <- c("ave.", 
                round(mean(train_accuracy), digits = 2),
                round(mean(vali_accuracy), digits = 2), 
                round(mean(test_accuracy), digits = 2))

new_df <- data.frame(set =  set_vector,
                     training = train_accuracy,
                     validation = vali_accuracy,
                     test = test_accuracy,
                     stringsAsFactors = FALSE)

new_df <- rbind(new_df, ave_vector)

write.csv(new_df, file = output_path, row.names = F, quote = F)
