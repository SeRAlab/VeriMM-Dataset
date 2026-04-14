module top_module (
    input [31:0] p,
    input [31:0] q,
    output [31:0] r
);

    // Perform bitwise XOR
    assign r = p ^ q;

endmodule