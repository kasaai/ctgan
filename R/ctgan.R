#' Initialize a CTGAN Model
#'
#' Initializes a CTGAN model object
#'
#' @import forge
#' @param embedding_dim Dimension of embedding layer.
#' @param gen_dim Dimensions of generator layers.
#' @param dis_dim Dimensions of discriminator layers.
#' @param gen_decay Generator weight decay for ADAM Optimizer.
#' @param dis_decay Discriminator weight decay for ADAM Optimizer.
#' @param batch_size Batch size.
#' @param log_frequency Whether to use log frequency of categorical levels in
#' conditional sampling. Defaults to TRUE.
#'
#' @export
ctgan <- function(embedding_dim = 128, gen_dim = c(256, 256),
                  dis_dim = c(256, 256), gen_decay = 1e-6,
                  dis_decay = gen_decay, batch_size = 500,
                  log_frequency = TRUE) {
  embedding_dim <- cast_integer(embedding_dim)
  gen_dim <- cast_integer(gen_dim)
  dis_dim <- cast_integer(dis_dim)
  gen_decay <- cast_scalar_double(gen_decay)
  dis_decay <- cast_scalar_double(dis_decay)
  batch_size <- cast_scalar_integer(batch_size)
  log_frequency <- cast_scalar_logical(log_frequency)

  ctgan <- reticulate::import("ctgan")
  model <- ctgan$CTGANSynthesizer(
    embedding_dim = embedding_dim,
    generator_dim = gen_dim,
    discriminator_dim  = dis_dim,
    generator_decay = gen_decay,
    discriminator_decay = dis_decay,
    batch_size = batch_size,
    log_frequency = log_frequency
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
    fit = function(train_data, epochs) {
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
        discrete_columns = categorical_columns,
        epochs = epochs
      )
    },
    sample = function(n) {
      if (is.null(private$metadata)) {
        stop("Metadata not found, consider fitting the model to data first.",
             call. = FALSE)
      }
      mat <- private$model_obj$sample(n = n)

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
#' @param epochs Number of epochs to train.
#' @param ... Additional arguments, currently unused.
#'
#' @export
fit.CTGANModel <-
  function(object, train_data,
           epochs = 100,...) {
    epochs <- cast_scalar_integer(epochs)

    object$fit(train_data, epochs)

    invisible(NULL)
  }

#' Synthesize Data Using a CTGAN Model
#'
#' @param ctgan_model A fitted `CTGANModel` object.
#' @param n Number of rows to generate.
#'
#' @export
ctgan_sample <- function(ctgan_model, n = 100) {
  n <- cast_scalar_integer(n)
  ctgan_model$sample(n)
}

#' @export
print.CTGANModel <- function(x, ...) {
  cat("A CTGAN Model")
}
