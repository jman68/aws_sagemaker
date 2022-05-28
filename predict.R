library(ranger)
library(jsonlite)

# download model file from S3 into /tmp folder
print("Is this even happening?")
system("aws s3 cp s3://r-testing/model/model.Rds /tmp/model.Rds")

handler <- function(body, ...) {
  # load model
  print("Trying to copy model object into tmp folder")
  system("aws s3 cp s3://r-testing/model/model.Rds /tmp/model.Rds")
  print(paste("The model objects exists:", file.exists("/tmp/model.Rds")))
  model <- readRDS("/tmp/model.Rds")
  # predict with loaded model
  predictions <- predict(model, data = body)
  # return response with predictions payload
  return(
    list(
      statusCode = 200,
      headers = list("Content-Type" = "application/json"),
      body = toJSON(list(predictions = predictions))
    )
  )
}
