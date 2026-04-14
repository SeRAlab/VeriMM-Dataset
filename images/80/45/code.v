module top_module (
    input [7:0] a,
    output [7:0] y
);

    // Perform right shift by 2 bits
    assign y = a >> 2;

endmodule