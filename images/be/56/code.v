module top_module(
	input [63:0] PC_sum1,
	output reg [63:0] PC_sum2,
	input [63:0] ALUResult1,
	output reg [63:0] ALUResult2,
	input [63:0] ReadData2in,
	output reg [63:0] ReadData2out,
	input clk,
	input reset,
	input Branch1, MemRead1, MemtoReg1, MemWrite1, RegWrite1, Zero1,
	output reg Branch2, MemRead2, MemtoReg2, MemWrite2, RegWrite2, Zero2,
	input [4:0] Rd1,
	output reg [4:0] Rd2
);always@(posedge clk)
	begin
		if(reset == 1'b0)
		begin
		PC_sum2 <= PC_sum1;
		ALUResult2 <= ALUResult1;
		ReadData2out <= ReadData2in;
		Branch2 <= Branch1;
		MemtoReg2 <= MemtoReg1;
		MemWrite2 <= MemWrite1;
		MemRead2 <= MemRead1;
		RegWrite2 <= RegWrite1;
		Rd2 <= Rd1;
		Zero2 <= Zero1;
		end
	end
	
	always@(reset)
	begin
		if(reset == 1'b1)
		begin
			PC_sum2 <= 0;
			ALUResult2 <= 0;
			ReadData2out <= 0;
			Branch2 <= 0;
			MemtoReg2 <= 0;
			MemWrite2 <= 0;
			MemRead2 <= 0;
			RegWrite2 <= 0;
			Rd2 <= 0;
			Zero2 <= 0;
		end
	end
	
endmodule