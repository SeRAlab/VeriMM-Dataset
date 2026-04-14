module top_module(instructionIn25_0, instructionOut27_0);input [25:0] instructionIn25_0;
	output reg[27:0] instructionOut27_0;

always@(*)
	begin
		instructionOut27_0[27:2] = instructionIn25_0;
		instructionOut27_0[1:0] = 2'b00;
	end
endmodule