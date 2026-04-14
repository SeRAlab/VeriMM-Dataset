module top_module(input clk,input reset,input load_incr,input [4:0] upc_next,output reg [4:0] upc);always @ (posedge clk, posedge reset) 
  if (reset) upc <= 5'b00000; 
  else if (load_incr) upc <= upc_next; 
  else if (~load_incr) upc <= upc + 1; 
  else upc <= 5'b00000; 
 endmodule