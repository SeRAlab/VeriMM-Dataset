module top_module(
    output signed [33:0] fma,
    input signed [33:0] a,
    input signed [33:0] b,
    input signed [33:0] c
    );wire [64:0] temp;
reg [33:0] fma_r;
assign temp = b * c;
assign fma = a + temp[64:31];endmodule