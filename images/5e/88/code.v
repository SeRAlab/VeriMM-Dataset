module top_module (
    input [7:0] a,
    output [7:0] y
);

    // Perform right shift
    assign y = a >> 1;

endmodule