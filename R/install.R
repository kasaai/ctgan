# installation mechanism taken from https://github.com/r-tensorflow/gpt2

install_ctgan_deps <- function() {
  c(
    "torch",
    "torchvision",
    "sklearn",
    "numpy",
    "pandas"
  )
}

install_ctgan_python_version <- function() {
  sys <- reticulate::import("sys")
  sys$version_info$major
}

install_ctgan_verify <- function() {
  installed <- sapply(install_ctgan_deps(),
                      function(e) reticulate::py_module_available(e))

  if (!all(installed)) stop("CTGAN dependencies are missing, considere running install_ctgan().")

  sys <- reticulate::import("sys")
  if (install_ctgan_python_version() <= 2) {
    stop("Python 3 required, but Python ", sys$version_info$major, ".", sys$version_info$minor, " is installed.")
  }
}

#' Install Dependencies
#'
#' Installs the python packages the CTGAN model requires.
#'
#' @param method Installation method. By default, "auto" automatically finds
#'   a method that will work in the local environment.
#' @param conda Path to conda executable (or "auto" to find conda using the
#'   \code{PATH} and other conventional install locations).
#' @param envname Name of Python environment to install within.
#' @param ... Additional parameters.
#'
#' @details
#'
#' This model also requires Python 3, Python 2 is unsupported.
#'
#' @export
install_ctgan <- function(method = c("auto", "virtualenv", "conda"),
                         conda = "auto",
                         envname = NULL,
                         restart_session = TRUE,
                         ...) {
  # some special handling for windows
  if (identical(.Platform$OS.type, "windows")) {

    # conda is the only supported method on windows
    method <- "conda"

    # confirm we actually have conda
    have_conda <- !is.null(tryCatch(reticulate::conda_binary(conda), error = function(e) NULL))
    if (!have_conda) {
      stop("CTGAN installation failed (no conda binary found)\n\n",
           "Install Anaconda for Python 3.x (https://www.anaconda.com/download/#windows)\n",
           "before installing GPT-2",
           call. = FALSE)
    }
  }

  extra_packages <- unique(install_ctgan_deps())


  reticulate::py_install(packages = extra_packages,
                         envname = envname, method = method, conda = conda,
                         pip = TRUE, ...)
  cat("\nInstallation complete.\n\n")
  if (restart_session && rstudioapi::hasFun("restartSession"))
    rstudioapi::restartSession()
  invisible(NULL)
}
