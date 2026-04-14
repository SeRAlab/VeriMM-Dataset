module top_module(
	input	[3:0]	d,
	input	[3:0]	t,
	input			cin,
	output	[2:0]	cout,
	output			D,
	output			T
);assign	D = d[3] | t[3]&d[2] | t[3]&t[2]&d[1] | t[3]&t[2]&t[1]&d[0];
	assign	T = t[3]&t[2]&t[1]&t[0];
	assign	cout[0] = d[0] | t[0]&cin;
	assign	cout[1] = d[1] | t[1]&d[0] | t[1]&t[0]&cin;
	assign	cout[2] = d[2] | t[2]&d[1] | t[2]&t[1]&d[0] | t[2]&t[1]&t[0]&cin;endmodule