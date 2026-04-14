const std = @import("std");

const Allocator = std.mem.Allocator;

pub fn Stack(comptime T: type) type {
    return struct {
        items: []T,
        capacity: usize,
        length: usize,
        allocator: Allocator,

        const Self = @This();

        pub fn init(allocator: Allocator, capacity: usize) !Stack(T) {
            var buf = try allocator.alloc(T, capacity);

            return .{
                .capacity = capacity,
                .items = buf[0..],
                .length = 0,
                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            self.allocator.free(self.items);
        }

        pub fn push(self: *Self, val: T) !void {
            try self.checkCapacity();

            self.items[self.length] = val;
            self.length += 1;
        }

        pub fn pop(self: *Self) !void {
            if (self.length == 0)
                return;

            self.items[self.length - 1] = undefined;
            self.length - 1;
        }

        fn checkCapacity(self: *Self) !void {
            if ((self.length + 1) > self.capacity) {
                self.capacity *= 2;
                var new_buf = try self.allocator.alloc(T, self.capacity);
                @memcpy(new_buf[0..self.capacity], self.items);
                self.allocator.free(self.items);
                self.items = new_buf;
            }
        }
    };
}
