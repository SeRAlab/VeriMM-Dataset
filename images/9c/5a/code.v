module top_module(
input wire		regwrite_WB,
input wire [4:0] wa_WB,
input wire [4:0]ra1_EX,
input wire [4:0]ra2_EX,
	
output wire forwardA,forwardB

);assign forwardA = ((wa_WB == ra1_EX)&(regwrite_WB)&(wa_WB != 5'b0));
assign forwardB = ((wa_WB == ra2_EX)&(regwrite_WB)&(wa_WB != 5'b0));endmodule