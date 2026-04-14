module ripple_carry_adder (
	input [3:0] a,
	input [3:0] b,
	output [4:0] sum);

	wire c1, c2, c3;

	full_adder fa0 (a[0], b[0], 1'b0, sum[0], c1);
	full_adder fa1 (a[1], b[1], c1, sum[1], c2);
	full_adder fa2 (a[2], b[2], c2, sum[2], c3);
	full_adder fa3 (a[3], b[3], c3, sum[3], sum[4]);
endmodule

module full_adder (
	input a, b, cin,
	output sum, cout);

	assign {cout, sum} = a + b + cin;
endmodule