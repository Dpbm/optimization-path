library("Rgraphviz")
library(comprehenr)

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



djk <- function(df){
  states <- rownames(df)
  cols <- colnames(df)
  actual_state <- states[1]
  
  route <- c(actual_state)
  visited <- c(actual_state)
  distances <- to_vec(for(i in seq(along=rownames(df))) NA)
  distances[1] <- 0
  
  min_states <- c()
  
  while(length(visited) != length(states)){
    print(paste("STATE: ", actual_state))
    
    for(state in cols){
      pos <- which(cols==state)
      value <- df[,actual_state][pos] 
      print(paste("value: ", value))
      
      if(value == 0){
        print("zero edge value!")
        print(noquote(""))
        next
      }
      
      print("Updated distances: ")
      if(is.na(distances[pos])){
        distances[pos] = value
      }else{
        distances[pos] <- distances[pos]+value
      }
      print(distances)
      print(noquote(""))
    }
    
    if(length(min_states) > 0){
      actual_state <- min_states[1]
      visited <- append(visited, min_states[1])
      min_states <- tail(min_states, -1)
      route <- append(route, actual_state)
      next
    }
    
    min_value <- 10000
    min_states <- c()
    
    for(distance in distances){
      if(distance > 0 && distance < min_value){
        positions <- which(distances==distance)
        
        for(pos in positions){
          dis_state <- states[pos]
          print(paste("dis_state: ", dis_state))
          if(dis_state %in% visited){
            print("already visited state")
            next
          }
          
          min_value <- distance
          min_states <- append(min_states, dis_state)
          print(paste("inside pos: ", pos))
          print(paste("inside min_value: ", min_value))
          print(paste("inside min_state: ", states[pos]))
        }
      }
    }
  
    print(paste("min value: ", min_value))
    print(paste("min states: ", min_states))
    print(noquote(""))
    
    
    visited <- append(visited, min_states[1])
    actual_state <- min_states[1]
    min_states <- tail(min_states, -1)
    route <- append(route, actual_state)
    Sys.sleep(1)
  }
  
  print(route)
}

djk(df)


