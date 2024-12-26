library("Rgraphviz");
library(comprehenr);
library(rstudioapi);

#browseVignettes("Rgraphviz"); # RGraphviz Documentation

script_directory <- dirname(rstudioapi::getActiveDocumentContext()$path);
setwd(script_directory);


#----------------------------------------------------------------------------------
# Setup Graph and data


nodes <- c("A", "B", "C", "D", "E");
graph <- new("graphNEL", nodes=nodes, edgemode="directed");
df <- data.frame (
  # A,B,C,D,E are column labels
  A = c(0, 5.8, 5.8, 7.6, 8.8),
  B = c(5.8, 0, 2.4, 4.3, 4.3),
  C = c(5.8, 2.4, 0, 3.5, 4.7),
  D = c(7.6, 4.3, 3.5, 0, 1.4),
  E = c(8.8, 4.3, 4.7, 1.4, 0)
);

column_labels <- nodes;
for (col_label in column_labels){
  values <- df[[col_label]];
  
  for(row_i in 1:length(column_labels)){
    row_label <- column_labels[row_i];
    weight <- values[row_i];
    
    print(cat(row_label, col_label, toString(weight), "\n"));
    graph <- addEdge(col_label, row_label, graph, weight);
  }
}

##### GRAPH UTILS ######
get_attrs <- function(graph){
  weights <- as.character(unlist(edgeWeights(graph)));
  names(weights) <- edgeNames(graph);
  edge_attr <- list();
  attr <- list();
  edge_attr$label <- weights;
  attr$edge$fontsize <- 6;
  
  data <- list();
  data$attr <- attr;
  data$edge_attr <- edge_attr;
  
  return(data);
}
###################

graph_data <- get_attrs(graph);
plot(graph, edgeAttrs=graph_data$edge_attr, attrs=graph_data$attr);

dev.copy(png, filename="./assets/graph.png");
dev.off();


#-----------------------------------------------------------------------------------------------------------------------
# Functions

header <- function(name){
  print("************************");
  print(cat("Running ", name, " algorithm"));
  print("************************");
}

show_result <- function(path, total){
  print("Path: ")
  print(toString(path));
  print(cat("Total length: ", toString(total)));
}

is_all_na <- function(values){
  return(sum(is.na(values)) == length(values));
}

is_empty <- function(array){
  return(length(array)==0);
}

greedy <- function(df){
  header("Greedy");
  
  path <- c("A");
  path_length <- 0;
  
  for (col_i in 1:length(column_labels)){
    values <- df[[col_i]];
    values[col_i] <- NA;
    
    min_pos <- which.min(values);
    label <- column_labels[min_pos];
    all_values_are_na <- FALSE
    
    while(label %in% path){
      values[min_pos] <- NA;
      min_pos <- which.min(values);
      
      if(is_all_na(values)){
        all_values_are_na <- TRUE
        break;
      }
      
      label <- column_labels[min_pos];
    }
    
    if(all_values_are_na){
      break;
    }
    
    path_length <- path_length + values[min_pos];
    path <- append(path, label);
    
  }
  
  show_result(path, path_length);
}

create_node <- function(label, pos, total_till_now, path){
  return(list(
      label=label,
      pos=pos,
      total=total_till_now,
      path=path
    ));
}

brute_force <- function(df){
  header("Brute Force");

  queue <- list(create_node("A", 1, 0, list("A")));
  total_to_remove <- 0;
  layer <- 0
  shortest_path <- NULL
  
  while(layer < 4){
    total_to_remove <- length(queue);
    for(current_node in queue){
      adjacents <- list();
      for(node_i in 1:length(column_labels)){
        if(column_labels[node_i] %in% current_node$path){
          next;
        }
        adjacents <- append(adjacents, node_i);
      }
      
      for(adjacent in adjacents){
        adjacent_label <- column_labels[adjacent];
        adjacent_pos <- adjacent;
        adjacent_total <- current_node$total + df[[current_node$pos]][adjacent_pos];
        adjacent_path <- append(current_node$path, adjacent_label);
        
        new_node <- create_node(adjacent_label, adjacent_pos, adjacent_total, adjacent_path);
        queue <- append(queue, list(new_node));
        
        if(layer == 3 && (is.null(shortest_path) || new_node$total < shortest_path$total)){
          shortest_path <- new_node;
        }
      }
    }
    
    layer <- layer+1;
    
    #clear queue
    for(i in 1:total_to_remove){
      queue <- queue[-1];
    }
  }
  
  show_result(shortest_path$path, shortest_path$total);
}

greedy(df);
brute_force(df);

setwd('~')
