const io = @import("common/io.zig");
const std = @import("std");

const directions = [_][2]i32{
    .{ -1, -1 },
    .{ -1, 0 },
    .{ -1, 1 },
    .{ 0, -1 },
    .{ 0, 1 },
    .{ 1, -1 },
    .{ 1, 0 },
    .{ 1, 1 },
};

fn is_in_bounds(row_len: i32, col_len: i32, row: i32, col: i32) bool {
    if (row < row_len and col < col_len and row >= 0 and col >= 0) {
        return true;
    }
    return false;
}

const RemoveableResult = struct { is_removeable: bool, to_check: std.ArrayList([2]i32) };
fn is_removeable(grid: [][]u8, row: usize, col: usize, alloc: std.mem.Allocator) !RemoveableResult {
    if (grid[row][col] != "@"[0]) {
        return .{ .is_removeable = false, .to_check = .{} };
    }
    const row_len = grid[0].len;
    const col_len = grid.len;
    var adj_count: i8 = 0;
    var list = try std.ArrayList([2]i32).initCapacity(alloc, 0);

    for (directions) |dirs| {
        const row_check = @as(i32, @intCast(row)) + dirs[0];
        const col_check = @as(i32, @intCast(col)) + dirs[1];
        const valid = is_in_bounds(@as(i32, @intCast(row_len)), @as(i32, @intCast(col_len)), row_check, col_check);
        if (valid and grid[@as(usize, @intCast(row_check))][@as(usize, @intCast(col_check))] == "@"[0]) {
            try list.append(alloc, .{ row_check, col_check });
            adj_count += 1;
        }
    }
    if (adj_count < 4) {
        return .{ .is_removeable = true, .to_check = list };
    }
    return .{ .is_removeable = false, .to_check = .{} };
}

fn part_one(grid: [][]u8, alloc: std.mem.Allocator) !i32 {
    const row_len = grid[0].len;
    const col_len = grid.len;
    var score: i32 = 0;

    for (0..col_len) |col| {
        for (0..row_len) |row| {
            if (grid[row][col] != "@"[0]) {
                continue;
            }
            const rem_res = try is_removeable(grid, row, col, alloc);
            if (rem_res.is_removeable) {
                score += 1;
            }
        }
    }
    return score;
}
fn print_grid(grid: [][]u8) void {
    const row_len = grid[0].len;
    const col_len = grid.len;

    for (0..col_len) |col| {
        for (0..row_len) |row| {
            std.debug.print("{c}", .{grid[col][row]});
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("\n", .{});
    std.debug.print("\n", .{});
}
fn part_two(grid: [][]u8, allocator: std.mem.Allocator) !i32 {
    var to_recheck = try std.ArrayList([2]i32).initCapacity(allocator, 0);
    const row_len = grid[0].len;
    const col_len = grid.len;
    var score: i32 = 0;

    for (0..col_len) |col| {
        for (0..row_len) |row| {
            if (grid[row][col] != "@"[0]) {
                continue;
            }
            const remove_result = try is_removeable(grid, row, col, allocator);
            if (remove_result.is_removeable) {
                for (remove_result.to_check.items) |c| {
                    try to_recheck.append(allocator, c);
                }
                grid[row][col] = '.';
                score += 1;
            }
        }
    }

    while (to_recheck.items.len > 0) {
        const next = to_recheck.pop() orelse break;
        const next_row = @as(usize, @intCast(next[0]));
        const next_col = @as(usize, @intCast(next[1]));
        const res = try is_removeable(grid, next_row, next_col, allocator);
        if (res.is_removeable) {
            for (res.to_check.items) |c| {
                try to_recheck.append(allocator, c);
            }
            grid[next_row][next_col] = '.';
            score += 1;
        }
    }

    return score;
}

pub fn main() !void {
    std.debug.print("Starting day 4\n", .{});
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    const input = try io.readFileToLines(alloc, "src/inputs/day04.txt");
    const score: i32 = try part_one(input, alloc);
    const score2: i32 = try part_two(input, alloc);
    // var score2: u64 = 0;
    // for (input) |row| {
    // score += part_one(row);
    // score2 += try part_two(row);
    // }
    std.debug.print("part 1: {}\n", .{score});
    std.debug.print("part 2: {}\n", .{score2});

    // std.debug.print("part 2: {}\n", .{score2});
}
