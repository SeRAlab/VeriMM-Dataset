module logic_design (
        input i,
        input j,
        input k,
        output l);

assign l = (~i & ~j & k) |
           (~i & j & k) |
           (i & ~j & k) |
           (i & j & k);

endmodule