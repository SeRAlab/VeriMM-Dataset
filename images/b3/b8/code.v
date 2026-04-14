module top_module(
  input [n-1:0] in1,
  input [n-1:0] in2,
  output [n-1:0] out_AND,
  output [n-1:0] out_OR,
  output [n-1:0] out_XOR,
  output [n-1:0] out_NOT
);parameter n = 8; // number of input bits

assign out_AND = in1 & in2;
assign out_OR = in1 | in2;
assign out_XOR = in1 ^ in2;
assign out_NOT = ~in1;

endmodule