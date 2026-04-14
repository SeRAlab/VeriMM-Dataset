module top_module(out,in);input [15:0] in; 
  output out; 
  assign out = (^in[15:0]); 
 endmodule