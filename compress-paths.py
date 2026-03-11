import csv
from collections import defaultdict

input_file = "paths.csv"
output_file = "paths_collapsed.csv"

def collapse_path_arrow(path):
    parts = path.split('->')
    if not parts:
        return ""
    collapsed = [parts[0]]
    for p in parts[1:]:
        if p != collapsed[-1]:
            collapsed.append(p)
    return '->'.join(collapsed)

collapsed_counts = defaultdict(int)

with open(input_file, newline='') as infile:
    reader = csv.reader(infile)
    for row in reader:
        path, count = row[0], int(row[1])
        collapsed_path = collapse_path_arrow(path)
        collapsed_counts[collapsed_path] += count

with open(output_file, 'w', newline='') as outfile:
    writer = csv.writer(outfile)
    writer.writerow(['path','count'])  # write header manually
    for path, count in collapsed_counts.items():
        writer.writerow([path, count])

print(f"Collapsed and aggregated paths written to {output_file}")