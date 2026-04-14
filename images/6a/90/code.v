module top_module(
		input [31:0]read_data1,
		input [31:0]read_data2,
		input aluSrc,		
		input memRead,		
		input branch,		
		input [19:0]immediate, 
		input [6:0] aluOp,
		input [14:0] imm_addr, 
		input [24:0] L,
		output reg [31:0]input1,
		output reg [31:0]input2
    );always @(*)
	 begin
		if ( aluSrc == 1 )
				input2 <= (immediate[19]==1)?{12'b111111111111, immediate}:{12'b0, immediate};
		else if (memRead == 1) 
			input2 <= (imm_addr[14]==1)?{17'b11111111111111111, imm_addr}:{17'b0, imm_addr};

		else if ( branch == 1) input2 <= (L[24]==1)?{7'b1111111, L}:{7'b0, L}; 
		else input2 <=  read_data2; 

		input1 <=  read_data1; 
	end

endmodule