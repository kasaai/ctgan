#' Save a CTGAN model
#'
#' Serialize a CTGAN Model object to disk.
#'
#' @param path Path to which the save the model.
#' @inheritParams ctgan_sample
#' @export
ctgan_save <- function(ctgan_model, path) {
  ctgan_model$save(path)
}

#' Load a saved CTGAN model
#'
#' @param path Path to the saved model.
#' @export
ctgan_load <- function(path) {
  import_ctgan()
  py_obj <- reticulate::py_load_object(file.path(path, "model.pickle"))
  metadata <- readRDS(file.path(path, "metadata.rds"))
  CTGANModel$new(py_obj, metadata)
}
