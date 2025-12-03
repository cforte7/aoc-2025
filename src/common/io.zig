const std = @import("std");

pub fn readFileWithSplit(alloc: std.mem.Allocator, path: []const u8, splitChar: u8) ![][]const u8 {
    const file_buf: []u8 = try std.fs.cwd().readFileAlloc(alloc, path, 18 * 1024 * 1024);
    defer alloc.free(file_buf);

    var it = std.mem.splitScalar(u8, file_buf, splitChar);
    var list = try std.ArrayList([]const u8).initCapacity(alloc, 0);

    while (it.next()) |line| {
        const copy = try alloc.dupe(u8, line);
        try list.append(alloc, std.mem.trim(u8, copy, "\n"));
    }
    return try list.toOwnedSlice(alloc);
}

pub fn readFileToLines(alloc: std.mem.Allocator, path: []const u8) ![][]u8 {
    const file_buf = try std.fs.cwd().readFileAlloc(alloc, path, 18 * 1024 * 1024);

    var line_count: usize = 0;
    for (file_buf) |c| {
        if (c == '\n') line_count += 1;
    }
    if (file_buf.len > 0 and file_buf[file_buf.len - 1] != '\n')
        line_count += 1;

    var lines = try alloc.alloc([]u8, line_count);

    var start: usize = 0;
    var idx: usize = 0;

    for (file_buf, 0..) |c, i| {
        if (c == '\n') {
            const line = file_buf[start..i];
            lines[idx] = try alloc.dupe(u8, line);
            idx += 1;
            start = i + 1;
        }
    }

    if (start < file_buf.len) {
        lines[idx] = try alloc.dupe(u8, file_buf[start..file_buf.len]);
    }

    alloc.free(file_buf);
    return lines;
}
