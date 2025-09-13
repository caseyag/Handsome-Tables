#' J&J Table
#'
#' jnj table function with excel drop downs
#'
#' @param data data.frame to pass into the widget
#'
#' @import htmlwidgets
#'
#' @export
jnj_tables <- function(data, width = NULL, height = NULL, elementId = NULL) {

  columns <- purrr::map(colnames(data), ~list(
     data = .x,
     # this can be fancier or another argument to the function later
     title = .x,
     # this should be a type check of the data column?
     # how does this impact filtering?
     type = 'text'
  ))

  # forward options using x
  x = list(
     data = data,
     columns = columns
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'jnj_tables',
    x,
    width = width,
    height = height,
    package = 'handsometable',
    elementId = elementId
  )
}

#' Shiny bindings for jnj_tables
#'
#' Output and render functions for using jnj_tables within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a jnj_tables
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name jnj_tables-shiny
#'
#' @export
jnj_tablesOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'jnj_tables', width, height, package = 'handsometable')
}

#' @rdname jnj_tables-shiny
#' @export
renderJnj_tables <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, jnj_tablesOutput, env, quoted = TRUE)
}

# renderJnj_tables(jnj_tables(data.frame()))
