module top_module (
    input [7:0] a,
    output [7:0] y
);

    // Invert all bits
    assign y = ~a;

endmodule