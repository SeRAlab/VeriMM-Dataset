module top_module(input wire [1:0] x, y,input wire a, b, c, d, e,output reg o);always @* begin 
  case (x) 
  0: o = b; 
  2: o = b; 
  1: o = c; 
  default: begin 
  o = a; 
  if (y == 0) o = d; 
  if (y == 1) o = e; 
  end 
  endcase 
  end 
 endmodule