
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
# install_ctgan()

synthesizer <- ctgan()
synthesizer %>% 
  fit(iris, epochs = 20)
#> Epoch 1, Loss G: 1.2498, Loss D: -0.0258
#> Epoch 2, Loss G: 1.2413, Loss D: -0.0013
#> Epoch 3, Loss G: 1.2533, Loss D: -0.0163
#> Epoch 4, Loss G: 1.2115, Loss D: -0.0140
#> Epoch 5, Loss G: 1.2236, Loss D: -0.0036
#> Epoch 6, Loss G: 1.1802, Loss D: -0.0423
#> Epoch 7, Loss G: 1.1796, Loss D: -0.0431
#> Epoch 8, Loss G: 1.1655, Loss D: -0.0262
#> Epoch 9, Loss G: 1.1485, Loss D: 0.0048
#> Epoch 10, Loss G: 1.1656, Loss D: -0.0655
#> Epoch 11, Loss G: 1.1132, Loss D: -0.0001
#> Epoch 12, Loss G: 1.1015, Loss D: 0.0136
#> Epoch 13, Loss G: 1.0568, Loss D: -0.0220
#> Epoch 14, Loss G: 1.0911, Loss D: -0.0036
#> Epoch 15, Loss G: 1.0389, Loss D: -0.0355
#> Epoch 16, Loss G: 1.0149, Loss D: -0.0320
#> Epoch 17, Loss G: 1.0376, Loss D: 0.0366
#> Epoch 18, Loss G: 1.0651, Loss D: -0.0760
#> Epoch 19, Loss G: 0.9866, Loss D: -0.0425
#> Epoch 20, Loss G: 1.0371, Loss D: -0.0767
synthesizer %>% 
  ctgan_sample() %>% 
  # Dataset-specific post-processing
  dplyr::mutate_if(is.numeric, ~ pmax(.x, 0.1))
#> # A tibble: 100 x 5
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species   
#>           <dbl>       <dbl>        <dbl>       <dbl> <chr>     
#>  1         5.86        1.77        2.83        1.87  versicolor
#>  2         4.52        3.49        0.182       2.98  setosa    
#>  3         4.50        2.02        0.231       0.405 setosa    
#>  4         6.57        3.12        2.28        3.25  versicolor
#>  5         4.36        3.27        2.01        2.64  virginica 
#>  6         6.98        2.32        2.95        1.71  versicolor
#>  7         4.30        1.59        2.49        0.273 setosa    
#>  8         5.12        1.90        0.521       2.77  versicolor
#>  9         7.23        2.34        0.411       3.09  virginica 
#> 10         5.36        1.99        2.18        1.97  setosa    
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
