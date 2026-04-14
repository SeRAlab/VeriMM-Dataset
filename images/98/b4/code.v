module top_module(
	input [15:0] cin,  
	input Op,          
	output reg [31:0] result  
);always @ (*)
	if (Op&&cin[15]) result=32'hffff0000|cin;
	else result=32'h0000ffff&cin;endmodule