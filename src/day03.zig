const io = @import("common/io.zig");
const std = @import("std");

fn part_one(row: []u8) i32 {
    var max_value: i32 = -1;
    var max_index: usize = 0;

    const row_len = row.len;
    for (0..(row_len - 1)) |index| {
        // this converts it from byte representation to actual number value
        // not really sure how or why this works
        const as_int = row[index] - '0';
        if (as_int > max_value) {
            max_value = as_int;
            max_index = index;
        }
    }

    var second_value: i32 = -1;
    for ((max_index + 1)..row_len) |index| {
        const as_int = row[index] - '0';
        if (as_int > second_value) {
            second_value = as_int;
        }
    }
    const out = max_value * 10 + second_value;
    return out;
}

fn part_two(row: []const u8) !u64 {
    var leftmost_index: usize = 0;
    const row_len = row.len;
    var list: [12]u8 = undefined;
    for (0..12) |forward| {
        const i = 11 - forward;
        const rightmost_index = row_len - i - 1;
        var max_value: u8 = 0;
        var max_index: usize = 0;
        // std.debug.print("rightmost_inde is {}\n", .{rightmost_index});
        for (leftmost_index..(rightmost_index + 1)) |j| {
            const num_val = row[j] - '0';
            if (num_val > max_value) {
                max_value = num_val;
                max_index = j;
            }
        }
        // std.debug.print("max_value is: {}, max_index is: {}\n", .{ max_value, max_index });
        list[forward] = row[max_index];
        leftmost_index = max_index + 1;
    }
    std.debug.print("output is: {any}\n", .{list});
    const number = try std.fmt.parseInt(u64, &list, 10);
    return number;
}

test "part two item 1" {
    const input: []const u8 = "987654321111111";
    const res = try part_two(input);
    std.debug.print("item 1 res: {}\n", .{res});
    try std.testing.expect(res == 987654321111);
}

test "part two item 2" {
    const input: []const u8 = "234234234234278";
    const res = try part_two(input);
    std.debug.print("item 2 res: {}\n", .{res});
    try std.testing.expect(res == 434234234278);
}

pub fn main() !void {
    std.debug.print("Starting day 3\n", .{});
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    const input = try io.readFileToLines(alloc, "src/inputs/day03.txt");
    var score: i32 = 0;
    var score2: u64 = 0;
    for (input) |row| {
        score += part_one(row);
        score2 += try part_two(row);
    }
    std.debug.print("part 1: {}\n", .{score});
    std.debug.print("part 2: {}\n", .{score2});
}
