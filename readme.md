lisjoin
================

A small package with list-tibble join operations.

# Motivation

There no native strictly key-pair data structure to R. There is,
however, a sufficently good first-approach which is a named list.

``` r
{
  ids <- paste0(sample(letters, size = 1000, replace = TRUE), sample(1:10, 4, replace = TRUE))
  named_list <- rep(list(rnorm(10)), 1000)
  names(named_list) <- ids
  head(named_list)
}
```

    ## $m8
    ##  [1]  0.40840233  0.15185549  0.74321498  0.05058977  0.44946788 -0.63077498
    ##  [7]  1.04724210  0.34529634 -0.18808432 -0.17658951
    ## 
    ## $t9
    ##  [1]  0.40840233  0.15185549  0.74321498  0.05058977  0.44946788 -0.63077498
    ##  [7]  1.04724210  0.34529634 -0.18808432 -0.17658951
    ## 
    ## $s7
    ##  [1]  0.40840233  0.15185549  0.74321498  0.05058977  0.44946788 -0.63077498
    ##  [7]  1.04724210  0.34529634 -0.18808432 -0.17658951
    ## 
    ## $f4
    ##  [1]  0.40840233  0.15185549  0.74321498  0.05058977  0.44946788 -0.63077498
    ##  [7]  1.04724210  0.34529634 -0.18808432 -0.17658951
    ## 
    ## $w8
    ##  [1]  0.40840233  0.15185549  0.74321498  0.05058977  0.44946788 -0.63077498
    ##  [7]  1.04724210  0.34529634 -0.18808432 -0.17658951
    ## 
    ## $k9
    ##  [1]  0.40840233  0.15185549  0.74321498  0.05058977  0.44946788 -0.63077498
    ##  [7]  1.04724210  0.34529634 -0.18808432 -0.17658951

And this approach can get you far-ish.

``` r
library(tidyverse)
```

    ## ── Attaching packages ────────────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──

    ## ✓ ggplot2 3.3.2     ✓ purrr   0.3.4
    ## ✓ tibble  3.0.3     ✓ dplyr   1.0.2
    ## ✓ tidyr   1.1.2     ✓ stringr 1.4.0
    ## ✓ readr   1.3.1     ✓ forcats 0.5.0

    ## ── Conflicts ───────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
pluck(named_list, sample(ids, 1)) 
```

    ##  [1]  0.40840233  0.15185549  0.74321498  0.05058977  0.44946788 -0.63077498
    ##  [7]  1.04724210  0.34529634 -0.18808432 -0.17658951

``` r
# update specific values
ids_to_update <- sample(ids, 5)

modify_at(named_list, 
          ids_to_update, 
          function(x) 2*x - 3) ->
  updated_list

sample(named_list, 20) %>% # recover ids given condition
  keep(~ mean(.x) < 0) %>%
  names()
```

    ## character(0)

And by that I mean this far.

``` r
(tibble(key = sample(ids, 100),
       val = runif(100)) ->
  keyval_tibble)
