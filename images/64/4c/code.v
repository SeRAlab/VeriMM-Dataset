module binary_decoder(
	input [1:0] binary_in,
	output [3:0] one_hot_out
);

	assign one_hot_out = (binary_in == 2'b00) ? 4'b0001 :
						 (binary_in == 2'b01) ? 4'b0010 :
						 (binary_in == 2'b10) ? 4'b0100 :
						 (binary_in == 2'b11) ? 4'b1000 : 4'b0000;
	
endmodule