#' Join a tibble and a named list
#'
#' @param .tibble A tibble to be joined to `.list`
#' @param .list a named list. Passing an unnamed list will throw an error.
#' @param key a symbol containing the variable name in `.tibble` to be used as key.
#' @param name name of the new variable with matched values from `.list`. Defaults to "val".
#' @param strategy How should values be matched? Specify either 'left', 'right', 'inner' or 'full' to use the matching `dplyr::x_join`. Defaults to 'left'.
#' @param types Should the operation enforce types? Defaults to no types, but users can enforce by choosing among 'int', 'dbl', 'chr' and 'lgl'.
#'
#' @import rlang
#' @import dplyr
#' @import purrr
#' @export


lisjoin <- function(.tibble, .list, .key,
                    name = "val", strategy = "left", types = NULL) {

  .key <- rlang::ensym(.key)
  name <- rlang::sym(name)

  if(is.null(types)) { # check for nulity

    specified_map <- purrr::map

  } else if(!types %in% c("int", "dbl", "chr", "lgl")) { # check for mispecification

    rlang::abort("Param types must be one of the following: 'int', 'dbl', 'chr', 'lgl'.")

  } else { # if not null and properly specified then find requested function

    specified_map <-
      purrr::pluck(
        list(int = purrr::map_int,
             dbl = purrr::map_dbl,
             chr = purrr::map_chr,
             lgl = purrr::map_lgl),
        types
      )

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

  if(is.null(names(.list))) {

    rlang::abort("Param .list must be a named list.")

  }

  if(!is.list(.list)) {

    rlang::abort("Param .list must be a list")

  }

  specified_join <-
    purrr::pluck(
      list(left = dplyr::left_join,
           right = dplyr::right_join,
           inner = dplyr::inner_join,
           full = dplyr::full_join),
      strategy
      )

  .listib <- tibble(key = names(.list),
                    val = specified_map(key, ~ purrr::pluck(.list, .x)))

  specified_join(.tibble, .listib)


}

