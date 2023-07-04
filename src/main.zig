const std = @import("std");

extern "libTES3MP-core" fn libtes3mp_LogMessage(c_int, ?[*:0]const u8) void;

extern "libTES3MP-core" fn libtes3mp_bind_OnServerPostInit(*const fn () callconv(.C) u8) callconv(.C) void;

export fn sayHello() callconv(.C) u8 {
    libtes3mp_LogMessage(1, "Hello from the example DLL!");

    return 3;
}

export fn libmain() callconv(.C) void {
    libtes3mp_bind_OnServerPostInit(&sayHello);
}

comptime {
    std.testing.refAllDecls(@This());
}
