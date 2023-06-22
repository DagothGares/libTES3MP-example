const std = @import("std");

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addSharedLibrary(.{
        .name = "libTES3MP-example",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    
    lib.addLibraryPath(thisDir() ++ "/libs");
    
    switch(optimize)  {
        .ReleaseFast, .ReleaseSmall => lib.strip = true,
        else => {},
    }

    b.installArtifact(lib);
}
