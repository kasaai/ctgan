
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
  fit(iris, batch_size = 50, epochs = 20)
#> Epoch 1, Loss G: 1.1506, Loss D: 0.0993
#> Epoch 5, Loss G: 1.0985, Loss D: -0.0522
#> Epoch 10, Loss G: 1.1815, Loss D: -0.0337
#> Epoch 15, Loss G: 0.6709, Loss D: -0.1656
#> Epoch 20, Loss G: 0.5551, Loss D: 0.2805
synthesizer %>% 
  ctgan_sample()
#> # A tibble: 100 x 5
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species   
#>           <dbl>       <dbl>        <dbl>       <dbl> <chr>     
#>  1         7.75        2.57        0.265       1.20  versicolor
#>  2         7.17        2.35        3.29        1.44  versicolor
#>  3         6.06        1.94        1.84        0.744 setosa    
#>  4         7.17        2.23        5.70        0.829 setosa    
#>  5         6.52        3.33        3.51        1.15  virginica 
#>  6         6.11        2.49        2.03        0.732 versicolor
#>  7         7.46        3.39        2.87        1.28  virginica 
#>  8         7.24        2.43        5.21        0.371 virginica 
#>  9         6.91        2.39        1.83        1.79  virginica 
#> 10         5.44        3.02        5.92        1.25  versicolor
#> # … with 90 more rows
```
