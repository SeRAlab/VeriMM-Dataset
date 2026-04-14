module top_module (
    input [7:0] a,
    output [7:0] y
);

    // Perform logical NOT
    assign y = ~a;

endmodule