module top_module(IN,OUT);input signed [7:0] IN;
	output signed [7:0] OUT;

	assign OUT[7:0] =-IN[7:0];endmodule