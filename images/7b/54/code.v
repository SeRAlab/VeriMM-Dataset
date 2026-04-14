module top_module(
    input wire [5:0] g,
    output wire [5:0] xor_result
);

    assign xor_result = g ^ 6'h1F;

endmodule