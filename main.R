library("Rgraphviz")

nodes <- c("A", "B", "C", "D", "E");

graph <- new("graphNEL", nodes=nodes, edgemode="directed")
graph <- addEdge("A", "B", graph, 1, xlabel="test")
graph <- addEdge("B", "C", graph, 1)
graph <- addEdge("C", "D", graph, 1)
graph <- addEdge("D", "E", graph, 1)
graph <- addEdge("E", "A", graph, 1)

distances = c(5.8, 2.4, )

plot(graph, edgeAttrs=list(labels=))

