module top_module(Sel,In1,In2,Out);input Sel;
	input[31:0] In1, In2;
	
	output[31:0] Out;
	wire[31:0] Out;

	assign Out = (Sel)?In2:In1;

endmodule