module top_module(in0, in1, select, out);parameter WIDTH = 6;   		
  input [WIDTH - 1:0] in1;      
  input [WIDTH - 1:0] in0;		
  input select;
  output [WIDTH - 1:0] out;
  
  assign out = select ? in1 : in0;   
endmodule