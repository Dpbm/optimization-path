library("Rgraphviz")

nodes <- c("A", "B", "C", "D", "E");

graph <- new("graphNEL", nodes=nodes, edgemode="directed")
graph <- addEdge("A", "B", graph, 5.8)
graph <- addEdge("B", "C", graph, 2.4)
graph <- addEdge("C", "D", graph, 5.6)
graph <- addEdge("D", "E", graph, 1.5)
graph <- addEdge("E", "A", graph, 9.8)


get_attrs <- function(graph){
  weights <- as.character(unlist(edgeWeights(graph)))
  names(weights) <- edgeNames(graph)
  edge_attr <- list()
  attr <- list()
  edge_attr$label <- weights
  attr$edge$fontsize <- 8
  
  data <- list()
  data$attr <- attr
  data$edge_attr <- edge_attr
  
  return(data)
}

data <- get_attrs(graph)
plot(graph, edgeAttrs=data$edge_attr, attrs=data$attr)

df <- data.frame (
  A = c(0, 5.8, 5.8, 7.6, 8.8),
  B = c(5.3, 0, 2.4, 4.3, 4.3),
  C = c(7.1, 1.7, 0, 3.5, 4.7),
  D = c(8.7, 4.0, 3.4, 0, 1.4),
  E = c(9.8, 5.1, 4.5, 1.4, 0)
)
rownames(df) <- nodes
df

full_graph <- new("graphNEL", nodes=nodes, edgemode="directed")

cols <- colnames(df)
for(row in rownames(df)){
  for(col in cols){
    pos <- which(cols==col)
    value <- df[,row][pos]
    
    print(row)
    print(col)
    print(pos)
    print(value)
    print(noquote(""))
    
    
    full_graph <- addEdge(row, col, full_graph, value)
  }
}

data <- get_attrs(full_graph)
plot(full_graph, edgeAttrs=data$edge_attr, attrs=data$attr)



greedy <- function(df){
  total <- 0 
  rows <- rownames(df)
  cols <- colnames(df)
  actual_row <- rows[1]
  visited_states <- list()
  
  while(actual_row != tail(rows, n=1)){
    min_value <- 10000
    min_col <- actual_row
    visited_states <- append(visited_states, actual_row)
    
    print(paste("actual state: ", actual_row))
    print(df[,actual_row])
    
    for(col in cols){
      pos <- which(cols==col)
      print(paste("position: ", pos))
      value <- df[,actual_row][pos]
      print(paste("value: ", value))
      
      if(value == 0){
        print("equal zero")
        print(noquote(""))
        next
      }
      
      print("different of zero")
      
      if(value < min_value && !(col %in% visited_states)){
        print(paste("new min value: ", value))
        print(paste("new min col: ", col))
        min_value <- value
        min_col <- col
      }
      
      print(noquote(""))
      
      Sys.sleep(1)
    }
    
    if(min_col == actual_row){
      print("Nothing found!")
      break
    }
    
    actual_row <- min_col
    total <- total+min_value
  }
  
  return(total)
}

greedy(df)


