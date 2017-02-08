#' Read in and remove sensitive data
#'
#' \code{outbreak_dataset_read} reads data from outbreak practical file and fills in ID blanks.
#' See inst/extdata for examples of how the excel files should look like before importing.
#'
#' @param xlsx.file Full file path to where xlsx Outbreak dataset is stored.
#'
#' @export
#'
#'
#'

outbreak_dataset_read <- function(xlsx.file){

  # read in .xlsx file of data - see inst/extdata/paper.txt for example formatting with names removed
  df <- XLConnect::readWorksheetFromFile(xlsx.file,sheet=1,startRow = 2,endCol = 15,colTypes="character")
  df[,c(1,2,6,9,12,13,14,15)] <- lapply(df[,c(1,2,6,9,12,13,14,15)],as.numeric)

  names(df)[c(4:12,15)] <- c("Infection_Date","Infection_Time","Infection_Hours.since.start",
                             "Symptoms_Date","Symptoms_Time","Symptoms_Hours.since.start",
                             "End_Infection_Date","End_Infection_Time","End_Infection_Hours.since.start",
                             "Onward_Infection_Hours.since.start")

  df$Reinfection <- as.logical(df$Reinfection)

  # Nice format times to remove the years
    df$Infection_Time <- strftime(strptime(x = as.character(df$Infection_Time),format = "%H.%M"),"%H:%M:%S")
    df$Symptoms_Time <- strftime(strptime(x = as.character(df$Symptoms_Time),format = "%H.%M"),"%H:%M:%S")
    df$End_Infection_Time <- strftime(strptime(x = as.character(df$End_Infection_Time),format = "%H.%M"),"%H:%M:%S")

    df$Infection_Date <- strftime(df$Infection_Date,"%m/%d/%Y")
    df$Symptoms_Date <- strftime(df$Symptoms_Date,"%m/%d/%Y")
    df$End_Infection_Date <- strftime(df$End_Infection_Date,"%m/%d/%Y")



  # Calculate epidemiological parameters
  df$Latent_Period_Hours <- df$Onward_Infection_Hours.since.start - df$Infection_Hours.since.start
  df$Incubation_Period_Hours <- df$Symptoms_Hours.since.start - df$Infection_Hours.since.start
  df$Infectious_Period_Hours <- df$End_Infection_Hours.since.start - df$Onward_Infection_Hours.since.start
  df$Generation_Time_Hours <- df$Infection_Hours.since.start - df$Infection_Hours.since.start[match(df$Parent.ID,df$ID)]

  # Remove errors in Generation Times
  error.pos <- which(df$Generation_Time_Hours<0)
  if(length(error.pos)>0){

    df$Generation_Time_Hours[df$Generation_Time_Hours<0] <- NA
    message(paste("Warning: Some negative generation times were recorded and subsequently
              removed. Please check rows ",paste(error.pos,collapse = ", ")))

  }

  # Format data to include all necessary contacts, i.e. fill in id number in columns where omitted
  counter <- 0
  for ( i in 1:length(df$ID)){

    if(!is.na(df$ID[i])){
      counter <- counter + 1
    } else {
      df$ID[i] <- counter
    }

  }

  ## Let's change those who were unifected to have this column equal to false for the sake of including them
  ## within graph plotting
  df$Reinfection[is.na(df$Reinfection)] <- FALSE

  ## remove unnecessary data if not required
  res <- df[,-c(13,14)]

  return(res)

}
