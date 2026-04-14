module top_module(
    input [3:0] in,
    output reg count
);wire [1:0] sum;
    assign sum[0] = in[0] ^ in[1];
    assign sum[1] = sum[0] ^ in[2];
    assign count = sum[1] ^ in[3];

endmodule