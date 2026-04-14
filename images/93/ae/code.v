module top_module(
  input [3:0] in_vector,
  output [3:0] out_vector,
  output o0,
  output o1,
  output o2,
  output o3
);assign o0 = in_vector[0];
  assign o1 = in_vector[1];
  assign o2 = in_vector[2];
  assign o3 = in_vector[3];
  
  assign out_vector = in_vector;

endmodule