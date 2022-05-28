library(ranger)
library(jsonlite)

# download model file from S3 into /tmp folder
system("aws s3 cp s3://r-testing/model/model.Rds /tmp/model.rds")

handler <- function(body, ...) {
  data <- fromJSON(txt = body)
  # load model
  model <- readRDS("/tmp/model.rds")
  # predict with loaded model
  predictions <- predict(model, data = data)
  # return response with predictions payload
  return(
    list(
      statusCode = 200,
      headers = list("Content-Type" = "application/json"),
      body = toJSON(list(predictions = predictions))
    )
  )
}
