module top_module (
    input [15:0] b,
    output [15:0] z
);

    // Perform right shift
    assign z = b >> 2;

endmodule