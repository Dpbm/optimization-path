labels = {'A','B','C','D','E'}

relations = {
    'AA':0.0,
    'AB':5.8,
    'AC':5.8,
    'AD':7.6,
    'AE':8.8,

    'BA':5.3,
    'BB':0.0,
    'BC':2.4,
    'BD':4.3,
    'BE':4.3,

    'CA':7.1,
    'CB':1.7,
    'CC':0.0,
    'CD':3.5,
    'CE':4.7,

    'DA':8.7,
    'DB':4.0,
    'DC':3.4,
    'DD':0.0,
    'DE':1.4,

    'EA':9.8,
    'EB':5.1,
    'EC':4.5,
    'ED':1.4,
    'EE':0.0
}

class Node:
    def __init__(self,label,value=0,next=None):
        self.label=label
        self.value=value
        self.next=next
        self.previous = {label}
        self.parent = None
        self.depth = 0
        self.visited = False

    def update_previous(self, new_previous):
        self.previous = new_previous
    
    def update_depth(self, new_depth):
        self.depth = new_depth

    def label_is_ancient(self,label):
        return label in self.previous

    def is_leaf(self):
        return self.next is None

    def __str__(self):
        return f"""
        node label: {self.label}
        node value: {self.value}
        next nodes: {'None' if self.is_leaf() else ' '.join([node.label for node in self.next])}
        previous: {' '.join(list(self.previous))}
        """



routes = Node('A')

nodes_to_visit = [routes]

while len(nodes_to_visit) > 0:
    current_node = nodes_to_visit[0]
    current_node_label = current_node.label 

    is_the_last_level = current_node.depth >= 4
    if(is_the_last_level):
        nodes_to_visit.pop(0)
        continue
    else:
        current_node.next = []

    for label in labels:
        if(current_node.label_is_ancient(label)):
            continue
        new_node = Node(label,value=relations[f'{current_node_label}{label}'])
        new_node.update_previous(current_node.previous.union({label}))
        new_node.parent = current_node
        new_node.update_depth(current_node.depth+1) 

        current_node.next.append(new_node)
        nodes_to_visit.append(new_node)
    nodes_to_visit.pop(0)
