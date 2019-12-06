
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
#> Epoch 1, Loss G: 1.0098, Loss D: 0.0044
#> Epoch 5, Loss G: 1.0908, Loss D: -0.0092
#> Epoch 10, Loss G: 1.0011, Loss D: 0.0028
#> Epoch 15, Loss G: 0.9803, Loss D: -0.0570
#> Epoch 20, Loss G: 0.7675, Loss D: -0.1298
synthesizer %>% 
  ctgan_sample()
#> # A tibble: 100 x 5
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species   
#>           <dbl>       <dbl>        <dbl>       <dbl> <chr>     
#>  1         5.14        3.52         1.41       2.38  versicolor
#>  2         5.58        3.74         2.74       1.88  setosa    
#>  3         6.03        3.71         7.47       0.141 setosa    
#>  4         5.19        3.01         6.42       2.21  virginica 
#>  5         6.66        4.45         5.45       3.21  setosa    
#>  6         4.29        4.43         3.44      -0.519 virginica 
#>  7         7.47        3.07         3.88       2.22  versicolor
#>  8         4.23        4.12         6.50       1.56  versicolor
#>  9         7.66        3.44         3.92       0.777 versicolor
#> 10         6.17        2.33         2.65       1.48  versicolor
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
