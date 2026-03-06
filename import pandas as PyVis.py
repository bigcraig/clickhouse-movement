import pandas as pd
from pyvis.network import Network

# load edge list
df = pd.read_csv("edges.csv", header=None,
                 names=["from_probe","to_probe","weight"])

net = Network(height="800px", width="100%", directed=True)

# add nodes
nodes = set(df["from_probe"]).union(set(df["to_probe"]))
for node in nodes:
    net.add_node(node, label=node)

# add edges
for _, row in df.iterrows():
    net.add_edge(row["from_probe"], row["to_probe"], value=row["weight"],
                 title=f"Flow: {row['weight']}")
net.show_buttons(filter_=['physics']) # add a physics button

net.write_html("crowd_flow.html")