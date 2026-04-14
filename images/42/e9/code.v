module top_module(data_operandA, data_operandB, data_result);input [31:0] data_operandA, data_operandB;
	output [31:0] data_result;
	
	generate

		genvar d;

		for(d = 0; d < 32; d = d + 1) begin : and_gen_var
			 and my_and(data_result[d], data_operandA[d], data_operandB[d]); 
		end

	endgenerate
	
endmodule