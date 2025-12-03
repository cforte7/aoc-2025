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

    if (compare_slices(first_half, second_half)) {
        return input;
    }
    return 0;
}
fn compare_slices(s1: []const u8, s2: []const u8) bool {
    for (0..(s1.len)) |i| {
        if (s1[i] != s2[i]) {
            return false;
        }
    }
    return true;
}

fn compare_chunks(sample: []const u8, value: []const u8, size: usize) bool {
    for (1..(value.len / size)) |chunk| {
        const start_index = chunk * size;
        const end_index = chunk * size + size;
        const current_chunk = value[start_index..end_index];
        const is_match = compare_slices(sample, current_chunk);
        if (!is_match) {
            return false;
        }
    }
    return true;
}

fn part_two(input: usize) usize {
    var buffer: [20]u8 = undefined;
    const value = std.fmt.bufPrint(&buffer, "{}", .{input}) catch unreachable;

    if (value.len == 1) {
        return 0;
    }
    const half_len = value.len / 2;
    for (1..(half_len + 1)) |size| {
        // if we cant evenly divide by our size, there will never be a match
        if (value.len % size != 0) {
            continue;
        }

        const sample = value[0..size];
        const is_good = compare_chunks(sample, value, size);
        if (is_good) {
            return input;
        }
    }
    return 0;
}

test "part two works" {
    const result = part_two(1010);
    try std.testing.expect(result == 1010);
}
pub fn main() !void {
    std.debug.print("Starting day 2\n", .{});
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    const res = try io.readFileWithSplit(alloc, "src/inputs/day02.txt", ","[0]);
    var score: usize = 0;
    var score2: usize = 0;
    for (res) |row| {
        var spliterator = std.mem.splitScalar(u8, row, "-"[0]);
        const start_number = try std.fmt.parseInt(usize, spliterator.next().?, 10);
        const end_number = try std.fmt.parseInt(usize, spliterator.next().?, 10);
        for (start_number..(end_number + 1)) |num| {
            score += part_one(num);
            score2 += part_two(num);
        }
    }
    std.debug.print("part 1: {}\npart 2: {}\n", .{ score, score2 });
}
