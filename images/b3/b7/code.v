module top_module(
	input [9:0] signals,
	 output RegDst, ALUsrc, RegWrite, MemRead, MemWrite, MemToReg, Branch, Jump,
	output [1:0] size_in
);assign RegDst   = signals[9];
assign ALUsrc   = signals[8];
assign RegWrite = signals[7];
assign MemRead  = signals[6];
assign MemWrite = signals[5];
assign MemToReg = signals[4];
assign Branch   = signals[3];
assign Jump 	 = signals[2];
assign size_in  = signals[1:0];

endmodule