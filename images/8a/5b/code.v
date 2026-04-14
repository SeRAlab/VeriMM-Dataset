module top_module (
    input [31:0] a,
    input [31:0] b,
    output [31:0] y
);

    // Perform bitwise OR
    assign y = a | b;

endmodule