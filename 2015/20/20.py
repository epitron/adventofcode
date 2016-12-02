import sys
import numpy

goal = 29000000

houses = numpy.zeros(goal//10, dtype=int)

# for i in range(2, goal//10):
#     houses[i::i] += 10 * i

for i in range(2, goal//10):
    houses[i:(50*i)+1:i] += 11 * i

for n, score in enumerate(houses):
  if score >= goal:
    print(n, score)
    sys.exit()

