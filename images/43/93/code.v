module top_module(clock, out);input clock; 
  output reg [31:0]out; 
  always @(posedge clock) 
  out <= out + 1'b1; 
 endmodule