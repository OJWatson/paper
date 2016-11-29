#' Plot 4x1 boxplots of epidemiological parameters
#'
#' \code{paramater_boxplots_plot} takes output of \code{outbreak_dataset_read} and
#' plots boxplot of epidemiological parameter observations
#'
#' @param outbreak.dataset Outbreak dataset outputted by \code{outbreak_dataset_read}
#' @param title Plot title
#'
#' @export
#'
#'
#'

paramater_boxplots_plot <- function(outbreak.dataset,title){

  # load windows plotting fonts
  extrafont::loadfonts(device="win",quiet = T)

  # melt dataset into suitable dataframe
  melted <- reshape2::melt(outbreak.dataset[,c("ID","Latent_Period_Hours","Incubation_Period_Hours",
                                               "Infectious_Period_Hours","Generation_Time_Hours")],
                           id=c("ID"))

  # create initial boxplot
  gg <- ggplot2::ggplot(melted) + ggplot2::geom_boxplot(ggplot2::aes(x=variable,y=value))

  # add overlay of raw data and make pretty
  res <- gg + ggplot2::geom_point(ggplot2::aes(x=variable,y=value,alpha=0.1),
                                  position = ggplot2::position_jitter(width = 0.2), na.rm = T) +
    ggplot2::ylab("Time (hours)") +
    ggplot2::theme_classic() + ggplot2::theme_light() +
    ggplot2::scale_x_discrete(limit = c("Latent_Period_Hours","Incubation_Period_Hours","Infectious_Period_Hours","Generation_Time_Hours"),
                              labels = c("Latent Period","Incubation Period","Infectious Period","Generation Time"),
                              name = "Group") +
    ggplot2::theme(legend.position="none",
                   axis.title.x = ggplot2::element_blank(),
                   axis.text.x = ggplot2::element_text(size = 12, family = "Times New Roman"),
                   axis.title.y = ggplot2::element_text(margin=ggplot2::margin(c(0,10)),size = 14, family = "Times New Roman"),
                   axis.text.y = ggplot2::element_text(size = 12, family = "Times New Roman"),
                   plot.title = ggplot2::element_text(size = 14, family = "Times New Roman",hjust = 0.5)) +
    ggplot2::ggtitle(title)

  # print output before returning ggplot object
  suppressWarnings(
    print(res)
  )

  return(res)

}

