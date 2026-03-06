#3D Plot
import pandas as pd
import networkx as nx
import plotly.graph_objects as go

# Load CSV
#df = pd.read_csv("edges.csv")

df = pd.read_csv("edges.csv", header=None,
                 names=["from_probe","to_probe","weight"])
# Build graph
G = nx.DiGraph()
for _, row in df.iterrows():
    G.add_edge(row['from_probe'], row['to_probe'], weight=row['weight'])

# Compute 3D positions
pos = nx.spring_layout(G, dim=3, seed=42)

# Extract node coordinates
Xn = [pos[k][0] for k in G.nodes()]
Yn = [pos[k][1] for k in G.nodes()]
Zn = [pos[k][2] for k in G.nodes()]

# Extract edge coordinates
Xe, Ye, Ze = [], [], []
for e in G.edges():
    Xe += [pos[e[0]][0], pos[e[1]][0], None]
    Ye += [pos[e[0]][1], pos[e[1]][1], None]
    Ze += [pos[e[0]][2], pos[e[1]][2], None]

# Plot edges
edge_trace = go.Scatter3d(x=Xe, y=Ye, z=Ze,
                          mode='lines',
                          line=dict(color='blue', width=2),
                          hoverinfo='none')

# Plot nodes
node_trace = go.Scatter3d(x=Xn, y=Yn, z=Zn,
                          mode='markers+text',
                          marker=dict(symbol='circle', size=10, color='red'),
                          text=list(G.nodes()),
                          textposition="top center",
                          hoverinfo='text')

fig = go.Figure(data=[edge_trace, node_trace])
fig.update_layout(scene=dict(xaxis=dict(showbackground=False),
                             yaxis=dict(showbackground=False),
                             zaxis=dict(showbackground=False)),
                  margin=dict(l=0, r=0, b=0, t=0))

#fig.show()
fig.write_html("crowd_flow_3D.html")