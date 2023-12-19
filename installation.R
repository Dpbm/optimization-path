MIRROR <- "https://cran-r.c3sl.ufpr.br/"

install.packages("comprehenr", repos=MIRROR)

if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager", repos=MIRROR)

BiocManager::install("Rgraphviz")
