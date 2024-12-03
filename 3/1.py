import re

def load_input():
    with open('3.txt', 'r') as fp:
        return fp.read()

if __name__ == '__main__':
    inp = load_input()

    # captured groups: (n0, n1)
    regex = r'mul\(([0-9]+),([0-9]+)\)'
    total = 0

    for match in re.findall(regex, inp):
        total += int(match[0]) * int(match[1])

    print(total)