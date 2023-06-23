const std = @import("std");

extern "libTES3MP-core" fn impl_LogMessage(c_int, ?[*:0]const u8) void;

extern "libTES3MP-core" fn bind_OnServerPostInit(*const fn () callconv(.C) u8) callconv(.C) void;

export fn sayHello() callconv(.C) u8 {
    impl_LogMessage(1, "Hello from the example DLL!");
    
    return 3;
}

export fn libmain() callconv(.C) void {
    bind_OnServerPostInit(&sayHello);
}

comptime {
    std.testing.refAllDecls(@This());
}