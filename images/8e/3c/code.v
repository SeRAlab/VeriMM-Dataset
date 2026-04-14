module top_module(
		
		
		input[31:0] leftOperand,
		
		
		input[31:0] rightOperand,
		
		
		output[31:0] result

	);assign result = leftOperand * rightOperand;

endmodule