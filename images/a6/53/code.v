module top_module (
    input [15:0] a,
    input [15:0] b,
    output [15:0] y
);

    // Perform subtraction
    assign y = a - b;

endmodule