module top_module(
	input [31:0] nextPc,
	input [31:0] inst,
	output reg [31:0] jumpPc);always @(nextPc or inst) begin
		jumpPc[1:0] = 2'b00;
		jumpPc[27:2] = inst[25:0];
		jumpPc[31:28] = nextPc[31:28];
	end 
endmodule