#' Plot offspring distribution
#'
#' \code{offspring_distribution_plot} takes output of \code{outbreak_dataset_read} and
#' plots offspring distribution. Returns ggplot object for plotting.
#'
#' @param outbreak.dataset Outbreak dataset outputted by \code{outbreak_dataset_read}
#' @param title Plot title. Default = NULL
#' @param include.unobserved.as.zero Boolean detailing whether idividuals who have not
#' yet ended their infection by the end of the practical are included and as R0 = 0 occurences.
#' Default = FALSE.
#'
#' @export
#'
#'
#'

offspring_distribution_plot <- function(outbreak.dataset,title=NULL,include.unobserved.as.zero=FALSE) {

  # load windows plotting fonts
  extrafont::loadfonts(device="win",quiet = T)

  # tabulate the offspring distribution observed
  if(include.unobserved.as.zero){
    offspring_distribution_df <- data.frame("R0" = as.numeric(
      table( factor(outbreak.dataset$Parent.ID, levels = min(outbreak.dataset$Parent.ID,na.rm = T):max(outbreak.dataset$Parent.ID,na.rm=T)))
    ))
  } else {
    offspring_distribution_df <- data.frame("R0" = as.numeric(table(outbreak.dataset$Parent.ID)))
  }
  # generate poisson expected
  #ppois(q = 0:max(offspring_distribution_df$R0),1.8,lower.tail = F)*length(offspring_distribution_df$R0)

  # Create ggplot object
  res <- ggplot2::ggplot(offspring_distribution_df, ggplot2::aes(R0)) +
    ggplot2::geom_histogram(bins = length(min(offspring_distribution_df$R0):max(offspring_distribution_df$R0)),colour = "black", fill = "white") +
    ggplot2::geom_freqpoly(bins = length(min(offspring_distribution_df$R0):max(offspring_distribution_df$R0)), size = 1) +
    ggplot2::xlab("Offspring Distribution (R0)") +
    ggplot2::ylab("Frequency") +
    ggplot2::scale_x_continuous(breaks=min(offspring_distribution_df$R0):max(offspring_distribution_df$R0)) +
    ggplot2::theme_classic() + ggplot2::theme_light() +
    ggplot2::theme(legend.position="none",
      axis.text.x = ggplot2::element_text(size = 12, family = "Times New Roman"),
      axis.title.y = ggplot2::element_text(margin=ggplot2::margin(c(0,10)),size = 14, family = "Times New Roman"),
      axis.text.y = ggplot2::element_text(size = 12, family = "Times New Roman"),
      plot.title = ggplot2::element_text(size = 14, family = "Times New Roman",hjust = 0.5),
      panel.border = ggplot2::element_blank(),
      axis.line = ggplot2::element_line())

   # add title if required
  if(!is.null(title)){
    res <- res + ggplot2::ggtitle(title)
  }

  # retrun ggplot object
  return(res)

}

