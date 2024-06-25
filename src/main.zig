









const std = @import("std");

const Elem = struct {
    value: u32,
    key: u32,
    is_used: bool,
};
    
const capacity: usize = 32;
var val: [capacity]Elem = undefined;

pub fn hash(n: u32) usize {
    return (n * 10 + 3) / 2;
}

pub fn insert(key: u32, value: u32) void {
    var index: usize = hash(key)%capacity;
    while(val[index].is_used == true) {
        if(index > capacity) index = 0;
        index += 1;
    }
    val[index] = Elem {
        .value = value,
        .key = key,
        .is_used = true,
    };
}

pub fn get(key: u32) u32 {
    for(0..capacity) |i| {
        if(val[i].key == key) return val[i].value;
    }
    return 1;
}

pub fn main() !void {
    insert(15, 32);
    std.debug.print("Hello, world! {d}\n", .{get(11)});
}
