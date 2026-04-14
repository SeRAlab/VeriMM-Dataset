module top_module(
    input wire [9:0] y,
    output wire [9:0] xor_result
);

    assign xor_result = y ^ 10'h3F3;

endmodule