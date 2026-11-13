# handsometable

Spreadsheet-style tables for R and Shiny, built on the [Handsontable](https://handsontable.com) JavaScript library.

> **Work in progress.** The API may change before the first release.

`handsome_table()` turns a data frame into a styled table with:

- per-column filter menus with search
- long text truncated at 40 characters, expanding on click
- a right-click menu to freeze, unfreeze, hide and unhide columns
- resizable columns, wrapped headers, and a height that follows the window

[Live demo](https://caseyag.github.io/work/handsome-table/)

## Installation

```r
# install.packages("remotes")
remotes::install_github("caseyag/Handsome-Tables")
```

## Usage

```r
library(handsometable)

handsome_table(mtcars)
```

In Shiny:

```r
ui <- fluidPage(handsome_tableOutput("table"))
server <- function(input, output) {
  output$table <- renderHandsome_table(handsome_table(mtcars))
}
```

## License

The handsometable wrapper code is MIT licensed. The bundled Handsontable library has its own license: it is free for non-commercial use and evaluation. **Commercial use requires a Handsontable license**, and you pass your key with:

```r
handsome_table(df, license_key = "your-license-key")
```

See [`inst/COPYRIGHTS`](inst/COPYRIGHTS) and the [Handsontable license](https://handsontable.com/docs/software-license/).

## Roadmap

- Editable cells with dropdown, date and checkbox column types
- Two-way binding, so edits flow back to R
- Validation rules

## Authors

Casey Aguilar-Gervase and Maya Gans.
