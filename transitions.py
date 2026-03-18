import pandas as pd

df = pd.read_csv('results.csv', header=None, 
                  names=['mac','timestamp','probe'])

# Keep rows where probe changes
df['prev_probe'] = df.groupby('mac')['probe'].shift(1)
df['next_probe'] = df.groupby('mac')['probe'].shift(-1)

transitions = df[
    (df['probe'] != df['prev_probe']) |
    (df['probe'] != df['next_probe'])
].drop(columns=['prev_probe','next_probe'])

transitions.to_csv('transitions.csv', index=False)