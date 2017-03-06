#' Discrete in time SIR simulator
#'
#' \code{discrete_SIR_simulator} takes output of \code{first_infection_list} and
#' \code{outbreak_dataset_read} and simulates a discrete time SIR epidemic time
#' series using a user-provided R0, population size (N), number of initial seed
#' infections (I) and time of seeding (seed.hour). The simulation uses a poisson
#' distribrution to describe the number of secondary cases, the generation times
#' and recovery times. The mean for the secondary cases is equal to R0, and the
#' mean for the generation and recovery times is calculated from the user-provided
#' first_infection_list and outbreak.dataset.
#'
#' @param R0 Reproductive number. Default = 1.8
#' @param N Total population size. If NULL (default) then the total population
#' is the same as the provided datasets.
#' @param I Number of initial seed infections. Default = 3
#' @param seed.hour Hour at which seeding of epidemic begins. Default = 9
#' @param first_infection_list Infection list outputted by \code{first_infection_list}
#' @param outbreak.dataset Outbreak dataset outputted by \code{outbreak_dataset_read}
#' @param sampling Boolean determining if recovery and generation times should be sampled
#' from the observed or drawn fro a poisson with mean equal to mean of the observed.
#' Default = FALSE (poisson draws used)
#' @param exponential Boolean determining if infection is exponential or not. If
#' FALSE (Default) then the number of secondary infections from an individual is
#' takes into account S/N
#'
#' @export
#'
#'

