`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

#' @importFrom dplyr .data
transform_data <- function(train_data) {
  train_data <- train_data %>%
    dplyr::mutate_if(is.factor, ~ levels(.x)[.x]) %>%
    dplyr::mutate_if(is.logical, as.character) %>%
    dplyr::mutate_if(is.character, ~ ifelse(is.na(.x), "(Missing)", .x)) %>%
    assertr::assert(assertr::not_na, dplyr::everything())

  col_classes <- lapply(train_data, class)
  bad_cols <- col_classes %>%
    purrr::discard(~ .x %in% c("numeric", "integer", "character"))

  if (length(bad_cols)) {
    stop(glue::glue("The following columns have unsupported types:
                       {paste0(names(bad_cols), ' (', bad_cols, ')',
                    collapse = ',')}"),
      call. = FALSE
    )
  }

  if (any(unlist(col_classes) == "character")) {
    rec <- recipes::recipe(train_data, ~.) %>%
      recipes::step_integer(recipes::all_nominal(),
        zero_based = TRUE
      )
    trained_rec <- recipes::prep(rec, train_data, retain = FALSE)
    col_info <- trained_rec$var_info %>%
      dplyr::select(.data$variable, .data$type)
    categorical_levels <- trained_rec$orig_lvls %>%
      purrr::keep(~ length(.x$values) > 1) %>%
      purrr::map("values")
    train_data <- recipes::bake(trained_rec, train_data)
  } else {
    col_info <- tibble::tibble(
      variable = names(train_data),
      type = "numeric"
    )
    categorical_levels <- NULL
  }

  list(
    train_data = train_data,
    metadata = list(
      col_info = col_info,
      categorical_levels = categorical_levels
    )
  )
}
