module combinational_logic (
        input u,
        input v,
        input w,
        output x);

assign x = (~u & v & ~w) |
           (~u & ~v & w) |
           (u & ~v & ~w) |
           (u & v & w);

endmodule