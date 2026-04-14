module top_module(
  input [3:0] a,
  input [3:0] b,
  output [3:0] result
);wire [3:0] and_result;
  
  assign and_result[0] = a[0] & b[0];
  assign and_result[1] = a[1] & b[1];
  assign and_result[2] = a[2] & b[2];
  assign and_result[3] = a[3] & b[3];
  
  assign result = and_result;

endmodule