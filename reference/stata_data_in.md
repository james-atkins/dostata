# Transfer data from R to Stata

Transfer data from R to Stata

## Usage

``` r
stata_data_in(
  data_frame,
  ...,
  clear = FALSE,
  session = stata_default_session()
)
```

## Arguments

- data_frame:

  The data frame to be loaded in Stata

- ...:

  These dots are for future extensions and must be empty.

- clear:

  Whether to replace the data set already in Stata

- session:

  The Stata session to load the data set in
