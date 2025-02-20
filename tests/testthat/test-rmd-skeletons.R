render_skeleton <- function(x) {
  tmp <- tempfile()
  dir.create(tmp)
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
  src <- system.file("rmarkdown/templates", x, "skeleton/skeleton.Rmd", package = "bslib")
  # Comment out bs_themer() since that needs a shiny runtime
  txt <- sub("^bslib::bs_themer()", "#bslib::bs_themer()", readLines(src))
  writeLines(txt, file.path(tmp, "tmp.Rmd"))
  rmarkdown::render(file.path(tmp, "tmp.Rmd"), quiet = TRUE)
}

test_that("Rmd skeletons can be render cleanly", {
  expect_error(render_skeleton("bs3"), NA)
  expect_error(render_skeleton("bs4"), NA)
  withr::with_namespace(
    "shiny",
    expect_error(render_skeleton("real-time"), NA)
  )
})
