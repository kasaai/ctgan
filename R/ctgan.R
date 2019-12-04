import_ctgan <- function() {
  python_path <- system.file("python", package = "ctgan")
  reticulate::import_from_path("ctgan", path = python_path)
}

#' Initialize a CTGAN Model
#'
#' Initializes a CTGAN model object
#'
#' @param embedding_dim Dimension of embedding layer.
#' @param gen_dim Dimensions of generator layers.
#' @param dis_dim Dimensions of discriminator layers.
#' @param l2_scale ADAM weight decay.
#' @export
ctgan <- function(embedding_dim = 128, gen_dim = c(256, 256),
                  dis_dim = c(256, 256), l2_scale = 1e-6) {
  ctgan <- import_ctgan()
  model <- ctgan$ctgan_model$CTGANSynthesizer(
    embedding_dim = as.integer(embedding_dim),
    gen_dim = as.integer(gen_dim),
    dis_dim = as.integer(dis_dim),
    l2scale = l2_scale
  )

  CTGANModel$new(model)
}

CTGANModel <- R6::R6Class(
  "CTGANModel",
  public = list(
    initialize = function(model_obj, metadata = NULL) {
      private$model_obj <- model_obj
      private$metadata <- metadata
    },
    fit = function(train_data, batch_size, epochs) {
      c(train_data, metadata) %<-% transform_data(train_data)

      categorical_col_indices <- which(metadata$col_info$type == "nominal") - 1
      categorical_columns <- if (length(categorical_col_indices)) {
        reticulate::tuple(as.list(categorical_col_indices))
      } else {
        reticulate::tuple()
      }

      private$metadata <- metadata

      private$model_obj$fit(
        train_data = as.matrix(train_data),
        categorical_columns = categorical_columns,
        batch_size = as.integer(batch_size),
        epochs = as.integer(epochs)
      )
    },
    sample = function(n, batch_size) {
      if (is.null(private$metadata)) {
        stop("Metadata not found, consider fitting the model to data first.",
             call. = FALSE)
      }
      mat <- private$model_obj$sample(
        n = as.integer(n),
        batch_size = as.integer(batch_size)
      )

      colnames(mat) <- private$metadata$col_info$variable

      mat %>%
        tibble::as_tibble() %>%
        purrr::imap_dfc(function(v, nm) {
          if (!is.null(lvls <- private$metadata$categorical_levels[[nm]])) {
            lvls[v + 1]
          } else {
            v
          }
        })
    },
    save = function(path) {
      path <- normalizePath(path)
      dir.create(path, recursive = TRUE, showWarnings = FALSE)
      saveRDS(private$metadata, file.path(path, "metadata.rds"))
      reticulate::py_save_object(private$model_obj, file.path(path, "model.pickle"))
      invisible(NULL)
    }
  ),
  private = list(
    model_obj = NULL,
    metadata = NULL
  )
)

#' Train a CTGAN Model
#'
#' @param object A `CTGANModel` object.
#' @param train_data Training data, should be a data frame.
#' @param batch_size Batch size.
#' @param epochs Number of epochs to train.
#' @param ... Additional arguments, currently unused.
#'
#' @export
fit.CTGANModel <-
  function(object, train_data,
           batch_size = 100, epochs = 100, ...) {

    # Discriminator forward pass requires batch size to divide 10
    batch_size <- min(batch_size, nrow(train_data)) %>%
      max(10) %>%
      round(-1)

    object$fit(train_data, batch_size, epochs)

    invisible(NULL)
  }

#' Synthesize Data Using a CTGAN Model
#'
#' @param ctgan_model A fitted `CTGANModel` object.
#' @param n Number of rows to generate.
#' @param batch_size Batch size.
#'
#' @export
ctgan_sample <- function(ctgan_model, n = 100, batch_size = 100) {
  ctgan_model$sample(n, batch_size)
}

#' @export
print.CTGANModel <- function(x, ...) {
  cat("A CTGAN Model")
}
