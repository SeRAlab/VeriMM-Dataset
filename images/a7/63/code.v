module top_module(in1, in2, enable, out);input [3:0] in1;
  input [3:0] in2;
  input enable;
  output [3:0] out;
  
  wire [3:0] result;
  
  assign result = in1 * in2; // multiply the two input vectors
  
  assign out = enable ? result : 4'b0; // output the result if enable is high, otherwise output 0
  
endmodule