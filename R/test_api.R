library(httr)

url = "https://oihpd1td48.execute-api.us-east-1.amazonaws.com/test"
url = "https://mrm9qypzbk.execute-api.us-east-1.amazonaws.com/test/getresults"

aws_api_call <- function(test, url, api_key) {
  input_json = toJSON(list(test),
                      auto_unbox = TRUE)
  httr::POST(
    url = url,
    add_headers('x-api-key' = api_key),
    body = input_json,
    content_type("application/json")
  )
}

api_key = "3sZS6gIBlA13fCdnEt8dS4Gar291a3tG6sO7t9PB"

api_call = aws_api_call(test_abalone, url, api_key)
predictions = unlist(content(api_call))
test_abalone_final = test_abalone
test_abalone_final[,"predictions"] = predictions

