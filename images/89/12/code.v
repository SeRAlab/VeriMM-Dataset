module top_module(input[3:0] in, input clk , input ld, output[3:0] out);reg[3:0] q; 
  always @(posedge clk) 
  if(ld) 
  q = in; 
  assign out = q; 
 endmodule