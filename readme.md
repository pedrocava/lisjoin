lisjoin
================

A small package with list-tibble join operations.

# Motivation

There no native strictly key-pair data structure to R. There is,
however, a sufficently good first-approach which is a named list.

``` r
{
  ids <- paste0(sample(letters, size = 1000, replace = TRUE), 
                sample(1:30, 4, replace = TRUE))
  named_list <- purrr::map(1:1000, function(.x) rnorm(10))
  names(named_list) <- ids
  head(named_list)
}
```

    ## $p28
    ##  [1] -1.46777476  0.74539593 -0.04664338  0.10781217  1.46081849  1.12868098
    ##  [7] -0.92717928 -0.14309675 -0.11820866 -0.43120743
    ## 
    ## $s30
    ##  [1] -1.31831735  1.99491831 -0.03777807 -1.25668048  0.09732199 -0.65921933
    ##  [7]  0.89431084 -0.36112306 -1.11437703  1.61232659
    ## 
    ## $v12
    ##  [1] -1.3033179675  1.1507490652  0.0002327135 -0.4352504670 -0.0690152133
    ##  [6]  2.0782264295  2.0316954216 -1.0194318330 -1.2564915962  0.4674051620
    ## 
    ## $f15
    ##  [1] -2.52414903 -2.04408138  0.16168534  0.73952108 -0.98379734 -0.24529745
    ##  [7]  0.39888376 -1.97808891  0.29995678  0.01493763
    ## 
    ## $y28
    ##  [1] -2.18879872  1.09157658 -0.04494610 -0.21365753 -1.61516204  0.92281453
    ##  [7] -0.00809693 -0.78239806 -0.37681752  1.10060229
    ## 
    ## $n30
    ##  [1] -0.9895956  0.5019188  0.6067216 -0.7643856  1.1582335  0.2849196
    ##  [7] -0.6200820  0.1745718 -0.3898789 -0.5189159

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

    ##  [1]  0.593759344  0.009909793 -0.743166196  0.221449062  0.530201613
    ##  [6]  0.078539020  0.606547272  0.335228779 -0.270646825 -1.218436378

``` r
# update specific values
ids_to_update <- sample(ids, 5)

modify_at(named_list, 
          ids_to_update, 
          function(x) 2*x - 3) ->
  updated_list

sample(named_list, 200) %>% # recover ids given condition
  keep(~ mean(.x) < -.5) %>%
  names()
```

    ##  [1] "w28" "y12" "t15" "k30" "e15" "b12" "u28" "i15" "l28" "s28" "c30" "j28"
    ## [13] "g15" "f28" "g30"

And by that I mean this far.

``` r
(tibble(key = sample(ids, 100),
       val = runif(100)) ->
  keyval_tibble)
```

    ## # A tibble: 100 x 2
    ##    key      val
    ##    <chr>  <dbl>
    ##  1 m15   0.291 
    ##  2 j28   0.686 
    ##  3 f28   0.930 
    ##  4 e30   0.889 
    ##  5 o30   0.977 
    ##  6 g28   0.914 
    ##  7 t28   0.790 
    ##  8 q28   0.0524
    ##  9 y15   0.644 
    ## 10 t15   0.764 
    ## # … with 90 more rows

``` r
left_join(keyval_tibble)
```

    ## Error in auto_copy(x, y, copy = copy): argument "y" is missing, with no default

