module top_module(clk,OUT, ZeroFlag, In1, In2, ALUOP , shamt);input clk;
	input [31:0] In1, In2;
	input [4:0] shamt ;
	input [2:0] ALUOP;
	output [31:0] OUT;
	reg [31:0] OUT;
	output ZeroFlag;
	reg ZeroFlag;
	
	

	always @ (posedge clk)
	begin
	 ZeroFlag = (In1==In2)? 1'b1 : 1'b0 ;

		case (ALUOP)
			0 : OUT = In1 + In2; 
			1 : OUT = In1 - In2; 
			2 : OUT = In1 & In2; 
			3 : OUT = In1 | In2; 
			4 : OUT = In1 << shamt;
			5 : OUT = In1 >> shamt;
			6 : OUT = 3'bx;
			7 : OUT = In1 < In2;
		endcase

	end
endmodule