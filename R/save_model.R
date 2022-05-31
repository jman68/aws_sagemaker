library(tidyverse)
library(tidymodels)
library(rsample)
library(ranger)
library(Rcpp)

set.seed(1234)

abalone = read.csv("C:/Users/jonat/Documents/Sagemaker/data/abalone.csv", 
                   col.names = c("sex","length","diameter","height","whole_wt",
                                 "shucked_wt","viscera_wt","shell_wt","rings"))

abalone_split = initial_split(abalone, prop = 0.7)

train = training(abalone_split)
test = testing(abalone_split)

abalone_rec <-
  recipe(rings ~ ., data = train) %>%
  step_dummy(all_nominal(), one_hot = TRUE)

prep_rec = prep(abalone_rec)
test_abalone = bake(prep_rec, new_data = test)
train_abalone = bake(prep_rec, new_data = NULL)

rf_model = ranger(formula = rings ~ .,
                  data = train_abalone,
                  num.trees = 300,
                  mtry = 3,
                  importance = 'impurity')

saveRDS(rf_model, "C:/Users/jonat/Documents/aws_sagemaker/abalone_fit.Rds")

# Set up test df as JSON
test_json = jsonlite::toJSON(test_abalone)
write(test_json, file = 'test_json.JSON')
