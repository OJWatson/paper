# paper

[![Build Status](https://travis-ci.org/OJWatson/paper.png?branch=master)](https://travis-ci.org/OJWatson/paper)

## What is this?

Paper is a package designed to assist in demonstration of analysis associated to "paper outbreak" teaching practical. It is a collection of functions designed to ease analaysis of the paper outbreak practical within R. This includes importing and cleaning data from an excel sheet, viewing the infection network, visualising the outbreak as an animation, and calculating the epidemiological parameters associated with the practical.

> To view the tutorial please click [here](https://cdn.rawgit.com/OJWatson/paper/cd02199d4c8f473b9acca9d06661a6bf026289e0/tutorials/paper-package-tutorial.html).

## Installing *paper* devel

To install the development version from github the package [*devtools*](https://github.com/hadley/devtools) is required.

Install the release version of devtools from CRAN with install.packages("devtools").

Make sure you have a working development environment.

1. Windows: Install [Rtools](https://cran.r-project.org/bin/windows/Rtools/).For a guide on how to install devtools please see the following [guide](https://github.com/stan-dev/rstan/wiki/Install-Rtools-for-Windows).

2. Mac: Install Xcode from the Mac App Store.

3. Linux: Install a compiler and various development libraries (details vary across different flavors of Linux).


```r
install.packages("devtools")
library(devtools)
install_github("OJWatson/paper")
```

Once installed, the package can be loaded using:

```r
library(paper)
```

## Asking a question

For bug reports, feature requests, contributions, use github's [issue system.](https://github.com/OJWatson/paper/issues)
