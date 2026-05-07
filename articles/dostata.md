# Introduction to dostata

The aim of dostata is to enable you to combine the strengths of both R
and Stata into one seamless workflow. This document introduces you to
dostata’s basic functionality.

To start using dostata, you must first load the package.

``` r
library(dostata)
```

**Note:** All dostata functions start with the prefix `stata_`.

## Finding Stata

In order to run, dostata needs the path to your Stata executable. It
should find this path automatically, but if it cannot you can specify it
using
[`stata_path()`](https://dostata.jamesatkins.com/reference/stata_path.md).
This function may also be useful if you have multiple versions of Stata
installed and want to run an older version.

``` r
# For example on Windows
stata_path("C:/Program Files/Stata18/StataSE-64.exe")

# or on Mac
stata_path("/Applications/Stata/StataSE.app/Contents/MacOS/stata-se")

# or on Linux
stata_path("/opt/stata18/stata-mp")
```

## Running Commands

To run a Stata command from R, simply use the
[`stata_run()`](https://dostata.jamesatkins.com/reference/stata_run.md)
function. You can pass a single Stata command to this function or a
vector of commands.

``` r
stata_run("sysuse auto")
#> ℹ Started Stata session: /etc/profiles/per-user/james/bin/stata-se
#> sysuse auto
#> 
#> (1978 Automobile Data)
stata_run(c("summarize", "regress price length weight"))
#> summarize
#> 
#>     Variable |        Obs        Mean    Std. Dev.       Min        Max
#> -------------+---------------------------------------------------------
#>         make |          0
#>        price |         74    6165.257    2949.496       3291      15906
#>          mpg |         74     21.2973    5.785503         12         41
#>        rep78 |         69    3.405797    .9899323          1          5
#>     headroom |         74    2.993243    .8459948        1.5          5
#> -------------+---------------------------------------------------------
#>        trunk |         74    13.75676    4.277404          5         23
#>       weight |         74    3019.459    777.1936       1760       4840
#>       length |         74    187.9324    22.26634        142        233
#>         turn |         74    39.64865    4.399354         31         51
#> displacement |         74    197.2973    91.83722         79        425
#> -------------+---------------------------------------------------------
#>   gear_ratio |         74    3.014865    .4562871       2.19       3.89
#>      foreign |         74    .2972973    .4601885          0          1
#> regress price length weight
#> 
#>       Source |       SS           df       MS      Number of obs   =        74
#> -------------+----------------------------------   F(2, 71)        =     18.91
#>        Model |   220725280         2   110362640   Prob > F        =    0.0000
#>     Residual |   414340116        71  5835776.28   R-squared       =    0.3476
#> -------------+----------------------------------   Adj R-squared   =    0.3292
#>        Total |   635065396        73  8699525.97   Root MSE        =    2415.7
#> 
#> ------------------------------------------------------------------------------
#>        price |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
#> -------------+----------------------------------------------------------------
#>       length |  -97.96031    39.1746    -2.50   0.015    -176.0722   -19.84838
#>       weight |   4.699065   1.122339     4.19   0.000     2.461184    6.936946
#>        _cons |   10386.54   4308.159     2.41   0.019     1796.316    18976.76
#> ------------------------------------------------------------------------------
```

See how the second set of commands used the `auto` dataset that we
loaded with the first command. This works because, by default,
[`stata_run()`](https://dostata.jamesatkins.com/reference/stata_run.md)
uses the same Stata session every time you run a command. This means all
your data and results stay in one place, allowing you to easily build on
your previous commands. If needed, you can also run multiple Stata
sessions at the same time but most users can use dostata without
worrying about session management.

## Transferring Data

### Functions

dostata makes it is easy to transfer datasets between R and Stata. This
is useful when you want to use Stata’s powerful statistical capabilities
on data that you initially cleaned and tidied in R.

To pass data from R to Stata, use the function
[`stata_data_in()`](https://dostata.jamesatkins.com/reference/stata_data_in.md).
This function takes an R data frame and sends it to the Stata session
that you are working with. Behind the scenes,
[`stata_data_in()`](https://dostata.jamesatkins.com/reference/stata_data_in.md)
exports the R data frame to a `.dta` file using the
[`haven::write_dta`](https://haven.tidyverse.org/reference/read_dta.html)
function.

Similarly, if you have been working with a dataset in Stata and want to
bring that data back into R, use the function
[`stata_data_out()`](https://dostata.jamesatkins.com/reference/stata_data_out.md).
This function retrieves the current dataset from the active Stata
session and returns it as a data frame.

``` r
data("mtcars")

stata_data_in(mtcars, clear = TRUE)
#> use "$R_data_frame", clear
stata_run("summarize")
#> summarize
#> 
#>     Variable |        Obs        Mean    Std. Dev.       Min        Max
#> -------------+---------------------------------------------------------
#>          mpg |         32    20.09062    6.026948       10.4       33.9
#>          cyl |         32      6.1875    1.785922          4          8
#>         disp |         32    230.7219    123.9387       71.1        472
#>           hp |         32    146.6875    68.56287         52        335
#>         drat |         32    3.596563    .5346787       2.76       4.93
#> -------------+---------------------------------------------------------
#>           wt |         32     3.21725    .9784574      1.513      5.424
#>         qsec |         32    17.84875    1.786943       14.5       22.9
#>           vs |         32       .4375    .5040161          0          1
#>           am |         32      .40625    .4989909          0          1
#>         gear |         32      3.6875    .7378041          3          5
#> -------------+---------------------------------------------------------
#>         carb |         32      2.8125      1.6152          1          8

stata_run("rename mpg miles_per_gallon")
#> rename mpg miles_per_gallon
mtcars_stata <- stata_data_out()
#> save "/tmp/RtmpWeBxQg/dostata26f3dcd7976e5/stata26f3dc7ccad1d9.dta"
#> file /tmp/RtmpWeBxQg/dostata26f3dcd7976e5/stata26f3dc7ccad1d9.dta saved

mean(mtcars_stata$miles_per_gallon)
#> [1] 20.09062
```

### Magic Macros

In addition to these direct data transfer functions, dostata provides a
more general way to work with data between R and Stata using global
macros. In Stata, global macros of the form `$R_dataframe_name` are used
to reference R data frames. When you create a global macro in this
format, dostata automatically exports the specified R data frame to a
`.dta` file, which is the file format used by Stata for datasets. The
value of the global macro is then set to the path of this `.dta` file.

This functionality allows you to seamlessly use R data frames with a
variety of Stata commands that require a path to a dataset, such as
`merge`, `joinby`, or `append`. For example, in the following code,
`$R_mtcars` references the R data frame called `mtcars` in Stata,
allowing you to `use` it and then `append` it.

``` r
# dostata sets the gloal R_mtcars to be equal to the path of a dta file
# containing the data frame mtcars.
stata_run("use $R_mtcars, clear")
#> use $R_mtcars, clear
stata_run("summarize")
#> summarize
#> 
#>     Variable |        Obs        Mean    Std. Dev.       Min        Max
#> -------------+---------------------------------------------------------
#>          mpg |         32    20.09062    6.026948       10.4       33.9
#>          cyl |         32      6.1875    1.785922          4          8
#>         disp |         32    230.7219    123.9387       71.1        472
#>           hp |         32    146.6875    68.56287         52        335
#>         drat |         32    3.596563    .5346787       2.76       4.93
#> -------------+---------------------------------------------------------
#>           wt |         32     3.21725    .9784574      1.513      5.424
#>         qsec |         32    17.84875    1.786943       14.5       22.9
#>           vs |         32       .4375    .5040161          0          1
#>           am |         32      .40625    .4989909          0          1
#>         gear |         32      3.6875    .7378041          3          5
#> -------------+---------------------------------------------------------
#>         carb |         32      2.8125      1.6152          1          8
stata_run("display _N")
#> display _N
#> 32

stata_run("append using $R_mtcars")
#> append using $R_mtcars
stata_run("display _N")
#> display _N
#> 64
```

**Note:** R allows both variable names and column names to have dots in
them but this is **not** allowed by Stata. You will have to rename them
first.

``` stata
sysuse auto, clear
#> (1978 Automobile Data)
summarize
#> 
#>     Variable |        Obs        Mean    Std. Dev.       Min        Max
#> -------------+---------------------------------------------------------
#>         make |          0
#>        price |         74    6165.257    2949.496       3291      15906
#>          mpg |         74     21.2973    5.785503         12         41
#>        rep78 |         69    3.405797    .9899323          1          5
#>     headroom |         74    2.993243    .8459948        1.5          5
#> -------------+---------------------------------------------------------
#>        trunk |         74    13.75676    4.277404          5         23
#>       weight |         74    3019.459    777.1936       1760       4840
#>       length |         74    187.9324    22.26634        142        233
#>         turn |         74    39.64865    4.399354         31         51
#> displacement |         74    197.2973    91.83722         79        425
#> -------------+---------------------------------------------------------
#>   gear_ratio |         74    3.014865    .4562871       2.19       3.89
#>      foreign |         74    .2972973    .4601885          0          1
clear
```

```` default
```{stata}
describe
summarize mpg
```
````
