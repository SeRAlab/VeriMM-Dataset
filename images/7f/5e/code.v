module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] y,
    output overflow
);

    // Perform addition
    assign y = a + b;

    // Compute unsigned overflow
    assign overflow = (y < a);

endmodule