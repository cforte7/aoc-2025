const io = @import("common/io.zig");
const std = @import("std");

fn part_one(input: usize) usize {
    var buffer: [20]u8 = undefined;
    const value = std.fmt.bufPrint(&buffer, "{}", .{input}) catch unreachable;
    if (value.len % 2 != 0) {
        return 0;
    }
    const half_len = value.len / 2;
    const first_half = value[0..half_len];
    const second_half = value[half_len..];
    for (0..half_len) |i| {
        if (first_half[i] != second_half[i]) {
            // not a match
            return 0;
        }
    }
    return input;
}

pub fn main() !void {
    std.debug.print("Starting day 2\n", .{});
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    const res = try io.readFileWithSplit(alloc, "src/inputs/day02.txt", ","[0]);

    var score: usize = 0;
    // var score2: usize = 0;
    for (res) |row| {
        var spliterator = std.mem.splitScalar(u8, row, "-"[0]);

        const start_number = try std.fmt.parseInt(usize, spliterator.next().?, 10);
        const end_number = try std.fmt.parseInt(usize, spliterator.next().?, 10);
        for (start_number..(end_number + 1)) |num| {
            score += part_one(num);
        }
    }
    std.debug.print("part 1: {}", .{score});
}
