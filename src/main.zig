const std = @import("std");

const InsertError = error{
    MapFull,
};

const GetError = error{
    KeyNotFound,
};

const Elem = struct {
    value: u32,
    key: [*:0]const u8,
    is_used: bool,
};

const capacity: usize = 32;
var val: [capacity]Elem = undefined;
var map_s: usize = 0;

pub fn hash(n: [*:0]const u8) usize {
    var result: usize = 0;
    for (0..std.mem.len(n)) |i| {
        result += n[i] + 10 * 3;
    }
    return result;
}

pub fn insert(key: [*:0]const u8, value: u32) !void {
    if (map_s == capacity) return InsertError.MapFull;
    var index: usize = hash(key) % capacity;
    while (val[index].is_used == true) {
        if (index > capacity) index = 0;
        index += 1;
    }
    val[index] = Elem{
        .value = value,
        .key = key,
        .is_used = true,
    };
    map_s += 1;
}

pub fn get(key: [*:0]const u8) !u32 {
    for (0..capacity) |i| {
        if (val[i].key == key) return val[i].value;
    }
    return GetError.KeyNotFound;
}

pub fn main() !void {
    try insert("test", 32);
    try insert("test1", 16);
    try insert("test2", 8);
    try insert("test3", 2);
    const result: u32 = try get("test3");
    std.debug.print("Hello, world! {d}\n", .{result});
}
