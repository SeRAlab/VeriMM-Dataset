module top_module(in1, out1);parameter BITSIZE_in1=32, BITSIZE_out1=32;
  
  input [BITSIZE_in1-1:0] in1;
  
  output [BITSIZE_out1-1:0] out1;
  assign out1 = in1;endmodule