module top_module(
	input [31:0] Instruction,
	output reg RegWrite,
	output reg MUXsel1,
	output reg [5:0] RS,
	output reg [5:0] RD,
	output reg [3:0] ALUopsel,
	output reg [5:0] RT,
	output reg [14:0] Immediate
	);always @(*)
	begin
		RegWrite = 0;
		if (Instruction != 32'd0) begin
			RegWrite = 1;
			MUXsel1 = Instruction[31:31];
			RS = Instruction[30:25];
			RD = Instruction[24:19];
			ALUopsel = Instruction[18:15];
			RT = Instruction[14:9];
			Immediate = Instruction[14:0];
			if (ALUopsel == 4'b1011 || ALUopsel == 4'b1001) begin
				RT = RS[5:0];
				RS = RD[5:0];
			end
		end else begin
			
			MUXsel1 = 0;
			RS = 6'd63;
			ALUopsel = 4'b0001;
			RT = 6'd63;
		end
	end

endmodule