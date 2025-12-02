const std = @import("std");

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
