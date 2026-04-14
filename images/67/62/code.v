module top_module (
    input [11:0] p,
    input [11:0] q,
    output [11:0] r
);

    // Perform bitwise NAND
    assign r = ~(p & q);

endmodule