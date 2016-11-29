#' Read in and remove sensitive data
#'
#' \code{outbreak_dataset_read} reads data from outbreak practical file and fills in ID blanks
#'
#' @export
#'
#'
#'

outbreak_dataset_read <- function(file){

# read in .txt file of data - see inst/extdata/paper.txt for example formatting with names removed
data <- read.delim(file,row.names=NULL, stringsAsFactors=FALSE)

# Format data to include all necessary contacts, i.e. fill in id number in columns where omitted
counter <- 0
for ( i in 1:length(data$ID)){

  if(!is.na(data$ID[i])){
    counter <- counter + 1
  } else {
    data$ID[i] <- counter
  }

}

## remove sensitive data # TO DO: adjust when seen layout
res <- data[,-c(2,3,15,16,21)]

return(res)

}
