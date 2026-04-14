module top_module(
  input [3:0] in_vector,
  output [2:0] count
);wire [2:0] c1, c2, c3;
  assign c1 = in_vector[0] ^ in_vector[1];
  assign c2 = c1 ^ in_vector[2];
  assign c3 = c2 ^ in_vector[3];
  assign count = {c3, c2, c1};

endmodule