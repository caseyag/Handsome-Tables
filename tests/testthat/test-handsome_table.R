# Sample data for testing
sample_data <- data.frame(
  Name = c("Alice", "Bob"),
  Age = c(25, 30),
  stringsAsFactors = FALSE
)

test_that("handsome_table returns an htmlwidget", {
  ht <- handsome_table(sample_data)
  expect_s3_class(ht, "htmlwidget")
})

test_that("handsome_table contains the correct data", {
  ht <- handsome_table(sample_data)
  expect_equal(ht$x$data, sample_data)
})

test_that("handsome_table sets up correct columns", {
  ht <- handsome_table(sample_data)

  # Columns should match the column names of sample_data
  column_names <- purrr::map_chr(ht$x$columns, "data")
  expect_equal(column_names, colnames(sample_data))

  # Column titles should also match
  column_titles <- purrr::map_chr(ht$x$columns, "title")
  expect_equal(column_titles, colnames(sample_data))

  # Column types default to "text"
  column_types <- purrr::map_chr(ht$x$columns, "type")
  expect_true(all(column_types == "text"))
})

test_that("Shiny output functions exist and are callable", {
  expect_true(exists("handsome_tableOutput"))
  expect_true(exists("renderHandsome_table"))

  # Test that the Shiny output function returns a shiny tag list
  shiny_output <- handsome_tableOutput("test_id")
  expect_s3_class(shiny_output, "shiny.tag.list")
})

test_that("renderHandsome_table accepts quoted and unquoted expressions", {
  expr1 <- renderHandsome_table(handsome_table(sample_data))
  expr2 <- renderHandsome_table(quote(handsome_table(sample_data)), quoted = TRUE)

  expect_s3_class(expr1, "shiny.render.function")
  expect_s3_class(expr2, "shiny.render.function")
})
