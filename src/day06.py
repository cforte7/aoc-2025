from typing import Literal
from dataclasses import dataclass


@dataclass
class MathProblem:
    numbers: list[int]
    operator: Literal["*", "+"]

    def mult(self) -> int:
        out = 1
        for num in self.numbers:
            out = out * num
        return out

    def add(self) -> int:
        out = 0
        for num in self.numbers:
            out += num
        return out

    def solve(self) -> int:
        if self.operator == "*":
            return self.mult()
        return self.add()


def part_one(data: str) -> list[MathProblem]:
    parsed = []
    for c in data.split("\n")[0:-1]:
        parsed.append([i for i in c.split(" ") if i != ""])

    out: list[MathProblem] = []
    col_count = len(parsed[0])

    for col_index in range(col_count):
        numbers = []
        for row_index in range(len(parsed) - 1):
            numbers.append(int(parsed[row_index][col_index]))
        prob = MathProblem(numbers=numbers, operator=parsed[-1][col_index])
        out.append(prob)
    return out


def part_two(data: str) -> list[MathProblem]:
    out = []
    parsed = []
    for row in data.split("\n")[:-1]:
        parsed.append([i for i in row])

    col_count = len(parsed[0])
    row_count = len(parsed)

    problems = []
    numbers = []
    for col_index in range(col_count - 1, -1, -1):
        column_digits = []
        for row_index in range(row_count - 1):
            val = parsed[row_index][col_index]
            if val.isdigit():
                column_digits.append(val)

        if len(column_digits) == 0:
            continue
        as_int = int("".join(column_digits))
        numbers.append(as_int)
        maybe_operator = parsed[-1][col_index]
        if maybe_operator != " ":
            problem = MathProblem(numbers=numbers, operator=maybe_operator)
            problems.append(problem)
            numbers = []

    return problems


def main():
    with open("inputs/day06.txt", "r") as file:
        content = file.read()
        score1 = 0
        score2 = 0
        problems = part_one(content)
        for p in problems:
            s = p.solve()
            score1 += s

        problems2 = part_two(content)
        for p in problems2:
            score2 += p.solve()
        print(score2)


if __name__ == "__main__":
    main()