discrete_SIR_simulator <- function(R0 = 1.8, N = NULL, I = 3, seed.hour = NULL,
                                   first_infection_list, outbreak.dataset,
                                   sampling = FALSE, exponential = FALSE){

  # Initial conditions
  # If no N is provided, then the total population is the same as the provided datasets
  if(is.null(N)){
    N <- max(outbreak.dataset$ID)
    seed.hour <- min(first_infection_list$linelist$Infection_Hours.since.start,na.rm=T)
  }
  S <- N - I
  R <- 0

  # Create vector of all discrete times from 0 to end of infection list
  times <- sort(c(0:max(first_infection_list$linelist$End_Infection_Hours.since.start,na.rm = TRUE),seed.hour))

  # Create result vectors
  Sv <- rep(S,length(times))
  Iv <- rep(I,length(times))
  Rv <- rep(R,length(times))

  # Create vector of recovery times from the infection list
  Recovery_Times <- outbreak.dataset$End_Infection_Hours.since.start - outbreak.dataset$Infection_Hours.since.start

  # Remove the NAs
  Recovery_Times <- Recovery_Times[!is.na(Recovery_Times)]

  # Create vector of generation times from the outbreak dataset
  Generation_Times <- outbreak.dataset$Generation_Time_Hours

  # Remove the NAs
  Generation_Times <- Generation_Times[!is.na(Generation_Times)]

  # Create vector of generation times from the outbreak dataset
  Incubation_Times <- outbreak.dataset$Incubation_Period_Hours

  ## Distribtuion means for recovery, generation times
  mean.recovery.time <- mean(Recovery_Times,na.rm=T)  ## mean for poisson distribution describing average recovery time in hours
  mean.generation.time <- mean(Generation_Times,na.rm = T)  ## mean for poisson distribution describing average generation time in hours

  ## Handle seed time if provided
  ## start at start seed time
  if(is.numeric(seed.hour)){
    start <- seed.hour
    seed.vp <- match(seed.hour,times)
    Sv[1:(seed.vp - 1)] <- N
    Iv[1:(seed.vp - 1)] <- 0
  } else {
    start <- 0
  }

  ## End time for simulation
  end <- max(times)

  ## Initialisation
  if(exponential==FALSE){
    possible.new.infections <- sum(rpois(n=I,lambda=R0))
    prob_of_succesful_contact <- (S : (S-possible.new.infections+1))/N
    prob_of_succesful_contact[prob_of_succesful_contact<0] <- 0
    new.infections <-  sum(sapply(X = prob_of_succesful_contact,function(x){return(rbinom(n = 1,size = 1,prob = x))}))
  } else {
    new.infections <- sum(rpois(n = I,lambda = R0))
  }

  if(sampling == TRUE){
    infection.times <- round(sample(x = Generation_Times,size=new.infections,replace = T) + ceiling(start))
    recovery.times <- round(sample(x = Recovery_Times,size=I,replace = T) + ceiling(start))
  } else {
    infection.times <- rpois(new.infections,lambda = mean.generation.time) + ceiling(start)
    recovery.times <- rpois(I,lambda = mean.recovery.time) + ceiling(start)
  }

  next.event <- min(c(infection.times,recovery.times))
  if(next.event!=start){
    start <- start + 1
  }

  # create boolean to end simulation early if it is finished
  stop_simulation = FALSE

  ## Main loop
  for (current.hour in ceiling(start):end ){

    ## for reproducibility this is done in case non discrete time steps are to be used
    vp <- match(current.hour,times)

    ## Copy last hour initially
    Sv[vp] <- Sv[vp-1]
    Iv[vp] <- Iv[vp-1]
    Rv[vp] <- Rv[vp-1]

    if(sum(Sv[vp],Iv[vp],Rv[vp]) != N){
      stop("N not constant")
    }

    ## if there is an event for the day
    if(next.event == current.hour){

      ## handle infection next event
      ## -----------------------------------------------------------------------------------------------
      while(is.element(current.hour,infection.times)){

        # How many people are being infected now
        now.infections <- sum(infection.times == current.hour)

        # Remove the current hour infection times
        infection.times <- infection.times[!infection.times == current.hour]

        # Update the S and I according to number of infections in this hour
        Sv[vp] <- Sv[vp] - now.infections
        Iv[vp] <- Iv[vp] + now.infections

        # Work out what time those infected in this hour will recover
        if(sampling == TRUE){
          recovery.times <- c(recovery.times , round(sample(x = Recovery_Times,size=now.infections,replace = T) + current.hour))
        } else {
          recovery.times <- c(recovery.times , rpois(n = now.infections,lambda=mean.recovery.time) + current.hour)
        }


        # First work out how many new infections would arise from the infections that
        # occured in this hour, and what their times would be
        if(exponential==FALSE){
          possible.new.infections <- sum(rpois(n=now.infections,lambda=R0))
          prob_of_succesful_contact <- (Sv[vp] : (Sv[vp]-possible.new.infections+1))/N
          prob_of_succesful_contact[prob_of_succesful_contact<0] <- 0
          new.infections <-  sum(sapply(X = prob_of_succesful_contact,function(x){return(rbinom(n = 1,size = 1,prob = x))}))
        } else {
          new.infections <- sum(rpois(n = now.infections,lambda = R0))
        }


        if(sampling == TRUE){
          infection.times <- c(infection.times , round(sample(x = Generation_Times,size=new.infections,replace = T) + current.hour))
        } else {
          infection.times <- c(infection.times , rpois(n = new.infections,lambda=mean.generation.time) + current.hour)
        }

        # If there are more infection times than people to infect, then sort the infection times and
        # take the earliest x, where x is the number of susceptibles left
        if(length(infection.times) > Sv[vp]){
          infection.times <- head(sort(infection.times),Sv[vp])
        }

      }

      ## handle recovery next event
      ## -----------------------------------------------------------------------------------------------
      if(is.element(current.hour,recovery.times)){

        # How many people are recovering now
        new.recoveries <- sum(recovery.times == current.hour)

        # Remove those times that are recovering in this hour
        recovery.times <- recovery.times[!recovery.times == current.hour]

        # Update recovered and infected accordingly
        Rv[vp] <- Rv[vp] + new.recoveries
        Iv[vp] <- Iv[vp] - new.recoveries

      }

      ## update next event or break out of sim loop if no more events
      if(length(c(infection.times,recovery.times))==0){

        ## if we are on the last time step then we don't do this
        if(vp != length(times)){
          Sv[(vp+1) : (end+1)] <- Sv[vp]
          Iv[(vp+1) : (end+1)] <- Iv[vp]
          Rv[(vp+1) : (end+1)] <- Rv[vp]
        }
        stop_simulation = TRUE

      }
      if(stop_simulation) break

      ## find out next event time
      next.event <- min(c(infection.times,recovery.times))


    }


  }

  # return results
  test = TRUE
  if(test){
    a = 1
    if(length(Sv)>length(times)){
      a=2
    }
  }

  return(data.frame(Sv,Iv,Rv,times))

}

