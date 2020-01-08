ctgan_deps <- function() {
  c(
    "ctgan"
  )
}

#' Install CTGAN
#'
#' Installs the CTGAN python package.
#'
#' @param method Installation method. By default, "auto" automatically finds
#'   a method that will work in the local environment.
#' @param conda Path to conda executable (or "auto" to find conda using the
#'   \code{PATH} and other conventional install locations).
#' @param envname Name of Python environment to install within.
#' @param restart_session Whether to restart R session after installation.
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

  reticulate::py_install(packages = ctgan_deps(),
                         envname = envname, method = method, conda = conda,
                         pip = TRUE,
                         ...)

  cat("\nInstallation complete.\n\n")

  if (restart_session && rstudioapi::hasFun("restartSession"))
    rstudioapi::restartSession()

  invisible(NULL)
}
