module top_module(
input [7:0] bits,	
output [2:0] position,	
output active		
);wire [3:0] bits4;
wire [1:0] bits2;

assign position[2] = ~(|bits[3:0]);		
assign bits4 = position[2] ? bits[7:4] : bits[3:0];	
assign position[1] = ~(|bits4[1:0]);		
assign bits2 = position[1] ? bits4[3:2] : bits4[1:0];	
assign position[0] = ~bits2[0];
assign active = (|bits);

endmodule