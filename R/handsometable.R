#' Handsome Table
#'
#' A JS Handsontable Wrapper
#'
#' @param data data.frame to pass into the widget
#' @param width,height Widget size, as a CSS unit or a number of pixels.
#' @param elementId Optional element id for the widget.
#' @param license_key Handsontable license key. The default,
#'   `"non-commercial-and-evaluation"`, is only valid for non-commercial use
#'   and evaluation. Commercial use requires a license from Handsontable; pass
#'   that key here. See <https://handsontable.com/docs/license-key/>.
#'
#' @import htmlwidgets
#'
#' @export
handsome_table <- function(data, width = NULL, height = NULL, elementId = NULL,
                           license_key = "non-commercial-and-evaluation") {

  if (!is.character(license_key) || length(license_key) != 1 || is.na(license_key)) {
    stop("`license_key` must be a single string.", call. = FALSE)
  }

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
     columns = columns,
     licenseKey = license_key
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'handsome_table',
    x,
    width = width,
    height = height,
    package = 'handsometable',
    elementId = elementId
  )
}

#' Shiny bindings for handsome_table
#'
#' Output and render functions for using handsome_table within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a handsome_table
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name handsome_table-shiny
#'
#' @export
handsome_tableOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'handsome_table', width, height, package = 'handsometable')
}

#' @rdname handsome_table-shiny
#' @export
renderHandsome_table <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, handsome_tableOutput, env, quoted = TRUE)
}
