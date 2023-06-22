const std = @import("std");

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    
    const libTES3MP = b.addSharedLibrary(.{
        .name = "libTES3MP-core",
        .root_source_file = .{ .path = "lib/libTES3MP-core/src/main.zig" },
        .target = target,
        .optimize = .ReleaseFast, // libTES3MP currently cannot be run in other release modes.
    });
    // Since libTES3MP uses ReleaseFast, there's no need to keep debug info.
    libTES3MP.strip = true;
    libTES3MP.override_dest_dir = .{
        .custom = "deps",
    };
    b.installArtifact(libTES3MP);

    const lib = b.addSharedLibrary(.{
        .name = "libTES3MP-example",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    lib.addLibraryPath(thisDir() ++ "/zig-out/deps");
    lib.linkSystemLibrary("libTES3MP-core");
    
    switch(optimize)  {
        .ReleaseFast, .ReleaseSmall => lib.strip = true,
        else => {},
    }

    b.installArtifact(lib);
}
