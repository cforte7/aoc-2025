const std = @import("std");
pub fn main() !void {
    const spins = @divFloor(-10, 100);
    std.debug.print("value: {}\n", .{spins});
}
