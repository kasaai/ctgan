get_model_attribute <- function(model, attribute) {
  model$.__enclos_env__$private$model_obj[[attribute]]
}

expect_attribute_identical <- function(model, attribute, value) {
  expect_identical(get_model_attribute(model, attribute), value)
}

tryCatch(reticulate::import("ctgan"), error = function(e) {
  if (grepl("module named 'ctgan", e)) install_ctgan()
})
