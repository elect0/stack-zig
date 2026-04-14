const std = @import("std");
const Io = std.Io;

const Stack = @import("stack_generic.zig");

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    const Stacki32 = Stack.Stack(i32);

    var stack = try Stacki32.init(allocator, 16);
    defer stack.deinit();

    try stack.push(1);
    try stack.push(2);
    try stack.push(4);
    try stack.push(8);
    try stack.push(16);
    try stack.push(32);

    std.debug.print("Stack Length: {d}\n", .{stack.length});
    std.debug.print("Stack Capacity: {d}\n", .{stack.capacity});

    for (0..stack.length) |i| {
        std.debug.print("Number: {d}\n", .{stack.items[i]});
    }
}
