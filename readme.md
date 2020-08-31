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

    ## $e10
    ## [1] 1.20587
    ## 
    ## $j1
    ## [1] -1.17007
    ## 
    ## $v7
    ## [1] -0.6495615
    ## 
    ## $j1
    ## [1] 3.372412
    ## 
    ## $h10
    ## [1] 1.10409
    ## 
    ## $l1
    ## [1] 0.1494034

And this approach can get you far-ish.

``` r
library(tidyverse)
```

    ## ── Attaching packages ────────────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──

    ## ✓ ggplot2 3.3.2     ✓ purrr   0.3.4
    ## ✓ tibble  3.0.3     ✓ dplyr   1.0.2
    ## ✓ tidyr   1.1.0     ✓ stringr 1.4.0
    ## ✓ readr   1.3.1     ✓ forcats 0.5.0

    ## ── Conflicts ───────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
pluck(named_list, sample(ids, 1)) 
```

    ## [1] -1.286478

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

    ## [1] "r10" "s10" "p10" "c10" "j7"  "g7"  "y10" "n1"  "c1"

And by that I mean this far.

``` r
(tibble(key = sample(ids, 100),
       val = runif(100)) ->
  keyval_tibble)
```

    ## # A tibble: 100 x 2
    ##    key      val
    ##    <chr>  <dbl>
    ##  1 t7    0.681 
    ##  2 z10   0.891 
    ##  3 r7    0.806 
    ##  4 a7    0.114 
    ##  5 r10   0.0709
    ##  6 c1    0.587 
    ##  7 a7    0.180 
    ##  8 m10   0.296 
    ##  9 v10   0.302 
    ## 10 q1    0.0777
    ## # … with 90 more rows

``` r
left_join(keyval_tibble)
```

    ## Error in auto_copy(x, y, copy = copy): argument "y" is missing, with no default

``` r
left_join(keyval_tibble, named_list, by = character(), copy = TRUE)
```

    ## # A tibble: 100 x 1,002
    ##    key      val   e10    j1     v7  j1.1   h10    l1    u7   j1.2   a10    s1
    ##    <chr>  <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl>
    ##  1 t7    0.681   1.21 -1.17 -0.650  3.37  1.10 0.149 0.209 -0.195 0.405  1.46
    ##  2 z10   0.891   1.21 -1.17 -0.650  3.37  1.10 0.149 0.209 -0.195 0.405  1.46
    ##  3 r7    0.806   1.21 -1.17 -0.650  3.37  1.10 0.149 0.209 -0.195 0.405  1.46
    ##  4 a7    0.114   1.21 -1.17 -0.650  3.37  1.10 0.149 0.209 -0.195 0.405  1.46
    ##  5 r10   0.0709  1.21 -1.17 -0.650  3.37  1.10 0.149 0.209 -0.195 0.405  1.46
    ##  6 c1    0.587   1.21 -1.17 -0.650  3.37  1.10 0.149 0.209 -0.195 0.405  1.46
    ##  7 a7    0.180   1.21 -1.17 -0.650  3.37  1.10 0.149 0.209 -0.195 0.405  1.46
    ##  8 m10   0.296   1.21 -1.17 -0.650  3.37  1.10 0.149 0.209 -0.195 0.405  1.46
    ##  9 v10   0.302   1.21 -1.17 -0.650  3.37  1.10 0.149 0.209 -0.195 0.405  1.46
    ## 10 q1    0.0777  1.21 -1.17 -0.650  3.37  1.10 0.149 0.209 -0.195 0.405  1.46
    ## # … with 90 more rows, and 990 more variables: s7 <dbl>, t1 <dbl>, k10 <dbl>,
    ## #   e1 <dbl>, v7.1 <dbl>, q1 <dbl>, t10 <dbl>, d1 <dbl>, z7 <dbl>, p1 <dbl>,
    ## #   a10.1 <dbl>, o1 <dbl>, a7 <dbl>, z1 <dbl>, r10 <dbl>, k1 <dbl>, a7.1 <dbl>,
    ## #   e1.1 <dbl>, f10 <dbl>, x1 <dbl>, j7 <dbl>, g1 <dbl>, m10 <dbl>, v1 <dbl>,
    ## #   o7 <dbl>, a1 <dbl>, k10.1 <dbl>, c1 <dbl>, j7.1 <dbl>, j1.3 <dbl>,
    ## #   i10 <dbl>, w1 <dbl>, b7 <dbl>, d1.1 <dbl>, p10 <dbl>, c1.1 <dbl>, q7 <dbl>,
    ## #   d1.2 <dbl>, b10 <dbl>, f1 <dbl>, m7 <dbl>, e1.2 <dbl>, p10.1 <dbl>,
    ## #   r1 <dbl>, c7 <dbl>, r1.1 <dbl>, c10 <dbl>, r1.2 <dbl>, v7.2 <dbl>,
    ## #   b1 <dbl>, n10 <dbl>, g1.1 <dbl>, k7 <dbl>, a1.1 <dbl>, l10 <dbl>, h1 <dbl>,
    ## #   l7 <dbl>, o1.1 <dbl>, v10 <dbl>, p1.1 <dbl>, s7.1 <dbl>, r1.3 <dbl>,
    ## #   a10.2 <dbl>, w1.1 <dbl>, j7.2 <dbl>, j1.4 <dbl>, s10 <dbl>, b1.1 <dbl>,
    ## #   i7 <dbl>, z1.1 <dbl>, y10 <dbl>, w1.2 <dbl>, b7.1 <dbl>, v1.1 <dbl>,
    ## #   v10.1 <dbl>, r1.4 <dbl>, l7.1 <dbl>, r1.5 <dbl>, d10 <dbl>, z1.2 <dbl>,
    ## #   b7.2 <dbl>, f1.1 <dbl>, u10 <dbl>, y1 <dbl>, j7.3 <dbl>, d1.3 <dbl>,
    ## #   l10.1 <dbl>, t1.1 <dbl>, x7 <dbl>, a1.2 <dbl>, m10.1 <dbl>, t1.2 <dbl>,
    ## #   k7.1 <dbl>, c1.2 <dbl>, w10 <dbl>, d1.4 <dbl>, j7.4 <dbl>, z1.3 <dbl>,
    ## #   x10 <dbl>, b1.2 <dbl>, …

`lisjoin`, as of now, provides a lazy prototypical approach:

``` r
library(lisjoin)
```

    ## Loading required package: rlang

    ## 
    ## Attaching package: 'rlang'

    ## The following objects are masked from 'package:purrr':
    ## 
    ##     %@%, as_function, flatten, flatten_chr, flatten_dbl, flatten_int,
    ##     flatten_lgl, flatten_raw, invoke, list_along, modify, prepend,
    ##     splice

    ## Warning: replacing previous import 'purrr::list_along' by 'rlang::list_along'
    ## when loading 'lisjoin'

    ## Warning: replacing previous import 'purrr::invoke' by 'rlang::invoke' when
    ## loading 'lisjoin'

    ## Warning: replacing previous import 'purrr::flatten_raw' by 'rlang::flatten_raw'
    ## when loading 'lisjoin'

    ## Warning: replacing previous import 'purrr::modify' by 'rlang::modify' when
    ## loading 'lisjoin'

    ## Warning: replacing previous import 'purrr::as_function' by 'rlang::as_function'
    ## when loading 'lisjoin'

    ## Warning: replacing previous import 'purrr::flatten_dbl' by 'rlang::flatten_dbl'
    ## when loading 'lisjoin'

    ## Warning: replacing previous import 'purrr::flatten_lgl' by 'rlang::flatten_lgl'
    ## when loading 'lisjoin'

    ## Warning: replacing previous import 'purrr::flatten_int' by 'rlang::flatten_int'
    ## when loading 'lisjoin'

    ## Warning: replacing previous import 'purrr::%@%' by 'rlang::%@%' when loading
    ## 'lisjoin'

    ## Warning: replacing previous import 'purrr::flatten_chr' by 'rlang::flatten_chr'
    ## when loading 'lisjoin'

    ## Warning: replacing previous import 'purrr::splice' by 'rlang::splice' when
    ## loading 'lisjoin'

    ## Warning: replacing previous import 'purrr::flatten' by 'rlang::flatten' when
    ## loading 'lisjoin'

    ## Warning: replacing previous import 'purrr::prepend' by 'rlang::prepend' when
    ## loading 'lisjoin'

``` r
lisjoin(keyval_tibble, named_list, .key = key)
```

    ## Error in lisjoin(keyval_tibble, named_list, .key = key): object 'key' not found

Right now `lisjoin` supports key-guessing, type stable,
left/right/inner/full joins.

### Long term goals

This package is partly inspired primarely by clojure’s map structure,
purrr’s filosophy and design. In the long term I see it as a tool
allowing tidy data workflows on lists.
