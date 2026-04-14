module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] y,
    output b_out
);

    // Perform subtraction
    assign {b_out, y} = a - b;

endmodule