``` r
left_join(keyval_tibble, named_list, by = character(), copy = TRUE)
```

    ## # A tibble: 1,000 x 1,002
    ##    key     val     p28     s30      v12     f15      y28    n30    c12    c15
    ##    <chr> <dbl>   <dbl>   <dbl>    <dbl>   <dbl>    <dbl>  <dbl>  <dbl>  <dbl>
    ##  1 m15   0.291 -1.47   -1.32   -1.30e+0 -2.52   -2.19    -0.990 -1.62   0.353
    ##  2 m15   0.291  0.745   1.99    1.15e+0 -2.04    1.09     0.502 -0.438  0.571
    ##  3 m15   0.291 -0.0466 -0.0378  2.33e-4  0.162  -0.0449   0.607 -0.474  1.70 
    ##  4 m15   0.291  0.108  -1.26   -4.35e-1  0.740  -0.214   -0.764 -0.381  1.24 
    ##  5 m15   0.291  1.46    0.0973 -6.90e-2 -0.984  -1.62     1.16  -1.48  -0.319
    ##  6 m15   0.291  1.13   -0.659   2.08e+0 -0.245   0.923    0.285 -0.984  0.431
    ##  7 m15   0.291 -0.927   0.894   2.03e+0  0.399  -0.00810 -0.620 -0.532  0.968
    ##  8 m15   0.291 -0.143  -0.361  -1.02e+0 -1.98   -0.782    0.175 -0.331  0.378
    ##  9 m15   0.291 -0.118  -1.11   -1.26e+0  0.300  -0.377   -0.390  1.37  -0.504
    ## 10 m15   0.291 -0.431   1.61    4.67e-1  0.0149  1.10    -0.519 -1.54  -1.20 
    ## # … with 990 more rows, and 992 more variables: h28 <dbl>, i30 <dbl>,
    ## #   t12 <dbl>, h15 <dbl>, c28 <dbl>, w30 <dbl>, w12 <dbl>, a15 <dbl>,
    ## #   x28 <dbl>, k30 <dbl>, w12.1 <dbl>, g15 <dbl>, g28 <dbl>, e30 <dbl>,
    ## #   n12 <dbl>, n15 <dbl>, o28 <dbl>, a30 <dbl>, o12 <dbl>, z15 <dbl>,
    ## #   m28 <dbl>, b30 <dbl>, c12.1 <dbl>, o15 <dbl>, w28 <dbl>, d30 <dbl>,
    ## #   w12.2 <dbl>, m15 <dbl>, b28 <dbl>, j30 <dbl>, m12 <dbl>, o15.1 <dbl>,
    ## #   s28 <dbl>, q30 <dbl>, t12.1 <dbl>, t15 <dbl>, c28.1 <dbl>, d30.1 <dbl>,
    ## #   r12 <dbl>, u15 <dbl>, b28.1 <dbl>, v30 <dbl>, a12 <dbl>, a15.1 <dbl>,
    ## #   h28.1 <dbl>, f30 <dbl>, m12.1 <dbl>, l15 <dbl>, g28.1 <dbl>, q30.1 <dbl>,
    ## #   p12 <dbl>, i15 <dbl>, b28.2 <dbl>, g30 <dbl>, x12 <dbl>, f15.1 <dbl>,
    ## #   h28.2 <dbl>, e30.1 <dbl>, c12.2 <dbl>, p15 <dbl>, x28.1 <dbl>, e30.2 <dbl>,
    ## #   x12.1 <dbl>, n15.1 <dbl>, e28 <dbl>, y30 <dbl>, a12.1 <dbl>, x15 <dbl>,
    ## #   q28 <dbl>, x30 <dbl>, l12 <dbl>, g15.1 <dbl>, f28 <dbl>, w30.1 <dbl>,
    ## #   k12 <dbl>, t15.1 <dbl>, e28.1 <dbl>, u30 <dbl>, b12 <dbl>, z15.1 <dbl>,
    ## #   a28 <dbl>, z30 <dbl>, b12.1 <dbl>, p15.1 <dbl>, q28.1 <dbl>, k30.1 <dbl>,
    ## #   h12 <dbl>, h15.1 <dbl>, j28 <dbl>, p30 <dbl>, z12 <dbl>, u15.1 <dbl>,
    ## #   u28 <dbl>, y30.1 <dbl>, c12.3 <dbl>, d15 <dbl>, f28.1 <dbl>, v30.1 <dbl>,
    ## #   w12.3 <dbl>, q15 <dbl>, …

`lisjoin`, as of now, provides a lazy prototypical approach:

``` r
library(lisjoin)

lisjoin(keyval_tibble, named_list, .key = key)
```

    ## # A tibble: 1,013 x 3
    ##    key     val list_val  
    ##    <chr> <dbl> <list>    
    ##  1 m15   0.291 <dbl [10]>
    ##  2 m15   0.291 <dbl [10]>
    ##  3 m15   0.291 <dbl [10]>
    ##  4 m15   0.291 <dbl [10]>
    ##  5 m15   0.291 <dbl [10]>
    ##  6 m15   0.291 <dbl [10]>
    ##  7 m15   0.291 <dbl [10]>
    ##  8 m15   0.291 <dbl [10]>
    ##  9 j28   0.686 <dbl [10]>
    ## 10 j28   0.686 <dbl [10]>
    ## # … with 1,003 more rows

Right now `lisjoin` supports key-guessing, type stability,
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

    ## # A tibble: 1,013 x 3
    ##    key     val list_val
    ##    <chr> <dbl>    <dbl>
    ##  1 m15   0.291   -4.24 
    ##  2 m15   0.291   -4.24 
    ##  3 m15   0.291   -4.24 
    ##  4 m15   0.291   -4.24 
    ##  5 m15   0.291   -4.24 
    ##  6 m15   0.291   -4.24 
    ##  7 m15   0.291   -4.24 
    ##  8 m15   0.291   -4.24 
    ##  9 j28   0.686    0.376
    ## 10 j28   0.686    0.376
    ## # … with 1,003 more rows

This feature is still under work, in the future expect it to work with
length \> 1 on the list’s elements, with automatic unnesting.

### Long term goals

This package is inspired by clojure’s map structure,
purrr’s filosophy and design. In the long term I see it as a tool
allowing tidy data workflows on lists.
