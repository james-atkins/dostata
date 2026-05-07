# Evaluate Stata commands and return details of their evaluation

`stata_evaluate` similar to the
[`evaluate::evaluate()`](https://dostata.jamesatkins.com/reference/evaluate.r-lib.org/reference/evaluate.md)
function. It returns an `evaluation` object that consists of the Stata
commands run and the corresponding output and errors.

## Usage

``` r
stata_evaluate(
  commands,
  ...,
  session = stata_default_session(),
  env = parent.frame()
)
```

## Arguments

- commands:

  A vector of Stata commands to run

- ...:

  These dots are for future extensions and must be empty.

- session:

  The Stata session to run the commands in

- env:

  The R environment in which to look for data frames to transfer to
  Stata
