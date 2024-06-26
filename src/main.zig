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
    
const Map = struct {
    capacity: usize,    
    pub var val: std.ArrayList(Elem) = undefined;
    pub var map_s: usize = 0;
    
    pub fn hash(n: [*:0]const u8) usize {
        var result: usize = 0;
        for (0..std.mem.len(n)) |i| {
            result += n[i] + 10 * 3;
        }
        return result;
    }
    
    pub fn insert(self: Map, key: [*:0]const u8, value: u32) !void {
        if (map_s >= self.capacity) return InsertError.MapFull;
        var index: usize = hash(key) % self.capacity;
        while (val.items[index].is_used) {
            if (index > self.capacity) index = 0;
            index += 1;
        }
        try val.append(undefined);
        val.items[index] = Elem{
            .value = value,
            .key = key,
            .is_used = true,
        };
        map_s += 1;
    }
    
    pub fn get(self: Map, key: [*:0]const u8) !u32 {
        for (0..self.capacity) |i| {
            if (val.items[i].key == key) return val.items[i].value;
        }
        return GetError.KeyNotFound;
    }
        
    pub fn init() !Map {
        const allocator = std.heap.page_allocator;        
        map_s = 0;
        val = std.ArrayList(Elem).init(allocator);
        val.items = try val.addManyAsArray(32);
        return Map{.capacity = 32};
    }
};

pub fn main() !void {
    var map: Map = try Map.init();
    try map.insert("test", 32);
    try map.insert("test1", 16);
    try map.insert("test2", 8);
    try map.insert("test3", 2);
    const result: u32 = try map.get("test2");
    std.debug.print("Hello, world! {d}\n", .{result});
}
