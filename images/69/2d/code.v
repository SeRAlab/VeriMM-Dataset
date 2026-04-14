module top_module(
  input [n-1:0] in1,
  input [n-1:0] in2,
  output eq,
  output gt,
  output lt
);parameter n = 8; // number of bits in input signals

wire [n-1:0] xor_out;
wire [n-1:0] and_out1;
wire [n-1:0] and_out2;

assign xor_out = in1 ^ in2;
assign and_out1 = in1 & xor_out;
assign and_out2 = in2 & xor_out;

assign eq = ~|xor_out;
assign gt = |and_out1;
assign lt = |and_out2;

endmodule