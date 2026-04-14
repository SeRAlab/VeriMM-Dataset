module top_module(
    input [7:0] A, B,
    output [7:0] S,
    output C
);wire [8:0] temp_sum;
wire [7:0] temp_carry;

assign temp_sum = {1'b0, A} + {1'b0, B};
assign temp_carry = {temp_sum[1:0], temp_sum[3:2], temp_sum[5:4], temp_sum[7:6]} + {1'b0, temp_sum[0], temp_sum[2], temp_sum[4], temp_sum[6]};

assign S = temp_sum[7:0];
assign C = temp_carry[4];

endmodule