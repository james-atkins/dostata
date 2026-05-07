# Sessions

By default, when you call stata_run() without specifying a session, it
will use the default Stata session. This default session is
automatically created the first time you run stata_run() or when you
initialize a session with the stata_default_session() function. All
commands sent using stata_run() will be executed within this default
session unless you specify otherwise.

When
[`stata_run()`](https://dostata.jamesatkins.com/reference/stata_run.md)
is run for the first time, dostata starts a *Stata session* in the
background. A Stata session is an instance of Stata that dostata
communicates with, allowing you to execute commands, perform analyses
and manage data as if you were using Stata directly.

By default, all commands you execute using dostata are directed to the
same Stata session that was initially started. This means that unless
you specify otherwise, every operation — such as loading data, running
regressions, or generating graphs — is conducted within this single
session. The state of this session is preserved across commands, which
allows for a seamless workflow where data and results from previous
commands are immediately available for subsequent operations.

However, dostata also supports running multiple Stata sessions
concurrently. This functionality can be useful in various scenarios. For
example, if you are working on multiple projects at the same time or
need to run different analyses in parallel without affecting the state
of another session, you can create additional sessions. Each session
runs independently in the background, maintaining its own unique
environment and set of variables, ensuring that operations in one
session do not interfere with those in another.

To interact with the default session, you can use the
[`stata_default_session()`](https://dostata.jamesatkins.com/reference/stata_default_session.md)
function. This function provides direct access to the default Stata
session, allowing you to manage its state or retrieve information about
it. If you need to switch between different sessions or create a new
one, you can do so by specifying the session explicitly in your commands
or by using other functions provided by the dostata package.

``` r
another_session <- stata_start_session()
#> ℹ Started Stata session:
#> /etc/profiles/per-user/james/bin/stata-se

stata_run("sysuse lifeexp", session = another_session)
#> sysuse lifeexp
#> (Life expectancy, 1998)
stata_run("describe, simple", session = another_session)
#> describe, simple
#> region     country    popgrowth  lexp       gnppc      safewater

# Note that the data set loaded in the default session is different to the
# data set in `another_session`.
stata_run("describe, simple")
#> ℹ Started Stata session: /etc/profiles/per-user/james/bin/stata-se
#> describe, simple

stata_close_session(another_session)
```
