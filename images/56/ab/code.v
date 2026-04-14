module top_module(clock, counter);input clock; 
 output reg [7:0] counter; 
 always @(posedge clock) 
  counter <= counter + 1; 
 endmodule