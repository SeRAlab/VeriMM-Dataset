module top_module(in, out);input in; 
 output reg out; 
 reg tmp; 
 always @* begin 
  tmp = 1; 
  out = 1'b0; 
  case (1'b1) 
  tmp: out = in; 
  endcase 
  tmp = 0; 
 end 
 endmodule