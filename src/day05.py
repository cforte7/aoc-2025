import bisect


def build_inputs(data: str) -> tuple[list[list[int]], list[int]]:
    ranges, checks = data.split("\n\n")
    sorted_ranges = []
    for r in ranges.split("\n"):
        start, end = r.split("-")
        start = int(start)
        end = int(end)
        sorted_ranges.append([start, end])
    sorted_ranges = sorted(sorted_ranges, key=lambda x: x[0])
    checks = [int(i) for i in checks.split("\n") if i]

    out = [sorted_ranges[0]]
    for r in sorted_ranges:
        if r[0] <= out[-1][1]:
            out[-1][1] = max(out[-1][1], r[1])
        else:
            out.append(r)

    return out, checks


def is_in_range(fresh: list[list[int]], value: int) -> bool:
    starts = [i[0] for i in fresh]
    index = bisect.bisect_right(starts, value) - 1
    target_range = fresh[index]
    if target_range[0] <= value <= target_range[1]:
        return True
    return False


def part_one(fresh: list[list[int]], checks: list[int]) -> int:
    score = 0
    print(len(checks))
    print(len(fresh))
    for c in checks:
        if is_in_range(fresh, c):
            score += 1
    return score


def part_two(fresh: list[list[int]]) -> int:
    score = 0
    for v in fresh:
        score += v[1] - v[0] + 1
    return score


def main():
    with open("inputs/day05.txt", "r") as file:
        content = file.read()
        fresh, checks = build_inputs(content)
        print(f"Part One: {part_one(fresh, checks)}")
        print(f"Part Two: {part_two(fresh)}")


if __name__ == "__main__":
    main()
