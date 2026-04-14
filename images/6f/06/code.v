module top_module (
    input [9:0] a,
    output [9:0] y
);

    // Perform bitwise NOT
    assign y = ~a;

endmodule