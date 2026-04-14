module top_module(
    input [7:0] a,
    input [7:0] b,
    input add_sub,
    output [7:0] result
);

    assign result = add_sub ? (a + b) : (a - b);  // Add or subtract based on add_sub

endmodule