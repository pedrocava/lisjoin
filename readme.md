lisjoin
================

A small package with list-tibble join operations.

# Motivation

There no native strictly key-pair data structure to R. There is,
however, a sufficently good first-approach which is a named list.

``` r
{
  ids <- paste0(sample(letters, size = 1000, replace = TRUE), sample(1:10, 4, replace = TRUE))
  named_list <- as.list(rnorm(1000))
  names(named_list) <- ids
  head(named_list)
}
```

    ## $y10
    ## [1] 1.251378
    ## 
    ## $w4
    ## [1] -0.7925863
    ## 
    ## $c8
    ## [1] 0.9153455
    ## 
    ## $s10
    ## [1] 1.288998
    ## 
    ## $a10
    ## [1] -0.5573979
    ## 
    ## $j4
    ## [1] -0.714583

And this approach can get you far-ish.

``` r
library(tidyverse)
```

    ## ── Attaching packages ──────────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──

    ## ✓ ggplot2 3.3.0     ✓ purrr   0.3.4
    ## ✓ tibble  3.0.3     ✓ dplyr   1.0.2
    ## ✓ tidyr   1.1.2     ✓ stringr 1.4.0
    ## ✓ readr   1.3.1     ✓ forcats 0.5.0

    ## ── Conflicts ─────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
pluck(named_list, sample(ids, 1)) 
```

    ## [1] 0.8156067

``` r
# update specific values
ids_to_update <- sample(ids, 5)

modify_at(named_list, 
          ids_to_update, 
          function(x) 2*x - 3) ->
  updated_list

sample(named_list, 20) %>% # recover ids given condition
  keep(~ .x < 0) %>%
  names()
```

    ##  [1] "q10" "j10" "q4"  "e4"  "v4"  "t4"  "x10" "a8"  "y10" "t8"  "n10"

And by that I mean this far.

``` r
(tibble(key = sample(ids, 100),
       val = runif(100)) ->
  keyval_tibble)
