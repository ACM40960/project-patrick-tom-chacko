# Make a function that is capable of doing things on its own.
Model = function(data_train){
  #subset the observation based on classes
  data_true = subset(data_train, data_train$Class==1)
  # No disease = 0
  data_false = subset(data_train, data_train$Class==0)
  
  # computing mean of all columns using apply()
  all_column_mean <- apply(data_true[-c(1,41)], 2, mean, na.rm=TRUE)
  # imputing NA with the mean calculated
  for(i in colnames(data_true[-c(1,41)])){data_true[,i][is.na(data_true[,i])] <- all_column_mean[i]}
  
  #neg data missing value imputation
  all_column_mean_f <- apply(data_false[-c(1,41)], 2, mean, na.rm=TRUE)
  
  # imputing NA with the mean calculated
  for(i in colnames(data_false[-c(1,41)])){data_false[,i][is.na(data_false[,i])] <- all_column_mean_f[i]}
  
  #combining data
  comb_data_train = rbind(data_true,data_false)
  
  # Set the "ID" column as row names
  rownames(comb_data_train) <- comb_data_train$Id
  # Remove the "ID" column from the dataframe if needed
  comb_data_train$Id <- NULL
  
  #standardise the data due to different scaled numeric variables 
  #41 st Variable EJ comes to 40th position
  stand_comb_data = as.data.frame(scale(comb_data_train[-c(40,57)]))
  #convert EJ to numeric
  # Convert "A" to 0 and "B" to 1 using ifelse()
  EJ_num<- ifelse(comb_data_train$EJ == "A", 0, 1)
  stand_comb_data$EJ = EJ_num
  stand_comb_data$Class = comb_data_train$Class
  return(list(pos_data = data_true,neg_data = data_false, combnd_data = comb_data_train,
              standard_proc_data = stand_comb_data))
  
  
}
file = read.csv('train.csv')
data1 = Model(file)

str(data1$standard_proc_data)
fit = prcomp(data1$standard_proc_data,scale. = TRUE)
# Assuming 'X' is your input data matrix

# Perform PCA on the data
pca_result <- prcomp(data1$standard_proc_data)

# Extract the standard deviation and proportion of variance explained
variance <- pca_result$sdev^2
variance_proportion <- variance / sum(variance)

# Calculate the cumulative variance explained
cumulative_variance <- cumsum(variance_proportion)

plot(pca_result)

# Print the cumulative variance explained
cat("Cumulative Variance Explained:\n")
for (i in 1:length(cumulative_variance)) {
  cat("Component", i, ":", round(cumulative_variance[i], 4), "\n")
}

data = data1$standard_proc_data
N <- nrow(data)
ind = sample(1:617, N)
data = data[ind,]

# Separate inputs and outputs
x_train <- data[, !(names(data) %in% 'Class')]
x_train$X <- NULL
y_train <- data$Class

#Prepare a test set not seen by Model
N_test = sample(1:617,0.1*617)
N_test
x_test = x_train[N_test,]
y_test = y_train[N_test]

N_train = setdiff(1:617,N_test)

x_train = x_train[N_train,]
y_train = y_train[N_train]

# Define F1 score metric function
f1_score_metric <- function(y_true, y_pred) {
  true_positives <- sum(y_true * y_pred)
  possible_positives <- sum(y_true)
  predicted_positives <- sum(y_pred)
  
  precision <- true_positives / (predicted_positives + k_epsilon())
  recall <- true_positives / (possible_positives + k_epsilon())
  
  f1_score <- 2 * (precision * recall) / (precision + recall + k_epsilon())
  return(f1_score)
}

# Define custom F1 score metric
f1_metric <- custom_metric(
  "f1", 
  function(y_true, y_pred) f1_score_metric(y_true, y_pred))



# Calculate class weights
class_weights <- table(y_train)
total_cases <- sum(class_weights)
class_weights <- total_cases / (2 * class_weights)

# Normalize the class weights so they sum to 1
class_weights <- class_weights / sum(class_weights)

# Build the DNN model
dnn_model_balanced <- keras_model_sequential() %>%
  layer_dense(units = 56, activation = 'relu', input_shape = c(ncol(x_train))) %>%
  layer_dropout(rate = 0.2) %>%
  layer_dense(units = 26, activation = 'relu') %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 14, activation = 'relu') %>%
  layer_dropout(rate = 0.4) %>%
  layer_dense(units = 1, activation = 'sigmoid') 

# Compile the model
dnn_model_balanced %>% compile(
  loss = 'binary_crossentropy',
  optimizer = 'adam',
  metrics = c('accuracy',f1_metric)
)

# Train the model using class weights
history <- dnn_model_balanced %>% fit(
  x = as.matrix(x_train), 
  y = y_train,
  epochs = 150,
  batch_size = 32,
  validation_split = 0.4,
  class_weight = as.list(class_weights)
)


# Evaluate using a threshold to compute F1 Score post-training
y_val_pred <- predict(dnn_model_balanced, as.matrix(x_train[1:floor(0.4 * nrow(x_train)), ]))
threshold <- 0.5
y_val_pred <- ifelse(y_val_pred > threshold, 1, 0)
val_true <- y_train[1:floor(0.4 * nrow(x_train))]

f1_val <- f1_score_metric(val_true, y_val_pred)
print(paste("Validation F1 Score:", f1_val))


# Evaluate using a threshold to compute F1 Score post-training
y_test_pred <- predict(dnn_model_balanced, as.matrix(x_test))
threshold <- 0.5
y_test_pred <- ifelse(y_test_pred > threshold, 1, 0)
test_true <- y_test

f1_test <- f1_score_metric(test_true, y_test_pred)
print(paste("Testing via F1 Score:", round(f1_test,4)))

