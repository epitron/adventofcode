total = 0
evalled = 0

with open("input.txt") as f:
  for line in f:
    line = line.strip()
    total += len(line)
    evalled += len(eval(line))

print(total - evalled)
