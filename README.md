# paper

[![Build Status](https://travis-ci.org/OJWatson/paper.png?branch=master)](https://travis-ci.org/OJWatson/paper)

### What is this?

Paper is a package designed to assist in demonstration of analysis associated to "paper outbreak" teaching practical. It is a collection of functions designed to ease analaysis of the paper outbreak practical within R. This includes importing and cleaning data from an excel sheet, viewing the infection network, visualising the outbreak as an animation, and calculating the epidemiological parameters associated with the practical.

***
> To view the tutorial please click [here](https://cdn.rawgit.com/OJWatson/paper/1548c4225286a3163c2fe74bedac093ec634768b/tutorials/paper-package-tutorial.html).

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
install_github("OJWatson/paper")
library(paper)
```

***
### Troubleshoot Guide

1. If you are installing the package outside of RStudio or an IDE that enables write access then try launching your IDE as an administrator. 

2. When installing the package to a library/shared computer you may see the following error:
```r
"Error in unzip(src, list = TRUE) : 'exdir' does not exist".
```
This error is thrown when the default temporary directory where the package unzips to is not writeable. To fix this, first close all instances of R / RStudio and open Command Prompt and enter the following:
```r
R
Sys.setenv(c("TMP","TEMP","TMPDIR") = "C:/Users/User/Desktop")
```
Now, open a new RStudio window and you should be able to install the package. 

***

#### Asking a question

For bug reports, feature requests, contributions, use github's [issue system.](https://github.com/OJWatson/paper/issues)
