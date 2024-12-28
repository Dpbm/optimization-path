MIRROR <- "https://cran-r.c3sl.ufpr.br/"

install.packages("tidyverse")
install.packages(c("comprehenr", "rstudioapi"),  repos=MIRROR)

if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager", repos=MIRROR)

BiocManager::install("Rgraphviz")
