const io = @import("common/io.zig");
const std = @import("std");


fn parse_data (input: [][]u8) {
    for 
}

pub fn main() !void {
    std.debug.print("Starting day 5\n", .{});
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    const res = io.readFileToLines(alloc, "src/inputs/day05.txt") catch |err| {
        std.debug.print("Error: {}\n", .{err});
        return;
    };
    var pos: i32 = 50;
    var part_one_score: i32 = 0;
    var part_two_score: u32 = 0;
    part_two_score += 1;
    var LRMult: i32 = 1;
    std.debug.print("part one score: {}\n", .{part_one_score});
    std.debug.print("part two score: {}\n", .{part_two_score});
}
