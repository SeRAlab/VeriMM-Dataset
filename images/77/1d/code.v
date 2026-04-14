module top_module(
							  score,
							  thousands,
							  hundreds,
							  tens,
							  ones
    );input [13:0] score;
	output [3:0] thousands;
	output [3:0] hundreds;
	output [3:0] tens;
	output [3:0] ones;
	
	
	
	
	wire [9:0] thousands_rem; 
	wire [6:0] hundreds_rem; 
	wire [3:0] tens_rem; 
	
	
	
	
	assign thousands = score / 1000; 
	assign hundreds = thousands_rem / 100;
	assign tens = hundreds_rem / 10;
	
	assign thousands_rem = score % 1000;
	assign hundreds_rem = thousands_rem % 100;
	assign ones = hundreds_rem % 10;


endmodule