```

    ## # A tibble: 100 x 2
    ##    key      val
    ##    <chr>  <dbl>
    ##  1 h10   0.890 
    ##  2 s8    0.0390
    ##  3 j4    0.378 
    ##  4 n8    0.149 
    ##  5 z10   0.718 
    ##  6 n10   0.877 
    ##  7 y4    0.747 
    ##  8 h10   0.472 
    ##  9 e10   0.851 
    ## 10 y10   0.838 
    ## # … with 90 more rows

``` r
left_join(keyval_tibble)
```

    ## Error in auto_copy(x, y, copy = copy): argument "y" is missing, with no default

``` r
left_join(keyval_tibble, named_list, by = character(), copy = TRUE)
```

    ## # A tibble: 100 x 1,002
    ##    key      val   y10     w4    c8   s10    a10     j4     a8    r10   w10
    ##    <chr>  <dbl> <dbl>  <dbl> <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl>
    ##  1 h10   0.890   1.25 -0.793 0.915  1.29 -0.557 -0.715 -0.541 -0.417 0.400
    ##  2 s8    0.0390  1.25 -0.793 0.915  1.29 -0.557 -0.715 -0.541 -0.417 0.400
    ##  3 j4    0.378   1.25 -0.793 0.915  1.29 -0.557 -0.715 -0.541 -0.417 0.400
    ##  4 n8    0.149   1.25 -0.793 0.915  1.29 -0.557 -0.715 -0.541 -0.417 0.400
    ##  5 z10   0.718   1.25 -0.793 0.915  1.29 -0.557 -0.715 -0.541 -0.417 0.400
    ##  6 n10   0.877   1.25 -0.793 0.915  1.29 -0.557 -0.715 -0.541 -0.417 0.400
    ##  7 y4    0.747   1.25 -0.793 0.915  1.29 -0.557 -0.715 -0.541 -0.417 0.400
    ##  8 h10   0.472   1.25 -0.793 0.915  1.29 -0.557 -0.715 -0.541 -0.417 0.400
    ##  9 e10   0.851   1.25 -0.793 0.915  1.29 -0.557 -0.715 -0.541 -0.417 0.400
    ## 10 y10   0.838   1.25 -0.793 0.915  1.29 -0.557 -0.715 -0.541 -0.417 0.400
    ## # … with 90 more rows, and 991 more variables: n4 <dbl>, r8 <dbl>, b10 <dbl>,
    ## #   w10.1 <dbl>, h4 <dbl>, x8 <dbl>, a10.1 <dbl>, b10.1 <dbl>, p4 <dbl>,
    ## #   b8 <dbl>, o10 <dbl>, d10 <dbl>, l4 <dbl>, k8 <dbl>, q10 <dbl>, h10 <dbl>,
    ## #   w4.1 <dbl>, a8.1 <dbl>, n10 <dbl>, c10 <dbl>, k4 <dbl>, b8.1 <dbl>,
    ## #   m10 <dbl>, a10.2 <dbl>, m4 <dbl>, t8 <dbl>, r10.1 <dbl>, w10.2 <dbl>,
    ## #   n4.1 <dbl>, c8.1 <dbl>, q10.1 <dbl>, y10.1 <dbl>, z4 <dbl>, p8 <dbl>,
    ## #   q10.2 <dbl>, i10 <dbl>, p4.1 <dbl>, j8 <dbl>, u10 <dbl>, f10 <dbl>,
    ## #   z4.1 <dbl>, h8 <dbl>, l10 <dbl>, g10 <dbl>, l4.1 <dbl>, k8.1 <dbl>,
    ## #   g10.1 <dbl>, n10.1 <dbl>, e4 <dbl>, t8.1 <dbl>, a10.3 <dbl>, k10 <dbl>,
    ## #   g4 <dbl>, h8.1 <dbl>, q10.3 <dbl>, f10.1 <dbl>, l4.2 <dbl>, a8.2 <dbl>,
    ## #   c10.1 <dbl>, y10.2 <dbl>, i4 <dbl>, f8 <dbl>, a10.4 <dbl>, b10.2 <dbl>,
    ## #   q4 <dbl>, y8 <dbl>, u10.1 <dbl>, o10.1 <dbl>, k4.1 <dbl>, g8 <dbl>,
    ## #   p10 <dbl>, w10.3 <dbl>, x4 <dbl>, a8.3 <dbl>, o10.2 <dbl>, q10.4 <dbl>,
    ## #   f4 <dbl>, a8.4 <dbl>, z10 <dbl>, m10.1 <dbl>, v4 <dbl>, x8.1 <dbl>,
    ## #   n10.2 <dbl>, g10.2 <dbl>, z4.2 <dbl>, i8 <dbl>, i10.1 <dbl>, w10.4 <dbl>,
    ## #   d4 <dbl>, v8 <dbl>, n10.3 <dbl>, n10.4 <dbl>, w4.2 <dbl>, f8.1 <dbl>,
    ## #   a10.5 <dbl>, j10 <dbl>, g4.1 <dbl>, t8.2 <dbl>, c10.2 <dbl>, z10.1 <dbl>, …

`lisjoin`, as of now, provides a lazy prototypical approach:

``` r
library(lisjoin)

lisjoin(keyval_tibble, named_list, .key = key)
```

    ## # A tibble: 1,362 x 3
    ##    key     val list_val 
    ##    <chr> <dbl> <list>   
    ##  1 h10   0.890 <dbl [1]>
    ##  2 h10   0.890 <dbl [1]>
    ##  3 h10   0.890 <dbl [1]>
    ##  4 h10   0.890 <dbl [1]>
    ##  5 h10   0.890 <dbl [1]>
    ##  6 h10   0.890 <dbl [1]>
    ##  7 h10   0.890 <dbl [1]>
    ##  8 h10   0.890 <dbl [1]>
    ##  9 h10   0.890 <dbl [1]>
    ## 10 h10   0.890 <dbl [1]>
    ## # … with 1,352 more rows

Right now `lisjoin` supports key-guessing, type stable,
left/right/inner/full joins. For example, since we know the output is
going to be a double-precision number:

``` r
library(lisjoin)

lisjoin(keyval_tibble, named_list, .key = key, type = 'dbl')
```

    ## # A tibble: 1,362 x 3
    ##    key     val list_val
    ##    <chr> <dbl>    <dbl>
    ##  1 h10   0.890   -0.267
    ##  2 h10   0.890   -0.267
    ##  3 h10   0.890   -0.267
    ##  4 h10   0.890   -0.267
    ##  5 h10   0.890   -0.267
    ##  6 h10   0.890   -0.267
    ##  7 h10   0.890   -0.267
    ##  8 h10   0.890   -0.267
    ##  9 h10   0.890   -0.267
    ## 10 h10   0.890   -0.267
    ## # … with 1,352 more rows

### Long term goals

This package is partly inspired primarely by clojure’s map structure,
purrr’s filosophy and design. In the long term I see it as a tool
allowing tidy data workflows on lists.
