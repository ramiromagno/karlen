
<!-- README.md is generated from README.Rmd. Please edit that file -->

# karlen

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/karlen)](https://CRAN.R-project.org/package=karlen)
<!-- badges: end -->

`{karlen}` provides real-time PCR data sets by Karlen et al. (2007) in
tidy format.

## Installation

``` r
install.packages("karlen")
```

## Data

``` r
library(ggplot2)
library(dplyr, warn.conflicts = FALSE)
library(karlen)

karlen |>
  dplyr::filter(sample_type != "ntc") |>
  ggplot(aes(x = cycle, y = fluor, group = well, col = as.factor(dilution))) +
  geom_line(linewidth = 0.1) +
  geom_point(size = 0.05) +
  facet_grid(rows = vars(plate), cols = vars(sample), scales = "free_y") +
  labs(color = "Fold dilution")
```

<img src="man/figures/README-example-1.svg" width="100%" />
