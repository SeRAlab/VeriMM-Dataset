module top_module(mult_output, mult_overflow);input [31:0] mult_output;
	output mult_overflow;
	
	
	wire[31:0] not_bits; 
	assign not_bits = ~mult_output[31:0];
	wire not_ovf;
	
	 or or1(not_ovf, &not_bits[31:0], &mult_output[31:0]);
	 not (mult_overflow, not_ovf);
	
endmodule