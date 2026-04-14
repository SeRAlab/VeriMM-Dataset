module top_module (
    input [3:0] a,
    output [3:0] y
);

    // Perform bitwise NOT
    assign y = ~a;

endmodule