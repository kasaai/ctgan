
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
#> Epoch 1, Loss G: 1.1005, Loss D: 0.0009
#> Epoch 5, Loss G: 1.1248, Loss D: 0.0533
#> Epoch 10, Loss G: 0.9896, Loss D: 0.0195
#> Epoch 15, Loss G: 0.9014, Loss D: -0.0940
#> Epoch 20, Loss G: 0.7421, Loss D: 0.2860
synthesizer %>% 
  ctgan_sample()
#> # A tibble: 100 x 5
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species   
#>           <dbl>       <dbl>        <dbl>       <dbl> <chr>     
#>  1         6.21        4.21         7.41       0.623 versicolor
#>  2         5.05        4.07         5.78       0.812 virginica 
#>  3         5.43        3.97         6.49       1.38  setosa    
#>  4         4.32        4.49         7.54       2.59  virginica 
#>  5         3.69        4.00         4.32       2.98  versicolor
#>  6         4.66        4.45         1.73       1.31  versicolor
#>  7         5.84        4.11         1.81       0.939 versicolor
#>  8         5.37        3.60         2.43       0.583 setosa    
#>  9         4.67        3.77         2.28       2.83  virginica 
#> 10         4.77        4.15         6.14       2.79  setosa    
#> # … with 90 more rows
```
