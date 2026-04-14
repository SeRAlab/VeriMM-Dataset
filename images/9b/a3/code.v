module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] y,
    output c_out
);

    // Perform addition
    assign {c_out, y} = a + b;

endmodule