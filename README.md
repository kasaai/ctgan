
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ctgan

<!-- badges: start -->

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
# install_ctgan_deps()

synthesizer <- ctgan()
synthesizer %>% 
  fit(iris, epochs = 20)
#> Epoch 1, Loss G: 1.0212, Loss D: 0.1023
#> Epoch 5, Loss G: 1.0818, Loss D: 0.0002
#> Epoch 10, Loss G: 1.0123, Loss D: 0.0265
#> Epoch 15, Loss G: 0.9943, Loss D: 0.0271
#> Epoch 20, Loss G: 1.0249, Loss D: 0.0717
synthesizer %>% 
  ctgan_sample() %>% 
  # Dataset-specific post-processing
  dplyr::mutate_if(is.numeric, ~ pmax(.x, 0.1))
#> # A tibble: 100 x 5
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species   
#>           <dbl>       <dbl>        <dbl>       <dbl> <chr>     
#>  1         5.71        2.97         6.95       2.83  versicolor
#>  2         5.09        2.15         2.71       0.586 versicolor
#>  3         7.20        3.13         2.36       0.730 setosa    
#>  4         4.96        3.47         1.56       2.36  virginica 
#>  5         6.71        3.29         2.71       0.678 versicolor
#>  6         5.51        2.44         6.33       0.610 versicolor
#>  7         6.91        2.86         9.51       0.711 versicolor
#>  8         7.54        1.90         2.22       0.361 versicolor
#>  9         7.01        3.01         7.02       2.83  setosa    
#> 10         6.94        2.56         7.63       0.535 virginica 
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
