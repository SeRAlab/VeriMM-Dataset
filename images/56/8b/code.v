module top_module(input wire [1:0] s,input wire a, b, c, d,output reg [3:0] o);always @* begin 
  o = {4{a}}; 
  if (s == 0) o = {3{b}}; 
  if (s == 1) o = {2{c}}; 
  if (s == 2) o = d; 
  end 
 endmodule