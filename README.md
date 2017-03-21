# paper

[![Build Status](https://travis-ci.org/OJWatson/paper.png?branch=master)](https://travis-ci.org/OJWatson/paper)

### What is this?

Paper is a package designed to assist in demonstration of analysis associated to "paper outbreak" teaching practical. It is a collection of functions designed to ease analaysis of the paper outbreak practical within R. This includes importing and cleaning data from an excel sheet, viewing the infection network, visualising the outbreak as an animation, and calculating the epidemiological parameters associated with the practical.

***
> To view the tutorial please click [here](https://cdn.rawgit.com/OJWatson/paper/d7d3c6e8de5f12a155e1560136d6b0b08d5bc9f4/tutorials/paper-package-tutorial.html).

***

### Installing *paper*

To install the development version from github the package [*devtools*](https://github.com/hadley/devtools) is required.

In order to install devtools you need to make sure you have a working development environment:

1. **Windows**: Install **[Rtools](https://cran.r-project.org/bin/windows/Rtools/)**. For help on how to install **Rtools** please see the following [guide](https://github.com/stan-dev/rstan/wiki/Install-Rtools-for-Windows).

2. **Mac**: Install Xcode from the Mac App Store.

3. **Linux**: Install a compiler and various development libraries (details vary across different flavors of Linux).

Once a working development environment is ready, then devtools can be installed from CRAN:

```r
install.packages("devtools")
library(devtools)
```
Once installed, the package can be installed and loaded using:

```r
devtools::install_github("OJWatson/paper")
library(paper)
```

***
### Troubleshoot Guide

1. If you are installing the package outside of RStudio or an IDE that enables write access then try launching your IDE as an administrator. 

2. When installing the package to a library/shared computer you may see the following error:
```r
"Error in unzip(src, list = TRUE) : 'exdir' does not exist".
```
This error is related to RStudio failing to handle the network location for installation. A quick fix is to close RStudio and open the directory where you have R installed on your network ("\\icnas1.cc.ic.ac.uk/ic001/R/R-3.3.2/bin" - where ic001 is your username). In that directory run R and then install the package by using:
```r
devtools::install_github("OJWatson/paper")
```
Now, open a new RStudio window and you should be able to load the package, presuming your RStudio session is using your network R library. To troubleshoot this:
``` r 
.libPaths()
## If the above does not return something that looks like "\\\\icnas1.cc.ic.ac.uk/ic001/R/R-3.3.2/library" then add the library path:
.libPaths("\\\\icnas1.cc.ic.ac.uk/ic001/R/R-3.3.2/library")
```
***

#### Asking a question

For bug reports, feature requests, contributions, use github's [issue system.](https://github.com/OJWatson/paper/issues)
