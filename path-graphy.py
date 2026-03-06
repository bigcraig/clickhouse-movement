import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt

df = pd.read_csv("edges.csv", header=None,
                 names=["from_probe","to_probe","weight"])

G = nx.from_pandas_edgelist(df, "from_probe", "to_probe",
                            edge_attr="weight", create_using=nx.DiGraph())

pos = nx.spring_layout(G, k=0.5)

nx.draw(G, pos, with_labels=True, node_size=800,
        width=[d['weight']/500 for _,_,d in G.edges(data=True)])

plt.show()