library(ranger)
library(jsonlite)

# download model file from S3 into /tmp folder
system("aws s3 cp s3://r-testing/model/model.Rds /tmp/model.Rds")

handler <- function(body, ...) {
  # load model
  model <- readRDS("/tmp/model.Rds")
  # parse JSON inputs
  if(typeof(body) == "character") {
    body = fromJSON(body)    
  }
  # check body structure and pass as data.frame
  print(str(body))
  body = as.data.frame(body)
  # predict with loaded model
  predictions <- predict(model, data = body)
  # return response with predictions payload
  return(
    list(
      statusCode = 200,
      headers = list("Content-Type" = "application/json"),
      body = toJSON(predictions$predictions)
    )
  )
}
