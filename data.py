from math import pi


starting_point = 'A'
labels = {'A','B','C','D','E'}
labels_index = {
    'A':0,
    'B':1,
    'C':2,
    'D':3,
    'E':4
}

nodes_index_relations_split = {
    0 : {
        0: 'B',
        1: 'C',
        2: 'D',
        3: 'E'
    },
    1 : {
        0: 'A',
        1: 'C',
        2: 'D',
        3: 'E'
    },
    2 : {
        0: 'A',
        1: 'B',
        2: 'D',
        3: 'E'
    }, 
    3 : {
        0: 'A',
        1: 'B',
        2: 'C',
        3: 'E'
    },
    4: {
        0: 'A',
        1: 'B',
        2: 'C',
        3: 'D' 
    }
}

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

def encode_angle(value, farest):
    return (value*pi)/farest