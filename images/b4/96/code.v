module top_module(
		output sum,
		output carry,
		input bit_A,
		input bit_B
    );assign sum = bit_A ^ bit_B;
	assign carry = bit_A & bit_B;
	
endmodule