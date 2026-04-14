module top_module(
  input [3:0] a,
  input [3:0] b,
  input cin,
  input sel,
  output [3:0] sum,
  output cout
);wire [3:0] and_out;
wire [3:0] xor_out;
wire [3:0] and_not_out;
wire [3:0] and_sel_out;
wire [3:0] or_sel_out;

assign and_out = a & b;
assign xor_out = a ^ b;
assign and_not_out = and_out & ~sel;
assign and_sel_out = and_out & sel;
assign or_sel_out = and_not_out | and_sel_out;

assign sum = xor_out ^ cin;
assign cout = or_sel_out[3];

assign sum[3] = or_sel_out[2];
assign sum[2] = or_sel_out[1];
assign sum[1] = or_sel_out[0];
assign sum[0] = xor_out[0] ^ cin;

endmodule