from collections import defaultdict


def parse_input(data: str) -> list[list[str]]:
    as_lines = data.split("\n")
    return [[y for y in x] for x in as_lines]


def part_one(data: str) -> int:
    parsed = parse_input(data)
    start = parsed[0]
    lasers = []
    split = 0

    for x in start:
        if x == "S":
            lasers.append(True)
        else:
            lasers.append(False)

    for row in parsed[1:-1]:
        new = {}
        for i in range(len(lasers)):
            if lasers[i] is True:
                if row[i] == "^":
                    split += 1
                    new[i - 1] = True
                    new[i + 1] = True
                else:
                    new[i] = True

        for i in range(len(lasers)):
            lasers[i] = new.get(i, False)

    return split


cache: dict[tuple[int, int], int] = {}


def solve_2(row: int, col: int, data: list[list[str]]) -> int:
    maybe_cache = cache.get((row, col))
    if maybe_cache:
        return maybe_cache
    for i in range(len(data) - row - 1):
        if data[i + row][col] == "^":
            out = solve_2(i + row + 1, col - 1, data) + solve_2(
                i + row + 1, col + 1, data
            )
            cache[(row, col)] = out
            return out

    return 1


def part_two(data: str) -> int:
    start = -1
    parsed = parse_input(data)

    for i in range(len(parsed[0])):
        if parsed[0][i] == "S":
            start = i
            break

    lookup: dict[int, list[int]] = defaultdict(list)
    for i in range(len(parsed)):
        for j in range(len(parsed[i])):
            if parsed[i][j] == "^":
                lookup[i].append(j)
    return solve_2(0, start, parsed)


def main():
    with open("inputs/day07.txt", "r") as file:
        data = file.read()
        score1 = 0
        score2 = 0
        score1 = part_one(data)
        score2 = part_two(data)

        print(score1)
        print(score2)


if __name__ == "__main__":
    main()
