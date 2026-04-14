module logic_circuit (
        input m,
        input n,
        input o,
        output t);

assign t = (~m & ~n & ~o) |
           (~m & n & o) |
           (m & ~n & ~o) |
           (m & n & o);

endmodule