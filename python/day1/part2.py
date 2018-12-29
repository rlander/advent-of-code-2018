from itertools import cycle


def solve():
    lines = [int(line.rstrip('\n')) for line in open('input')]
    lines = cycle(lines)
    total = 0
    freqs = []

    while True:
        total += next(lines)
        if total in freqs:
            break
        freqs.append(total)
    return total
