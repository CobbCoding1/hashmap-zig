const std = @import("std");

const InsertError = error {
    MapFull,
};
    
const GetError = error {
    KeyNotFound,
};

const Elem = struct {
    value: u32,
    key: u32,
    is_used: bool,
};
    
const capacity: usize = 32;
var val: [capacity]Elem = undefined;
var map_s: usize = 0;

pub fn hash(n: u32) usize {
    return (n * 10 + 3) / 2;
}

pub fn insert(key: u32, value: u32) !void {
    if(map_s == capacity) return InsertError.MapFull;
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
    map_s += 1;
}

pub fn get(key: u32) !u32 {
    for(0..capacity) |i| {
        if(val[i].key == key) return val[i].value;
    }
    return GetError.KeyNotFound;
}

pub fn main() !void {
    try insert(15, 32);
    try insert(32, 16);        
    try insert(12, 8);    
    try insert(11, 2);        
    const result: u32 = try get(15);
    std.debug.print("Hello, world! {d}\n", .{result});
}
