module binary_adder_4bit(
	input 	[3:0] A,
	input 	[3:0] B,
	input 	Cin,
	output [3:0] S,
	output Cout
);

assign {Cout, S} = A + B + Cin;

endmodule