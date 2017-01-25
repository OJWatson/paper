# Paper package tutorial overview
OJ Watson  
`r Sys.Date()`  

## Overview 

  The paper R package has been designed to be an additional tool in helping assist
with running the "paper outbreak" practical. The package assumes that the data has
been collected and stored in a similar fashion to that presented within the xlsx file
included within the external data directory, and that the main data from the first 
sheet in the excel document, between cell A2:Oxxx, is to be used.

  Given the above specificiations, the tutorial below will give an overview of how
to read in the data and produce a number of plots to help visualise the outbreak and
present the key epidemiological parameters.

## Loading the data

First we will read in the data from wherever you have stored the .xlsx file. Below
we will be using the example included with the package. The output of the following
section is stored within the package as well as a sample dataset called "paper.outbreak.2016".
If you are using the sample dataset in the remainder of the tutorial then remember to
set the outbreak.dataset variable equal to paper.outbreak.2016.



```r
# First make sure the package is installed
devtools::install_github("OJWatson/paper")

# Load package
library(paper)

# With the package installed first read in the data.
# This function will throw warnings highlighting rows where there may be errors in the excel file
outbreak.dataset <- paper::outbreak_dataset_read(xlsx.file = system.file("extdata","2016_OUTBREAK.xlsx",package="paper"))

# Visualise the dataset
str(outbreak.dataset)
```

```
## 'data.frame':	130 obs. of  17 variables:
##  $ ID                                : num  1 2 3 4 4 4 5 6 7 8 ...
##  $ Parent.ID                         : num  NA NA NA 2 38 19 2 1 1 2 ...
##  $ Reinfection                       : logi  FALSE FALSE FALSE FALSE TRUE TRUE ...
##  $ Infection_Date                    : chr  "17/10/16" "17/10/16" "17/10/16" "17/10/16" ...
##  $ Infection_Time                    : chr  "09:30:00" "09:30:00" "09:30:00" "13:30:00" ...
##  $ Infection_Hours.since.start       : num  9.5 9.5 9.5 13.5 36.7 ...
##  $ Symptoms_Date                     : chr  NA NA NA NA ...
##  $ Symptoms_Time                     : chr  NA NA NA NA ...
##  $ Symptoms_Hours.since.start        : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ End_Infection_Date                : chr  "17/10/16" "17/10/16" "17/10/16" "17/10/16" ...
##  $ End_Infection_Time                : chr  "14:00:00" "15:00:00" "16:41:00" "18:37:00" ...
##  $ End_Infection_Hours.since.start   : num  14 15 16.7 18.6 NA ...
##  $ Onward_Infection_Hours.since.start: num  13.9 13.5 16.7 17.6 NA ...
##  $ Latent_Period_Hours               : num  4.43 4 7.18 4.08 NA ...
##  $ Incubation_Period_Hours           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ Infectious_Period_Hours           : num  0.0667 1.5 0 1.0333 NA ...
##  $ Generation_Time_Hours             : num  NA NA NA 4 0.333 ...
```

```r
# This dataset is also saved within the paper package and can be accessed as such:
data("paper.outbreak.2016",package="paper")
## Confirm the datasets are the same
identical(paper.outbreak.2016,outbreak.dataset)
```

```
## [1] TRUE
```

```r
# If you are using the sample dataset for the remainder of the turorial then 
# uncomment the following line of code:

# outbreak.dataset <- paper.outbreak.2016
```

## Create an infection network

For the next task we will need to subset the collected data so that we are only
looking at those cases that were not reinfections. Using this subset of the data
we will then be able to plot a number of static images from the network that will
enable us to seee how the outbreak progressed in time.


```r
# Convert the read outbreak dataset into only the non-reinfections
first_infection_list <- paper::first_infection_list(outbreak.dataset)

# The above function has now sorted our data into a list of two dataframes. These
# data frames show the "linelist" and "contacts" data. We can now see that the
# linelist data only possesses information about contacts that were not reinfections:

unique(first_infection_list$linelist$Reinfection)
```

```
## [1] FALSE
```

```r
# Next we will create a plot of the outbreak that is time-orientated, i.e. the relative
# node positions represents the point in time that an individual was infected:

paper::infection_network_plot(first_infection_list = first_infection_list, time = TRUE)
```

<img src="paper-package-tutorial_files/figure-html/Create an infection network-1.png" style="display: block; margin: auto;" />

```r
# We can also visualise the network in a more "tree" like fashion which shows each
# infection event with an equal length branch for easier visualisation:

paper::infection_network_plot(first_infection_list = first_infection_list, time = FALSE)
```

<img src="paper-package-tutorial_files/figure-html/Create an infection network-2.png" style="display: block; margin: auto;" />

```r
# Lastly we can visualise what the outbreak looked like by viewing the outbreak
# at the end of each day, i.e. at 24 hour intervals

paper::daily_timeseries_plot(first_infection_list=first_infection_list)
```

```
## Edge activity in base.net was ignored
## Created net.obs.period to describe network
##  Network observation period info:
##   Number of observation spells: 1 
##   Maximal time range observed: -Inf until Inf 
##   Temporal mode: continuous 
##   Time unit: unknown 
##   Suggested time increment: NA
```

```
## No coordinate information found in network, running compute.animation
```

<img src="paper-package-tutorial_files/figure-html/Create an infection network-3.png" style="display: block; margin: auto;" />

## Animate the infection network

So far we have only been able to visualise the outbreak at discrete moments in
time. To improve this we can also create an html page showing an animation of the
outbreak process. (This will take a minute or two).


```r
# Change the file parameter to wherever you want the html to be stored
  paper::animate_infection_network(first_infection_list=first_infection_list,
                            file=paste(getwd(),"/Animated-Network-Dynamic.html",sep=""),
                            detach=FALSE)
```

```
## Edge activity in base.net was ignored
## Created net.obs.period to describe network
##  Network observation period info:
##   Number of observation spells: 1 
##   Maximal time range observed: -Inf until Inf 
##   Temporal mode: continuous 
##   Time unit: unknown 
##   Suggested time increment: NA
```

When you run the above function the animated network will automatically load in
a web browser and save the html page to file path specified. To view the output 
of the above function please then click [here](https://cdn.rawgit.com/OJWatson/paper/master/tutorials/Animated-Network-Dynamic.html)

## Epidemic Time Series

We can also use the collected data to plot the epidemic time series, using the times
recorded for when the infection started and ended in each individual.


```r
paper::epidemic_timeseries_plot(first_infection_list = first_infection_list)
```

<img src="paper-package-tutorial_files/figure-html/Epidemic Time Series-1.png" style="display: block; margin: auto;" />

## Parameter investigation

Lastly we can examine the distribution of the epidemiological parameters.


```r
paper::paramater_boxplots_plot(outbreak.dataset=outbreak.dataset)
```

<img src="paper-package-tutorial_files/figure-html/Epidemiological parameter investigation-1.png" style="display: block; margin: auto;" />

## Summary and further thoughts

Hopefully the above tutorial has shown how the paper outbreak practical can be extended
using R to extend the analysis and aid in visualising the outbreak process.

---


