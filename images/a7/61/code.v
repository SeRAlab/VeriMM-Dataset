module top_module(clock_a,wren_a,address_a,data_a,clock_b,wren_b,address_b,data_b,q_a,q_b);input clock_a; 
 input wren_a; 
 input [8:0] address_a; 
 input [7:0] data_a; 
 input clock_b; 
 input wren_b; 
 input [8:0] address_b; 
 input [7:0] data_b; 
 output [7:0] q_a, 
  q_b; 
 reg [7:0] q_a, 
  q_b; 
 reg [7:0] mema [0:511]; 
 always @(posedge clock_a) if(wren_a) mema[address_a] <= data_a; 
 always @(posedge clock_a) q_a <= mema[address_a]; 
 always @(posedge clock_b) q_b <= mema[address_b]; 
 endmodule