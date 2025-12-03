const io = @import("common/io.zig");
const std = @import("std");

pub fn main() !void {
    std.debug.print("Starting day 1\n", .{});
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    const res = io.readFileToLines(alloc, "src/inputs/day01.txt") catch |err| {
        std.debug.print("Error: {}\n", .{err});
        return;
    };
    var pos: i32 = 50;
    var part_one_score: i32 = 0;
    var part_two_score: u32 = 0;
    var LRMult: i32 = 1;
    for (res) |c| {
        if (c[0] == "L"[0]) {
            LRMult = -1;
        } else {
            LRMult = 1;
        }
        const move = try std.fmt.parseInt(i32, c[1..], 10);
        const move_with_dir = move * LRMult;
        const new_pos: i32 = pos + move_with_dir;
        const full_turns = @abs(@divTrunc(move * LRMult, 100));
        part_two_score += full_turns;
        const remainder = @rem(move_with_dir, 100);
        if (pos + remainder >= 100 or pos > 0 and (pos + remainder) <= 0) {
            part_two_score += 1;
        }
        pos = @mod(new_pos, 100);

        if (pos == 0) {
            part_one_score += 1;
        }
    }
    std.debug.print("part one score: {}\n", .{part_one_score});
    std.debug.print("part two score: {}\n", .{part_two_score});
}
