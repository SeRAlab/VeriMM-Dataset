module top_module (
    input [3:0] p,
    input [3:0] q,
    output [3:0] r
);

    // Perform bitwise AND
    assign r = p & q;

endmodule