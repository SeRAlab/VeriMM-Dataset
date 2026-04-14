module top_module(
	x_in,
	x_out
);parameter no_of_digits = 4;
	parameter radix_bits = 3;
	parameter radix = 4;
	
	input [no_of_digits*radix_bits-1:0] x_in;
	output reg [no_of_digits*radix_bits-1:0] x_out;
	
	genvar i;
	
	generate
	for (i=0; i<no_of_digits; i=i+1)
	begin : loop_gen_block_1
		always @ (x_in)
		begin : alway_block
			integer temp;
			temp = $signed(x_in[(i+1)*radix_bits-1:i*radix_bits]);
			x_out[(i+1)*radix_bits-1:i*radix_bits] = -temp;
		end
	end
	endgenerate
	
endmodule