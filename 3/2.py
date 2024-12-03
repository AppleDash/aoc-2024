import re

def load_input():
    with open('3.txt', 'r') as fp:
        return fp.read()

if __name__ == '__main__':
    inp = load_input()
    # captured groups: ("mul" | "", n0, n1, "do" | "don't")
    regex = r'(?:(mul)\(([0-9]+),([0-9]+)\)|(do|don\'t)\(\))'
    total = 0
    mul = True
    
    for match in re.findall(regex, inp):
        if match[-1] == 'do':
            mul = True
        elif match[-1] == 'don\'t':
            mul = False
        elif mul:
            total += int(match[1]) * int(match[2])

    print(total)
