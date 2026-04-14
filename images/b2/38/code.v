module top_module(
	input A,B,Cin,
	output Z,Cout
);assign Z = A^B^Cin ;
 assign Cout = A&B | B&Cin | A&Cin ;endmodule