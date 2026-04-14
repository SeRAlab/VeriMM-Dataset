module top_module(
    input [15:0] A,
    input [15:0] B,
    input C_in,
    output [15:0] S,
    output C_out
);wire [16:0] temp_sum;

assign temp_sum = {1'b0, A} + {1'b0, B} + {C_in};

assign S = temp_sum[15:0];
assign C_out = temp_sum[16];

endmodule