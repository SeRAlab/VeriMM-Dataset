module top_module( data_in,data_out,we,clk);parameter WIDTH = 8; 
 input [WIDTH-1:0] data_in; 
 input we; 
 input clk; 
 output [WIDTH-1:0] data_out; 
 reg [WIDTH-1:0] data_out; 
 always @ (posedge clk) 
 begin 
  if (we) 
  data_out<=#1 data_in; 
 end 
 endmodule