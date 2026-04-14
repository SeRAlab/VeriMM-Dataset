module bit_check (
	input [13:0] signal,
	output [12:0] and_result,
	output [13:1] or_result,
	output [13:0] xor_result);assign and_result = signal & signal[13:1];
assign or_result = signal | signal[13:1];
assign xor_result = signal^{signal[0], signal[13:1]};

endmodule