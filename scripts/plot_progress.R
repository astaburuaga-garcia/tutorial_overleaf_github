#!/usr/bin/env Rscript
# plot_progress.R, plot thesis page count over time
# Usage: Rscript plot_progress.R [progress.csv] [output_dir]
#
# Writes both progress.pdf (for inclusion in the thesis) and progress.png
# (for the README dashboard, since GitHub does not render PDFs inline).

args <- commandArgs(trailingOnly = TRUE)
csv_path <- if (length(args) >= 1) args[1] else "progress.csv"
out_dir  <- if (length(args) >= 2) args[2] else "figures"

if (!file.exists(csv_path)) {
  stop("Log file not found: ", csv_path, ". Run ./track_progress.sh first.")
}

dat <- read.csv(csv_path, stringsAsFactors = FALSE)
dat$date <- as.Date(dat$date)
dat <- dat[order(dat$date), ]

dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
pdf_path <- file.path(out_dir, "progress.pdf")
png_path <- file.path(out_dir, "progress.png")

draw <- function(device_open, device_close) {
  device_open()
  if (requireNamespace("ggplot2", quietly = TRUE)) {
    library(ggplot2)
    p <- ggplot(dat, aes(x = date, y = pages)) +
      geom_line(linewidth = 0.6, colour = "#2c3e50") +
      geom_point(size = 1.6, colour = "#2c3e50") +
      labs(x = NULL, y = "Pages", title = "Thesis writing progress") +
      theme_minimal(base_size = 12) +
      theme(panel.grid.minor = element_blank())
    print(p)
  } else {
    par(mar = c(4, 4, 2, 1))
    plot(dat$date, dat$pages,
         type = "o", pch = 16, lwd = 1.5,
         xlab = "", ylab = "Pages",
         main = "Thesis writing progress")
  }
  device_close()
}

draw(function() pdf(pdf_path, width = 6, height = 3.5), dev.off)
draw(function() png(png_path, width = 1200, height = 700, res = 200), dev.off)

cat("Wrote", pdf_path, "and", png_path, "(", nrow(dat), "data points )\n")
