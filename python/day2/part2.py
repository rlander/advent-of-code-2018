from itertools import combinations

def solve():
    lines = (line.rstrip('\n') for line in open('input'))

    for id1, id2 in combinations(lines, 2):
        count = 0
        res = ""

        for l1, l2 in zip(id1, id2):
            if l1 == l2:
                count += 1
                res += res.join(l1)

        if count == len(id1) - 1:
            return res
