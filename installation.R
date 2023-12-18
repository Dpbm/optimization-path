MIRROR <- "https://cran-r.c3sl.ufpr.br/"

if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager", repos=MIRROR)

BiocManager::install("Rgraphviz")
