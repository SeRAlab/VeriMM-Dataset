module top_module(clk, rst, ena, state);input clk, rst, ena; 
  output [14:0] state; 
  reg [14:0] state; 
  always @(posedge rst or posedge clk) begin 
  if (rst == 1) begin 
  state <= 1; 
  end else if (ena) begin 
  state[14:1] <= state[13:0]; 
  state[0] <= state[13] ^ state[14]; 
  end 
  end 
 endmodule