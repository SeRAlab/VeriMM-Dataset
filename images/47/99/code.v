module top_module(
  input [n-1:0] in,
  input [log2_n-1:0] ctrl,
  output [n-1:0] out
);parameter n = 8; // number of bits in the binary number
parameter log2_n = 3; // number of control signals required

assign out = (ctrl >= 0) ? (in << ctrl) : (in >> -ctrl);

endmodule