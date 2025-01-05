library(tidyverse);

#----------------------------------------------------------------------------------
# Setup data


nodes <- c("A", "B", "C", "D", "E");
df <- data.frame (
  # A,B,C,D,E are column labels
  A = c(0, 5.8, 5.8, 7.6, 8.8),
  B = c(5.8, 0, 2.4, 4.3, 4.3),
  C = c(5.8, 2.4, 0, 3.5, 4.7),
  D = c(7.6, 4.3, 3.5, 0, 1.4),
  E = c(8.8, 4.3, 4.7, 1.4, 0)
);

column_labels <- nodes;


#-----------------------------------------------------------------------------------------------------------------------
# Functions

header <- function(name){
  print("************************");
  print(paste("Running ", name, " algorithm"));
  print("************************");
}

show_result <- function(path, total){
  print("Path: ")
  print(toString(path));
  print(paste("Total length: ", toString(total)));
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


dijkstra <- function(df){
  header("Dijkstra");
  
  path <- list(1); # starts on A node
  distances <- list();
  visited <- list(); # A has already been visited
  current_node <- 1; # node A
  
  # initialize distances
  for(i in 1:length(df)){
    distances <- append(distances, if(i ==1) 0 else Inf);
  }

  while(length(visited) < length(df)-1){
    # adjacents
    shortest <- Inf;
    smallest_node <- current_node;
    for(i in 1:length(df)){
      if(i == current_node || i %in% visited){
        next;
      }
      
      current_node_distance <- distances[[current_node]];
      nodes_distance <- df[[current_node]][i];
      new_distance <- nodes_distance + current_node_distance;
    
      # once all nodes are connected, we won't check if the new value is smaller or not
      distances[i] <- new_distance;
      
    
      if(shortest > new_distance){
        shortest <- new_distance;
        smallest_node <- i;
      }
    }
    
    visited <- append(visited, current_node);
    current_node <- smallest_node;
    path <- append(path, smallest_node);
    
  }
 
  labels_path <- list();
  for(i in path){
    labels_path <- append(labels_path, column_labels[i]);
  }

  show_result(labels_path, shortest);
  
}

create_node_relation <- function(weight, from, to){
  return(
    list(
      weight=weight,
      from=from,
      to=to
    )
  );
}

form_loop <- function(edges){
  # in this case, we only need to check if there are duplicated nodes
  return(any(duplicated(as.list(edges[[1]]))) || any(duplicated(edges[[2]])));
}

kruskal <- function(df){
  header("Kruskal");
  
  edges <- tibble(
    weight=numeric(),
    source=numeric(),
    destination=numeric(),
  );
  
  
  # translated a df into a list of nodes
  nodes <- list();
  for(i in 1:length(df)){
    for(j in 1:length(df)){
      if(j <= i){
        next;
      }
      nodes <- append(nodes, list(create_node_relation(df[[i]][j], i, j)));
    }
  }
  
  # sort data
  sorted_nodes <- list();
  already_checked <- list();
  while(length(sorted_nodes) < length(nodes)){
    min_value_pos <- 1;
    min_value <- Inf;
    for(node_i in 1:length(nodes)){
      if(node_i %in% already_checked){
        next;  
      }
      node <- nodes[[node_i]];
    
      if(node$weight < min_value){
        min_value <- node$weight;
        min_value_pos <- node_i;
      }
    }
    sorted_nodes <- append(sorted_nodes, nodes[min_value_pos]);
    already_checked <- append(already_checked, min_value_pos);
  }
  
  # pass sorted_nodes to a data frame
  for(node in sorted_nodes){
    edges <- edges %>% add_row(weight=node$weight, source=node$from, destination=node$to);
  }
  
  selected_nodes <- tibble(
    weight=numeric(),
    source=numeric(),
    destination=numeric(),
  );
  
  row_i <- 1;

  while(length(selected_nodes[[1]]) < length(column_labels)-1){
    
    row <- edges[row_i,]

    tmp_df <- selected_nodes;
    tmp_df <- tmp_df %>% add_row(weight=row$weight, source=row$source, destination=row$destination);
    
    if(!form_loop(tmp_df)){
      selected_nodes <- selected_nodes %>% add_row(weight=row$weight, source=row$source, destination=row$destination);
    }
  
    row_i <- row_i+1;
  }
  
  path <- list();
  path_size <- sum(selected_nodes[[1]]);
  
  # reconstruct path
  current_node <- 1;
  while(length(path) != length(df)){
    for(row_i in seq_len(nrow(selected_nodes))){
      row <- selected_nodes[row_i,]
      if(row$source == current_node){
        path<-append(path, column_labels[current_node]);
        
        if(length(path) == length(df)-1){
          path <- append(path, column_labels[row$destination]);
        }else{
          current_node <- row$destination;
        }
        
        break;
      }
    }
  }
  
    
  show_result(path, path_size);
} 

greedy(df);
brute_force(df);
dijkstra(df);
kruskal(df);