module combinational_function (
        input i,
        input j,
        input k,
        output m);

assign m = (~i & j & ~k) |
           (~i & ~j & k) |
           (i & ~j & ~k) |
           (i & j & k);

endmodule