
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ctgan

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/kasaai/ctgan/branch/master/graph/badge.svg)](https://codecov.io/gh/kasaai/ctgan?branch=master)
[![R build
status](https://github.com/kasaai/ctgan/workflows/R-CMD-check/badge.svg)](https://github.com/kasaai/ctgan/actions)
<!-- badges: end -->

The ctgan package provides an R interface to
[CTGAN](https://github.com/DAI-Lab/CTGAN), a GAN-based data synthesizer.
The package enables one to create synthetic samples of confidential or
proprietary datasets for sharing. For more details and use cases, see
the papers in the [References](#references) section.

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
# install_ctgan()

synthesizer <- ctgan()
synthesizer %>% 
  fit(iris, epochs = 20)
#> Epoch 1, Loss G: 1.1087, Loss D: -0.0124
#> Epoch 2, Loss G: 1.1455, Loss D: 0.0002
#> Epoch 3, Loss G: 1.1319, Loss D: -0.0197
#> Epoch 4, Loss G: 1.1054, Loss D: 0.0126
#> Epoch 5, Loss G: 1.0720, Loss D: -0.0240
#> Epoch 6, Loss G: 1.0652, Loss D: -0.0669
#> Epoch 7, Loss G: 1.0788, Loss D: -0.0513
#> Epoch 8, Loss G: 1.0766, Loss D: -0.0393
#> Epoch 9, Loss G: 1.0464, Loss D: -0.0116
#> Epoch 10, Loss G: 1.0297, Loss D: 0.0042
#> Epoch 11, Loss G: 1.0110, Loss D: -0.0482
#> Epoch 12, Loss G: 0.9828, Loss D: -0.0413
#> Epoch 13, Loss G: 0.9493, Loss D: -0.0031
#> Epoch 14, Loss G: 1.0067, Loss D: -0.0687
#> Epoch 15, Loss G: 0.9857, Loss D: -0.0215
#> Epoch 16, Loss G: 0.9618, Loss D: 0.0044
#> Epoch 17, Loss G: 0.9280, Loss D: 0.0061
#> Epoch 18, Loss G: 0.8579, Loss D: -0.0139
#> Epoch 19, Loss G: 0.8993, Loss D: 0.0400
#> Epoch 20, Loss G: 0.8277, Loss D: 0.0320
synthesizer %>% 
  ctgan_sample() %>% 
  # Dataset-specific post-processing
  dplyr::mutate_if(is.numeric, ~ pmax(.x, 0.1))
#> # A tibble: 100 x 5
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species   
#>           <dbl>       <dbl>        <dbl>       <dbl> <chr>     
#>  1         4.67        3.49        3.97         1.94 virginica 
#>  2         7.75        3.14        3.87         1.96 setosa    
#>  3         5.84        3.68        4.81         2.46 versicolor
#>  4         5.03        2.90        2.74         2.38 virginica 
#>  5         5.01        4.39        0.423        1.83 versicolor
#>  6         5.74        3.33        3.20         2.58 virginica 
#>  7         4.13        3.15        2.88         3.24 setosa    
#>  8         6.83        2.81        3.25         3.60 setosa    
#>  9         5.21        3.92        6.06         2.15 setosa    
#> 10         4.23        3.98        2.81         2.52 virginica 
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

## References

If you use ctgan, please consider citing the original work,

  - *Lei Xu, Maria Skoularidou, Alfredo Cuesta-Infante, Kalyan
    Veeramachaneni.* **Modeling Tabular data using Conditional GAN**.
    NeurIPS, 2019.

and the work implementing the R package,

  - *Kevin Kuo.* **Generative Synthesis of Insurance Datasets**.
    [arXiv:1912.02423](https://arxiv.org/abs/1912.02423), 2019.

<!-- end list -->

``` latex
@inproceedings{xu2019modeling,
  title={Modeling Tabular data using Conditional GAN},
  author={Xu, Lei and Skoularidou, Maria and Cuesta-Infante, Alfredo and Veeramachaneni, Kalyan},
  booktitle={Advances in Neural Information Processing Systems},
  year={2019}
}

@misc{kuo2019generative,
    title={Generative Synthesis of Insurance Datasets},
    author={Kevin Kuo},
    year={2019},
    eprint={1912.02423},
    archivePrefix={arXiv},
    primaryClass={stat.AP}
}
```
