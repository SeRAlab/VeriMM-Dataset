module top_module(in1, in2, out1);parameter BITSIZE_in1=32, BITSIZE_in2=32, BITSIZE_out1=1;
  
  input signed [BITSIZE_in1-1:0] in1;
  input signed [BITSIZE_in2-1:0] in2;
  
  output [BITSIZE_out1-1:0] out1;
  assign out1 = in1 < in2;endmodule