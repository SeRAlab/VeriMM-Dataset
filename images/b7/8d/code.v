module subtractor3bit(
    input [2:0] a,
    input [2:0] b,
    output [2:0] difference,
    output borrow_out
);assign {borrow_out, difference} = a - b;

endmodule