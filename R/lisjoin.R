#' Join a tibble and a named list
#'
#' @param .tibble A tibble to be joined to `.list`
#' @param .list a named list. Passing an unnamed list will throw an error.
#' @param key a symbol containing the variable name in `.tibble` to be used as key.
#' @param name name of the new variable with matched values from `.list`. Defaults to "val".
#' @param strategy How should values be matched? Specify either 'left', 'right', 'inner' or 'full' to use the matching `dplyr::x_join`. Defaults to 'left'.
#'
#' @import rlang
#' @import dplyr
#' @import purrr
#' @import glue
#' @export


lisjoin <- function(
  .tibble,
  .list,
  key,
  name = "val",
  strategy = "left") {

  key <- rlang::ensym(key)

  if(rlang::is_null(names(.list))) {

    rlang::abort("Param .list must be a named list.")

  }

  if(!rlang::is_list(.list)) {

    rlang::abort("Param .list must be a list")

  }

  specified_join <-
    purrr::pluck(
      list(
        left = dplyr::left_join,
        right = dplyr::right_join,
        inner = dplyr::inner_join,
        full = dplyr::full_join),
      strategy)

  tibble::tibble(key = names(.list)) %>%
    dplyr::mutate(
      list_val = purrr::map(
        .x = key,
        .f = ~ purrr::pluck(.list, .x))) ->
    .listib

  .tibble %>%
    specified_join(
      .listib,
      by = rlang::as_string(key))

}


lisjoin <- function(
  .tibble,
  .list,
  key,
  name = "val",
  strategy = "left",
  .key_guessing = TRUE) {


  .key <- rlang::ensym(key)
  name <- rlang::sym(name)


  if("list_val" %in% names(.tibble)) {

    rlang::abort("Please rename variable `list_vall` in the tibble")

  }

  if(!strategy %in% c("left", "right", "inner", "full")) {

    rlang::abort("Param `strategy` must be one of the following: 'left', 'right', 'inner', 'full'.")

  }

  if(!rlang::as_string(.key) %in% names(.tibble)) {

    rlang::abort("Param `key` must be a string with the name of a variable in `.tibble`.")

  }

  if(!is_tibble(.tibble)) {

    rlang::abort("Param .tibble must be of class `tibble`.")

  }



  specified_join <-
    purrr::pluck(
      list(left = dplyr::left_join,
           right = dplyr::right_join,
           inner = dplyr::inner_join,
           full = dplyr::full_join),
      strategy)


  tibble::tibble(key = names(.list)) %>%
    dplyr::mutate(
      list_val = purrr::map(
        .x = key,
        .f = ~ purrr::pluck(.list, .x))) ->
    .listib


  specified_join(.tibble, .listib, by = rlang::as_string(key))


}


