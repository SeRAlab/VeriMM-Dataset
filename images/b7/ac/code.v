module top_module(xin, yin, sel, out);parameter k = 16 ;
  input [k-1:0] xin, yin; 
  input sel;
  output[k-1:0] out ;
  
  assign out = sel ? xin : yin;endmodule