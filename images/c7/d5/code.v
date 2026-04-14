module bin_to_two_bit(input [3:0] in, output [1:0] out);
	
	wire [1:0] in_2bit;
	
	assign in_2bit[0] = in[1] | in[3];
	assign in_2bit[1] = in[2] | in[3];
	
	assign out = in_2bit;
	
endmodule