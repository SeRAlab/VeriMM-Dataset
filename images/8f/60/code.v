module top_module(
			input [31:0] opCode,dirReg,dirJump,
			output reg [31:0] dir
    );always @*
	begin
		if((opCode[31:26] == 6'b000000) && (opCode[5:0] == 6'b001000))
			dir = dirReg;
		else
			dir = dirJump;
		end
endmodule