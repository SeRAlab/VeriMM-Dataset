module top_module (
    input [7:0] h,
    input [7:0] i,
    output [7:0] j
);

    // Perform subtraction
    assign j = h - i;

endmodule