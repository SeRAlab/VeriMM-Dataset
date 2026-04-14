module top_module(input [11:0] in,output reg [11:0] out);always @ * begin 
  if(in[11] == 1'b1) 
  out = ~in + 12'b1; 
  else 
  out = in; 
  end 
 endmodule