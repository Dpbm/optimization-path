import networkx as nx
import matplotlib.pyplot as plt

from data import relations, labels



graph = nx.DiGraph()

graph.add_nodes_from(list(labels))

for relation, weight in relations.items():
    node_from = relation[0]
    node_to = relation[1]

    graph.add_edge(node_from, node_to, weight=weight)



layout = nx.circular_layout(graph)
nx.draw(graph, with_labels=True, font_weight='bold', pos=layout)
labels = nx.get_edge_attributes(graph,'weight')
nx.draw_networkx_edge_labels(graph,layout,edge_labels=labels)
plt.savefig("./assets/graph.png")

