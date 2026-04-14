module top_module (
    input [15:0] a,
    input [15:0] b,
    output [15:0] y
);

    // Perform bitwise XNOR
    assign y = ~(a ^ b);

endmodule