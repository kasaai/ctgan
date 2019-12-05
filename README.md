
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ctgan

<!-- badges: start -->

<!-- badges: end -->

The ctgan package provides an R interface to
[CTGAN](https://github.com/DAI-Lab/CTGAN), a GAN-based data synthesizer.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("kasaai/ctgan")
```

## Example

A quick example:

``` r
library(ctgan)

# Install dependencies before first usage
# install_ctgan_deps()

synthesizer <- ctgan()
synthesizer %>% 
  fit(iris, epochs = 20)
#> Epoch 1, Loss G: 1.1082, Loss D: -0.0291
#> Epoch 5, Loss G: 1.1978, Loss D: 0.0520
#> Epoch 10, Loss G: 1.2053, Loss D: 0.0311
#> Epoch 15, Loss G: 1.3112, Loss D: -0.1810
#> Epoch 20, Loss G: 1.2067, Loss D: -0.1018
synthesizer %>% 
  ctgan_sample()
#> # A tibble: 100 x 5
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species   
#>           <dbl>       <dbl>        <dbl>       <dbl> <chr>     
#>  1         5.69        2.48         2.56      2.08   versicolor
#>  2         3.84        2.51         2.41      1.48   virginica 
#>  3         4.80        1.98         6.46      0.616  setosa    
#>  4         5.48        3.00         9.15      0.280  virginica 
#>  5         4.27        3.04         2.53      0.0432 versicolor
#>  6         4.51        3.56         4.25      1.11   virginica 
#>  7         4.54        3.76         8.15      1.33   versicolor
#>  8         5.19        2.38         1.56      1.30   setosa    
#>  9         6.01        2.69         6.08      0.946  virginica 
#> 10         6.51        1.74         6.62      1.02   versicolor
#> # … with 90 more rows
```

This generated dataset can then be shared, but one can also serialize
and share the trained synthesizer:

``` r
model_dir <- tempdir()
synthesizer %>% 
  ctgan_save(model_dir)

ctgan_load(model_dir)
#> A CTGAN Model
```
