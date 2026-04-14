module top_module (
    input [7:0] a,
    output [7:0] y
);

    // Perform left shift by 3 bits
    assign y = a << 3;

endmodule