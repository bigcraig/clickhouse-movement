def collapse_path_arrow(path):
    """Collapse consecutive duplicates in a path string with '->' separator"""
    parts = path.split('->')
    if not parts:
        return ""
    collapsed = [parts[0]]
    for p in parts[1:]:
        if p != collapsed[-1]:
            collapsed.append(p)
    return '->'.join(collapsed)

# Example:
path = "018d959e5->018d959e5->0a71576dd->0a71576dd->0472e71fd->0472e71fd->0aff41123"
collapsed = collapse_path_arrow(path)
print(collapsed)