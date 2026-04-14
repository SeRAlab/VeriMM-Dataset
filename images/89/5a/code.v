module top_module (
    input [9:0] a,
    output [9:0] b
);

    // Perform left shift by 2 positions
    assign b = a << 2;

endmodule