module top_module(input wire clock,input wire [7:0] val_a, val_b,output reg [3:0] distance);wire [7:0] bit_diff; 
 assign bit_diff = val_a ^ val_b; 
 always @(posedge clock) begin 
  distance = bit_diff[0] + bit_diff[1] + bit_diff[2] + bit_diff[3] 
  + bit_diff[4] + bit_diff[5] + bit_diff[6] + bit_diff[7]; 
 end 
 endmodule