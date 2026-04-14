module top_module(

	input 									Clk,
	input										Reset,
	input					[31:0]		PCIn,
	input					[2:0]			WBIn,
	input					[1:0]			MIn,
	input					[31:0]		ALUResultIn,

	input					[31:0]		MemDataIn,
	input					[4:0]			DstMuxIn,


	output	reg		[31:0]		PCOut,
	(* equivalent_register_removal = "no" *) output	reg		[2:0]			WBOut,
	(* equivalent_register_removal = "no" *) output	reg		[1:0]			MOut,
	output	reg		[31:0]		ALUResultOut,

	output	reg		[31:0]		MemDataOut,
	output	reg		[4:0]			DstMuxOut
);always @( posedge Clk or posedge Reset )
		begin
		if ( Reset )
			begin
				PCOut						 <=		32'b0;
				WBOut					 	 <= 	2'b0;
				MOut						 <=		2'b0;
				ALUResultOut		 <=		32'b0;
			
				MemDataOut			 <=		32'b0;
				DstMuxOut			 	 <=		5'b0;
			end
		else
			begin
				PCOut						 <=		PCIn;
				WBOut					 	 <= 	WBIn;
				MOut					 	 <=		MIn;
				ALUResultOut		 <=		ALUResultIn;
			
				MemDataOut			 <=		MemDataIn;
				DstMuxOut			 	 <=		DstMuxIn;
			end
		end

endmodule