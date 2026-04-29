#!/usr/bin/env Rscript
# plot_progress.R, plot thesis page count over time
# Usage: Rscript plot_progress.R [progress.csv] [progress.pdf]

args <- commandArgs(trailingOnly = TRUE)
csv_path <- if (length(args) >= 1) args[1] else "progress.csv"
out_path <- if (length(args) >= 2) args[2] else "figures/progress.pdf"

if (!file.exists(csv_path)) {
  stop("Log file not found: ", csv_path, ". Run ./track_progress.sh first.")
}

dat <- read.csv(csv_path, stringsAsFactors = FALSE)
dat$date <- as.Date(dat$date)
dat <- dat[order(dat$date), ]

dir.create(dirname(out_path), showWarnings = FALSE, recursive = TRUE)

if (requireNamespace("ggplot2", quietly = TRUE)) {
  library(ggplot2)
  p <- ggplot(dat, aes(x = date, y = pages)) +
    geom_line(linewidth = 0.6, colour = "#2c3e50") +
    geom_point(size = 1.6, colour = "#2c3e50") +
    labs(x = NULL, y = "Pages", title = "Thesis writing progress") +
    theme_minimal(base_size = 12) +
    theme(panel.grid.minor = element_blank())
  ggsave(out_path, p, width = 6, height = 3.5)
} else {
  pdf(out_path, width = 6, height = 3.5)
  par(mar = c(4, 4, 2, 1))
  plot(dat$date, dat$pages,
       type = "o", pch = 16, lwd = 1.5,
       xlab = "", ylab = "Pages",
       main = "Thesis writing progress")
  dev.off()
}

cat("Wrote", out_path, "(", nrow(dat), "data points )\n")
