module ripple_carry_adder (
	input [3:0] a,
	input [3:0] b,
	output [3:0] sum,
	output cout);assign {cout, sum} = a + b;
	
endmodule