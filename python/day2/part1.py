from collections import defaultdict

def solve():
    lines = [line.rstrip('\n') for line in open('input')]
    twos = 0
    threes = 0

    for l in lines:
        count = defaultdict(lambda: 0)

        for i in l:
            count[i] += 1

        count = {v:k for k,v in count.items()}

        if count.get(2):   
             twos += 1
        if count.get(3):
            threes += 1
    return twos * threes 
