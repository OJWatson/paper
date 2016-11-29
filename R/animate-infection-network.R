#' Creates interactive html file with d3 network animation
#'
#' \code{animate_infection_network} takes output of \code{first_infection_list} and
#' produces a network animation of the outbreak using d3. Output is saved to file
#' as an html page
#'
#' N.B. Function
#'
#' @param first_infection_list Infection list outputted by \code{first_infection_list}.
#' @param file Full file path where html is to be saved to.
#' @param detach Boolean that detaches the packages loaded within the library.
#' Deafult = FALSE, i.e. packages remain in Global Environment.
#'
#' @export
#'
#'
#'

animate_infection_network <- function(first_infection_list, file, detach = FALSE){

  # if user has not provided .html file ending add ".html"
  if(tail(unlist(strsplit(file,".",fixed=T)),1) != "html"){
    file <- paste(file,".html",sep="")
  }

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
  paper.net.dyn <- networkDynamic::networkDynamic(
    base.net = paper.net,
    edge.spells=data.frame("onset" = first_infection_list$contacts$Infection_Hours.since.start,
                           "terminus" = max(first_infection_list$linelist$End_Infection_Hours.since.start),
                           "tail"=first_infection_list$contacts$From,
                           "head"=first_infection_list$contacts$To),
    vertex.spells=data.frame(onset=0,
                             terminus=max(first_infection_list$linelist$End_Infection_Hours.since.start),
                             vertex.id=1:dim(first_infection_list$linelist)[1])
  )

  # load ndtv
  suppressWarnings(suppressMessages(library(ndtv)))

  # precompute animation slices
  ndtv::compute.animation(paper.net.dyn, animation.mode = "kamadakawai",
                          slice.par=list(start=0,end=max(first_infection_list$linelist$End_Infection_Hours.since.start),
                                         interval=1, aggregate.dur=1, rule='latest'),
                          vertex.col="color")

  # render d3 movie and save to file paramter
  ndtv::render.d3movie(paper.net.dyn, usearrows = T,
                       displaylabels = T,
                       vertex.col = "color",
                       launchBrowser=T, filename=file,
                       render.par=list(tween.frames = 1, show.time = T),
                       plot.par=list(mar=c(0,0,0,0)),
                       main = "Outbreak Dynamics 2016. Susceptible (blue), Infected (red), Recovered (green)",
                       cex.main = 2)

  if(detach){
  invisible(
    Vectorize(detach)(name=paste0("package:", c("ndtv","sna","animation",
                                              "networkDynamic","network","statnet.common")),
                    unload=TRUE, character.only=TRUE)
  )
  }

}
