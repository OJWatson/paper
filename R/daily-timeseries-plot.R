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

  # create initially network so that node colors can be added to the vertices
  paper.net <- network::network(first_infection_list$contacts,  vertex.attr=first_infection_list$linelist, matrix.type="edgelist",
                                loops=F, multiple=F, ignore.eval = F)

  # add vertex color attributes related to onset of infection and recovery
  networkDynamic::activate.vertex.attribute(paper.net,"color","blue",onset=-Inf,terminus=Inf)
  networkDynamic::activate.vertex.attribute(paper.net,"color","red",
                                            onset=first_infection_list$linelist$Infection_Hours.since.start,terminus=Inf)
  networkDynamic::activate.vertex.attribute(paper.net,"color","green",
                                            onset=first_infection_list$linelist$End_Infection_Hours.since.start,terminus=Inf)

  # create network dynamics
  Dyn <- networkDynamic::networkDynamic(
    base.net = paper.net,
    edge.spells=data.frame("onset" = first_infection_list$contacts$Infection_Hours.since.start,
                           "terminus" = max(first_infection_list$linelist$End_Infection_Hours.since.start),
                           "tail"=first_infection_list$contacts$From,
                           "head"=first_infection_list$contacts$To),
    vertex.spells=data.frame(onset=0,
                             terminus=max(first_infection_list$linelist$End_Infection_Hours.since.start),
                             vertex.id=1:dim(first_infection_list$linelist)[1])
  )

  # all network events
  events <- sort(unique(as.data.frame(Dyn)[,]))

  # create graphical parameters
  par(mai = c(1,0,0,0),cex.lab=2)
  par(mfrow=c(1,5))


  ndtv::filmstrip(Dyn, displaylabels=F,
                  slice.par=list(start=0, end=119,interval=24,
                                 aggregate.dur=24, rule='latest'),mfrow=c(1,5),vertex.cex=1.5,
                  vertex.col = "color")


}

