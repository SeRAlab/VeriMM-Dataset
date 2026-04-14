module add_4bit (
	input [3:0] a,
	input [3:0] b,
	output [4:0] sum,
	output carry_out
);

	wire [3:0] sum_4bit;
	wire carry_out_4bit;

	// perform the addition
	assign sum_4bit = a + b;

	// check for carry-out
	assign carry_out_4bit = (sum_4bit[4] == 1);

	// pad the sum with a leading zero
	assign sum = {1'b0, sum_4bit};

	// output the results
	assign carry_out = carry_out_4bit;

endmodule