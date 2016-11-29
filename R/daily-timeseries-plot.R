#' Plot 5x1 multiplot of network at 24 hour intervals
#'
#' \code{daily_timeseries_plot} takes output of \code{first_infection_list} and
#' plots 5x1 plot of infection network at 24 hour intervals
#'
#' @param first_infection_list Infection list outputted by \code{first_infection_list}
#'
#' @export
#'
#'
#'

daily_timeseries_plot <- function(first_infection_list){

  # create network dataframe
  nd.df <- data.frame("onset" = first_infection_list$contacts$Infection_Hours.since.start,
                      "terminus" = max(first_infection_list$linelist$End_Infection_Hours.since.start),
                      "tail"=first_infection_list$contacts$From,
                      "head"=first_infection_list$contacts$To)

  # build network dynamics
  Dyn <- networkDynamic::networkDynamic(vertex.spells=data.frame(onset=0, terminus=max(nd.df$terminus),
                                                                 vertex.id=1:dim(first_infection_list$linelist)[1]),
                                        edge.spells=nd.df[,c(1,2,3,4)])

  # all network events
  events <- sort(unique(as.data.frame(Dyn)[,]))

  # create graphical parameters
  par(mai = c(1,0,0,0),cex.lab=2)
  par(mfrow=c(1,5))

  ndtv::filmstrip(Dyn, displaylabels=F,
                  slice.par=list(start=0, end=119,interval=24,
                                 aggregate.dur=24, rule='latest'),mfrow=c(1,5),vertex.cex=1.5)

}