```

    ## # A tibble: 100 x 2
    ##    key      val
    ##    <chr>  <dbl>
    ##  1 s7    0.655 
    ##  2 i8    0.0378
    ##  3 g8    0.915 
    ##  4 j8    0.563 
    ##  5 y9    0.595 
    ##  6 e9    0.513 
    ##  7 j7    0.801 
    ##  8 f4    0.498 
    ##  9 v9    0.554 
    ## 10 o9    0.859 
    ## # … with 90 more rows

``` r
left_join(keyval_tibble)
```

    ## Error in auto_copy(x, y, copy = copy): argument "y" is missing, with no default

``` r
left_join(keyval_tibble, named_list, by = character(), copy = TRUE)
```

    ## # A tibble: 1,000 x 1,002
    ##    key     val      m8      t9      s7      f4      w8      k9      n7      v4
    ##    <chr> <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    ##  1 s7    0.655  0.408   0.408   0.408   0.408   0.408   0.408   0.408   0.408 
    ##  2 s7    0.655  0.152   0.152   0.152   0.152   0.152   0.152   0.152   0.152 
    ##  3 s7    0.655  0.743   0.743   0.743   0.743   0.743   0.743   0.743   0.743 
    ##  4 s7    0.655  0.0506  0.0506  0.0506  0.0506  0.0506  0.0506  0.0506  0.0506
    ##  5 s7    0.655  0.449   0.449   0.449   0.449   0.449   0.449   0.449   0.449 
    ##  6 s7    0.655 -0.631  -0.631  -0.631  -0.631  -0.631  -0.631  -0.631  -0.631 
    ##  7 s7    0.655  1.05    1.05    1.05    1.05    1.05    1.05    1.05    1.05  
    ##  8 s7    0.655  0.345   0.345   0.345   0.345   0.345   0.345   0.345   0.345 
    ##  9 s7    0.655 -0.188  -0.188  -0.188  -0.188  -0.188  -0.188  -0.188  -0.188 
    ## 10 s7    0.655 -0.177  -0.177  -0.177  -0.177  -0.177  -0.177  -0.177  -0.177 
    ## # … with 990 more rows, and 992 more variables: c8 <dbl>, r9 <dbl>, w7 <dbl>,
    ## #   r4 <dbl>, p8 <dbl>, c9 <dbl>, m7 <dbl>, k4 <dbl>, q8 <dbl>, s9 <dbl>,
    ## #   z7 <dbl>, a4 <dbl>, y8 <dbl>, f9 <dbl>, h7 <dbl>, q4 <dbl>, p8.1 <dbl>,
    ## #   t9.1 <dbl>, u7 <dbl>, q4.1 <dbl>, p8.2 <dbl>, q9 <dbl>, i7 <dbl>, s4 <dbl>,
    ## #   x8 <dbl>, i9 <dbl>, k7 <dbl>, l4 <dbl>, u8 <dbl>, f9.1 <dbl>, j7 <dbl>,
    ## #   z4 <dbl>, k8 <dbl>, j9 <dbl>, x7 <dbl>, w4 <dbl>, m8.1 <dbl>, x9 <dbl>,
    ## #   g7 <dbl>, b4 <dbl>, l8 <dbl>, j9.1 <dbl>, c7 <dbl>, s4.1 <dbl>, t8 <dbl>,
    ## #   o9 <dbl>, v7 <dbl>, c4 <dbl>, u8.1 <dbl>, c9.1 <dbl>, e7 <dbl>, q4.2 <dbl>,
    ## #   z8 <dbl>, b9 <dbl>, p7 <dbl>, o4 <dbl>, k8.1 <dbl>, s9.1 <dbl>, k7.1 <dbl>,
    ## #   k4.1 <dbl>, y8.1 <dbl>, k9.1 <dbl>, c7.1 <dbl>, j4 <dbl>, z8.1 <dbl>,
    ## #   d9 <dbl>, j7.1 <dbl>, h4 <dbl>, v8 <dbl>, c9.2 <dbl>, d7 <dbl>, o4.1 <dbl>,
    ## #   y8.2 <dbl>, a9 <dbl>, a7 <dbl>, h4.1 <dbl>, z8.2 <dbl>, y9 <dbl>,
    ## #   z7.1 <dbl>, t4 <dbl>, b8 <dbl>, n9 <dbl>, p7.1 <dbl>, y4 <dbl>, u8.2 <dbl>,
    ## #   z9 <dbl>, k7.2 <dbl>, o4.2 <dbl>, l8.1 <dbl>, z9.1 <dbl>, k7.3 <dbl>,
    ## #   h4.2 <dbl>, i8 <dbl>, g9 <dbl>, n7.1 <dbl>, f4.1 <dbl>, x8.1 <dbl>,
    ## #   i9.1 <dbl>, x7.1 <dbl>, t4.1 <dbl>, …

`lisjoin`, as of now, provides a lazy prototypical approach:

``` r
library(lisjoin)

lisjoin(keyval_tibble, named_list, .key = key)
```

    ## # A tibble: 1,055 x 3
    ##    key      val list_val  
    ##    <chr>  <dbl> <list>    
    ##  1 s7    0.655  <dbl [10]>
    ##  2 s7    0.655  <dbl [10]>
    ##  3 s7    0.655  <dbl [10]>
    ##  4 s7    0.655  <dbl [10]>
    ##  5 s7    0.655  <dbl [10]>
    ##  6 s7    0.655  <dbl [10]>
    ##  7 s7    0.655  <dbl [10]>
    ##  8 s7    0.655  <dbl [10]>
    ##  9 s7    0.655  <dbl [10]>
    ## 10 i8    0.0378 <dbl [10]>
    ## # … with 1,045 more rows

Right now `lisjoin` supports key-guessing, type stable,
left/right/inner/full joins. For example, since we know the output is
going to be a double-precision number:

``` r
library(lisjoin)

map(named_list,
    ~ reduce(.x, sum)) %>% # reducing list
  lisjoin(keyval_tibble, 
          .,
          .key = key,
          type = 'dbl')
```

    ## # A tibble: 1,055 x 3
    ##    key      val list_val
    ##    <chr>  <dbl>    <dbl>
    ##  1 s7    0.655      2.20
    ##  2 s7    0.655      2.20
    ##  3 s7    0.655      2.20
    ##  4 s7    0.655      2.20
    ##  5 s7    0.655      2.20
    ##  6 s7    0.655      2.20
    ##  7 s7    0.655      2.20
    ##  8 s7    0.655      2.20
    ##  9 s7    0.655      2.20
    ## 10 i8    0.0378     2.20
    ## # … with 1,045 more rows

This feature is still under work, in the future expect it to work with
length \> 1 on the list’s elements, with automatic unnesting.

### Long term goals

This package is partly inspired primarely by clojure’s map structure,
purrr’s filosophy and design. In the long term I see it as a tool
allowing tidy data workflows on lists.
