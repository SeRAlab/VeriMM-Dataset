module top_module(
   input 			CLK_I, RST_I,
	input [31:0] 	DAT_I,					
	input 			WE_I, STB_I, CYC_I,
	output			ACK_O,
	
	output [31:0]	DAT_O,				
	output			CYC_O, STB_O,
	output 			WE_O,
	input				ACK_I	
    );assign DAT_O = DAT_I;
assign WE_O  = WE_I;
assign STB_O = STB_I;
assign CYC_O = CYC_I;
assign ACK_O = ACK_I;
endmodule