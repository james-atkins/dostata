# Run a Stata command

Run a Stata command

## Usage

``` r
stata_run(
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
